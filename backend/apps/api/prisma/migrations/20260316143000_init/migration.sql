-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "public";

-- CreateEnum
CREATE TYPE "AuthMode" AS ENUM ('guest', 'registered');

-- CreateEnum
CREATE TYPE "VowType" AS ENUM ('binary', 'count', 'duration');

-- CreateEnum
CREATE TYPE "VowLifecycle" AS ENUM ('draft', 'active', 'archived');

-- CreateEnum
CREATE TYPE "CompletionSource" AS ENUM ('manual', 'healthkit');

-- CreateEnum
CREATE TYPE "CompletionStatus" AS ENUM ('partial', 'complete');

-- CreateEnum
CREATE TYPE "SyncOperationType" AS ENUM ('vow_create', 'vow_update', 'vow_archive', 'completion_submit', 'analytics_enqueue');

-- CreateEnum
CREATE TYPE "SyncOperationStatus" AS ENUM ('pending', 'in_flight', 'retryable_error', 'terminal_error', 'applied');

-- CreateEnum
CREATE TYPE "SubscriptionTier" AS ENUM ('free', 'trial', 'premium_monthly', 'premium_annual');

-- CreateEnum
CREATE TYPE "BillingState" AS ENUM ('active', 'grace_period', 'billing_retry', 'expired');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "authMode" "AuthMode" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuthProviderLink" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "providerUserId" TEXT NOT NULL,
    "linkedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastUsedAt" TIMESTAMP(3),

    CONSTRAINT "AuthProviderLink_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuthSession" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "accessTokenHash" TEXT NOT NULL,
    "refreshTokenHash" TEXT,
    "deviceIdentifier" TEXT,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "revokedAt" TIMESTAMP(3),

    CONSTRAINT "AuthSession_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Profile" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "identityShellId" TEXT NOT NULL,
    "originFamilyId" TEXT NOT NULL,
    "toneMode" TEXT NOT NULL,
    "timezone" TEXT NOT NULL,
    "onboardingState" TEXT NOT NULL,
    "selectedChapterId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Profile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Avatar" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "bodyFrame" TEXT NOT NULL,
    "skinTone" TEXT NOT NULL,
    "hairStyle" TEXT NOT NULL,
    "hairColor" TEXT NOT NULL,
    "accessory" TEXT,
    "appearanceJson" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Avatar_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Vow" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "type" "VowType" NOT NULL,
    "lifecycle" "VowLifecycle" NOT NULL,
    "targetValue" INTEGER,
    "unitLabel" TEXT,
    "reminderEnabled" BOOLEAN NOT NULL DEFAULT false,
    "archivedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "Vow_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VowSchedule" (
    "id" TEXT NOT NULL,
    "vowId" TEXT NOT NULL,
    "timezone" TEXT NOT NULL,
    "recurrenceRule" TEXT NOT NULL,
    "reminderHourLocal" INTEGER,
    "reminderMinute" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "VowSchedule_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VowCompletionEvent" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "vowId" TEXT NOT NULL,
    "clientRequestId" TEXT NOT NULL,
    "localDate" TEXT NOT NULL,
    "occurredAtUtc" TIMESTAMP(3) NOT NULL,
    "source" "CompletionSource" NOT NULL,
    "status" "CompletionStatus" NOT NULL,
    "quantity" INTEGER,
    "durationSeconds" INTEGER,
    "noteRedacted" BOOLEAN NOT NULL DEFAULT true,
    "rawPayload" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "VowCompletionEvent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RewardGrant" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "completionEventId" TEXT,
    "rewardKind" TEXT NOT NULL,
    "resonanceDelta" INTEGER NOT NULL DEFAULT 0,
    "goldDelta" INTEGER NOT NULL DEFAULT 0,
    "embersDelta" INTEGER NOT NULL DEFAULT 0,
    "grantPayload" JSONB NOT NULL,
    "grantedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "RewardGrant_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SyncOperation" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "clientRequestId" TEXT NOT NULL,
    "operationType" "SyncOperationType" NOT NULL,
    "status" "SyncOperationStatus" NOT NULL,
    "payload" JSONB NOT NULL,
    "dependencyIds" JSONB,
    "attemptCount" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastAttemptAt" TIMESTAMP(3),
    "appliedAt" TIMESTAMP(3),

    CONSTRAINT "SyncOperation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ChapterState" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "chapterId" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "activeQuestId" TEXT,
    "snapshotPayload" JSONB NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ChapterState_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DistrictState" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "districtId" TEXT NOT NULL,
    "restorationStage" TEXT NOT NULL,
    "problemTemplateId" TEXT,
    "visibilityPayload" JSONB NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DistrictState_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SubscriptionState" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "tier" "SubscriptionTier" NOT NULL,
    "billingState" "BillingState" NOT NULL,
    "storefront" TEXT,
    "expiresAt" TIMESTAMP(3),
    "entitlementPayload" JSONB NOT NULL,
    "refreshedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SubscriptionState_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AnalyticsRawEvent" (
    "id" TEXT NOT NULL,
    "userId" TEXT,
    "eventName" TEXT NOT NULL,
    "eventVersion" TEXT NOT NULL,
    "sessionId" TEXT NOT NULL,
    "surface" TEXT NOT NULL,
    "localDate" TEXT NOT NULL,
    "occurredAtUtc" TIMESTAMP(3) NOT NULL,
    "appBuild" TEXT NOT NULL,
    "platform" TEXT NOT NULL,
    "anonymizedActorId" TEXT NOT NULL,
    "payload" JSONB NOT NULL,
    "ingestedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AnalyticsRawEvent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RemoteConfigSnapshot" (
    "id" TEXT NOT NULL,
    "environment" TEXT NOT NULL,
    "schemaVersion" TEXT NOT NULL,
    "etag" TEXT,
    "configPayload" JSONB NOT NULL,
    "fetchedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "RemoteConfigSnapshot_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditLog" (
    "id" TEXT NOT NULL,
    "userId" TEXT,
    "scope" TEXT NOT NULL,
    "action" TEXT NOT NULL,
    "actorType" TEXT NOT NULL,
    "actorId" TEXT,
    "requestId" TEXT,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AuditLog_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "AuthProviderLink_userId_idx" ON "AuthProviderLink"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "AuthProviderLink_provider_providerUserId_key" ON "AuthProviderLink"("provider", "providerUserId");

-- CreateIndex
CREATE INDEX "AuthSession_userId_idx" ON "AuthSession"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Profile_userId_key" ON "Profile"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Avatar_userId_key" ON "Avatar"("userId");

-- CreateIndex
CREATE INDEX "Vow_userId_lifecycle_idx" ON "Vow"("userId", "lifecycle");

-- CreateIndex
CREATE UNIQUE INDEX "VowSchedule_vowId_key" ON "VowSchedule"("vowId");

-- CreateIndex
CREATE UNIQUE INDEX "VowCompletionEvent_clientRequestId_key" ON "VowCompletionEvent"("clientRequestId");

-- CreateIndex
CREATE INDEX "VowCompletionEvent_userId_localDate_idx" ON "VowCompletionEvent"("userId", "localDate");

-- CreateIndex
CREATE INDEX "VowCompletionEvent_vowId_localDate_idx" ON "VowCompletionEvent"("vowId", "localDate");

-- CreateIndex
CREATE INDEX "RewardGrant_userId_grantedAt_idx" ON "RewardGrant"("userId", "grantedAt");

-- CreateIndex
CREATE UNIQUE INDEX "SyncOperation_clientRequestId_key" ON "SyncOperation"("clientRequestId");

-- CreateIndex
CREATE INDEX "SyncOperation_userId_status_idx" ON "SyncOperation"("userId", "status");

-- CreateIndex
CREATE UNIQUE INDEX "ChapterState_userId_chapterId_key" ON "ChapterState"("userId", "chapterId");

-- CreateIndex
CREATE UNIQUE INDEX "DistrictState_userId_districtId_key" ON "DistrictState"("userId", "districtId");

-- CreateIndex
CREATE INDEX "SubscriptionState_userId_refreshedAt_idx" ON "SubscriptionState"("userId", "refreshedAt");

-- CreateIndex
CREATE INDEX "AnalyticsRawEvent_eventName_occurredAtUtc_idx" ON "AnalyticsRawEvent"("eventName", "occurredAtUtc");

-- CreateIndex
CREATE INDEX "AnalyticsRawEvent_userId_occurredAtUtc_idx" ON "AnalyticsRawEvent"("userId", "occurredAtUtc");

-- CreateIndex
CREATE INDEX "RemoteConfigSnapshot_environment_fetchedAt_idx" ON "RemoteConfigSnapshot"("environment", "fetchedAt");

-- CreateIndex
CREATE INDEX "AuditLog_scope_createdAt_idx" ON "AuditLog"("scope", "createdAt");

-- AddForeignKey
ALTER TABLE "AuthProviderLink" ADD CONSTRAINT "AuthProviderLink_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuthSession" ADD CONSTRAINT "AuthSession_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Profile" ADD CONSTRAINT "Profile_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Avatar" ADD CONSTRAINT "Avatar_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Vow" ADD CONSTRAINT "Vow_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VowSchedule" ADD CONSTRAINT "VowSchedule_vowId_fkey" FOREIGN KEY ("vowId") REFERENCES "Vow"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VowCompletionEvent" ADD CONSTRAINT "VowCompletionEvent_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VowCompletionEvent" ADD CONSTRAINT "VowCompletionEvent_vowId_fkey" FOREIGN KEY ("vowId") REFERENCES "Vow"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RewardGrant" ADD CONSTRAINT "RewardGrant_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RewardGrant" ADD CONSTRAINT "RewardGrant_completionEventId_fkey" FOREIGN KEY ("completionEventId") REFERENCES "VowCompletionEvent"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SyncOperation" ADD CONSTRAINT "SyncOperation_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChapterState" ADD CONSTRAINT "ChapterState_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DistrictState" ADD CONSTRAINT "DistrictState_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SubscriptionState" ADD CONSTRAINT "SubscriptionState_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AnalyticsRawEvent" ADD CONSTRAINT "AnalyticsRawEvent_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditLog" ADD CONSTRAINT "AuditLog_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

