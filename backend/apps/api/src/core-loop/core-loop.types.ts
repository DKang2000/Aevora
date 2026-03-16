export type AuthMode = "guest" | "registered";
export type ToneMode = "gentle" | "balanced" | "driven";
export type VowType = "binary" | "count" | "duration";
export type VowStatus = "draft" | "active" | "archived";
export type VowDifficulty = "gentle" | "standard" | "stretch";
export type CompletionState = "partial" | "complete";
export type SubscriptionTier = "free" | "trial" | "premium_monthly" | "premium_annual";
export type BillingState = "active" | "grace_period" | "billing_retry" | "expired";

export interface SessionResponse {
  accessToken: string;
  refreshToken: string;
  user: {
    id: string;
    authMode: AuthMode;
  };
}

export interface ProfileRecord {
  id: string;
  userId: string;
  selectedIdentityShellId: string;
  originFamilyId: string;
  toneMode: ToneMode;
  timezone: string;
  onboardingState: "not_started" | "in_progress" | "completed";
  displayName: string;
  pronouns?: string | null;
  selectedGoals: string[];
  selectedLifeAreas: string[];
  blocker?: string | null;
  dailyLoad: number;
}

export interface AvatarRecord {
  id: string;
  userId: string;
  silhouetteId: string;
  paletteId: string;
  accessoryIds: string[];
}

export interface SubscriptionStateRecord {
  id: string;
  tier: SubscriptionTier;
  billingState: BillingState;
  trialEligible: boolean;
  expiresAt?: string | null;
  restoreTier?: Exclude<SubscriptionTier, "free"> | null;
}

export interface VowScheduleRecord {
  cadence: string;
  activeWeekdays: string[];
  reminderLocalTime?: string | null;
}

export interface VowRecord {
  id: string;
  userId: string;
  title: string;
  type: VowType;
  category: string;
  status: VowStatus;
  difficulty: VowDifficulty;
  target: {
    value: number;
    unit: string;
  };
  schedule: VowScheduleRecord;
}

export interface LevelStateRecord {
  rank: number;
  currentRankResonance: number;
  lifetimeResonance: number;
}

export interface EmberStateRecord {
  availableEmbers: number;
  heat: number;
  lastCoolingDate?: string;
  lastRekindledDate?: string;
}

export interface ChapterStateRecord {
  chapterId: string;
  status: string;
  progressPercent: number;
  currentDay: number;
  activeQuestId: string;
  tomorrowPromptKey: string;
  entitlementStatus: "free_preview" | "premium_full";
  accessibleDayCap: number;
}

export interface DistrictStateRecord {
  districtId: string;
  restorationStage: string;
  problemTemplateId: string;
  visibleNpcIds: string[];
  currentMomentId: string;
  worldChangeKey: string;
  problemState: string;
  problemProgressPercent: number;
}

export interface InventoryItemRecord {
  id: string;
  itemDefinitionId: string;
  bucket: "reward_token" | "prop" | "cosmetic" | "chapter_reward";
  rarity: "common" | "uncommon" | "rare";
  quantity: number;
  earnedFrom: string;
  status: "stored" | "applied";
  slot: "display" | "attire" | "keepsake";
}

export interface ShopOfferRecord {
  id: string;
  itemDefinitionId: string;
  priceGold: number;
  entitlementGate: "free" | "premium";
  vendorNpcId: string;
  stockLimit: number;
  chapterGate: "starter_arc" | "chapter_one";
  repeatable: boolean;
  canAfford: boolean;
  isOwned: boolean;
  isLocked: boolean;
  remainingStock: number;
}

export interface RewardLedgerRecord {
  id: string;
  source: "completion" | "chapter_milestone" | "shop_purchase";
  localDate: string;
  resonanceDelta: number;
  goldDelta: number;
  itemDefinitionIds: string[];
  note: string;
}

export interface ShopPurchaseRecord {
  id: string;
  offerId: string;
  itemDefinitionId: string;
  purchasedAt: string;
  priceGold: number;
  remainingGold: number;
}

export interface NotificationPreferenceRecord {
  userId: string;
  remindersEnabled: boolean;
  rewardMomentsEnabled: boolean;
  weeklyArcEnabled: boolean;
}

export interface SourceConnectionRecord {
  sourceType: "healthkit";
  authorizationState: "not_requested" | "requested" | "granted" | "denied";
  supportedDomains: Array<"workout" | "steps" | "sleep">;
  lastSyncAt?: string | null;
}

export interface NotificationPlanItemRecord {
  id: string;
  kind: "vow_reminder" | "witness_prompt" | "streak_risk" | "chapter_ready";
  title: string;
  body: string;
  deliveryHourLocal: number;
  deliveryMinuteLocal: number;
  destination: "today" | "world" | "quest_journal";
  vowId?: string | null;
}

export interface VerifiedCompletionImportRecord {
  importId: string;
  sourceEventId: string;
  sourceType: "healthkit";
  sourceDomain: "workout" | "steps" | "sleep";
  vowId: string;
  localDate: string;
  completionResponse: CompletionResponseRecord;
 }

export interface CompletionRequestRecord {
  clientRequestId: string;
  vowId: string;
  localDate: string;
  source: "manual" | "healthkit";
  progressState: CompletionState;
  quantity?: number | null;
  durationMinutes?: number | null;
}

export interface CompletionResponseRecord {
  completionEvent: {
    id: string;
    vowId: string;
    localDate: string;
    progressPercent: number;
    progressState: CompletionState;
  };
  rewards: Array<{
    id: string;
    resonance: number;
    gold: number;
    worldChangeKey: string;
    magicalMomentId?: string;
    levelUp?: boolean;
  }>;
  reconciliation: {
    status: "applied" | "duplicate" | "conflict";
  };
}

export interface ChainStateRecord {
  currentLength: number;
  bestLength: number;
  status: "steady" | "cooling" | "rekindled";
  lastCompletedDate?: string;
}

export interface PlayerState {
  user: {
    id: string;
    authMode: AuthMode;
  };
  profile: ProfileRecord;
  avatar: AvatarRecord;
  subscriptionState: SubscriptionStateRecord;
  vows: VowRecord[];
  completionsByRequestId: Record<string, CompletionResponseRecord>;
  completionDatesByVowId: Record<string, string[]>;
  completionDates: string[];
  dayCompletionCounts: Record<string, number>;
  chainStates: Record<string, ChainStateRecord>;
  emberState: EmberStateRecord;
  levelState: LevelStateRecord;
  goldBalance: number;
  chapterState: ChapterStateRecord;
  districtState: DistrictStateRecord;
  inventoryItems: InventoryItemRecord[];
  rewardLedger: RewardLedgerRecord[];
  shopPurchaseHistory: ShopPurchaseRecord[];
  notificationPreference: NotificationPreferenceRecord;
  sourceConnections: SourceConnectionRecord[];
  verifiedCompletionsBySourceEventId: Record<string, VerifiedCompletionImportRecord>;
}

export interface QueueOperationRecord {
  clientRequestId: string;
  operationType: "vow_create" | "vow_update" | "vow_archive" | "completion_submit" | "shop_purchase" | "verified_completion";
  payload: Record<string, unknown>;
}
