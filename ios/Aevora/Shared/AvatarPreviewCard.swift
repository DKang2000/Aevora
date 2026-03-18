import SwiftUI

enum AvatarPreviewStyle: Equatable {
    case onboarding
    case hearth
}

struct AvatarPreviewConfiguration: Equatable {
    let displayName: String
    let pronouns: String
    let identityName: String
    let silhouetteId: String
    let paletteId: String
    let accessoryLabel: String
    let statusLine: String
}

struct AvatarSelectionOption: Identifiable, Equatable {
    let id: String
    let label: String
}

struct OnboardingAvatarStepState: Equatable {
    let configuration: AvatarPreviewConfiguration
    let silhouetteOptions: [AvatarSelectionOption]
    let paletteOptions: [AvatarSelectionOption]
}

enum AvatarPresentationCatalog {
    struct SilhouetteDefinition: Equatable {
        let id: String
        let label: String
        let kind: SilhouetteKind
    }

    struct PaletteDefinition: Equatable {
        let id: String
        let label: String
        let clothHex: String
        let trimHex: String
        let neutralHex: String
        let hairHex: String
    }

    struct AccessoryDefinition: Equatable {
        let id: String
        let label: String
    }

    enum SilhouetteKind: Equatable {
        case guardCape
        case vowWard
        case pathfinder
        case sigilCoat
        case archiveRobe
        case fieldApron
        case ovenApron
        case counterVest
        case ledgerCoat
        case civicCloak
    }

    static let silhouettes: [SilhouetteDefinition] = [
        .init(id: "silhouette_guard", label: "Guard", kind: .guardCape),
        .init(id: "silhouette_vow_ward", label: "Vow Ward", kind: .vowWard),
        .init(id: "silhouette_pathfinder", label: "Pathfinder", kind: .pathfinder),
        .init(id: "silhouette_sigil_coat", label: "Sigil Coat", kind: .sigilCoat),
        .init(id: "silhouette_archive_robe", label: "Archive Robe", kind: .archiveRobe),
        .init(id: "silhouette_field_apron", label: "Field Apron", kind: .fieldApron),
        .init(id: "silhouette_oven_apron", label: "Oven Apron", kind: .ovenApron),
        .init(id: "silhouette_counter_vest", label: "Counter Vest", kind: .counterVest),
        .init(id: "silhouette_ledger_coat", label: "Ledger Coat", kind: .ledgerCoat),
        .init(id: "silhouette_civic_cloak", label: "Civic Cloak", kind: .civicCloak)
    ]

    static let palettes: [PaletteDefinition] = [
        .init(id: "palette_burnished_gold", label: "Burnished Gold", clothHex: "#A87925", trimHex: "#F0CF7A", neutralHex: "#544430", hairHex: "#2F241D"),
        .init(id: "palette_dawn_white", label: "Dawn White", clothHex: "#F1E9D8", trimHex: "#D9A647", neutralHex: "#61503B", hairHex: "#6B543C"),
        .init(id: "palette_moss_steel", label: "Moss Steel", clothHex: "#496255", trimHex: "#9CC193", neutralHex: "#4A5662", hairHex: "#5D4534"),
        .init(id: "palette_moon_ink", label: "Moon Ink", clothHex: "#2E3654", trimHex: "#A28AA3", neutralHex: "#5C6788", hairHex: "#2D231B"),
        .init(id: "palette_amber_ink", label: "Amber Ink", clothHex: "#7A5335", trimHex: "#E7A46C", neutralHex: "#574A46", hairHex: "#6A4730"),
        .init(id: "palette_harvest_green", label: "Harvest Green", clothHex: "#55724C", trimHex: "#D9A647", neutralHex: "#6A5B4E", hairHex: "#5B432E"),
        .init(id: "palette_ember_ochre", label: "Ember Ochre", clothHex: "#C7722F", trimHex: "#F0CF7A", neutralHex: "#6B4A35", hairHex: "#7A5A34"),
        .init(id: "palette_roasted_clay", label: "Roasted Clay", clothHex: "#9C5F49", trimHex: "#E7A46C", neutralHex: "#6E554A", hairHex: "#7A5D41"),
        .init(id: "palette_copper_blue", label: "Copper Blue", clothHex: "#47627E", trimHex: "#E38C40", neutralHex: "#695949", hairHex: "#5D4534"),
        .init(id: "palette_stone_plum", label: "Stone Plum", clothHex: "#6B536E", trimHex: "#CDBEAC", neutralHex: "#625851", hairHex: "#8B6D58")
    ]

