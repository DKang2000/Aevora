import SwiftUI

struct TodayRootView: View {
    @EnvironmentObject private var environment: AppEnvironment

    var body: some View {
        NavigationStack {
            let store = environment.firstPlayableStore
            let accountStore = environment.accountSurfaceStore

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(store.copy.text("today.headline", fallback: "Today's vows"))
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                        Text("Day \(store.chapterState.currentDay) of \(store.chapterState.chapterLength) in \(store.chapterState.title)")
                            .font(.headline)
                            .foregroundStyle(.secondary)
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
                RewardModalView(state: reward, copy: store.copy) {
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
        VStack(alignment: .leading, spacing: 12) {
            Text(store.copy.text("today.chapter_title", fallback: "Current chapter"))
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            Text(store.chapterState.title)
                .font(.title3.bold())
            Text(store.chapterState.objectiveTitle)
                .font(.headline)
            Text(store.chapterState.summary)
                .foregroundStyle(.secondary)
            ProgressView(value: store.chapterState.progressPercent)
                .tint(Color(red: 0.89, green: 0.55, blue: 0.25))
            if store.chapterState.statusNote.isEmpty == false {
                Text(store.chapterState.statusNote)
                    .font(.footnote)
                    .foregroundStyle(Color(red: 0.45, green: 0.24, blue: 0.13))
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
        }
        .padding(18)
        .background(
            LinearGradient(
                colors: [Color(red: 0.96, green: 0.90, blue: 0.81), Color(red: 0.93, green: 0.82, blue: 0.67)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
    }

    private func reminderStrip(store: FirstPlayableStore) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(store.reminderPrompts) { prompt in
                VStack(alignment: .leading, spacing: 4) {
                    Text(prompt.title)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Text(prompt.body)
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(14)
                .background(Color(red: 0.95, green: 0.93, blue: 0.89))
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
        }
    }

    private func returnSurfacesCard(store: FirstPlayableStore, accountStore: AccountSurfaceStore) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Return surfaces")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            if accountStore.shouldShowNotificationEducation && store.completionDayCount > 0 {
                VStack(alignment: .leading, spacing: 8) {
                    Text(store.copy.text("notifications.education_title", fallback: "Let Aevora keep the district in view"))
                        .font(.headline)
                    Text(store.copy.text("notifications.education_body", fallback: "Turn on notifications after setup so vow reminders and witness beats can pull you back without friction."))
                        .foregroundStyle(.secondary)
                    Button("Turn on notifications") {
                        accountStore.requestNotifications(using: store)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(red: 0.45, green: 0.24, blue: 0.13))
                }
            }

            if accountStore.shouldShowHealthKitEducation && store.hasCompletedOnboarding {
                VStack(alignment: .leading, spacing: 8) {
                    Text(store.copy.text("healthkit.education_title", fallback: "Verified inputs can stay narrow and optional"))
                        .font(.headline)
                    Text(store.copy.text("healthkit.education_body", fallback: "If one of your vows matches a supported HealthKit path, you can connect it here and still keep manual logging available."))
                        .foregroundStyle(.secondary)
                    Button(store.copy.text("healthkit.connect_cta", fallback: "Connect HealthKit")) {
                        accountStore.connectHealthKit(using: store)
                    }
                    .buttonStyle(.bordered)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(accountStore.supportsAdvancedWidgets ? "Premium witness surfaces are active." : "The free Today widget is ready. Premium adds deeper witness surfaces.")
                    .font(.subheadline)
                Text(accountStore.supportsLiveActivities ? "Live Activities can stay active while your current chapter is in motion." : "Live Activities unlock with premium breadth.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(18)
        .background(Color(red: 0.95, green: 0.93, blue: 0.89))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private func vowList(store: FirstPlayableStore) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(store.activeVows) { vow in
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(vow.title)
                                .font(.headline)
                            Text("\(vow.category) • \(vow.targetValue) \(vow.targetUnit)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            if let badge = store.completionBadge(for: vow.id) {
                                Text(badge)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(Color(red: 0.24, green: 0.48, blue: 0.31))
                            }
                        }
                        Spacer()
                        Text(vow.statusLabel)
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(vow.isCompleteToday ? .green : .secondary)
                    }
                    ProgressView(value: min(Double(vow.progressToday) / Double(max(vow.targetValue, 1)), 1))
                        .tint(vow.isCompleteToday ? .green : Color(red: 0.89, green: 0.55, blue: 0.25))
                    if let history = vow.history.first {
                        Text("Last kept: \(history.localDate) • \(history.progressState.capitalized)")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    Button(vow.type == "binary" ? store.copy.text("vow.binary_done", fallback: "Completed") : store.copy.text("today.complete_vow_cta", fallback: "Log progress")) {
                        store.quickLog(vow)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(red: 0.45, green: 0.24, blue: 0.13))
                    .disabled(vow.isCompleteToday)
                    .accessibilityLabel("Log progress for \(vow.title)")
                }
                .padding(18)
                .background(Color(red: 0.98, green: 0.96, blue: 0.92))
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
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
            if !store.inventoryItems.isEmpty {
                Text("Latest keepsake: \(store.inventoryItems.last?.name ?? "")")
                    .font(.footnote.weight(.semibold))
            }
            Text(store.chapterState.tomorrowPrompt)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }

    private func statChip(title: String, value: Int) -> some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.headline)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(red: 0.95, green: 0.93, blue: 0.89))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
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
                .tint(Color(red: 0.45, green: 0.24, blue: 0.13))
            }
            .padding()
            .navigationTitle(store.copy.text("vow.progress_title", fallback: "Log today's progress"))
        }
        .presentationDetents([.fraction(0.28)])
    }

    private func paywallPreview(store: FirstPlayableStore, accountStore: AccountSurfaceStore) -> some View {
        VStack(spacing: 20) {
            Text(store.copy.text("paywall.headline", fallback: "Unlock your full journey in Aevora"))
                .font(.title2.bold())
                .multilineTextAlignment(.center)
            Text(store.copy.text("paywall.body", fallback: "Premium expands your world, your witness surfaces, and your active vow breadth."))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            VStack(spacing: 12) {
                if accountStore.subscriptionState.trialEligible && accountStore.subscriptionState.tier == .free {
                    Button(store.copy.text("paywall.trial_cta", fallback: "Start free trial")) {
                        accountStore.startTrial(using: store)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(red: 0.45, green: 0.24, blue: 0.13))
                } else {
                    Button("Unlock monthly premium") {
                        accountStore.purchase(tier: .premiumMonthly, using: store)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(red: 0.45, green: 0.24, blue: 0.13))
                }

                Button("Unlock annual premium") {
                    accountStore.purchase(tier: .premiumAnnual, using: store)
                }
                .buttonStyle(.bordered)

                Button(store.copy.text("settings.restore_purchase_cta", fallback: "Restore purchase")) {
                    accountStore.restorePurchases(using: store)
                }
                .buttonStyle(.bordered)
            }
            Button(store.copy.text("paywall.continue_free_cta", fallback: "Keep the free path")) {
                store.dismissSoftPaywall()
            }
            .buttonStyle(.borderedProminent)
            .tint(Color(red: 0.71, green: 0.63, blue: 0.56))
        }
        .padding(24)
        .presentationDetents([.medium])
    }
}
