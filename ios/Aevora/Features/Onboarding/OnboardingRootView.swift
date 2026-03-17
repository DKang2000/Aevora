import AuthenticationServices
import SwiftUI

struct OnboardingRootView: View {
    @ObservedObject var store: FirstPlayableStore

    private let goals = ["consistency", "energy", "focus", "calm", "discipline", "momentum", "balance", "confidence"]
    private let lifeAreas = ["Physical", "Intellectual", "Career", "Hobbies", "Emotional"]
    private let blockers = ["I forget", "I try to do too much", "I lose motivation", "I feel all-or-nothing", "My days are unpredictable", "My current tools feel dead"]
    private let tones = ["gentle", "balanced", "driven"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Aevora")
                        .font(AevoraTokens.Typography.caption)
                        .foregroundStyle(AevoraTokens.Color.text.secondary)
                    ProgressView(value: Double(store.onboardingStep), total: 6)
                        .tint(AevoraTokens.Color.action.progress)
                }

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        stepBody
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 12)
                }

                HStack {
                    if store.onboardingStep > 1 {
                        Button(store.copy.text("onboarding.back", fallback: "Back")) {
                            store.goBackOnboarding()
                        }
                        .buttonStyle(.bordered)
                    }

                    Spacer()

                    Button(store.onboardingStep == 6 ? store.copy.text("onboarding.finish", fallback: "Enter Aevora") : store.copy.text("onboarding.next", fallback: "Next")) {
                        if store.onboardingStep == 6 {
                            store.finishOnboarding()
                        } else {
                            store.advanceOnboarding()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AevoraTokens.Color.action.primaryFill)
                    .disabled(store.onboardingStep == 0 && !store.hasStartedOnboarding)
                }
            }
            .padding(24)
            .background(AevoraTokens.Gradient.chapter.primary.ignoresSafeArea())
        }
    }

    @ViewBuilder
    private var stepBody: some View {
        switch store.onboardingStep {
        case 0:
            VStack(alignment: .leading, spacing: 16) {
                Text(store.copy.text("onboarding.welcome_title", fallback: "Level up in Aevora as you level up in real life."))
                    .font(AevoraTokens.Typography.displayLarge)
                Text(store.copy.text("onboarding.welcome_body", fallback: "Keep a few meaningful vows, and the city will answer."))
                    .font(AevoraTokens.Typography.headline)
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
        case 1:
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
        case 2:
            VStack(alignment: .leading, spacing: 20) {
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
                singleChoice(title: store.copy.text("onboarding.blocker_title", fallback: "What usually gets in your way?"), options: blockers, selection: $store.selectedBlocker)
            }
        case 3:
            VStack(alignment: .leading, spacing: 20) {
                Text(store.copy.text("onboarding.daily_load_title", fallback: "How many daily vows can you realistically keep?"))
                    .font(AevoraTokens.Typography.headline)
                Picker("Daily load", selection: $store.dailyLoad) {
                    Text("3").tag(3)
                    Text("5").tag(5)
                    Text("7").tag(7)
                }
                .pickerStyle(.segmented)

                singleChoice(title: store.copy.text("onboarding.tone_title", fallback: "What tone do you want from Aevora?"), options: tones, selection: $store.toneMode)
            }
        case 4:
            VStack(alignment: .leading, spacing: 20) {
                Text(store.copy.text("onboarding.family_title", fallback: "Choose your origin family"))
                    .font(AevoraTokens.Typography.headline)
                ForEach(store.content.originFamilies) { family in
                    choiceCard(
                        title: store.copy.text(family.titleKey, fallback: family.id),
                        body: store.copy.text(family.summaryKey, fallback: family.summaryKey),
                        isSelected: family.id == store.selectedFamilyID
                    ) {
                        store.selectedFamilyID = family.id
                        if let firstIdentity = store.content.identityShells.first(where: { $0.originFamilyId == family.id }) {
                            store.selectedIdentityID = firstIdentity.id
                        }
                    }
                }
            }
        case 5:
            VStack(alignment: .leading, spacing: 20) {
                Text(store.copy.text("onboarding.identity_title", fallback: "Choose your path"))
                    .font(AevoraTokens.Typography.headline)
                ForEach(store.content.identityShells.filter { $0.originFamilyId == store.selectedFamilyID }) { identity in
                    choiceCard(
                        title: store.copy.text(identity.displayNameKey, fallback: identity.id),
                        body: store.copy.text(identity.summaryKey, fallback: identity.summaryKey),
                        isSelected: identity.id == store.selectedIdentityID
                    ) {
                        store.selectedIdentityID = identity.id
                    }
                }
            }
        case 6:
            VStack(alignment: .leading, spacing: 20) {
                Text(store.copy.text("onboarding.avatar_title", fallback: "Shape your arrival"))
                    .font(AevoraTokens.Typography.headline)
                tokenTextField("Name", text: $store.avatarDraft.displayName)
                tokenTextField("Pronouns (optional)", text: $store.avatarDraft.pronouns)
                VStack(alignment: .leading, spacing: 12) {
                    Text(store.copy.text("onboarding.vows_title", fallback: "Your starter vows"))
                        .font(AevoraTokens.Typography.headline)
                    ForEach(store.recommendedVows) { vow in
                        HStack(alignment: .top, spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(vow.title)
                                    .font(AevoraTokens.Typography.headline)
                                Text("\(vow.category) • \(vow.targetValue) \(vow.targetUnit)")
                                    .font(AevoraTokens.Typography.subheadline)
                                    .foregroundStyle(AevoraTokens.Color.text.secondary)
                            }
                            Spacer()
                            Button("Replace") {
                                store.replaceRecommendation(vow.id)
                            }
                            .font(AevoraTokens.Typography.footnote)
                        }
                        .padding(14)
                        .background(AevoraTokens.Color.surface.cardPrimary.opacity(0.92))
                        .overlay(tokenCardStroke(isSelected: false))
                        .clipShape(RoundedRectangle(cornerRadius: AevoraTokens.Radius.sm, style: .continuous))
                    }
                }
            }
        default:
            EmptyView()
        }
    }

    private func choiceCard(title: String, body: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(AevoraTokens.Typography.headline)
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
                .font(AevoraTokens.Typography.headline)
            ForEach(options, id: \.self) { option in
                choiceCard(title: option, body: "", isSelected: selection.wrappedValue == option) {
                    selection.wrappedValue = option
                }
            }
        }
    }

    private func optionPicker(title: String, subtitle: String, options: [String], selection: Binding<Set<String>>, limit: Int) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(AevoraTokens.Typography.headline)
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
}