    static let accessories: [AccessoryDefinition] = [
        .init(id: "accessory_cloak_pin", label: "Cloak Pin"),
        .init(id: "accessory_lantern_seal", label: "Lantern Seal"),
        .init(id: "accessory_field_wrap", label: "Field Wrap"),
        .init(id: "accessory_quill_pin", label: "Quill Pin"),
        .init(id: "accessory_satchel_clasp", label: "Satchel Clasp"),
        .init(id: "accessory_seed_pouch", label: "Seed Pouch"),
        .init(id: "accessory_flour_wrap", label: "Flour Wrap"),
        .init(id: "accessory_cup_charm", label: "Cup Charm"),
        .init(id: "accessory_seal_ring", label: "Seal Ring"),
        .init(id: "accessory_charter_chain", label: "Charter Chain")
    ]

    static func silhouette(for id: String) -> SilhouetteDefinition? {
        silhouettes.first(where: { $0.id == id })
    }

    static func palette(for id: String) -> PaletteDefinition? {
        palettes.first(where: { $0.id == id })
    }

    static func accessory(for id: String) -> AccessoryDefinition? {
        accessories.first(where: { $0.id == id })
    }
}

struct AvatarPreviewCard: View {
    let configuration: AvatarPreviewConfiguration
    let style: AvatarPreviewStyle

    private var displayName: String {
        let trimmed = configuration.displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "Wayfarer" : trimmed
    }

    private var silhouette: AvatarPresentationCatalog.SilhouetteDefinition {
        AvatarPresentationCatalog.silhouette(for: configuration.silhouetteId)
            ?? AvatarPresentationCatalog.silhouettes.first!
    }

    private var palette: AvatarPresentationCatalog.PaletteDefinition {
        AvatarPresentationCatalog.palette(for: configuration.paletteId)
            ?? AvatarPresentationCatalog.palettes.first!
    }

    var body: some View {
        let avatarWidth: CGFloat = style == .onboarding ? 146 : 122
        let avatarHeight: CGFloat = style == .onboarding ? 198 : 162

        VStack(alignment: .leading, spacing: style == .onboarding ? 16 : 14) {
            HStack(alignment: .center, spacing: style == .onboarding ? 18 : 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: style == .onboarding ? 24 : 22, style: .continuous)
                        .fill(AevoraTokens.Color.surface.cardPrimary)
                    RoundedRectangle(cornerRadius: style == .onboarding ? 24 : 22, style: .continuous)
                        .stroke(AevoraTokens.Color.border.default, lineWidth: 1.5)
                    AvatarFigureView(silhouette: silhouette, palette: palette, compact: style == .hearth)
                        .padding(style == .onboarding ? 12 : 10)
                }
                .frame(width: avatarWidth, height: avatarHeight)

                VStack(alignment: .leading, spacing: 8) {
                    Text(displayName)
                        .font(style == .onboarding ? AevoraTokens.Typography.displayMedium : AevoraTokens.Typography.headline)
                        .foregroundStyle(AevoraTokens.Color.text.primary)
                        .lineLimit(2)
                    Text(configuration.identityName)
                        .font(AevoraTokens.Typography.caption)
                        .foregroundStyle(AevoraTokens.Color.emberCopper.shade700)
                    if !configuration.pronouns.isEmpty {
                        Text(configuration.pronouns)
                            .font(AevoraTokens.Typography.footnote)
                            .foregroundStyle(AevoraTokens.Color.text.secondary)
                    }
                    Text(configuration.statusLine)
                        .font(AevoraTokens.Typography.subheadline)
                        .foregroundStyle(AevoraTokens.Color.text.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 0)
            }

            HStack(spacing: 10) {
                AvatarLabelChip(label: silhouette.label, fill: AevoraTokens.Color.surface.cardPrimary, foreground: AevoraTokens.Color.text.primary)
                AvatarLabelChip(label: palette.label, fill: AevoraTokens.Color.parchmentStone.shade200, foreground: AevoraTokens.Color.text.primary)
                if !configuration.accessoryLabel.isEmpty {
                    AvatarLabelChip(label: configuration.accessoryLabel, fill: AevoraTokens.Color.mossGreen.shade300, foreground: AevoraTokens.Color.text.primary)
                }
            }
        }
        .padding(style == .onboarding ? 18 : 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [AevoraTokens.Color.surface.cardElevated, AevoraTokens.Color.surface.cardPrimary],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: style == .onboarding ? 30 : 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: style == .onboarding ? 30 : 28, style: .continuous)
                .stroke(AevoraTokens.Color.border.default, lineWidth: 1.5)
        )
    }
}

