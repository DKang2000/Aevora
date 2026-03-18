import SwiftUI

struct AssetDebugMenuView: View {
    @ObservedObject var assetResolver: AevoraAssetResolver

    var body: some View {
        let entries = assetResolver.debugEntries()
        let importedCount = entries.filter { $0.resolution.presentationState == .imported }.count
        let mappedPlaceholderCount = entries.filter { $0.resolution.presentationState == .mappedPlaceholder }.count
        let fallbackMissingCount = entries.filter { $0.resolution.presentationState == .fallbackMissing }.count

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

            HStack(spacing: 10) {
                summaryCard(title: "Imported", value: importedCount, tint: AevoraTokens.Color.text.success)
                summaryCard(title: "Mapped placeholder", value: mappedPlaceholderCount, tint: AevoraTokens.Color.action.primaryFill)
                summaryCard(title: "Fallback missing", value: fallbackMissingCount, tint: AevoraTokens.Color.text.secondary)
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

                    Text(entry.resolution.statusDetail)
                        .font(AevoraTokens.Typography.caption)
                        .foregroundStyle(entry.resolution.tintColor)

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

    private func summaryCard(title: String, value: Int, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("\(value)")
                .font(AevoraTokens.Typography.headline)
                .foregroundStyle(AevoraTokens.Color.text.primary)
            Text(title)
                .font(AevoraTokens.Typography.caption)
                .foregroundStyle(tint)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(AevoraTokens.Color.surface.cardSecondary)
        .clipShape(RoundedRectangle(cornerRadius: AevoraTokens.Radius.sm, style: .continuous))
    }
}
