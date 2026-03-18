import SwiftUI

struct TodayRootView: View {
    @EnvironmentObject private var environment: AppEnvironment

    static let chapterAssetSlots: [AevoraAssetSlot] = [.chapterCard, .promoCard]
    static let rewardAssetSlots: [AevoraAssetSlot] = [.rewardCard, .rewardFX]

    var body: some View {
        NavigationStack {
            let store = environment.firstPlayableStore
            let accountStore = environment.accountSurfaceStore

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(store.copy.text("today.headline", fallback: "Today's vows"))
                            .font(AevoraTokens.Typography.displayLarge)
                        Text("Day \(store.chapterState.currentDay) of \(store.chapterState.chapterLength) in \(store.chapterState.title)")
                            .font(AevoraTokens.Typography.headline)
                            .foregroundStyle(AevoraTokens.Color.text.secondary)
                    }

                    chapterCard(store: store)
                    reminderStrip(store: store)
                    returnSurfacesCard(store: store, accountStore: accountStore)
                    vowList(store: store)
                    footerStats(store: store)
                }
                .padding()
            }
            .navigationTitle("Today")
            .sheet(item: $environment.firstPlayableStore.rewardPresentation) { reward in
                RewardModalView(state: reward, copy: store.copy, assetResolver: environment.assetResolver) {
                    environment.firstPlayableStore.rewardDismissed()
                    environment.selectedTab = .world
                }
            }
            .sheet(isPresented: $environment.firstPlayableStore.isQuestJournalPresented) {
                QuestJournalSheet(
                    content: store.content,
                    copy: store.copy,
                    currentDay: store.chapterState.currentDay,
                    completionDayCount: store.completionDayCount
                )
            }
            .sheet(isPresented: $environment.firstPlayableStore.isProgressSheetPresented) {
                progressSheet(store: store)
            }
            .sheet(isPresented: $environment.firstPlayableStore.isSoftPaywallPresented) {
                paywallPreview(store: store, accountStore: accountStore)
            }
        }
    }

    private func chapterCard(store: FirstPlayableStore) -> some View {
        let resolutions = environment.assetResolver.resolve(slots: Self.chapterAssetSlots)

        return VStack(alignment: .leading, spacing: 12) {
            if let chapterResolution = resolutions.first {
                AevoraAssetRenderableView(
                    resolution: chapterResolution,
                    style: .wideBanner
                )
                .frame(height: 172)
            }
            Text(store.copy.text("today.chapter_title", fallback: "Current chapter"))
                .font(AevoraTokens.Typography.caption)
                .foregroundStyle(AevoraTokens.Color.text.secondary)
            Text(store.chapterState.title)
                .font(AevoraTokens.Typography.titleCard)
            Text(store.chapterState.objectiveTitle)
                .font(AevoraTokens.Typography.headline)
            Text(store.chapterState.summary)
                .font(AevoraTokens.Typography.subheadline)
                .foregroundStyle(AevoraTokens.Color.text.secondary)
            ProgressView(value: store.chapterState.progressPercent)
                .tint(AevoraTokens.Color.action.progress)
            if store.chapterState.statusNote.isEmpty == false {
                Text(store.chapterState.statusNote)
                    .font(AevoraTokens.Typography.footnote)
                    .foregroundStyle(AevoraTokens.Color.action.primaryFill)
            }
            Button {
                store.isQuestJournalPresented = true
            } label: {
                HStack {
                    Text(store.copy.text("today.quest_title", fallback: "Today's chapter beat"))
                    Spacer()
                    Text("Open")
                }
            }
            .buttonStyle(.bordered)
            if let promoResolution = resolutions.dropFirst().first {
                HStack {
                    Text("Promo family stays ready for imported art without changing the chapter card structure.")
                        .font(AevoraTokens.Typography.caption)
                        .foregroundStyle(AevoraTokens.Color.text.secondary)
                    Spacer()
                    AevoraAssetStatusPill(resolution: promoResolution)
                }
            }
        }
        .padding(18)
        .background(AevoraTokens.Gradient.chapter.primary)
        .clipShape(RoundedRectangle(cornerRadius: AevoraTokens.Radius.xl, style: .continuous))
    }

    private func reminderStrip(store: FirstPlayableStore) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(store.reminderPrompts) { prompt in
                VStack(alignment: .leading, spacing: 4) {
                    Text(prompt.title)
                        .font(AevoraTokens.Typography.caption)
                        .foregroundStyle(AevoraTokens.Color.text.secondary)
                    Text(prompt.body)
                        .font(AevoraTokens.Typography.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(14)
                .background(AevoraTokens.Color.surface.cardSecondary)
                .clipShape(RoundedRectangle(cornerRadius: AevoraTokens.Radius.sm, style: .continuous))
            }
        }
    }

    private func returnSurfacesCard(store: FirstPlayableStore, accountStore: AccountSurfaceStore) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Return surfaces")
                .font(AevoraTokens.Typography.caption)
                .foregroundStyle(AevoraTokens.Color.text.secondary)

            if accountStore.shouldShowNotificationEducation && store.completionDayCount > 0 {
                VStack(alignment: .leading, spacing: 8) {
                    Text(store.copy.text("notifications.education_title", fallback: "Let Aevora keep the district in view"))
                        .font(AevoraTokens.Typography.headline)
                    Text(store.copy.text("notifications.education_body", fallback: "Turn on notifications after setup so vow reminders and witness beats can pull you back without friction."))
                        .font(AevoraTokens.Typography.subheadline)
                        .foregroundStyle(AevoraTokens.Color.text.secondary)
                    Button("Turn on notifications") {
                        accountStore.requestNotifications(using: store)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AevoraTokens.Color.action.primaryFill)
                }
            }

            if accountStore.shouldShowHealthKitEducation && store.hasCompletedOnboarding {
                VStack(alignment: .leading, spacing: 8) {
                    Text(store.copy.text("healthkit.education_title", fallback: "Verified inputs can stay narrow and optional"))
                        .font(AevoraTokens.Typography.headline)
                    Text(store.copy.text("healthkit.education_body", fallback: "If one of your vows matches a supported HealthKit path, you can connect it here and still keep manual logging available."))
                        .font(AevoraTokens.Typography.subheadline)
                        .foregroundStyle(AevoraTokens.Color.text.secondary)
                    Button(store.copy.text("healthkit.connect_cta", fallback: "Connect HealthKit")) {
                        accountStore.connectHealthKit(using: store)
                    }
                    .buttonStyle(.bordered)
                    .tint(AevoraTokens.Color.action.primaryFill)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(accountStore.supportsAdvancedWidgets ? "Premium witness surfaces are active." : "The free Today widget is ready. Premium adds deeper witness surfaces.")
                    .font(AevoraTokens.Typography.subheadline)
                Text(accountStore.supportsLiveActivities ? "Live Activities can stay active while your current chapter is in motion." : "Live Activities unlock with premium breadth.")
                    .font(AevoraTokens.Typography.footnote)
                    .foregroundStyle(AevoraTokens.Color.text.secondary)
            }
        }
        .padding(18)
        .background(AevoraTokens.Color.surface.cardSecondary)
        .clipShape(RoundedRectangle(cornerRadius: AevoraTokens.Radius.md, style: .continuous))
    }

    private func vowList(store: FirstPlayableStore) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(store.activeVows) { vow in
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(vow.title)
                                .font(AevoraTokens.Typography.headline)
                            Text("\(vow.category) • \(vow.targetValue) \(vow.targetUnit)")
                                .font(AevoraTokens.Typography.subheadline)
                                .foregroundStyle(AevoraTokens.Color.text.secondary)
                            if let badge = store.completionBadge(for: vow.id) {
                                Text(badge)
                                    .font(AevoraTokens.Typography.caption)
                                    .foregroundStyle(AevoraTokens.Color.text.success)
                            }
                        }
                        Spacer()
                        Text(vow.statusLabel)
                            .font(AevoraTokens.Typography.footnote)
                            .foregroundStyle(vow.isCompleteToday ? AevoraTokens.Color.text.success : AevoraTokens.Color.text.secondary)
                    }
                    ProgressView(value: min(Double(vow.progressToday) / Double(max(vow.targetValue, 1)), 1))
                        .tint(vow.isCompleteToday ? AevoraTokens.Color.state.successFill : AevoraTokens.Color.action.progress)
                    if let history = vow.history.first {
                        Text("Last kept: \(history.localDate) • \(history.progressState.capitalized)")
                            .font(AevoraTokens.Typography.footnote)
                            .foregroundStyle(AevoraTokens.Color.text.secondary)
                    }
                    Button(vow.type == "binary" ? store.copy.text("vow.binary_done", fallback: "Completed") : store.copy.text("today.complete_vow_cta", fallback: "Log progress")) {
                        store.quickLog(vow)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AevoraTokens.Color.action.primaryFill)
                    .disabled(vow.isCompleteToday)
                    .accessibilityLabel("Log progress for \(vow.title)")
                }
                .padding(18)
                .background(AevoraTokens.Color.surface.cardPrimary)
                .clipShape(RoundedRectangle(cornerRadius: AevoraTokens.Radius.lg, style: .continuous))
            }
        }
    }

    private func footerStats(store: FirstPlayableStore) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                statChip(title: store.copy.text("today.chain_title", fallback: "Chains"), value: store.activeVows.map(\.chainLength).max() ?? 0)
                statChip(title: store.copy.text("today.embers_title", fallback: "Embers"), value: store.availableEmbers)
                statChip(title: "Gold", value: store.goldBalance)
                statChip(title: "Rank", value: store.rank)
            }
            Button(store.copy.text("today.world_cta", fallback: "See the district respond")) {
                environment.selectedTab = .world
            }
            .buttonStyle(.bordered)
            .tint(AevoraTokens.Color.action.primaryFill)
            if !store.inventoryItems.isEmpty {
                Text("Latest keepsake: \(store.inventoryItems.last?.name ?? "")")
                    .font(AevoraTokens.Typography.footnote)
            }
            Text(store.chapterState.tomorrowPrompt)
                .font(AevoraTokens.Typography.footnote)
                .foregroundStyle(AevoraTokens.Color.text.secondary)
        }
    }

    private func statChip(title: String, value: Int) -> some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(AevoraTokens.Typography.headline)
            Text(title)
                .font(AevoraTokens.Typography.caption)
                .foregroundStyle(AevoraTokens.Color.text.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(AevoraTokens.Color.surface.cardSecondary)
        .clipShape(RoundedRectangle(cornerRadius: AevoraTokens.Radius.sm, style: .continuous))
    }

    private func progressSheet(store: FirstPlayableStore) -> some View {
        NavigationStack {
            VStack(spacing: 20) {
                Stepper(value: $environment.firstPlayableStore.progressSheetValue, in: 1...180) {
                    Text("\(environment.firstPlayableStore.progressSheetValue)")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                }
                .padding()

                Button(store.copy.text("vow.partial_cta", fallback: "Save progress")) {
                    store.confirmProgressSheet()
                }
                .buttonStyle(.borderedProminent)
                .tint(AevoraTokens.Color.action.primaryFill)
            }
            .padding()
            .navigationTitle(store.copy.text("vow.progress_title", fallback: "Log today's progress"))
        }
        .presentationDetents([.fraction(0.28)])
    }

    private func paywallPreview(store: FirstPlayableStore, accountStore: AccountSurfaceStore) -> some View {
        VStack(spacing: 20) {
            Text(store.copy.text("paywall.headline", fallback: "Unlock your full journey in Aevora"))
                .font(AevoraTokens.Typography.displayMedium)
                .multilineTextAlignment(.center)
            Text(store.copy.text("paywall.body", fallback: "Premium expands your world, your witness surfaces, and your active vow breadth."))
                .font(AevoraTokens.Typography.subheadline)
                .foregroundStyle(AevoraTokens.Color.text.secondary)
                .multilineTextAlignment(.center)
            VStack(spacing: 12) {
                if accountStore.subscriptionState.trialEligible && accountStore.subscriptionState.tier == .free {
                    Button(store.copy.text("paywall.trial_cta", fallback: "Start free trial")) {
                        accountStore.startTrial(using: store)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AevoraTokens.Color.action.primaryFill)
                } else {
                    Button("Unlock monthly premium") {
                        accountStore.purchase(tier: .premiumMonthly, using: store)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AevoraTokens.Color.action.primaryFill)
                }

                Button("Unlock annual premium") {
                    accountStore.purchase(tier: .premiumAnnual, using: store)
                }
                .buttonStyle(.bordered)
                .tint(AevoraTokens.Color.action.primaryFill)

                Button(store.copy.text("settings.restore_purchase_cta", fallback: "Restore purchase")) {
                    accountStore.restorePurchases(using: store)
                }
                .buttonStyle(.bordered)
                .tint(AevoraTokens.Color.action.primaryFill)
            }
            Button(store.copy.text("paywall.continue_free_cta", fallback: "Keep the free path")) {
                store.dismissSoftPaywall()
            }
            .buttonStyle(.borderedProminent)
            .tint(AevoraTokens.Color.parchmentStone.shade300)
        }
        .padding(24)
        .presentationDetents([.medium])
    }
}