struct AvatarSilhouetteOptionChip: View {
    let option: AvatarSelectionOption
    let paletteId: String
    let isSelected: Bool

    private var silhouette: AvatarPresentationCatalog.SilhouetteDefinition {
        AvatarPresentationCatalog.silhouette(for: option.id) ?? AvatarPresentationCatalog.silhouettes.first!
    }

    private var palette: AvatarPresentationCatalog.PaletteDefinition {
        AvatarPresentationCatalog.palette(for: paletteId) ?? AvatarPresentationCatalog.palettes.first!
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AvatarFigureView(silhouette: silhouette, palette: palette, compact: true)
                .frame(width: 72, height: 82)
            Text(option.label)
                .font(AevoraTokens.Typography.footnote)
                .foregroundStyle(AevoraTokens.Color.text.primary)
                .lineLimit(2)
        }
        .padding(12)
        .frame(width: 120, alignment: .leading)
        .background(AevoraTokens.Color.surface.cardPrimary)
        .clipShape(RoundedRectangle(cornerRadius: AevoraTokens.Radius.md, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: AevoraTokens.Radius.md, style: .continuous)
                .stroke(isSelected ? AevoraTokens.Color.border.focus : AevoraTokens.Color.border.default, lineWidth: isSelected ? 2 : 1.5)
        )
    }
}

struct AvatarPaletteOptionChip: View {
    let option: AvatarSelectionOption
    let isSelected: Bool

    private var palette: AvatarPresentationCatalog.PaletteDefinition {
        AvatarPresentationCatalog.palette(for: option.id) ?? AvatarPresentationCatalog.palettes.first!
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                paletteSwatch(palette.clothHex)
                paletteSwatch(palette.trimHex)
                paletteSwatch(palette.neutralHex)
            }

            Text(option.label)
                .font(AevoraTokens.Typography.footnote)
                .foregroundStyle(AevoraTokens.Color.text.primary)
                .lineLimit(2)
        }
        .padding(12)
        .frame(width: 136, alignment: .leading)
        .background(AevoraTokens.Color.surface.cardPrimary)
        .clipShape(RoundedRectangle(cornerRadius: AevoraTokens.Radius.md, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: AevoraTokens.Radius.md, style: .continuous)
                .stroke(isSelected ? AevoraTokens.Color.border.focus : AevoraTokens.Color.border.default, lineWidth: isSelected ? 2 : 1.5)
        )
    }

    private func paletteSwatch(_ hex: String) -> some View {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(Color(hex: hex))
            .frame(width: 26, height: 26)
    }
}

struct AvatarLabelChip: View {
    let label: String
    let fill: Color
    let foreground: Color

    var body: some View {
        Text(label)
            .font(AevoraTokens.Typography.footnote)
            .foregroundStyle(foreground)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(fill)
            .clipShape(Capsule())
    }
}

private struct AvatarFigureView: View {
    let silhouette: AvatarPresentationCatalog.SilhouetteDefinition
    let palette: AvatarPresentationCatalog.PaletteDefinition
    let compact: Bool

    private var skinColor: Color {
        compact ? Color(hex: "#E7BE9A") : Color(hex: "#D4976A")
    }

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let bodyHeight = compact ? size.height * 0.6 : size.height * 0.66
            let bodyWidth = compact ? size.width * 0.56 : size.width * 0.6
            let cloakWidth = bodyWidth * 1.18
            let cloakHeight = bodyHeight * 1.03
            let headSize = compact ? size.width * 0.3 : size.width * 0.34

