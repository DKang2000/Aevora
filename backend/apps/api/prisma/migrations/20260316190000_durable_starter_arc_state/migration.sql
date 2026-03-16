-- CreateTable
CREATE TABLE "LevelState" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "rank" INTEGER NOT NULL,
    "currentRankResonance" INTEGER NOT NULL,
    "lifetimeResonance" INTEGER NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "LevelState_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EmberState" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "availableEmbers" INTEGER NOT NULL,
    "heat" INTEGER NOT NULL,
    "lastCoolingDate" TEXT,
    "lastRekindledDate" TEXT,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "EmberState_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ChainState" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "vowId" TEXT NOT NULL,
    "currentLength" INTEGER NOT NULL,
    "bestLength" INTEGER NOT NULL,
    "status" TEXT NOT NULL,
    "lastCompletedDate" TEXT,
    "coolingExpiresAt" TIMESTAMP(3),
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ChainState_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "InventoryItem" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "itemDefinitionId" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL DEFAULT 1,
    "bucket" TEXT NOT NULL,
    "rarity" TEXT NOT NULL,
    "sourceRewardGrantId" TEXT,
    "itemPayload" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "InventoryItem_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "LevelState_userId_key" ON "LevelState"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "EmberState_userId_key" ON "EmberState"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "ChainState_vowId_key" ON "ChainState"("vowId");

-- CreateIndex
CREATE UNIQUE INDEX "ChainState_userId_vowId_key" ON "ChainState"("userId", "vowId");

-- CreateIndex
CREATE INDEX "ChainState_userId_status_idx" ON "ChainState"("userId", "status");

-- CreateIndex
CREATE INDEX "InventoryItem_userId_bucket_idx" ON "InventoryItem"("userId", "bucket");

-- CreateIndex
CREATE INDEX "InventoryItem_sourceRewardGrantId_idx" ON "InventoryItem"("sourceRewardGrantId");

-- AddForeignKey
ALTER TABLE "LevelState" ADD CONSTRAINT "LevelState_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmberState" ADD CONSTRAINT "EmberState_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChainState" ADD CONSTRAINT "ChainState_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChainState" ADD CONSTRAINT "ChainState_vowId_fkey" FOREIGN KEY ("vowId") REFERENCES "Vow"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InventoryItem" ADD CONSTRAINT "InventoryItem_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InventoryItem" ADD CONSTRAINT "InventoryItem_sourceRewardGrantId_fkey" FOREIGN KEY ("sourceRewardGrantId") REFERENCES "RewardGrant"("id") ON DELETE SET NULL ON UPDATE CASCADE;
