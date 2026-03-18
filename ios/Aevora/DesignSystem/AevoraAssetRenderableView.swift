import SwiftUI
import UIKit

enum AevoraAssetPresentationStyle: Equatable {
    case heroCard
    case portraitBust
    case wideBanner
    case compactTile

    fileprivate var cornerRadius: CGFloat {
        switch self {
        case .heroCard:
            return 28
        case .portraitBust:
            return 24
        case .wideBanner:
            return 26
        case .compactTile:
            return 18
        }
    }

    fileprivate var minimumHeight: CGFloat {
        switch self {
        case .heroCard:
            return 196
        case .portraitBust:
            return 148
        case .wideBanner:
            return 154
        case .compactTile:
            return 92
        }
    }

    fileprivate var placeholderSymbol: String {
        switch self {
        case .heroCard:
            return "photo.stack"
        case .portraitBust:
            return "person.crop.rectangle"
        case .wideBanner:
            return "rectangle.inset.filled.and.person.filled"
        case .compactTile:
            return "square.grid.2x2"
        }
    }
}

enum AevoraAssetRenderSource: Equatable {
    case localFile(URL)
    case remoteURL(URL)
    case placeholder
}

struct AevoraAssetRenderableView: View {
    let resolution: AevoraAssetResolution
    let style: AevoraAssetPresentationStyle
    let showsStatusPill: Bool

    init(
        resolution: AevoraAssetResolution,
        style: AevoraAssetPresentationStyle,
        showsStatusPill: Bool = true
    ) {
        self.resolution = resolution
        self.style = style
        self.showsStatusPill = showsStatusPill
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            renderContent

            if showsStatusPill {
                AevoraAssetStatusPill(resolution: resolution)
                    .padding(12)
            }
        }
        .frame(maxWidth: .infinity, minHeight: style.minimumHeight, alignment: .center)
        .background(AevoraTokens.Color.surface.cardPrimary)
        .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous)
                .stroke(AevoraTokens.Color.border.subtle, lineWidth: 1)
        )
        .accessibilityLabel("\(resolution.displayTitle) art in \(resolution.statusLabel.lowercased()) state")
    }

    @ViewBuilder
    private var renderContent: some View {
        switch Self.renderSource(for: resolution) {
        case .localFile(let url):
            if let image = UIImage(contentsOfFile: url.path) {
                render(image: Image(uiImage: image))
            } else {
                placeholderChrome(message: "Imported art is unavailable locally, so Aevora keeps the layout stable.")
            }
        case .remoteURL(let url):
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    render(image: image)
                case .failure:
                    placeholderChrome(message: "Imported art could not load, so deterministic chrome stays visible.")
                case .empty:
                    placeholderChrome(message: "Loading imported art.")
                @unknown default:
                    placeholderChrome(message: resolution.statusDetail)
                }
            }
        case .placeholder:
            placeholderChrome(message: resolution.statusDetail)
        }
    }

    private func render(image: Image) -> some View {
        image
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                LinearGradient(
                    colors: [Color.clear, Color.black.opacity(0.12)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .clipped()
    }

    private func placeholderChrome(message: String) -> some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [
                    resolution.accentColors.first?.opacity(0.94) ?? AevoraTokens.Color.surface.cardSecondary,
                    resolution.accentColors.last?.opacity(0.82) ?? AevoraTokens.Color.surface.cardPrimary
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: style.placeholderSymbol)
                    .font(.system(size: style == .compactTile ? 18 : 24, weight: .semibold))
                    .foregroundStyle(AevoraTokens.Color.text.primary)
                Text(resolution.displayTitle)
                    .font(style == .compactTile ? AevoraTokens.Typography.caption : AevoraTokens.Typography.headline)
                    .foregroundStyle(AevoraTokens.Color.text.primary)
                    .lineLimit(2)
                Text(message)
                    .font(AevoraTokens.Typography.footnote)
                    .foregroundStyle(AevoraTokens.Color.text.secondary)
                    .lineLimit(style == .compactTile ? 2 : 3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(style == .compactTile ? 14 : 18)
        }
    }

    static func renderSource(
        for resolution: AevoraAssetResolution,
        bundles: [Bundle] = defaultBundles,
        fileManager: FileManager = .default
    ) -> AevoraAssetRenderSource {
        guard resolution.presentationState == .imported else {
            return .placeholder
        }

        guard let entry = resolution.entry else {
            return .placeholder
        }

        if let remoteURL = remoteURL(for: entry.artifactPath) {
            return .remoteURL(remoteURL)
        }

        if let localURL = bundleResourceURL(for: entry.artifactPath, bundles: bundles, fileManager: fileManager) {
            return .localFile(localURL)
        }

        if let localURL = localFileURL(for: entry.artifactPath, fileManager: fileManager) {
            return .localFile(localURL)
        }

        return .placeholder
    }

    static func bundleResourceURL(
        for artifactPath: String,
        bundles: [Bundle] = defaultBundles,
        fileManager: FileManager = .default
    ) -> URL? {
        guard artifactPath.hasPrefix("bundle://") else {
            return nil
        }

        let relativePath = artifactPath.replacingOccurrences(of: "bundle://", with: "")
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        guard relativePath.isEmpty == false else {
            return nil
        }

        let pathURL = URL(fileURLWithPath: relativePath)
        let resourceName = pathURL.deletingPathExtension().lastPathComponent
        let resourceExtension = pathURL.pathExtension.isEmpty ? nil : pathURL.pathExtension
        let resourceDirectory = pathURL.deletingLastPathComponent().path == "." ? nil : pathURL.deletingLastPathComponent().path

        for bundle in bundles {
            if let url = bundle.url(forResource: resourceName, withExtension: resourceExtension, subdirectory: resourceDirectory) {
                return url
            }

            if let url = bundle.url(forResource: resourceName, withExtension: resourceExtension) {
                return url
            }

            if let resourceRoot = bundle.resourceURL {
                let candidate = resourceRoot.appendingPathComponent(relativePath)
                if fileManager.fileExists(atPath: candidate.path) {
                    return candidate
                }
            }
        }

        return nil
    }

    static func localFileURL(
        for artifactPath: String,
        fileManager: FileManager = .default
    ) -> URL? {
        if artifactPath.hasPrefix("file://"), let url = URL(string: artifactPath), fileManager.fileExists(atPath: url.path) {
            return url
        }

        if artifactPath.hasPrefix("/") && fileManager.fileExists(atPath: artifactPath) {
            return URL(fileURLWithPath: artifactPath)
        }

        return nil
    }

    private static func remoteURL(for artifactPath: String) -> URL? {
        guard let url = URL(string: artifactPath),
              let scheme = url.scheme?.lowercased(),
              scheme == "http" || scheme == "https" else {
            return nil
        }

        return url
    }

    private static var defaultBundles: [Bundle] {
        var bundles: [Bundle] = [Bundle.main, Bundle(for: AevoraAssetBundleMarker.self)]
        if let frameworkBundle = Bundle.allFrameworks.first {
            bundles.append(frameworkBundle)
        }

        var seen = Set<ObjectIdentifier>()
        return bundles.filter { seen.insert(ObjectIdentifier($0)).inserted }
    }
}