            ZStack(alignment: .bottom) {
                Capsule()
                    .fill(Color.black.opacity(0.08))
                    .frame(width: compact ? 56 : 68, height: compact ? 10 : 14)
                    .offset(y: compact ? -4 : -8)

                if silhouette.kind == .guardCape || silhouette.kind == .vowWard || silhouette.kind == .pathfinder || silhouette.kind == .civicCloak {
                    AvatarGarmentShape(shoulderScale: 0.86, waistScale: 0.7, hemScale: 0.98)
                        .fill(Color(hex: palette.neutralHex))
                        .frame(width: cloakWidth, height: cloakHeight)
                        .offset(y: compact ? -10 : -14)
                }

                AvatarGarmentShape(
                    shoulderScale: silhouette.shoulderScale,
                    waistScale: silhouette.waistScale,
                    hemScale: silhouette.hemScale
                )
                .fill(Color(hex: palette.clothHex))
                .frame(width: bodyWidth, height: bodyHeight)

                trimOverlay
                    .frame(width: bodyWidth, height: bodyHeight)

                if silhouette.kind == .fieldApron || silhouette.kind == .ovenApron {
                    RoundedRectangle(cornerRadius: compact ? 10 : 14, style: .continuous)
                        .fill(Color(hex: "#F2EDE3"))
                        .frame(width: bodyWidth * 0.48, height: bodyHeight * 0.44)
                        .offset(y: compact ? -6 : -10)
                    Rectangle()
                        .fill(Color(hex: palette.trimHex))
                        .frame(width: bodyWidth * 0.58, height: compact ? 8 : 10)
                        .offset(y: compact ? -(bodyHeight * 0.14) : -(bodyHeight * 0.17))
                }

                accessoryView
                    .frame(width: bodyWidth, height: bodyHeight)

                HStack(spacing: compact ? 24 : 30) {
                    Rectangle()
                        .fill(Color(hex: palette.neutralHex))
                        .frame(width: compact ? 10 : 12, height: compact ? 18 : 22)
                    Rectangle()
                        .fill(Color(hex: palette.neutralHex))
                        .frame(width: compact ? 10 : 12, height: compact ? 18 : 22)
                }
                .offset(y: compact ? -2 : -6)

                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        Circle()
                            .fill(skinColor)
                            .frame(width: headSize, height: headSize)

                        hairView(size: headSize)
                    }
                    .offset(y: compact ? 8 : 10)

                    Spacer(minLength: 0)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
    }

    @ViewBuilder
    private var trimOverlay: some View {
        switch silhouette.kind {
        case .archiveRobe, .sigilCoat:
            Rectangle()
                .fill(Color(hex: palette.trimHex))
                .frame(width: compact ? 8 : 10, height: compact ? 54 : 72)
                .offset(y: compact ? -4 : -8)
        case .counterVest, .ledgerCoat:
            RoundedRectangle(cornerRadius: compact ? 10 : 12, style: .continuous)
                .stroke(Color(hex: palette.trimHex), lineWidth: compact ? 5 : 6)
                .frame(width: compact ? 34 : 42, height: compact ? 62 : 88)
                .offset(y: compact ? -3 : -8)
        default:
            Rectangle()
                .fill(Color(hex: palette.trimHex))
                .frame(width: compact ? 34 : 42, height: compact ? 8 : 10)
                .offset(y: compact ? -(bodyTrimOffset) : -bodyTrimOffset)
        }
    }

    private var bodyTrimOffset: CGFloat {
        compact ? 24 : 34
    }

    @ViewBuilder
    private var accessoryView: some View {
        switch silhouette.kind {
        case .guardCape:
            Circle()
                .stroke(Color(hex: palette.trimHex), lineWidth: compact ? 3 : 4)
                .frame(width: compact ? 14 : 18, height: compact ? 14 : 18)
                .offset(x: compact ? 24 : 30, y: compact ? -18 : -24)
        case .vowWard:
            Diamond()
                .fill(Color(hex: palette.trimHex))
                .frame(width: compact ? 14 : 18, height: compact ? 14 : 18)
                .offset(x: compact ? 22 : 28, y: compact ? -12 : -18)
        case .pathfinder, .fieldApron, .counterVest:
            RoundedRectangle(cornerRadius: compact ? 5 : 6, style: .continuous)
                .fill(Color(hex: palette.neutralHex))
                .frame(width: compact ? 14 : 18, height: compact ? 18 : 24)
                .offset(x: compact ? -22 : -30, y: compact ? 0 : 4)
        case .sigilCoat, .civicCloak:
            Circle()
                .fill(Color(hex: palette.trimHex))
                .frame(width: compact ? 10 : 12, height: compact ? 10 : 12)
                .offset(y: compact ? -14 : -18)
        case .archiveRobe:
            VStack(spacing: compact ? 3 : 4) {
                Rectangle()
                    .fill(Color(hex: palette.trimHex))
                    .frame(width: compact ? 4 : 5, height: compact ? 20 : 24)
                Circle()
                    .stroke(Color(hex: palette.trimHex), lineWidth: compact ? 2 : 3)
                    .frame(width: compact ? 12 : 16, height: compact ? 12 : 16)
            }
            .offset(x: compact ? 24 : 28, y: compact ? -8 : -12)
        case .ovenApron:
            Circle()
                .fill(Color(hex: palette.trimHex))
                .frame(width: compact ? 10 : 14, height: compact ? 10 : 14)
                .offset(x: compact ? 24 : 32, y: compact ? 6 : 10)
        case .ledgerCoat:
            RoundedRectangle(cornerRadius: compact ? 4 : 5, style: .continuous)
                .fill(Color(hex: palette.neutralHex))
                .frame(width: compact ? 14 : 18, height: compact ? 16 : 22)
                .offset(x: compact ? 24 : 30, y: compact ? -4 : 0)
        }
    }

    private func hairView(size: CGFloat) -> some View {
        let hairColor = Color(hex: palette.hairHex)
        return ZStack {
            switch silhouette.kind {
            case .archiveRobe, .sigilCoat, .civicCloak:
                RoundedRectangle(cornerRadius: size * 0.28, style: .continuous)
                    .fill(hairColor)
                    .frame(width: size * 1.02, height: size * 0.72)
                    .offset(y: -size * 0.13)
                Rectangle()
                    .fill(hairColor)
                    .frame(width: size * 0.5, height: size * 0.3)
                    .offset(y: size * 0.12)
            case .fieldApron, .ovenApron:
                RoundedRectangle(cornerRadius: size * 0.34, style: .continuous)
                    .fill(hairColor)
                    .frame(width: size * 0.98, height: size * 0.68)
                    .offset(y: -size * 0.14)
                Triangle()
                    .fill(hairColor)
                    .frame(width: size * 0.76, height: size * 0.34)
                    .offset(y: size * 0.14)
            default:
                RoundedRectangle(cornerRadius: size * 0.34, style: .continuous)
                    .fill(hairColor)
                    .frame(width: size * 1.04, height: size * 0.7)
                    .offset(y: -size * 0.14)
            }
        }
    }
}

