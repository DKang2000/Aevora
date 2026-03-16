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
}

export interface DistrictStateRecord {
  districtId: string;
  restorationStage: string;
  problemTemplateId: string;
  visibleNpcIds: string[];
  currentMomentId: string;
  worldChangeKey: string;
}

export interface InventoryItemRecord {
  id: string;
  itemDefinitionId: string;
  bucket: "reward_token" | "prop" | "cosmetic" | "chapter_reward";
  rarity: "common" | "uncommon" | "rare";
  quantity: number;
  earnedFrom: string;
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
  chapterState: ChapterStateRecord;
  districtState: DistrictStateRecord;
  inventoryItems: InventoryItemRecord[];
}

export interface QueueOperationRecord {
  clientRequestId: string;
  operationType: "vow_create" | "vow_update" | "vow_archive" | "completion_submit";
  payload: Record<string, unknown>;
}
