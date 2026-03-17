import Foundation
import SwiftUI

enum AevoraTokens {
    private static let store = TokenStore.load()

    enum Color {
        static let parchmentStone = ParchmentStonePalette()
        static let dawnGold = DawnGoldPalette()
        static let emberCopper = EmberCopperPalette()
        static let moonIndigo = MoonIndigoPalette()
        static let mossGreen = MossGreenPalette()
        static let ashPlum = AshPlumPalette()
        static let signalRed = SignalRedPalette()

        static let text = TextPalette()
        static let surface = SurfacePalette()
        static let border = BorderPalette()
        static let action = ActionPalette()
        static let state = StatePalette()
    }

    enum Gradient {
        static let chapter = ChapterGradients()
        static let reward = RewardGradients()
        static let world = WorldGradients()
        static let restoration = RestorationGradients()
    }

    enum Radius {
        static let sm = CGFloat(store.radius.sm)
        static let md = CGFloat(store.radius.md)
        static let lg = CGFloat(store.radius.lg)
        static let xl = CGFloat(store.radius.xl)
        static let pill = CGFloat(store.radius.pill)
    }

    enum Typography {
        static let displayLarge = makeFont(store.type.display.large)
        static let displayMedium = makeFont(store.type.display.medium)
        static let titleCard = makeFont(store.type.title.card)
        static let headline = makeFont(store.type.headline)
        static let body = makeFont(store.type.body)
        static let subheadline = makeFont(store.type.subheadline)
        static let footnote = makeFont(store.type.footnote)
        static let caption = makeFont(store.type.caption)
        static let button = makeFont(store.type.button)
    }

    struct ParchmentStonePalette {
        let shade050 = SwiftUI.Color(hex: AevoraTokens.store.color.parchmentStone.shade050)
        let shade100 = SwiftUI.Color(hex: AevoraTokens.store.color.parchmentStone.shade100)
        let shade200 = SwiftUI.Color(hex: AevoraTokens.store.color.parchmentStone.shade200)
        let shade300 = SwiftUI.Color(hex: AevoraTokens.store.color.parchmentStone.shade300)
    }

    struct DawnGoldPalette {
        let shade300 = SwiftUI.Color(hex: AevoraTokens.store.color.dawnGold.shade300)
        let shade500 = SwiftUI.Color(hex: AevoraTokens.store.color.dawnGold.shade500)
        let shade700 = SwiftUI.Color(hex: AevoraTokens.store.color.dawnGold.shade700)
    }

    struct EmberCopperPalette {
        let shade300 = SwiftUI.Color(hex: AevoraTokens.store.color.emberCopper.shade300)
        let shade500 = SwiftUI.Color(hex: AevoraTokens.store.color.emberCopper.shade500)
        let shade700 = SwiftUI.Color(hex: AevoraTokens.store.color.emberCopper.shade700)
    }

    struct MoonIndigoPalette {
        let shade300 = SwiftUI.Color(hex: AevoraTokens.store.color.moonIndigo.shade300)
        let shade500 = SwiftUI.Color(hex: AevoraTokens.store.color.moonIndigo.shade500)
        let shade700 = SwiftUI.Color(hex: AevoraTokens.store.color.moonIndigo.shade700)
        let shade900 = SwiftUI.Color(hex: AevoraTokens.store.color.moonIndigo.shade900)
    }

    struct MossGreenPalette {
        let shade300 = SwiftUI.Color(hex: AevoraTokens.store.color.mossGreen.shade300)
        let shade500 = SwiftUI.Color(hex: AevoraTokens.store.color.mossGreen.shade500)
        let shade700 = SwiftUI.Color(hex: AevoraTokens.store.color.mossGreen.shade700)
    }

    struct AshPlumPalette {
        let shade300 = SwiftUI.Color(hex: AevoraTokens.store.color.ashPlum.shade300)
        let shade500 = SwiftUI.Color(hex: AevoraTokens.store.color.ashPlum.shade500)
        let shade700 = SwiftUI.Color(hex: AevoraTokens.store.color.ashPlum.shade700)
    }

    struct SignalRedPalette {
        let shade500 = SwiftUI.Color(hex: AevoraTokens.store.color.signalRed.shade500)
        let shade700 = SwiftUI.Color(hex: AevoraTokens.store.color.signalRed.shade700)
    }