private struct AvatarGarmentShape: Shape {
    let shoulderScale: CGFloat
    let waistScale: CGFloat
    let hemScale: CGFloat

    func path(in rect: CGRect) -> Path {
        let shoulderWidth = rect.width * shoulderScale
        let waistWidth = rect.width * waistScale
        let hemWidth = rect.width * hemScale
        let topY = rect.minY + rect.height * 0.06
        let waistY = rect.minY + rect.height * 0.42
        let hemY = rect.maxY - rect.height * 0.04
        let centerX = rect.midX

        var path = Path()
        path.move(to: CGPoint(x: centerX - shoulderWidth / 2, y: topY))
        path.addLine(to: CGPoint(x: centerX + shoulderWidth / 2, y: topY))
        path.addLine(to: CGPoint(x: centerX + waistWidth / 2, y: waistY))
        path.addLine(to: CGPoint(x: centerX + hemWidth / 2, y: hemY))
        path.addLine(to: CGPoint(x: centerX - hemWidth / 2, y: hemY))
        path.addLine(to: CGPoint(x: centerX - waistWidth / 2, y: waistY))
        path.closeSubpath()
        return path
    }
}

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

private struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        return path
    }
}

private extension AvatarPresentationCatalog.SilhouetteDefinition {
    var shoulderScale: CGFloat {
        switch kind {
        case .guardCape, .vowWard:
            return 0.72
        case .archiveRobe, .sigilCoat, .civicCloak:
            return 0.66
        default:
            return 0.68
        }
    }

    var waistScale: CGFloat {
        switch kind {
        case .guardCape, .vowWard, .pathfinder:
            return 0.42
        case .archiveRobe, .sigilCoat, .civicCloak:
            return 0.5
        default:
            return 0.48
        }
    }

    var hemScale: CGFloat {
        switch kind {
        case .guardCape, .vowWard:
            return 0.52
        case .archiveRobe, .sigilCoat, .civicCloak:
            return 0.72
        case .fieldApron, .ovenApron, .counterVest:
            return 0.64
        default:
            return 0.58
        }
    }
}

private extension Color {
    init(hex: String) {
        let sanitized = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: sanitized).scanHexInt64(&int)
        let r, g, b: UInt64
        switch sanitized.count {
        case 6:
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (255, 255, 255)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}
