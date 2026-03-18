import SwiftUI

struct AevoraAssetResolution: Equatable, Identifiable {
    enum Status: String, Equatable {
        case mapped
        case placeholderFallback
    }

    let slot: AevoraAssetSlot
    let family: AevoraAssetSlotFamily
    let entry: AevoraAssetManifest.AssetEntry?
    let status: Status
    let fallbackReason: String

    var id: String { slot.id }
    var isMapped: Bool { status == .mapped }
    var isBetaCriticalMissing: Bool { family.betaCritical && !isMapped }

    var displayTitle: String {
        slot.rawValue
            .split(separator: ".")
            .map { String($0).capitalized }
            .joined(separator: " ")
    }

    var statusLabel: String {
        isMapped ? "Manifest mapped" : "Fallback active"
    }

    var sectionLabel: String { family.sectionId }
    var logicalPath: String { entry?.logicalPath ?? slot.rawValue.replacingOccurrences(of: ".", with: "/") }
    var artifactPath: String { entry?.artifactPath ?? "placeholder://\(logicalPath)" }

    var accentColors: [Color] {
        switch family.sectionId {
        case "ART-05":
            return [AevoraTokens.Color.dawnGold.shade300, AevoraTokens.Color.emberCopper.shade300]
        case "ART-06", "ART-07", "ART-08":
            return [AevoraTokens.Color.mossGreen.shade300, AevoraTokens.Color.surface.cardPrimary]
        case "ART-09", "ART-10":
            return [AevoraTokens.Color.ashPlum.shade300, AevoraTokens.Color.surface.cardPrimary]
        case "ART-11", "ART-12", "ART-13", "ART-14":
            return [AevoraTokens.Color.mossGreen.shade300, AevoraTokens.Color.parchmentStone.shade200]
        case "ART-15", "ART-19":
            return [AevoraTokens.Color.emberCopper.shade300, AevoraTokens.Color.parchmentStone.shade200]
        default:
            return [AevoraTokens.Color.surface.cardSecondary, AevoraTokens.Color.surface.cardPrimary]
        }
    }
}

struct AevoraAssetDebugEntry: Identifiable, Equatable {
    let slot: AevoraAssetSlot
    let family: AevoraAssetSlotFamily
    let resolution: AevoraAssetResolution

    var id: String { slot.id }
}

@MainActor
final class AevoraAssetResolver: ObservableObject {
    @Published private(set) var missingBetaCriticalSlotIDs: Set<String> = []

    let registry: AevoraAssetRegistry
    let manifest: AevoraAssetManifest

    init(registry: AevoraAssetRegistry, manifest: AevoraAssetManifest) {
        self.registry = registry
        self.manifest = manifest
        missingBetaCriticalSlotIDs = Set(
            registry.betaCriticalSlots()
                .filter { manifest.entry(for: $0.rawValue) == nil }
                .map(\.rawValue)
        )
    }

    func resolve(_ slot: AevoraAssetSlot) -> AevoraAssetResolution {
        let family = registry.family(for: slot)
            ?? AevoraAssetSlotFamily(id: slot.rawValue, sectionId: "ART-unknown", betaCritical: false, surfaces: [])
        let entry = manifest.entry(for: slot.rawValue)
        return AevoraAssetResolution(
            slot: slot,
            family: family,
            entry: entry,
            status: entry == nil ? .placeholderFallback : .mapped,
            fallbackReason: entry == nil ? "No manifest entry yet. Runtime uses deterministic placeholder chrome." : "Manifest entry loaded."
        )
    }

    func resolve(slots: [AevoraAssetSlot]) -> [AevoraAssetResolution] {
        slots.map(resolve)
    }

    func debugEntries(surface: AevoraAssetSurface? = nil) -> [AevoraAssetDebugEntry] {
        let slots = surface.map(registry.slots(for:)) ?? registry.allSlots
        return slots.map { slot in
            let resolution = resolve(slot)
            return AevoraAssetDebugEntry(
                slot: slot,
                family: registry.family(for: slot) ?? resolution.family,
                resolution: resolution
            )
        }
        .sorted { lhs, rhs in
            if lhs.family.sectionId == rhs.family.sectionId {
                return lhs.slot.rawValue < rhs.slot.rawValue
            }
            return lhs.family.sectionId < rhs.family.sectionId
        }
    }
}

struct AevoraAssetAccentView: View {
    let resolution: AevoraAssetResolution
    let title: String
    let subtitle: String?

    init(resolution: AevoraAssetResolution, title: String, subtitle: String? = nil) {
        self.resolution = resolution
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(
                    LinearGradient(
                        colors: resolution.accentColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 16, height: 16)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AevoraTokens.Typography.caption)
                    .foregroundStyle(AevoraTokens.Color.text.secondary)
                Text(subtitle ?? resolution.displayTitle)
                    .font(AevoraTokens.Typography.subheadline)
                    .foregroundStyle(AevoraTokens.Color.text.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 8)

            VStack(alignment: .trailing, spacing: 4) {
                Text(resolution.sectionLabel)
                    .font(AevoraTokens.Typography.caption)
                    .foregroundStyle(AevoraTokens.Color.text.secondary)
                Text(resolution.statusLabel)
                    .font(AevoraTokens.Typography.footnote)
                    .foregroundStyle(resolution.isMapped ? AevoraTokens.Color.text.success : AevoraTokens.Color.text.secondary)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: resolution.accentColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .opacity(0.22)
        )
        .clipShape(RoundedRectangle(cornerRadius: AevoraTokens.Radius.sm, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: AevoraTokens.Radius.sm, style: .continuous)
                .stroke(AevoraTokens.Color.border.subtle, lineWidth: 1)
        )
    }
}

struct AevoraAssetStatusPill: View {
    let resolution: AevoraAssetResolution

    var body: some View {
        Text(resolution.isMapped ? "Mapped" : "Placeholder")
            .font(AevoraTokens.Typography.caption)
            .foregroundStyle(resolution.isMapped ? AevoraTokens.Color.text.success : AevoraTokens.Color.text.secondary)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(AevoraTokens.Color.surface.cardSecondary)
            .clipShape(Capsule())
    }
}