    struct TextPalette {
        let primary = SwiftUI.Color(hex: AevoraTokens.store.color.text.primary)
        let secondary = SwiftUI.Color(hex: AevoraTokens.store.color.text.secondary)
        let tertiary = SwiftUI.Color(hex: AevoraTokens.store.color.text.tertiary)
        let inverse = SwiftUI.Color(hex: AevoraTokens.store.color.text.inverse)
        let success = SwiftUI.Color(hex: AevoraTokens.store.color.text.success)
        let warning = SwiftUI.Color(hex: AevoraTokens.store.color.text.warning)
    }

    struct SurfacePalette {
        let app = SwiftUI.Color(hex: AevoraTokens.store.color.surface.app)
        let cardPrimary = SwiftUI.Color(hex: AevoraTokens.store.color.surface.cardPrimary)
        let cardSecondary = SwiftUI.Color(hex: AevoraTokens.store.color.surface.cardSecondary)
        let cardElevated = SwiftUI.Color(hex: AevoraTokens.store.color.surface.cardElevated)
        let darkShell = SwiftUI.Color(hex: AevoraTokens.store.color.surface.darkShell)
        let disabled = SwiftUI.Color(hex: AevoraTokens.store.color.surface.disabled)
    }

    struct BorderPalette {
        let subtle = SwiftUI.Color(hex: AevoraTokens.store.color.border.subtle)
        let `default` = SwiftUI.Color(hex: AevoraTokens.store.color.border.default)
        let focus = SwiftUI.Color(hex: AevoraTokens.store.color.border.focus)
        let success = SwiftUI.Color(hex: AevoraTokens.store.color.border.success)
        let warning = SwiftUI.Color(hex: AevoraTokens.store.color.border.warning)
    }

    struct ActionPalette {
        let primaryFill = SwiftUI.Color(hex: AevoraTokens.store.color.action.primaryFill)
        let primaryText = SwiftUI.Color(hex: AevoraTokens.store.color.action.primaryText)
        let secondaryFill = SwiftUI.Color(hex: AevoraTokens.store.color.action.secondaryFill)
        let secondaryText = SwiftUI.Color(hex: AevoraTokens.store.color.action.secondaryText)
        let progress = SwiftUI.Color(hex: AevoraTokens.store.color.action.progress)
        let reward = SwiftUI.Color(hex: AevoraTokens.store.color.action.reward)
    }

    struct StatePalette {
        let successFill = SwiftUI.Color(hex: AevoraTokens.store.color.state.successFill)
        let successWash = SwiftUI.Color(hex: AevoraTokens.store.color.state.successWash)
        let warningFill = SwiftUI.Color(hex: AevoraTokens.store.color.state.warningFill)
        let dissonantFill = SwiftUI.Color(hex: AevoraTokens.store.color.state.dissonantFill)
        let lockedWash = SwiftUI.Color(hex: AevoraTokens.store.color.state.lockedWash)
    }

