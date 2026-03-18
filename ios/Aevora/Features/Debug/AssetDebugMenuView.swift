import SwiftUI

struct AssetDebugMenuView: View {
    @ObservedObject var assetResolver: AevoraAssetResolver

    var body: some View {
        let entries = assetResolver.debugEntries()

        VStack(alignment: .leading, spacing: 14) {
            if assetResolver.missingBetaCriticalSlotIDs.isEmpty {
                Text("All currently tracked beta-critical slots have manifest mappings or deterministic placeholder coverage.")
                    .font(AevoraTokens.Typography.footnote)
                    .foregroundStyle(AevoraTokens.Color.text.secondary)
            } else {
                Text("Missing beta-critical slots: \(assetResolver.missingBetaCriticalSlotIDs.count)")
                    .font(AevoraTokens.Typography.footnote)
                    .foregroundStyle(AevoraTokens.Color.text.warning)
            }

            ForEach(entries) { entry in
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Text(entry.slot.rawValue)
                            .font(AevoraTokens.Typography.footnote)
                            .foregroundStyle(AevoraTokens.Color.text.primary)
                        Spacer(minLength: 8)
                        if entry.family.betaCritical {
                            Text("Beta-critical")
                                .font(AevoraTokens.Typography.caption)
                                .foregroundStyle(AevoraTokens.Color.action.primaryFill)
                        }
                        AevoraAssetStatusPill(resolution: entry.resolution)
                    }

                    Text("\(entry.family.sectionId) • \(entry.resolution.logicalPath)")
                        .font(AevoraTokens.Typography.caption)
                        .foregroundStyle(AevoraTokens.Color.text.secondary)

                    Text(entry.resolution.artifactPath)
                        .font(AevoraTokens.Typography.caption)
                        .foregroundStyle(AevoraTokens.Color.text.secondary)

                    if entry.resolution.isBetaCriticalMissing {
                        Text("Manifest entry missing. Debug builds use placeholder-safe chrome until import.")
                            .font(AevoraTokens.Typography.caption)
                            .foregroundStyle(AevoraTokens.Color.text.warning)
                    }
                }
                .padding(.vertical, 6)
            }
        }
    }
}
