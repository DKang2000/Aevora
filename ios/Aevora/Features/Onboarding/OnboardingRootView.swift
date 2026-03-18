import AuthenticationServices
import SwiftUI

enum OnboardingFooterMode: Equatable {
    case backOnly
    case advance
    case inlineCompletion
}

struct OnboardingFooterConfiguration: Equatable {
    let mode: OnboardingFooterMode
    let primaryTitle: String?
}

struct OnboardingRootView: View {
    @ObservedObject var store: FirstPlayableStore
    @EnvironmentObject private var environment: AppEnvironment

    private let goals = ["consistency", "energy", "focus", "calm", "discipline", "momentum", "balance", "confidence"]
    private let lifeAreas = ["Physical", "Intellectual", "Career", "Hobbies", "Emotional"]
    private let blockers = ["I forget", "I try to do too much", "I lose motivation", "I feel all-or-nothing", "My days are unpredictable", "My current tools feel dead"]
    private let tones = ["gentle", "balanced", "driven"]

    private var currentStep: OnboardingFlowStep {
        store.currentOnboardingFlowStep
    }

    private var accountStore: AccountSurfaceStore {
        environment.accountSurfaceStore
    }

    private var assetResolver: AevoraAssetResolver {
        environment.assetResolver
    }

    static func footerConfiguration(for step: OnboardingFlowStep, copy: CopyCatalog) -> OnboardingFooterConfiguration {
        switch step {
        case .signIn:
            return OnboardingFooterConfiguration(mode: .backOnly, primaryTitle: nil)
        case .softPaywall:
            return OnboardingFooterConfiguration(mode: .inlineCompletion, primaryTitle: nil)
        case .starterVows:
            return OnboardingFooterConfiguration(mode: .advance, primaryTitle: "Preview quest")
        case .questPreview:
            return OnboardingFooterConfiguration(mode: .advance, primaryTitle: "See first witness")
        case .magicalMoment:
            return OnboardingFooterConfiguration(mode: .advance, primaryTitle: "See options")
        default:
            return OnboardingFooterConfiguration(
                mode: .advance,
                primaryTitle: copy.text("onboarding.next", fallback: "Next")
            )
        }
    }

    static func avatarStepState(for store: FirstPlayableStore) -> OnboardingAvatarStepState {
        store.onboardingAvatarStepState
    }

    static func assetSlot(for step: OnboardingFlowStep) -> AevoraAssetSlot? {
        switch step {
        case .welcomePromise:
            return .onboardingPromiseCards
        case .problemSolution:
            return .onboardingProblemSolutionCards
        case .family:
            return .onboardingFamilySelectionCards
        case .identity:
            return .onboardingIdentitySelectionCards
        case .avatar:
            return .avatarBaseBodyFrame
        case .magicalMoment:
            return .onboardingMagicalMomentHero
        case .softPaywall:
            return .onboardingPaywallSupporting
        default:
            return nil
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                progressHeader

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        stepBody
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 12)
                }

