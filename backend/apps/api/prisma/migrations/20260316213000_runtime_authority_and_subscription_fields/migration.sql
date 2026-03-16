ALTER TABLE "Profile"
ADD COLUMN     "displayName" TEXT NOT NULL DEFAULT 'Wayfarer',
ADD COLUMN     "pronouns" TEXT,
ADD COLUMN     "selectedGoals" JSONB NOT NULL DEFAULT '[]'::jsonb,
ADD COLUMN     "selectedLifeAreas" JSONB NOT NULL DEFAULT '[]'::jsonb,
ADD COLUMN     "blocker" TEXT,
ADD COLUMN     "dailyLoad" INTEGER NOT NULL DEFAULT 3;

ALTER TABLE "Vow"
ADD COLUMN     "category" TEXT NOT NULL DEFAULT 'Physical',
ADD COLUMN     "difficulty" TEXT NOT NULL DEFAULT 'standard';

ALTER TABLE "SubscriptionState"
ADD COLUMN     "trialEligible" BOOLEAN NOT NULL DEFAULT true;

CREATE TABLE "CoreLoopRuntimeSnapshot" (
    "id" TEXT NOT NULL,
    "statePayload" JSONB NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CoreLoopRuntimeSnapshot_pkey" PRIMARY KEY ("id")
);