    struct ChapterGradients {
        let primary = makeLinearGradient(
            colors: AevoraTokens.store.gradient.chapter.primary,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    struct RewardGradients {
        let warm = makeLinearGradient(
            colors: AevoraTokens.store.gradient.reward.warm,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    struct WorldGradients {
        let deep = makeLinearGradient(
            colors: AevoraTokens.store.gradient.world.deep,
            startPoint: .top,
            endPoint: .bottom
        )
    }

    struct RestorationGradients {
        let soft = makeLinearGradient(
            colors: AevoraTokens.store.gradient.restoration.soft,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private static func makeLinearGradient(
        colors: [String],
        startPoint: UnitPoint,
        endPoint: UnitPoint
    ) -> LinearGradient {
        LinearGradient(
            colors: colors.map(SwiftUI.Color.init(hex:)),
            startPoint: startPoint,
            endPoint: endPoint
        )
    }

    private static func makeFont(_ token: TokenStore.TypeToken) -> Font {
        let weight = fontWeight(token.weight)
        let design: Font.Design = token.family == "system-rounded" ? .rounded : .default
        return .system(size: token.size, weight: weight, design: design)
    }

    private static func fontWeight(_ value: String) -> Font.Weight {
        switch value {
        case "bold":
            return .bold
        case "semibold":
            return .semibold
        case "medium":
            return .medium
        case "light":
            return .light
        default:
            return .regular
        }
    }
}

private extension AevoraTokens {
    final class BundleLocator {}

    struct TokenStore: Decodable {
        let color: ColorTokens
        let gradient: GradientTokens
        let type: TypographyTokens
        let radius: RadiusTokens

        static func load() -> TokenStore {
            let decoder = JSONDecoder()
            let candidateBundles = [Bundle.main, Bundle(for: BundleLocator.self)] + Bundle.allBundles + Bundle.allFrameworks

            for bundle in candidateBundles {
                guard let url = bundle.url(forResource: "aevora-v1-design-tokens", withExtension: "json") else {
                    continue
                }

                do {
                    let data = try Data(contentsOf: url)
                    return try decoder.decode(TokenStore.self, from: data)
                } catch {
                    continue
                }
            }

            preconditionFailure("Unable to load bundled aevora-v1-design-tokens.json.")
        }

        struct ColorTokens: Decodable {
            let parchmentStone: PrimitiveShades4
            let dawnGold: PrimitiveShades3
            let emberCopper: PrimitiveShades3
            let moonIndigo: MoonIndigoShades
            let mossGreen: PrimitiveShades3
            let ashPlum: PrimitiveShades3
            let signalRed: SignalRedShades
            let text: TextTokens
            let surface: SurfaceTokens
            let border: BorderTokens
            let action: ActionTokens
            let state: StateTokens
        }

        struct PrimitiveShades4: Decodable {
            let shade050: String
            let shade100: String
            let shade200: String
            let shade300: String

            enum CodingKeys: String, CodingKey {
                case shade050 = "050"
                case shade100 = "100"
                case shade200 = "200"
                case shade300 = "300"
            }
        }

        struct PrimitiveShades3: Decodable {
            let shade300: String
            let shade500: String
            let shade700: String

            enum CodingKeys: String, CodingKey {
                case shade300 = "300"
                case shade500 = "500"
                case shade700 = "700"
            }
        }

        struct MoonIndigoShades: Decodable {
            let shade300: String
            let shade500: String
            let shade700: String
            let shade900: String

            enum CodingKeys: String, CodingKey {
                case shade300 = "300"
                case shade500 = "500"
                case shade700 = "700"
                case shade900 = "900"
            }
        }

        struct SignalRedShades: Decodable {
            let shade500: String
            let shade700: String

            enum CodingKeys: String, CodingKey {
                case shade500 = "500"
                case shade700 = "700"
            }
        }

        struct TextTokens: Decodable {
            let primary: String
            let secondary: String
            let tertiary: String
            let inverse: String
            let success: String
            let warning: String
        }

        struct SurfaceTokens: Decodable {
            let app: String
            let cardPrimary: String
            let cardSecondary: String
            let cardElevated: String
            let darkShell: String
            let disabled: String
        }

        struct BorderTokens: Decodable {
            let subtle: String
            let `default`: String
            let focus: String
            let success: String
            let warning: String
        }

        struct ActionTokens: Decodable {
            let primaryFill: String
            let primaryText: String
            let secondaryFill: String
            let secondaryText: String
            let progress: String
            let reward: String
        }

        struct StateTokens: Decodable {
            let successFill: String
            let successWash: String
            let warningFill: String
            let dissonantFill: String
            let lockedWash: String
        }

        struct GradientTokens: Decodable {
            let chapter: ChapterGradient
            let reward: RewardGradient
            let world: WorldGradient
            let restoration: RestorationGradient

            struct ChapterGradient: Decodable {
                let primary: [String]
            }

            struct RewardGradient: Decodable {
                let warm: [String]
            }

            struct WorldGradient: Decodable {
                let deep: [String]
            }

            struct RestorationGradient: Decodable {
                let soft: [String]
            }
        }

        struct TypographyTokens: Decodable {
            let display: DisplayTypeTokens
            let title: TitleTypeTokens
            let headline: TypeToken
            let body: TypeToken
            let subheadline: TypeToken
            let footnote: TypeToken
            let caption: TypeToken
            let button: TypeToken

            struct DisplayTypeTokens: Decodable {
                let large: TypeToken
                let medium: TypeToken
            }

            struct TitleTypeTokens: Decodable {
                let card: TypeToken
            }
        }

        struct TypeToken: Decodable {
            let family: String
            let size: CGFloat
            let weight: String
            let lineHeight: CGFloat
        }

        struct RadiusTokens: Decodable {
            let sm: Double
            let md: Double
            let lg: Double
            let xl: Double
            let pill: Double
        }
    }
}

private extension SwiftUI.Color {
    init(hex: String) {
        let trimmed = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: trimmed).scanHexInt64(&value)

        let red = Double((value >> 16) & 0xFF) / 255.0
        let green = Double((value >> 8) & 0xFF) / 255.0
        let blue = Double(value & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}
