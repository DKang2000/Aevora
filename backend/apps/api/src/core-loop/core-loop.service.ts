import { ConflictException, Injectable, NotFoundException, UnauthorizedException } from "@nestjs/common";
import { randomUUID } from "node:crypto";
import { existsSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import path from "node:path";

import { AppConfigService } from "../common/config/config.service";
import { PrismaService } from "../common/database/prisma.service";
import {
  AvatarRecord,
  ChapterStateRecord,
  CompletionRequestRecord,
  CompletionResponseRecord,
  DistrictStateRecord,
  InventoryItemRecord,
  PlayerState,
  ProfileRecord,
  QueueOperationRecord,
  SessionResponse,
  SubscriptionTier,
  VowRecord,
  VowScheduleRecord,
  VowType
} from "./core-loop.types";

type LaunchContent = {
  identityShells: Array<{ id: string; originFamilyId: string; defaultAvatar?: { silhouetteId: string; paletteId: string; accessoryIds: string[] } }>;
  chapters: Array<{ id: string; startingQuestId: string; tomorrowCtaKey: string }>;
  starterArcDays: Array<{
    day: number;
    questId: string;
    restorationStageId: string;
    worldMomentId: string;
    npcIdsVisible: string[];
    tomorrowPromptKey: string;
  }>;
  districts: Array<{
    id: string;
    problemTemplateIds: string[];
    restorationStages: Array<{ id: string; worldChangeKey: string }>;
  }>;
  itemDefinitions?: Array<{
    id: string;
    bucket: InventoryItemRecord["bucket"];
    rarity: InventoryItemRecord["rarity"];
  }>;
  shopOffers?: Array<Record<string, unknown>>;
};

type PersistedCoreLoopState = {
  users: Record<string, PlayerState>;
  accessTokens: Record<string, string>;
  refreshTokens: Record<string, string>;
  deviceSessions: Record<string, string>;
  appleSessions: Record<string, string>;
};

const BASE_RESONANCE: Record<VowType, number> = {
  binary: 10,
  count: 10,
  duration: 12
};

const BASE_GOLD: Record<VowType, number> = {
  binary: 5,
  count: 5,
  duration: 6
};

const DIFFICULTY_MULTIPLIER = {
  gentle: 0.8,
  standard: 1,
  stretch: 1.5
} as const;

const LEVEL_THRESHOLDS = [0, 40, 100, 180, 280, 400, 540, 700, 880, 1080, 1300, 1540, 1800, 2080, 2380];

@Injectable()
export class CoreLoopService {
  private readonly repoRoot = path.resolve(__dirname, "../../../../../");
  private readonly storePath = this.resolveStorePath();
  private readonly content = this.loadContent();
  private readonly persistenceMode: "file" | "prisma";
  private readonly runtimeSnapshotId = "core-loop-runtime";
  private readonly trialDurationDays = 7;

  private state = this.emptyState();
  private stateLoaded = false;

  constructor(
    private readonly prisma: PrismaService,
    private readonly config: AppConfigService
  ) {
    this.persistenceMode = config.all.CORE_LOOP_PERSISTENCE;
  }

  async createGuestSession(deviceId: string): Promise<SessionResponse> {
    await this.ensureStateLoaded();

    const existingUserId = this.state.deviceSessions[deviceId];
    if (existingUserId) {
      return this.issueSession(this.requireUser(existingUserId));
    }

    const user = this.makeNewUser({ authMode: "guest" });
    this.state.users[user.user.id] = user;
    this.state.deviceSessions[deviceId] = user.user.id;
    await this.persistState();
    return this.issueSession(user);
  }

  async createAppleSession(identityToken: string): Promise<SessionResponse> {
    await this.ensureStateLoaded();

    const existingUserId = this.state.appleSessions[identityToken];
    if (existingUserId) {
      const existing = this.requireUser(existingUserId);
      existing.user.authMode = "registered";
      await this.persistState();
      return this.issueSession(existing);
    }

    const user = this.makeNewUser({ authMode: "registered" });
    this.state.users[user.user.id] = user;
    this.state.appleSessions[identityToken] = user.user.id;
    await this.persistState();
    return this.issueSession(user);
  }

  async linkAccount(guestUserId: string, identityToken: string): Promise<SessionResponse> {
    await this.ensureStateLoaded();

    const user = this.requireUser(guestUserId);
    if (user.user.authMode === "registered") {
      throw new ConflictException("User is already linked.");
    }

    const linkedUserId = this.state.appleSessions[identityToken];
    if (linkedUserId && linkedUserId !== guestUserId) {
      throw new ConflictException("This Apple identity is already linked to another user.");
    }

    user.user.authMode = "registered";
    this.state.appleSessions[identityToken] = guestUserId;
    await this.persistState();
    return this.issueSession(user);
  }

  async restoreSession(refreshToken: string): Promise<SessionResponse> {
    await this.ensureStateLoaded();

    const userId = this.state.refreshTokens[refreshToken];
    if (!userId) {
      throw new UnauthorizedException("Refresh token is invalid.");
    }

    return this.issueSession(this.requireUser(userId));
  }

  async resolvePlayer(authorizationHeader?: string): Promise<PlayerState> {
    await this.ensureStateLoaded();

    const accessToken = authorizationHeader?.replace("Bearer ", "").trim();
    if (!accessToken) {
      throw new UnauthorizedException("Missing bearer token.");
    }

    const userId = this.state.accessTokens[accessToken];
    if (!userId) {
      throw new UnauthorizedException("Unknown access token.");
    }

    return this.requireUser(userId);
  }

  async getProfile(userId: string): Promise<{ profile: ProfileRecord; avatar: AvatarRecord; subscriptionState: PlayerState["subscriptionState"] }> {
    await this.ensureStateLoaded();
    const user = this.requireUser(userId);
    return {
      profile: user.profile,
      avatar: user.avatar,
      subscriptionState: user.subscriptionState
    };
  }

  async updateProfile(userId: string, patch: Partial<ProfileRecord>): Promise<{ profile: ProfileRecord; avatar: AvatarRecord; subscriptionState: PlayerState["subscriptionState"] }> {
    await this.ensureStateLoaded();

    const user = this.requireUser(userId);
    user.profile = {
      ...user.profile,
      ...patch,
      id: user.profile.id,
      userId
    };

    if (patch.selectedIdentityShellId) {
      const identity = this.content.identityShells.find((entry) => entry.id === patch.selectedIdentityShellId);
      if (identity) {
        user.profile.originFamilyId = identity.originFamilyId;
      }
    }

    await this.persistState();
    return this.getProfile(userId);
  }

  async updateAvatar(userId: string, patch: Partial<AvatarRecord>): Promise<{ avatar: AvatarRecord }> {
    await this.ensureStateLoaded();

    const user = this.requireUser(userId);
    user.avatar = {
      ...user.avatar,
      ...patch,
      id: user.avatar.id,
      userId
    };

    await this.persistState();
    return { avatar: user.avatar };
  }

  async listVows(userId: string): Promise<{ vows: VowRecord[] }> {
    await this.ensureStateLoaded();
    return { vows: this.requireUser(userId).vows };
  }

  async createVow(userId: string, input: Partial<VowRecord> & { schedule: VowScheduleRecord }): Promise<{ vow: VowRecord }> {
    await this.ensureStateLoaded();

    const user = this.requireUser(userId);
    const activeVows = user.vows.filter((vow) => vow.status === "active");
    const cap = user.subscriptionState.tier === "free" ? 3 : 7;

    if (activeVows.length >= cap) {
      throw new ConflictException("Active vow cap reached.");
    }

    const vow: VowRecord = {
      id: input.id ?? `vow_${randomUUID()}`,
      userId,
      title: input.title ?? "Untitled vow",
      type: input.type ?? "binary",
      category: input.category ?? "Physical",
      status: input.status ?? "active",
      difficulty: input.difficulty ?? "standard",
      target: input.target ?? {
        value: 1,
        unit: "completion"
      },
      schedule: input.schedule
    };

    user.vows = [...user.vows, vow];
    await this.persistState();
    return { vow };
  }

  async updateVow(userId: string, vowId: string, patch: Partial<VowRecord> & { schedule?: VowScheduleRecord }): Promise<{ vow: VowRecord }> {
    await this.ensureStateLoaded();

    const user = this.requireUser(userId);
    const vowIndex = user.vows.findIndex((entry) => entry.id === vowId);
    if (vowIndex === -1) {
      throw new NotFoundException("Vow not found.");
    }

    const current = user.vows[vowIndex];
    const updated: VowRecord = {
      ...current,
      ...patch,
      schedule: patch.schedule ?? current.schedule,
      id: current.id,
      userId
    };

    user.vows[vowIndex] = updated;
    await this.persistState();
    return { vow: updated };
  }

  async archiveVow(userId: string, vowId: string): Promise<{ vowId: string; status: "archived" }> {
    await this.updateVow(userId, vowId, { status: "archived" });
    return {
      vowId,
      status: "archived"
    };
  }

  async submitCompletion(userId: string, request: CompletionRequestRecord): Promise<CompletionResponseRecord> {
    await this.ensureStateLoaded();

    const user = this.requireUser(userId);
    const existing = user.completionsByRequestId[request.clientRequestId];
    if (existing) {
      return {
        ...existing,
        reconciliation: {
          status: "duplicate"
        }
      };
    }

    const vow = user.vows.find((entry) => entry.id === request.vowId);
    if (!vow) {
      throw new NotFoundException("Vow not found.");
    }

    const progressPercent = this.calculateProgressPercent(vow, request);
    const chainState = user.chainStates[vow.id] ?? {
      currentLength: 0,
      bestLength: 0,
      status: "steady" as const
    };

    const updatedChain = this.advanceChainState(chainState, request.localDate, user.emberState);
    user.chainStates[vow.id] = updatedChain.chainState;
    user.emberState = updatedChain.emberState;

    const firstVowOfDay = (user.dayCompletionCounts[request.localDate] ?? 0) === 0;
    user.dayCompletionCounts[request.localDate] = (user.dayCompletionCounts[request.localDate] ?? 0) + 1;
    if (!user.completionDates.includes(request.localDate)) {
      user.completionDates = [...user.completionDates, request.localDate].sort();
    }
    user.completionDatesByVowId[vow.id] = [...(user.completionDatesByVowId[vow.id] ?? []), request.localDate].sort();

    const rewards = this.computeRewards({
      vow,
      progressPercent,
      firstVowOfDay,
      allPlannedVowsCompleted: this.allPlannedVowsCompleted(user, request.localDate),
      chainLength: updatedChain.chainState.currentLength,
      previousRank: user.levelState.rank,
      currentLevelState: user.levelState
    });

    user.levelState = rewards.levelState;
    user.chapterState = this.buildChapterState(user.completionDates.length);
    user.districtState = this.buildDistrictState(user.completionDates.length);

    const inventoryAwards = this.inventoryAwardsForCompletionDay(user.completionDates.length);
    if (inventoryAwards.length > 0) {
      user.inventoryItems = this.mergeInventoryAwards(user.inventoryItems, inventoryAwards, request.localDate);
    }

    const response: CompletionResponseRecord = {
      completionEvent: {
        id: `vce_${randomUUID()}`,
        vowId: request.vowId,
        localDate: request.localDate,
        progressPercent,
        progressState: request.progressState
      },
      rewards: [
        {
          id: `rwd_${randomUUID()}`,
          resonance: rewards.resonance,
          gold: rewards.gold,
          worldChangeKey: user.districtState.worldChangeKey,
          magicalMomentId: user.completionDates.length === 1 ? user.districtState.currentMomentId : undefined,
          levelUp: rewards.levelState.rank > rewards.previousRank
        }
      ],
      reconciliation: {
        status: "applied"
      }
    };

    user.completionsByRequestId[request.clientRequestId] = response;
    await this.persistState();
    return response;
  }

  async syncOperations(
    userId: string,
    operations: QueueOperationRecord[]
  ): Promise<{ results: Array<{ clientRequestId: string; status: string; serverSnapshot?: unknown }> }> {
    const results: Array<{ clientRequestId: string; status: string; serverSnapshot?: unknown }> = [];

    for (const operation of operations) {
      try {
        if (operation.operationType === "vow_create") {
          const created = await this.createVow(userId, operation.payload as unknown as VowRecord & { schedule: VowScheduleRecord });
          results.push({ clientRequestId: operation.clientRequestId, status: "applied", serverSnapshot: created });
          continue;
        }

        if (operation.operationType === "vow_update") {
          const payload = operation.payload as Partial<VowRecord> & { id: string; schedule?: VowScheduleRecord };
          const updated = await this.updateVow(userId, payload.id, payload);
          results.push({ clientRequestId: operation.clientRequestId, status: "applied", serverSnapshot: updated });
          continue;
        }

        if (operation.operationType === "vow_archive") {
          const payload = operation.payload as { vowId: string };
          results.push({
            clientRequestId: operation.clientRequestId,
            status: "applied",
            serverSnapshot: await this.archiveVow(userId, payload.vowId)
          });
          continue;
        }

        const response = await this.submitCompletion(userId, operation.payload as unknown as CompletionRequestRecord);
        results.push({
          clientRequestId: operation.clientRequestId,
          status: response.reconciliation.status === "duplicate" ? "duplicate" : "applied",
          serverSnapshot: response
        });
      } catch {
        results.push({
          clientRequestId: operation.clientRequestId,
          status: "rejected"
        });
      }
    }

    return { results };
  }

  async getProgressionSnapshot(userId: string): Promise<{ levelState: PlayerState["levelState"]; emberState: PlayerState["emberState"]; activeChapter: ChapterStateRecord }> {
    await this.ensureStateLoaded();
    const user = this.requireUser(userId);
    return {
      levelState: user.levelState,
      emberState: user.emberState,
      activeChapter: user.chapterState
    };
  }

  async getCurrentChapter(userId: string): Promise<ChapterStateRecord> {
    await this.ensureStateLoaded();
    return this.requireUser(userId).chapterState;
  }

  async getWorldState(userId: string): Promise<{ districtState: DistrictStateRecord }> {
    await this.ensureStateLoaded();
    return {
      districtState: this.requireUser(userId).districtState
    };
  }

  async getInventory(userId: string): Promise<{ items: InventoryItemRecord[] }> {
    await this.ensureStateLoaded();
    return {
      items: this.requireUser(userId).inventoryItems
    };
  }

  async getShopOffers(): Promise<{ offers: Array<Record<string, unknown>> }> {
    return {
      offers: this.content.shopOffers ?? []
    };
  }

  async getSubscriptionState(userId: string): Promise<{ subscriptionState: PlayerState["subscriptionState"] }> {
    await this.ensureStateLoaded();
    return {
      subscriptionState: this.requireUser(userId).subscriptionState
    };
  }

  async startTrial(userId: string, source = "paywall"): Promise<{ subscriptionState: PlayerState["subscriptionState"]; source: string }> {
    await this.ensureStateLoaded();

    const user = this.requireUser(userId);
    if (!user.subscriptionState.trialEligible) {
      throw new ConflictException("Trial has already been used.");
    }

    user.subscriptionState = {
      ...user.subscriptionState,
      tier: "trial",
      billingState: "active",
      trialEligible: false,
      restoreTier: "trial",
      expiresAt: this.futureIsoDate(this.trialDurationDays)
    };
    await this.persistState();

    return {
      subscriptionState: user.subscriptionState,
      source
    };
  }

  async purchaseSubscription(
    userId: string,
    tier: Extract<SubscriptionTier, "premium_monthly" | "premium_annual">,
    source = "paywall"
  ): Promise<{ subscriptionState: PlayerState["subscriptionState"]; source: string }> {
    await this.ensureStateLoaded();

    const user = this.requireUser(userId);
    user.subscriptionState = {
      ...user.subscriptionState,
      tier,
      billingState: "active",
      trialEligible: false,
      restoreTier: tier,
      expiresAt: null
    };
    await this.persistState();

    return {
      subscriptionState: user.subscriptionState,
      source
    };
  }

  async restoreSubscription(userId: string): Promise<{ subscriptionState: PlayerState["subscriptionState"]; restored: boolean }> {
    await this.ensureStateLoaded();

    const user = this.requireUser(userId);
    const restoreTier = user.subscriptionState.restoreTier;
    if (!restoreTier) {
      return {
        subscriptionState: user.subscriptionState,
        restored: false
      };
    }

    user.subscriptionState = {
      ...user.subscriptionState,
      tier: restoreTier,
      billingState: "active",
      expiresAt: restoreTier === "trial" ? this.futureIsoDate(this.trialDurationDays) : null
    };
    await this.persistState();

    return {
      subscriptionState: user.subscriptionState,
      restored: true
    };
  }

  async downgradeSubscription(userId: string, reason = "billing_lapse"): Promise<{ subscriptionState: PlayerState["subscriptionState"]; reason: string }> {
    await this.ensureStateLoaded();

    const user = this.requireUser(userId);
    const previousTier = user.subscriptionState.tier;
    user.subscriptionState = {
      ...user.subscriptionState,
      tier: "free",
      billingState: "expired",
      restoreTier: previousTier === "free" ? user.subscriptionState.restoreTier ?? null : previousTier,
      expiresAt: new Date().toISOString()
    };
    await this.persistState();

    return {
      subscriptionState: user.subscriptionState,
      reason
    };
  }

  async getAccountSummary(userId: string): Promise<Record<string, unknown>> {
    await this.ensureStateLoaded();

    const user = this.requireUser(userId);
    return {
      account: {
        userId: user.user.id,
        authMode: user.user.authMode,
        selectedIdentityShellId: user.profile.selectedIdentityShellId,
        completionDayCount: user.completionDates.length,
        activeVowCount: user.vows.filter((entry) => entry.status === "active").length
      },
      subscriptionState: user.subscriptionState
    };
  }

  async requestAccountExport(userId: string): Promise<Record<string, unknown>> {
    await this.ensureStateLoaded();

    const user = this.requireUser(userId);
    return {
      exportRequest: {
        id: `exp_${randomUUID()}`,
        status: "prepared",
        generatedAt: new Date().toISOString()
      },
      summary: {
        userId: user.user.id,
        authMode: user.user.authMode,
        activeVows: user.vows.filter((entry) => entry.status === "active").length,
        completionDayCount: user.completionDates.length,
        subscriptionTier: user.subscriptionState.tier
      }
    };
  }

  async deleteAccount(userId: string): Promise<Record<string, unknown>> {
    await this.ensureStateLoaded();

    if (!this.state.users[userId]) {
      throw new NotFoundException("User not found.");
    }

    delete this.state.users[userId];
    this.removeUserSessions(userId);
    await this.persistState();

    return {
      status: "deleted",
      userId
    };
  }

  async getGlanceState(userId: string): Promise<Record<string, unknown>> {
    await this.ensureStateLoaded();

    const user = this.requireUser(userId);
    const activeVows = user.vows.filter((entry) => entry.status === "active");
    const completedToday = activeVows.filter((entry) => {
      const lastDate = user.completionDatesByVowId[entry.id]?.at(-1);
      return lastDate === user.completionDates.at(-1);
    }).length;

    return {
      todaySnapshot: {
        activeVowCount: activeVows.length,
        completedVowCount: completedToday,
        chapterId: user.chapterState.chapterId,
        chapterDay: user.chapterState.currentDay,
        districtStage: user.districtState.restorationStage,
        topChainLength: Math.max(0, ...Object.values(user.chainStates).map((entry) => entry.currentLength))
      },
      liveActivitySnapshot: {
        enabled: user.subscriptionState.tier !== "free",
        districtStage: user.districtState.restorationStage,
        progressPercent: user.chapterState.progressPercent
      }
    };
  }

  private makeNewUser(input: { authMode: "guest" | "registered" }): PlayerState {
    const userId = `usr_${randomUUID()}`;
    const identity = this.content.identityShells.find((entry) => entry.id === "idn_baker") ?? this.content.identityShells[0];
    const chapter = this.buildChapterState(0);
    const district = this.buildDistrictState(0);

    return {
      user: {
        id: userId,
        authMode: input.authMode
      },
      profile: {
        id: `pro_${randomUUID()}`,
        userId,
        selectedIdentityShellId: identity.id,
        originFamilyId: identity.originFamilyId,
        toneMode: "balanced",
        timezone: "America/New_York",
        onboardingState: "not_started",
        displayName: "Wayfarer",
        pronouns: null,
        selectedGoals: [],
        selectedLifeAreas: [],
        blocker: null,
        dailyLoad: 3
      },
      avatar: {
        id: `ava_${randomUUID()}`,
        userId,
        silhouetteId: identity.defaultAvatar?.silhouetteId ?? "silhouette_oven_apron",
        paletteId: identity.defaultAvatar?.paletteId ?? "palette_ember_ochre",
        accessoryIds: identity.defaultAvatar?.accessoryIds ?? []
      },
      subscriptionState: {
        id: `sub_${randomUUID()}`,
        tier: "free",
        billingState: "active",
        trialEligible: true,
        expiresAt: null,
        restoreTier: null
      },
      vows: [],
      completionsByRequestId: {},
      completionDatesByVowId: {},
      completionDates: [],
      dayCompletionCounts: {},
      chainStates: {},
      emberState: {
        availableEmbers: 2,
        heat: 0
      },
      levelState: {
        rank: 1,
        currentRankResonance: 0,
        lifetimeResonance: 0
      },
      chapterState: chapter,
      districtState: district,
      inventoryItems: []
    };
  }

  private async issueSession(user: PlayerState): Promise<SessionResponse> {
    const accessToken = `atk_${randomUUID()}`;
    const refreshToken = `rtk_${randomUUID()}`;
    this.state.accessTokens[accessToken] = user.user.id;
    this.state.refreshTokens[refreshToken] = user.user.id;
    await this.persistState();

    return {
      accessToken,
      refreshToken,
      user: user.user
    };
  }

  private requireUser(userId: string): PlayerState {
    const user = this.state.users[userId];
    if (!user) {
      throw new NotFoundException("User not found.");
    }

    return user;
  }

  private calculateProgressPercent(vow: VowRecord, request: CompletionRequestRecord): number {
    if (vow.type === "binary") {
      return 100;
    }

    const rawValue = vow.type === "count" ? request.quantity ?? 0 : request.durationMinutes ?? 0;
    const basePercent = Math.round((rawValue / Math.max(vow.target.value, 1)) * 100);
    const capped = Math.max(0, Math.min(basePercent, 120));

    if (request.progressState === "partial" && capped > 0) {
      return Math.max(30, capped);
    }

    return capped === 0 ? 100 : capped;
  }

  private advanceChainState(
    chainState: PlayerState["chainStates"][string],
    localDate: string,
    emberState: PlayerState["emberState"]
  ): { chainState: PlayerState["chainStates"][string]; emberState: PlayerState["emberState"] } {
    if (!chainState.lastCompletedDate) {
      return {
        chainState: {
          currentLength: 1,
          bestLength: 1,
          status: "steady",
          lastCompletedDate: localDate
        },
        emberState: {
          availableEmbers: emberState.availableEmbers,
          heat: Math.min(5, emberState.heat + 1)
        }
      };
    }

    const dayGap = this.dayDifference(chainState.lastCompletedDate, localDate);
    if (dayGap <= 1) {
      const currentLength = chainState.currentLength + 1;
      return {
        chainState: {
          currentLength,
          bestLength: Math.max(currentLength, chainState.bestLength),
          status: "steady",
          lastCompletedDate: localDate
        },
        emberState: {
          availableEmbers: emberState.availableEmbers,
          heat: Math.min(5, emberState.heat + 1)
        }
      };
    }

    if (dayGap <= 3 && emberState.availableEmbers > 0) {
      const currentLength = chainState.currentLength + 1;
      return {
        chainState: {
          currentLength,
          bestLength: Math.max(currentLength, chainState.bestLength),
          status: "rekindled",
          lastCompletedDate: localDate
        },
        emberState: {
          availableEmbers: emberState.availableEmbers - 1,
          heat: Math.max(1, emberState.heat),
          lastRekindledDate: localDate
        }
      };
    }

    return {
      chainState: {
        currentLength: 1,
        bestLength: Math.max(1, chainState.bestLength),
        status: "cooling",
        lastCompletedDate: localDate
      },
      emberState: {
        availableEmbers: emberState.availableEmbers,
        heat: Math.max(0, emberState.heat - 1),
        lastCoolingDate: localDate
      }
    };
  }

  private computeRewards(input: {
    vow: VowRecord;
    progressPercent: number;
    firstVowOfDay: boolean;
    allPlannedVowsCompleted: boolean;
    chainLength: number;
    previousRank: number;
    currentLevelState: PlayerState["levelState"];
  }): { resonance: number; gold: number; levelState: PlayerState["levelState"]; previousRank: number } {
    const baseResonance = BASE_RESONANCE[input.vow.type];
    const baseGold = BASE_GOLD[input.vow.type];
    const multiplier = DIFFICULTY_MULTIPLIER[input.vow.difficulty];
    const progressRatio = input.progressPercent / 100;
    const chainBonusPercent = this.chainBonusPercent(input.chainLength);

    let resonance = Math.round(baseResonance * multiplier * progressRatio);
    resonance += Math.round(resonance * (chainBonusPercent / 100));

    let gold = Math.round(baseGold * progressRatio);
    if (input.firstVowOfDay) {
      gold += 2;
    }
    if (input.allPlannedVowsCompleted) {
      gold += 5;
    }

    const lifetimeResonance = input.currentLevelState.lifetimeResonance + resonance;
    const rank = this.rankForResonance(lifetimeResonance);
    const currentRankFloor = LEVEL_THRESHOLDS[Math.max(0, rank - 1)] ?? 0;

    return {
      resonance,
      gold,
      previousRank: input.previousRank,
      levelState: {
        rank,
        currentRankResonance: lifetimeResonance - currentRankFloor,
        lifetimeResonance
      }
    };
  }

  private buildChapterState(completionDayCount: number): ChapterStateRecord {
    const chapter = this.content.chapters.find((entry) => entry.id === "starter_arc") ?? this.content.chapters[0];
    const boundedDay = Math.max(0, Math.min(Math.max(completionDayCount, 1), this.content.starterArcDays.length));
    const dayConfig = this.content.starterArcDays[Math.max(0, boundedDay - 1)] ?? this.content.starterArcDays[0];

    return {
      chapterId: "starter_arc",
      status: completionDayCount >= 7 ? "completed" : completionDayCount === 0 ? "not_started" : "in_progress",
      progressPercent: Math.min((completionDayCount / 7) * 100, 100),
      currentDay: Math.max(Math.min(completionDayCount, 7), 1),
      activeQuestId: completionDayCount === 0 ? chapter.startingQuestId : dayConfig.questId,
      tomorrowPromptKey: dayConfig.tomorrowPromptKey ?? chapter.tomorrowCtaKey
    };
  }

  private buildDistrictState(completionDayCount: number): DistrictStateRecord {
    const district = this.content.districts.find((entry) => entry.id === "ember_quay") ?? this.content.districts[0];
    const stageId = completionDayCount >= 7 ? "rekindled" : completionDayCount >= 3 ? "rebuilding" : completionDayCount >= 1 ? "stirring" : "dim";
    const dayConfig = completionDayCount === 0 ? this.content.starterArcDays[0] : this.content.starterArcDays[Math.min(completionDayCount - 1, this.content.starterArcDays.length - 1)];
    const stageConfig = district.restorationStages.find((entry) => entry.id === stageId) ?? district.restorationStages[0];

    return {
      districtId: "ember_quay",
      restorationStage: stageId,
      problemTemplateId: district.problemTemplateIds[0],
      visibleNpcIds: dayConfig.npcIdsVisible,
      currentMomentId: dayConfig.worldMomentId,
      worldChangeKey: stageConfig.worldChangeKey
    };
  }

  private inventoryAwardsForCompletionDay(completionDayCount: number): InventoryItemRecord[] {
    const itemDefinitions = this.content.itemDefinitions ?? [];
    const definitionsById = new Map(itemDefinitions.map((item) => [item.id, item] as const));
    const awards: InventoryItemRecord[] = [];

    if (completionDayCount === 1) {
      const token = definitionsById.get("ember_quay_token");
      if (token) {
        awards.push({
          id: `itm_${randomUUID()}`,
          itemDefinitionId: token.id,
          bucket: token.bucket,
          rarity: token.rarity,
          quantity: 1,
          earnedFrom: "starter_day_1_reward"
        });
      }
    }

    if (completionDayCount === 7) {
      const cosmetic = definitionsById.get("hearth_apron_common");
      if (cosmetic) {
        awards.push({
          id: `itm_${randomUUID()}`,
          itemDefinitionId: cosmetic.id,
          bucket: cosmetic.bucket,
          rarity: cosmetic.rarity,
          quantity: 1,
          earnedFrom: "starter_day_7_chest"
        });
      }
    }

    return awards;
  }

  private mergeInventoryAwards(existing: InventoryItemRecord[], incoming: InventoryItemRecord[], localDate: string): InventoryItemRecord[] {
    const merged = [...existing];
    for (const award of incoming) {
      const duplicate = merged.find((item) => item.itemDefinitionId === award.itemDefinitionId && item.earnedFrom === award.earnedFrom);
      if (!duplicate) {
        merged.push({
          ...award,
          earnedFrom: `${award.earnedFrom}:${localDate}`
        });
      }
    }

    return merged;
  }

  private resolveStorePath(): string {
    const override = process.env.AEVORA_CORE_LOOP_STORE_PATH;
    if (override && override.trim().length > 0) {
      return override;
    }

    return path.resolve(tmpdir(), "aevora-core-loop-store.json");
  }

  private loadContent(): LaunchContent {
    const contentPath = path.resolve(this.repoRoot, "content/launch/launch-content.min.v1.json");
    return JSON.parse(readFileSync(contentPath, "utf8")) as LaunchContent;
  }

  private async ensureStateLoaded(): Promise<void> {
    if (this.stateLoaded) {
      return;
    }

    this.state = this.persistenceMode === "prisma" ? await this.loadStateFromDatabase() : this.loadStateFromFile();
    this.stateLoaded = true;
  }

  private loadStateFromFile(): PersistedCoreLoopState {
    if (!existsSync(this.storePath)) {
      return this.emptyState();
    }

    try {
      return JSON.parse(readFileSync(this.storePath, "utf8")) as PersistedCoreLoopState;
    } catch {
      return this.emptyState();
    }
  }

  private async loadStateFromDatabase(): Promise<PersistedCoreLoopState> {
    const snapshot = await this.prisma.coreLoopRuntimeSnapshot.findUnique({
      where: {
        id: this.runtimeSnapshotId
      }
    });

    if (!snapshot) {
      return this.emptyState();
    }

    return snapshot.statePayload as unknown as PersistedCoreLoopState;
  }

  private async persistState(): Promise<void> {
    if (this.persistenceMode === "prisma") {
      await this.prisma.coreLoopRuntimeSnapshot.upsert({
        where: {
          id: this.runtimeSnapshotId
        },
        create: {
          id: this.runtimeSnapshotId,
          statePayload: this.state as never
        },
        update: {
          statePayload: this.state as never
        }
      });
      return;
    }

    mkdirSync(path.dirname(this.storePath), { recursive: true });
    writeFileSync(this.storePath, JSON.stringify(this.state, null, 2));
  }

  private emptyState(): PersistedCoreLoopState {
    return {
      users: {},
      accessTokens: {},
      refreshTokens: {},
      deviceSessions: {},
      appleSessions: {}
    };
  }

  private removeUserSessions(userId: string): void {
    this.state.accessTokens = Object.fromEntries(Object.entries(this.state.accessTokens).filter(([, mappedUserId]) => mappedUserId !== userId));
    this.state.refreshTokens = Object.fromEntries(Object.entries(this.state.refreshTokens).filter(([, mappedUserId]) => mappedUserId !== userId));
    this.state.deviceSessions = Object.fromEntries(Object.entries(this.state.deviceSessions).filter(([, mappedUserId]) => mappedUserId !== userId));
    this.state.appleSessions = Object.fromEntries(Object.entries(this.state.appleSessions).filter(([, mappedUserId]) => mappedUserId !== userId));
  }

  private dayDifference(fromDate: string, toDate: string): number {
    const from = new Date(`${fromDate}T00:00:00Z`);
    const to = new Date(`${toDate}T00:00:00Z`);
    return Math.max(0, Math.round((to.getTime() - from.getTime()) / 86_400_000));
  }

  private allPlannedVowsCompleted(user: PlayerState, localDate: string): boolean {
    const activeVowIDs = user.vows.filter((entry) => entry.status === "active").map((entry) => entry.id);
    if (activeVowIDs.length === 0) {
      return false;
    }

    return activeVowIDs.every((vowId) => (user.completionDatesByVowId[vowId] ?? []).includes(localDate));
  }

  private chainBonusPercent(chainLength: number): number {
    if (chainLength >= 30) {
      return 20;
    }
    if (chainLength >= 14) {
      return 15;
    }
    if (chainLength >= 7) {
      return 10;
    }
    if (chainLength >= 3) {
      return 5;
    }
    return 0;
  }

  private rankForResonance(lifetimeResonance: number): number {
    let rank = 1;
    for (let index = 0; index < LEVEL_THRESHOLDS.length; index += 1) {
      if (lifetimeResonance >= LEVEL_THRESHOLDS[index]) {
        rank = index + 1;
      }
    }

    return rank;
  }

  private futureIsoDate(dayCount: number): string {
    return new Date(Date.now() + (dayCount * 86_400_000)).toISOString();
  }
}