                footer
            }
            .padding(24)
            .background(AevoraTokens.Gradient.chapter.primary.ignoresSafeArea())
        }
    }

    private var progressHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Aevora")
                .font(AevoraTokens.Typography.caption)
                .foregroundStyle(AevoraTokens.Color.text.secondary)
            ProgressView(value: store.onboardingProgressValue, total: store.onboardingProgressTotal)
                .tint(AevoraTokens.Color.action.progress)
        }
    }

    @ViewBuilder
    private var footer: some View {
        let configuration = Self.footerConfiguration(for: currentStep, copy: store.copy)

        switch configuration.mode {
        case .backOnly:
            HStack {
                if currentStep.rawValue > 0 {
                    Button(store.copy.text("onboarding.back", fallback: "Back")) {
                        store.goBackOnboarding()
                    }
                    .buttonStyle(.bordered)
                }
                Spacer()
            }
        case .inlineCompletion:
            EmptyView()
        case .advance:
            HStack {
                if currentStep.rawValue > 0 {
                    Button(store.copy.text("onboarding.back", fallback: "Back")) {
                        store.goBackOnboarding()
                    }
                    .buttonStyle(.bordered)
                }

                Spacer()

                Button(configuration.primaryTitle ?? store.copy.text("onboarding.next", fallback: "Next")) {
                    store.advanceOnboarding()
                }
                .buttonStyle(.borderedProminent)
                .tint(AevoraTokens.Color.action.primaryFill)
                .disabled(isNextDisabled)
            }
        }
    }

    @ViewBuilder
    private var stepBody: some View {
        switch currentStep {
        case .welcomePromise:
            welcomePromiseView
        case .problemSolution:
            problemSolutionView
        case .signIn:
            signInView
        case .goals:
            optionPicker(
                title: store.copy.text("onboarding.goal_title", fallback: "What do you want more of right now?"),
                subtitle: "Choose up to three.",
                options: goals,
                selection: Binding(
                    get: { store.selectedGoals },
                    set: { store.selectedGoals = $0 }
                ),
                limit: 3
            )
        case .lifeAreas:
            optionPicker(
                title: store.copy.text("onboarding.life_areas_title", fallback: "Which life areas matter most this month?"),
                subtitle: "Choose up to three.",
                options: lifeAreas,
                selection: Binding(
                    get: { store.selectedLifeAreas },
                    set: { store.selectedLifeAreas = $0 }
                ),
                limit: 3
            )
        case .blocker:
            singleChoice(
                title: store.copy.text("onboarding.blocker_title", fallback: "What usually gets in your way?"),
                options: blockers,
                selection: $store.selectedBlocker
            )
        case .dailyLoad:
            dailyLoadView
        case .tone:
            singleChoice(
                title: store.copy.text("onboarding.tone_title", fallback: "What tone do you want from Aevora?"),
                options: tones,
                selection: $store.toneMode
            )
        case .family:
            familySelectionView
        case .identity:
            identitySelectionView
        case .avatar:
            avatarBasicsView
        case .starterVows:
            starterVowsView
        case .questPreview:
            questPreviewView
        case .magicalMoment:
            magicalMomentView
        case .softPaywall:
            softPaywallView
        }
    }

    private var welcomePromiseView: some View {
        let onboardingAsset = assetResolver.resolve(.onboardingPromiseCards)

        return VStack(alignment: .leading, spacing: 16) {
            AevoraAssetAccentView(
                resolution: onboardingAsset,
                title: "Onboarding card family",
                subtitle: "Promise cards stay mapped through one logical slot."
            )
            Text(store.copy.text("onboarding.welcome_title", fallback: "Level up in Aevora as you level up in real life."))
                .font(AevoraTokens.Typography.displayLarge)
            Text(store.copy.text("onboarding.welcome_body", fallback: "Keep a few meaningful vows, and the city will answer."))
                .font(AevoraTokens.Typography.headline)
                .foregroundStyle(AevoraTokens.Color.text.secondary)

            cardPanel(title: "What this feels like", eyebrow: "Welcome") {
                Text("Aevora starts with a believable plan, a chosen path, and one early proof that your real effort changes the city.")
                    .font(AevoraTokens.Typography.body)
                    .foregroundStyle(AevoraTokens.Color.text.secondary)
            }

            reassuranceStrip(items: [
                "Seen, not scored",
                "Small plans win",
                "Free path stays visible"
            ])
        }
    }

    private var problemSolutionView: some View {
        let onboardingAsset = assetResolver.resolve(.onboardingProblemSolutionCards)

        return VStack(alignment: .leading, spacing: 16) {
            AevoraAssetAccentView(
                resolution: onboardingAsset,
                title: "Problem/solution carousel",
                subtitle: "Runtime stays placeholder-safe while the final card family is still manual."
            )
            Text("Why Aevora works")
                .font(AevoraTokens.Typography.displayMedium)
            Text("Three quick beats establish the product logic before setup questions begin.")
                .font(AevoraTokens.Typography.subheadline)
                .foregroundStyle(AevoraTokens.Color.text.secondary)

            VStack(spacing: 12) {
                messageCard(
                    eyebrow: "Problem",
                    title: "Boring trackers don't stick",
                    body: "Rigid checklists feel dead before the week is done.",
                    accent: AevoraTokens.Color.ashPlum.shade300
                )
                messageCard(
                    eyebrow: "Recovery",
                    title: "One bad day shouldn't erase you",
                    body: "Momentum can cool without erasing who you are becoming.",
                    accent: AevoraTokens.Color.mossGreen.shade300
                )
                messageCard(
                    eyebrow: "Witness",
                    title: "Progress should feel visible",
                    body: "A kept vow changes the district, not just a number in a tracker.",
                    accent: AevoraTokens.Color.emberCopper.shade300
                )
            }
        }
    }

    private var signInView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Continue into Cyrane")
                .font(AevoraTokens.Typography.displayMedium)
            Text("Sign in now or keep moving as a guest. The free path stays valid either way.")
                .font(AevoraTokens.Typography.subheadline)
                .foregroundStyle(AevoraTokens.Color.text.secondary)

            SignInWithAppleButton(.continue) { request in
                request.requestedScopes = [.fullName]
            } onCompletion: { result in
                switch result {
                case .success(let authorization):
                    let credential = authorization.credential as? ASAuthorizationAppleIDCredential
                    let tokenData = credential?.identityToken
                    let token = tokenData.flatMap { String(data: $0, encoding: .utf8) } ?? UUID().uuidString
                    store.completeAppleSignIn(token: token)
                    store.advanceOnboarding()
                case .failure:
                    store.authErrorMessage = "Apple sign-in could not be completed."
                }
            }
            .signInWithAppleButtonStyle(.black)
            .frame(height: 52)

            Button(store.copy.text("onboarding.continue_guest", fallback: "Continue as guest")) {
                store.beginGuestMode()
                store.advanceOnboarding()
            }
            .buttonStyle(.borderedProminent)
            .tint(AevoraTokens.Color.action.primaryFill)

            if let authErrorMessage = store.authErrorMessage {
                Text(authErrorMessage)
                    .font(AevoraTokens.Typography.footnote)
                    .foregroundStyle(AevoraTokens.Color.text.warning)
            }
        }
    }

    private var dailyLoadView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(store.copy.text("onboarding.daily_load_title", fallback: "How many daily vows can you realistically keep?"))
                .font(AevoraTokens.Typography.headline)
            Picker("Daily load", selection: $store.dailyLoad) {
                Text("3").tag(3)
                Text("5").tag(5)
                Text("7").tag(7)
            }
            .pickerStyle(.segmented)

            cardPanel(title: "Recommendation", eyebrow: "Starter plan") {
                Text("Default to three unless you explicitly want more. The first week should feel believable, not heroic on paper.")
                    .font(AevoraTokens.Typography.body)
                    .foregroundStyle(AevoraTokens.Color.text.secondary)
            }
        }
    }

    private var familySelectionView: some View {
        let onboardingAsset = assetResolver.resolve(.onboardingFamilySelectionCards)

        return VStack(alignment: .leading, spacing: 16) {
            AevoraAssetAccentView(
                resolution: onboardingAsset,
                title: "Family selection accents",
                subtitle: "Each origin family keeps one logical art family instead of ad hoc card assets."
            )
            Text(store.copy.text("onboarding.family_title", fallback: "Choose your origin family"))
                .font(AevoraTokens.Typography.displayMedium)
            Text("Plain-language framing first, with a mythic civic accent carried by shape, props, and materials.")
                .font(AevoraTokens.Typography.subheadline)
                .foregroundStyle(AevoraTokens.Color.text.secondary)

            ForEach(store.content.originFamilies) { family in
                let accent = familyAccent(for: family.id)
                choiceCard(
                    title: store.copy.text(family.titleKey, fallback: family.id),
                    body: store.copy.text(family.summaryKey, fallback: family.summaryKey),
                    isSelected: family.id == store.selectedFamilyID,
                    accent: accent
                ) {
                    store.selectedFamilyID = family.id
                    if let firstIdentity = store.content.identityShells.first(where: { $0.originFamilyId == family.id }) {
                        store.selectedIdentityID = firstIdentity.id
                    }
                }
            }
        }
    }

    private var identitySelectionView: some View {
        let onboardingAsset = assetResolver.resolve(.onboardingIdentitySelectionCards)

        return VStack(alignment: .leading, spacing: 16) {
            AevoraAssetAccentView(
                resolution: onboardingAsset,
                title: "Identity selection accents",
                subtitle: "Selection boards can be swapped in later without changing this screen’s logic."
            )
            Text(store.copy.text("onboarding.identity_title", fallback: "Choose your path"))
                .font(AevoraTokens.Typography.displayMedium)
            Text("The free path can choose any one launch identity now. Premium breadth comes later through switching and chapter depth.")
                .font(AevoraTokens.Typography.subheadline)
                .foregroundStyle(AevoraTokens.Color.text.secondary)

            ForEach(store.content.identityShells.filter { $0.originFamilyId == store.selectedFamilyID }) { identity in
                let accent = identityAccent(for: identity)
                choiceCard(
                    title: store.copy.text(identity.displayNameKey, fallback: identity.id),
                    body: store.copy.text(identity.summaryKey, fallback: identity.summaryKey),
                    isSelected: identity.id == store.selectedIdentityID,
                    accent: accent
                ) {
                    store.selectedIdentityID = identity.id
                }
            }
        }
    }

    private var avatarBasicsView: some View {
        let avatarState = Self.avatarStepState(for: store)
        let baseFrameResolution = assetResolver.resolve(.avatarBaseBodyFrame)
        let bustAnchorResolution = assetResolver.resolve(.avatarBaseBustAnchor)

        return VStack(alignment: .leading, spacing: 16) {
            Text(store.copy.text("onboarding.avatar_title", fallback: "Shape your arrival"))
                .font(AevoraTokens.Typography.displayMedium)
            Text("Keep this fast. One screen, one preview, and no long character creator detour.")
                .font(AevoraTokens.Typography.subheadline)
                .foregroundStyle(AevoraTokens.Color.text.secondary)

            tokenTextField("Name", text: $store.avatarDraft.displayName)
            tokenTextField("Pronouns (optional)", text: $store.avatarDraft.pronouns)

            cardPanel(title: "Arrival preview", eyebrow: "Avatar basics") {
                VStack(alignment: .leading, spacing: 14) {
                    AvatarPreviewCard(
                        configuration: avatarState.configuration,
                        style: .onboarding,
                        assetResolutions: [baseFrameResolution, bustAnchorResolution]
                    )

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Silhouette")
                            .font(AevoraTokens.Typography.caption)
                            .foregroundStyle(AevoraTokens.Color.text.secondary)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(avatarState.silhouetteOptions) { option in
                                    Button {
                                        store.avatarDraft.silhouetteId = option.id
                                    } label: {
                                        AvatarSilhouetteOptionChip(
                                            option: option,
                                            paletteId: store.avatarDraft.paletteId,
                                            isSelected: option.id == store.avatarDraft.silhouetteId
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.vertical, 2)
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Palette")
                            .font(AevoraTokens.Typography.caption)
                            .foregroundStyle(AevoraTokens.Color.text.secondary)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(avatarState.paletteOptions) { option in
                                    Button {
                                        store.avatarDraft.paletteId = option.id
                                    } label: {
                                        AvatarPaletteOptionChip(
                                            option: option,
                                            isSelected: option.id == store.avatarDraft.paletteId
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.vertical, 2)
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Accessory")
                            .font(AevoraTokens.Typography.caption)
                            .foregroundStyle(AevoraTokens.Color.text.secondary)
                        AvatarLabelChip(
                            label: avatarState.configuration.accessoryLabel,
                            fill: AevoraTokens.Color.parchmentStone.shade200,
                            foreground: AevoraTokens.Color.text.primary
                        )
                    }
                }
            }
        }
    }

    private var starterVowsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(store.copy.text("onboarding.vows_title", fallback: "Your starter vows"))
                .font(AevoraTokens.Typography.displayMedium)
            Text("The first plan should feel humane, plausible, and light enough to keep.")
                .font(AevoraTokens.Typography.subheadline)
                .foregroundStyle(AevoraTokens.Color.text.secondary)

            ForEach(store.recommendedVows) { vow in
                cardPanel(title: vow.title, eyebrow: "Starter vow") {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("\(vow.category) • \(vow.targetValue) \(vow.targetUnit)")
                            .font(AevoraTokens.Typography.subheadline)
                            .foregroundStyle(AevoraTokens.Color.text.secondary)
                        Button("Replace") {
                            store.replaceRecommendation(vow.id)
                        }
                        .buttonStyle(.bordered)
                        .tint(AevoraTokens.Color.action.primaryFill)
                    }
                }
            }

            cardPanel(title: "Minimum viable consistency", eyebrow: "Pacing") {
                Text("At least one vow should feel almost impossible to fail on a normal day. That keeps the first week believable.")
                    .font(AevoraTokens.Typography.body)
                    .foregroundStyle(AevoraTokens.Color.text.secondary)
            }
        }
    }

    private var questPreviewView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quest preview")
                .font(AevoraTokens.Typography.displayMedium)
            Text("Quest framing should feel supportive and lightly mythic, never like a lore wall blocking setup.")
                .font(AevoraTokens.Typography.subheadline)
                .foregroundStyle(AevoraTokens.Color.text.secondary)

            VStack(alignment: .leading, spacing: 12) {
                Text("Day 1 • Arrival in a dim quarter")
                    .font(AevoraTokens.Typography.caption)
                    .foregroundStyle(AevoraTokens.Color.text.secondary)
                Text(store.onboardingQuestPreviewTitle)
                    .font(AevoraTokens.Typography.titleCard)
                Text(store.onboardingQuestPreviewSummary)
                    .font(AevoraTokens.Typography.subheadline)
                    .foregroundStyle(AevoraTokens.Color.text.secondary)
                ProgressView(value: 0.18)
                    .tint(AevoraTokens.Color.action.progress)
                Text(store.onboardingQuestTomorrowPrompt)
                    .font(AevoraTokens.Typography.footnote)
                    .foregroundStyle(AevoraTokens.Color.text.secondary)
            }
            .padding(18)
            .background(AevoraTokens.Gradient.chapter.primary)
            .clipShape(RoundedRectangle(cornerRadius: AevoraTokens.Radius.xl, style: .continuous))
        }
    }

    private var magicalMomentView: some View {
        let magicalMomentAsset = assetResolver.resolve(.onboardingMagicalMomentHero)
        let worldRepairAsset = assetResolver.resolve(.worldRepairFX)

        return VStack(alignment: .leading, spacing: 16) {
            AevoraAssetAccentView(
                resolution: magicalMomentAsset,
                title: "First witness frame",
                subtitle: "The magical moment stays art-slot driven and still lands before the soft paywall."
            )
            Text("Your first witness beat")
                .font(AevoraTokens.Typography.displayMedium)
            Text("Visible world consequence lands before any premium invitation.")
                .font(AevoraTokens.Typography.subheadline)
                .foregroundStyle(AevoraTokens.Color.text.secondary)

            sceneWitnessCard

            cardPanel(title: store.onboardingMagicalMomentPreviewTitle, eyebrow: "World response") {
                VStack(alignment: .leading, spacing: 8) {
                    AevoraAssetAccentView(
                        resolution: worldRepairAsset,
                        title: "World-repair FX hook",
                        subtitle: "Current builds use static proof instead of motion-heavy reward effects."
                    )
                    Text(store.onboardingMagicalMomentPreviewBody)
                        .font(AevoraTokens.Typography.body)
                        .foregroundStyle(AevoraTokens.Color.text.secondary)
                    Text(store.districtState.worldChangeText)
                        .font(AevoraTokens.Typography.subheadline)
                        .foregroundStyle(AevoraTokens.Color.action.primaryFill)
                }
            }
        }
    }

    private var softPaywallView: some View {
        let paywallAsset = assetResolver.resolve(.onboardingPaywallSupporting)

        return VStack(alignment: .leading, spacing: 20) {
            AevoraAssetAccentView(
                resolution: paywallAsset,
                title: "Supporting paywall art",
                subtitle: "The soft paywall keeps a dismissible free-path-safe slot even before final polish lands."
            )
            Text(store.copy.text("paywall.headline", fallback: "Unlock your full journey in Aevora"))
                .font(AevoraTokens.Typography.displayMedium)
            Text(store.copy.text("paywall.body", fallback: "Premium expands your world, your witness surfaces, and your active vow breadth."))
                .font(AevoraTokens.Typography.subheadline)
                .foregroundStyle(AevoraTokens.Color.text.secondary)

            cardPanel(title: "What stays free", eyebrow: "Free path") {
                Text("3 active vows, the 7-day starter arc, one launch identity, manual logging, and the basic world path remain available.")
                    .font(AevoraTokens.Typography.body)
                    .foregroundStyle(AevoraTokens.Color.text.secondary)
            }

            VStack(spacing: 12) {
                if accountStore.subscriptionState.trialEligible && accountStore.subscriptionState.tier == .free {
                    Button(store.copy.text("paywall.trial_cta", fallback: "Start free trial")) {
                        accountStore.startTrial(using: store)
                        store.finishOnboarding()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AevoraTokens.Color.action.primaryFill)
                } else if accountStore.subscriptionState.tier == .free {
                    Button("Unlock monthly premium") {
                        accountStore.purchase(tier: .premiumMonthly, using: store)
                        store.finishOnboarding()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AevoraTokens.Color.action.primaryFill)

                    Button("Unlock annual premium") {
                        accountStore.purchase(tier: .premiumAnnual, using: store)
                        store.finishOnboarding()
                    }
                    .buttonStyle(.bordered)
                    .tint(AevoraTokens.Color.action.primaryFill)
                } else {
                    Button("Continue to Today") {
                        store.finishOnboarding()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AevoraTokens.Color.action.primaryFill)
                }

                Button(store.copy.text("settings.restore_purchase_cta", fallback: "Restore purchase")) {
                    accountStore.restorePurchases(using: store)
                }
                .buttonStyle(.bordered)
                .tint(AevoraTokens.Color.action.primaryFill)

                Button(store.copy.text("paywall.continue_free_cta", fallback: "Keep the free path")) {
                    store.finishOnboarding()
                }
                .buttonStyle(.borderedProminent)
                .tint(AevoraTokens.Color.parchmentStone.shade300)
            }
        }
    }

    private var sceneWitnessCard: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: AevoraTokens.Radius.xl, style: .continuous)
                .fill(AevoraTokens.Gradient.world.deep)
                .frame(height: 250)
                .overlay(alignment: .topLeading) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Ember Quay responds")
                            .font(AevoraTokens.Typography.headline)
                            .foregroundStyle(AevoraTokens.Color.text.inverse)
                        Text("A shuttered oven glows, the lantern steadies, and the district feels warmer in one beat.")
                            .font(AevoraTokens.Typography.subheadline)
                            .foregroundStyle(AevoraTokens.Color.parchmentStone.shade100)
                    }
                    .padding(18)
                }
                .overlay(alignment: .bottomLeading) {
                    HStack(spacing: 18) {
                        RoundedRectangle(cornerRadius: AevoraTokens.Radius.sm, style: .continuous)
                            .fill(AevoraTokens.Color.emberCopper.shade700)
                            .frame(width: 72, height: 72)
                        Capsule()
                            .fill(AevoraTokens.Color.dawnGold.shade500)
                            .frame(width: 28, height: 86)
                        RoundedRectangle(cornerRadius: AevoraTokens.Radius.sm, style: .continuous)
                            .fill(AevoraTokens.Color.moonIndigo.shade300)
                            .frame(width: 116, height: 48)
                    }
                    .padding(18)
                }
        }
    }

    private var isNextDisabled: Bool {
        currentStep == .avatar && store.avatarDraft.displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func cardPanel<Content: View>(title: String, eyebrow: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(eyebrow)
                .font(AevoraTokens.Typography.caption)
                .foregroundStyle(AevoraTokens.Color.text.secondary)
            Text(title)
                .font(AevoraTokens.Typography.headline)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(AevoraTokens.Color.surface.cardPrimary.opacity(0.92))
        .overlay(tokenCardStroke(isSelected: false))
        .clipShape(RoundedRectangle(cornerRadius: AevoraTokens.Radius.md, style: .continuous))
    }

    private func reassuranceStrip(items: [String]) -> some View {
        VStack(spacing: 10) {
            ForEach(items, id: \.self) { item in
                HStack(spacing: 12) {
                    Circle()
                        .fill(AevoraTokens.Color.dawnGold.shade300)
                        .frame(width: 12, height: 12)
                    Text(item)
                        .font(AevoraTokens.Typography.subheadline)
                        .foregroundStyle(AevoraTokens.Color.text.primary)
                    Spacer()
                }
                .padding(14)
                .background(AevoraTokens.Color.surface.cardSecondary)
                .overlay(tokenCardStroke(isSelected: false))
                .clipShape(RoundedRectangle(cornerRadius: AevoraTokens.Radius.sm, style: .continuous))
            }
        }
    }

    private func messageCard(eyebrow: String, title: String, body: String, accent: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Circle()
                    .fill(accent)
                    .frame(width: 18, height: 18)
                Text(eyebrow)
                    .font(AevoraTokens.Typography.caption)
                    .foregroundStyle(AevoraTokens.Color.text.secondary)
            }
            Text(title)
                .font(AevoraTokens.Typography.headline)
            Text(body)
                .font(AevoraTokens.Typography.subheadline)
                .foregroundStyle(AevoraTokens.Color.text.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(AevoraTokens.Color.surface.cardPrimary.opacity(0.92))
        .overlay(tokenCardStroke(isSelected: false))
        .clipShape(RoundedRectangle(cornerRadius: AevoraTokens.Radius.md, style: .continuous))
    }

    private func choiceCard(
        title: String,
        body: String,
        isSelected: Bool,
        accent: (icon: String, label: String, tint: Color),
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top, spacing: 12) {
                    Label(accent.label, systemImage: accent.icon)
                        .font(AevoraTokens.Typography.caption)
                        .foregroundStyle(accent.tint)
                    Spacer()
                    if isSelected {
                        Text("Selected")
                            .font(AevoraTokens.Typography.caption)
                            .foregroundStyle(AevoraTokens.Color.text.primary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(AevoraTokens.Color.dawnGold.shade300)
                            .clipShape(Capsule())
                    }
                }
                Text(title)
                    .font(AevoraTokens.Typography.headline)
                    .foregroundStyle(AevoraTokens.Color.text.primary)
                if !body.isEmpty {
                    Text(body)
                        .font(AevoraTokens.Typography.subheadline)
                        .foregroundStyle(AevoraTokens.Color.text.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(isSelected ? AevoraTokens.Color.surface.cardElevated : AevoraTokens.Color.surface.cardPrimary.opacity(0.84))
            .overlay(tokenCardStroke(isSelected: isSelected))
            .clipShape(RoundedRectangle(cornerRadius: AevoraTokens.Radius.sm, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private func singleChoice(title: String, options: [String], selection: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(AevoraTokens.Typography.displayMedium)
            ForEach(options, id: \.self) { option in
                choiceCard(
                    title: option,
                    body: "",
                    isSelected: selection.wrappedValue == option,
                    accent: choiceAccent(for: option)
                ) {
                    selection.wrappedValue = option
                }
            }
        }
    }

    private func optionPicker(title: String, subtitle: String, options: [String], selection: Binding<Set<String>>, limit: Int) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(AevoraTokens.Typography.displayMedium)
            Text(subtitle)
                .font(AevoraTokens.Typography.subheadline)
                .foregroundStyle(AevoraTokens.Color.text.secondary)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(options, id: \.self) { option in
                    let isSelected = selection.wrappedValue.contains(option)
                    Button {
                        var updated = selection.wrappedValue
                        if isSelected {
                            updated.remove(option)
                        } else if updated.count < limit {
                            updated.insert(option)
                        }
                        selection.wrappedValue = updated
                    } label: {
                        Text(option.capitalized)
                            .font(AevoraTokens.Typography.subheadline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(isSelected ? AevoraTokens.Color.surface.cardElevated : AevoraTokens.Color.surface.cardPrimary.opacity(0.84))
                            .overlay(tokenCardStroke(isSelected: isSelected))
                            .clipShape(RoundedRectangle(cornerRadius: AevoraTokens.Radius.sm, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func tokenTextField(_ title: String, text: Binding<String>) -> some View {
        TextField(title, text: text)
            .font(AevoraTokens.Typography.body)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(AevoraTokens.Color.surface.cardPrimary)
            .overlay(tokenCardStroke(isSelected: false))
            .clipShape(RoundedRectangle(cornerRadius: AevoraTokens.Radius.sm, style: .continuous))
    }

    private func tokenCardStroke(isSelected: Bool) -> some View {
        RoundedRectangle(cornerRadius: AevoraTokens.Radius.sm, style: .continuous)
            .stroke(
                isSelected ? AevoraTokens.Color.border.focus : AevoraTokens.Color.border.subtle,
                lineWidth: isSelected ? 2 : 1.5
            )
    }

    private func familyAccent(for familyID: String) -> (icon: String, label: String, tint: Color) {
        switch familyID {
        case "dawnbound":
            return ("shield.fill", "Shield and civic defense", AevoraTokens.Color.dawnGold.shade500)
        case "archivist":
            return ("book.closed.fill", "Sigils and archive tools", AevoraTokens.Color.moonIndigo.shade300)
        case "hearthkeeper":
            return ("basket.fill", "Craft and domestic warmth", AevoraTokens.Color.emberCopper.shade300)
        case "chartermaker":
            return ("doc.text.fill", "Ledger and mercantile order", AevoraTokens.Color.mossGreen.shade500)
        default:
            return ("sparkles", "Origin family", AevoraTokens.Color.dawnGold.shade300)
        }
    }

    private func identityAccent(for identity: LaunchContent.IdentityShell) -> (icon: String, label: String, tint: Color) {
        switch identity.originFamilyId {
        case "dawnbound":
            return ("flag.fill", "Dawnbound path", AevoraTokens.Color.dawnGold.shade500)
        case "archivist":
            return ("scroll.fill", "Archivist path", AevoraTokens.Color.moonIndigo.shade300)
        case "hearthkeeper":
            return ("flame.fill", "Hearthkeeper path", AevoraTokens.Color.emberCopper.shade300)
        case "chartermaker":
            return ("seal.fill", "Chartermaker path", AevoraTokens.Color.mossGreen.shade500)
        default:
            return ("sparkles", "Identity shell", AevoraTokens.Color.dawnGold.shade300)
        }
    }

    private func choiceAccent(for option: String) -> (icon: String, label: String, tint: Color) {
        let lowercased = option.lowercased()
        if lowercased.contains("forget") {
            return ("bell.fill", "Reminder friction", AevoraTokens.Color.dawnGold.shade500)
        }
        if lowercased.contains("all-or-nothing") {
            return ("wind", "Recovery framing", AevoraTokens.Color.mossGreen.shade500)
        }
        if lowercased.contains("driven") {
            return ("bolt.fill", "Higher intensity", AevoraTokens.Color.emberCopper.shade300)
        }
        if lowercased.contains("gentle") {
            return ("leaf.fill", "Calmer tone", AevoraTokens.Color.mossGreen.shade500)
        }
        if lowercased.contains("balanced") {
            return ("circle.lefthalf.filled", "Balanced tone", AevoraTokens.Color.dawnGold.shade500)
        }
        return ("sparkles", "Starter choice", AevoraTokens.Color.dawnGold.shade300)
    }
}
