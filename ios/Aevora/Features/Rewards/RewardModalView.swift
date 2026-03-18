import SwiftUI

struct RewardModalView: View {
    let state: RewardPresentationState
    let copy: CopyCatalog
    let assetResolver: AevoraAssetResolver
    let onDismiss: () -> Void

    static let assetSlots: [AevoraAssetSlot] = [.rewardCard, .rewardFX]

    var body: some View {
        let assetResolutions = assetResolver.resolve(slots: Self.assetSlots)

        VStack(spacing: 20) {
            Capsule()
                .fill(AevoraTokens.Color.border.subtle)
                .frame(width: 44, height: 5)
                .padding(.top, 8)

            if let rewardCardResolution = assetResolutions.first {
                AevoraAssetRenderableView(
                    resolution: rewardCardResolution,
                    style: .heroCard
                )
                .frame(height: 184)
            }

            Text(copy.text("rewards.summary_title", fallback: "Your world responds."))
                .font(AevoraTokens.Typography.displayMedium)
                .foregroundStyle(AevoraTokens.Color.text.primary)

            HStack(spacing: 16) {
                metric(title: copy.text("rewards.resonance_label", fallback: "Resonance"), value: "\(state.resonance)")
                metric(title: copy.text("rewards.gold_label", fallback: "Gold"), value: "\(state.gold)")
            }

            if let rewardFXResolution = assetResolutions.dropFirst().first {
                AevoraAssetStatusPill(resolution: rewardFXResolution)
            }

            Text(state.worldChangeText)
                .font(AevoraTokens.Typography.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(AevoraTokens.Color.text.secondary)

            if let magicalMomentTitle = state.magicalMomentTitle {
                VStack(spacing: 8) {
                    Text(magicalMomentTitle)
                        .font(AevoraTokens.Typography.headline)
                        .foregroundStyle(AevoraTokens.Color.text.primary)
                    if let magicalMomentBody = state.magicalMomentBody {
                        Text(magicalMomentBody)
                            .font(AevoraTokens.Typography.subheadline)
                            .foregroundStyle(AevoraTokens.Color.text.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(AevoraTokens.Color.surface.cardElevated)
                .overlay(tokenCardStroke)
                .clipShape(RoundedRectangle(cornerRadius: AevoraTokens.Radius.sm, style: .continuous))
            }

            if state.leveledUp {
                Text("Rank up. The city notices your return.")
                    .font(AevoraTokens.Typography.headline)
                    .foregroundStyle(AevoraTokens.Color.action.primaryFill)
            }

            if !state.unlockedItemNames.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Unlocked")
                        .font(AevoraTokens.Typography.caption)
                        .foregroundStyle(AevoraTokens.Color.text.secondary)
                    ForEach(state.unlockedItemNames, id: \.self) { itemName in
                        Text(itemName)
                            .font(AevoraTokens.Typography.subheadline)
                            .foregroundStyle(AevoraTokens.Color.text.primary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(AevoraTokens.Color.surface.cardPrimary)
                .overlay(tokenCardStroke)
                .clipShape(RoundedRectangle(cornerRadius: AevoraTokens.Radius.sm, style: .continuous))
            }

            Button(copy.text("actions.see_world", fallback: "See world response")) {
                onDismiss()
            }
            .buttonStyle(.borderedProminent)
            .tint(AevoraTokens.Color.action.primaryFill)
            .padding(.bottom, 12)
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
        .presentationBackground(AevoraTokens.Color.surface.app)
        .presentationDetents([.medium])
    }

    private func metric(title: String, value: String) -> some View {
        VStack(spacing: 6) {
            Text(value)
                .font(AevoraTokens.Typography.displayMedium)
                .foregroundStyle(AevoraTokens.Color.text.primary)
            Text(title)
                .font(AevoraTokens.Typography.footnote)
                .foregroundStyle(AevoraTokens.Color.text.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(AevoraTokens.Color.surface.cardSecondary)
        .overlay(tokenCardStroke)
        .clipShape(RoundedRectangle(cornerRadius: AevoraTokens.Radius.sm, style: .continuous))
    }

    private var tokenCardStroke: some View {
        RoundedRectangle(cornerRadius: AevoraTokens.Radius.sm, style: .continuous)
            .stroke(AevoraTokens.Color.border.subtle, lineWidth: 1.5)
    }
}
