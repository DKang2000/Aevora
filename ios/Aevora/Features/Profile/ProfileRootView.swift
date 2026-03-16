import SwiftUI
import AuthenticationServices

struct ProfileRootView: View {
    @EnvironmentObject private var environment: AppEnvironment

    var body: some View {
        NavigationStack {
            let store = environment.firstPlayableStore
            let accountStore = environment.accountSurfaceStore

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("Profile")
                        .font(.largeTitle.bold())

                    profileSection(store: store)
                    subscriptionSection(store: store, accountStore: accountStore)
                    settingsSection(store: store, accountStore: accountStore)
                    accountSection(store: store, accountStore: accountStore)
                }
                .padding()
            }
            .navigationTitle("Profile")
        }
    }

    private func profileSection(store: FirstPlayableStore) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Identity")
                .font(.headline)
            Text("Auth mode: \(store.authMode.capitalized)")
                .foregroundStyle(.secondary)
            Text("Identity: \(store.copy.text(store.content.identityShells.first(where: { $0.id == store.selectedIdentityID })?.displayNameKey ?? "", fallback: store.selectedIdentityID))")
            Text("Rank \(store.rank) • \(store.lifetimeResonance) Resonance")
            Text("Starter arc progress: \(store.completionDayCount)/7 days")
            Text("Inventory: \(store.inventoryItems.count) rewards")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color(red: 0.98, green: 0.96, blue: 0.92))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private func subscriptionSection(store: FirstPlayableStore, accountStore: AccountSurfaceStore) -> some View {
        let tierLabel = accountStore.subscriptionState.tier.rawValue.replacingOccurrences(of: "_", with: " ").capitalized

        return VStack(alignment: .leading, spacing: 12) {
            Text("Subscription")
                .font(.headline)
            Text("Tier: \(tierLabel)")
            Text("Witness surfaces: \(accountStore.supportsAdvancedWidgets ? "Advanced widget + Live Activity" : "Basic widget")")
                .foregroundStyle(.secondary)
            HStack {
                if accountStore.subscriptionState.trialEligible && accountStore.subscriptionState.tier == .free {
                    Button("Start free trial") {
                        accountStore.startTrial(using: store)
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    Button("Unlock monthly") {
                        accountStore.purchase(tier: .premiumMonthly, using: store)
                    }
                    .buttonStyle(.borderedProminent)
                }

                Button("Restore") {
                    accountStore.restorePurchases(using: store)
                }
                .buttonStyle(.bordered)
            }
            Button("Downgrade to free path") {
                accountStore.downgradeToFree(using: store)
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color(red: 0.95, green: 0.93, blue: 0.89))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private func settingsSection(store: FirstPlayableStore, accountStore: AccountSurfaceStore) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Settings")
                .font(.headline)
            Text("Notifications: \(accountStore.notificationPermission.rawValue)")
                .foregroundStyle(.secondary)
            Button("Request notifications") {
                accountStore.requestNotifications(using: store)
            }
            .buttonStyle(.bordered)
            Text(accountStore.supportsLiveActivities ? "Live Activities are active for premium breadth." : "Live Activities unlock after premium upgrade.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color(red: 0.98, green: 0.96, blue: 0.92))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private func accountSection(store: FirstPlayableStore, accountStore: AccountSurfaceStore) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Account")
                .font(.headline)
            if store.authMode == "guest" {
                SignInWithAppleButton(.continue) { request in
                    request.requestedScopes = [.fullName]
                } onCompletion: { result in
                    switch result {
                    case .success(let authorization):
                        let credential = authorization.credential as? ASAuthorizationAppleIDCredential
                        let token = credential?.identityToken.flatMap { String(data: $0, encoding: .utf8) } ?? UUID().uuidString
                        accountStore.linkGuestAccount(using: store, identityToken: token)
                    case .failure:
                        accountStore.accountNotice = "Apple account linking could not be completed."
                    }
                }
                .frame(height: 44)
            }
            Button("Prepare export preview") {
                accountStore.prepareExport(using: store)
            }
            .buttonStyle(.bordered)
            Button("Delete local account state") {
                accountStore.deleteAccount(using: store)
            }
            .buttonStyle(.bordered)
            if let exportPreview = accountStore.exportPreview {
                Text(exportPreview)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            if let accountNotice = accountStore.accountNotice {
                Text(accountNotice)
                    .font(.footnote.weight(.semibold))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color(red: 0.95, green: 0.93, blue: 0.89))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}
