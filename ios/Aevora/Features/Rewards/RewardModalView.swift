import SwiftUI

struct RewardModalView: View {
    let state: RewardPresentationState
    let copy: CopyCatalog
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Capsule()
                .fill(Color.secondary.opacity(0.25))
                .frame(width: 44, height: 5)
                .padding(.top, 8)

            Text(copy.text("rewards.summary_title", fallback: "Your world responds."))
                .font(.title2.bold())

            HStack(spacing: 16) {
                metric(title: copy.text("rewards.resonance_label", fallback: "Resonance"), value: "\(state.resonance)")
                metric(title: copy.text("rewards.gold_label", fallback: "Gold"), value: "\(state.gold)")
            }

            Text(state.worldChangeText)
                .font(.body)
                .multilineTextAlignment(.center)

            if let magicalMomentTitle = state.magicalMomentTitle {
                VStack(spacing: 8) {
                    Text(magicalMomentTitle)
                        .font(.headline)
                    if let magicalMomentBody = state.magicalMomentBody {
                        Text(magicalMomentBody)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.97, green: 0.93, blue: 0.86))
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }

            if state.leveledUp {
                Text("Rank up. The city notices your return.")
                    .font(.headline)
                    .foregroundStyle(Color(red: 0.45, green: 0.24, blue: 0.13))
            }

            if !state.unlockedItemNames.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Unlocked")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                    ForEach(state.unlockedItemNames, id: \.self) { itemName in
                        Text(itemName)
                            .font(.subheadline.weight(.semibold))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(red: 0.96, green: 0.93, blue: 0.88))
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }

            Button(copy.text("actions.see_world", fallback: "See world response")) {
                onDismiss()
            }
            .buttonStyle(.borderedProminent)
            .tint(Color(red: 0.45, green: 0.24, blue: 0.13))
            .padding(.bottom, 12)
        }
        .padding(.horizontal, 24)
        .presentationDetents([.medium])
    }

    private func metric(title: String, value: String) -> some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
            Text(title)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color(red: 0.96, green: 0.93, blue: 0.88))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
