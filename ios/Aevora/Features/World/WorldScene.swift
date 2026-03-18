import SpriteKit
import SwiftUI

final class EmberQuayScene: SKScene {
    private let state: DistrictWitnessState
    private let anchorID: String
    private let tilesetResolution: AevoraAssetResolution
    private let repairResolution: AevoraAssetResolution

    init(
        size: CGSize,
        state: DistrictWitnessState,
        anchorID: String,
        tilesetResolution: AevoraAssetResolution,
        repairResolution: AevoraAssetResolution
    ) {
        self.state = state
        self.anchorID = anchorID
        self.tilesetResolution = tilesetResolution
        self.repairResolution = repairResolution
        super.init(size: size)
        scaleMode = .resizeFill
        backgroundColor = .clear
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        removeAllChildren()

        let quay = SKShapeNode(rectOf: CGSize(width: size.width * 0.92, height: size.height * 0.75), cornerRadius: 28)
        quay.fillColor = tilesetResolution.isImported
            ? .init(red: 0.11, green: 0.14, blue: 0.18, alpha: 0.34)
            : .init(red: 0.22, green: 0.23, blue: 0.27, alpha: 0.96)
        quay.strokeColor = tilesetResolution.isImported
            ? .init(red: 0.93, green: 0.83, blue: 0.60, alpha: 0.28)
            : .clear
        quay.lineWidth = tilesetResolution.isImported ? 2 : 0
        quay.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(quay)

        let oven = SKShapeNode(rectOf: CGSize(width: 84, height: 70), cornerRadius: 18)
        oven.position = CGPoint(x: size.width / 2 - 70, y: size.height / 2 - 10)
        oven.fillColor = state.stageID == "dim" ? .darkGray : .init(red: 0.82, green: 0.49, blue: 0.23, alpha: 1)
        oven.strokeColor = .clear
        addChild(oven)

        if state.stageID != "dim" {
            let glow = SKShapeNode(circleOfRadius: state.stageID == "rekindled" ? 34 : 24)
            glow.fillColor = .init(red: 0.96, green: 0.73, blue: 0.35, alpha: 0.45)
            glow.strokeColor = .clear
            glow.position = oven.position
            addChild(glow)
        }

        let lantern = SKShapeNode(circleOfRadius: 14)
        lantern.position = CGPoint(x: size.width / 2 + 70, y: size.height / 2 + 40)
        lantern.fillColor = state.stageID == "dim" ? .gray : .init(red: 0.95, green: 0.79, blue: 0.42, alpha: 1)
        lantern.strokeColor = .clear
        addChild(lantern)

        let stageAccent = SKShapeNode(rectOf: CGSize(width: 120, height: 24), cornerRadius: 12)
        stageAccent.position = CGPoint(x: size.width / 2 + 70, y: size.height / 2 - 48)
        stageAccent.fillColor = state.problemProgressPercent > 0.75
            ? .init(red: 0.80, green: 0.63, blue: 0.31, alpha: 1)
            : (repairResolution.isImported
                ? .init(red: 0.32, green: 0.53, blue: 0.42, alpha: 1)
                : .init(red: 0.46, green: 0.44, blue: 0.33, alpha: 1))
        stageAccent.strokeColor = .clear
        addChild(stageAccent)

        let avatar = SKShapeNode(circleOfRadius: 16)
        avatar.fillColor = .init(red: 0.93, green: 0.87, blue: 0.76, alpha: 1)
        avatar.strokeColor = .clear
        avatar.position = anchorPosition(for: anchorID)
        addChild(avatar)

        for npcID in state.visibleNPCIDs.prefix(3) {
            let marker = SKShapeNode(circleOfRadius: 10)
            marker.fillColor = .init(red: 0.52, green: 0.33, blue: 0.20, alpha: 1)
            marker.strokeColor = .clear
            marker.position = anchorPosition(for: npcID.contains("tovan") || npcID.contains("pollen") ? "oven_square" : (npcID.contains("sera") || npcID.contains("ilya") ? "lantern_stall" : "quay_gate"))
            addChild(marker)
        }
    }

    private func anchorPosition(for anchorID: String) -> CGPoint {
        switch anchorID {
        case "quay_gate":
            return CGPoint(x: size.width / 2 - 115, y: size.height / 2 - 30)
        case "lantern_stall":
            return CGPoint(x: size.width / 2 + 100, y: size.height / 2 + 10)
        default:
            return CGPoint(x: size.width / 2 - 20, y: size.height / 2 - 6)
        }
    }
}

struct WorldSceneContainer: View {
    let state: DistrictWitnessState
    let anchorID: String
    let tilesetResolution: AevoraAssetResolution
    let repairResolution: AevoraAssetResolution

    var body: some View {
        ZStack(alignment: .topLeading) {
            AevoraAssetRenderableView(
                resolution: tilesetResolution,
                style: .wideBanner
            )
            .frame(height: 260)

            SpriteView(
                scene: EmberQuayScene(
                    size: CGSize(width: 360, height: 260),
                    state: state,
                    anchorID: anchorID,
                    tilesetResolution: tilesetResolution,
                    repairResolution: repairResolution
                )
            )
            .frame(height: 260)
            .background(Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))

            VStack(alignment: .leading, spacing: 8) {
                AevoraAssetStatusPill(resolution: tilesetResolution)
                AevoraAssetStatusPill(resolution: repairResolution)
            }
            .padding(16)
        }
        .accessibilityLabel("Ember Quay district scene in \(state.stageTitle) state")
    }
}
