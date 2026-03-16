import SpriteKit
import SwiftUI

final class EmberQuayScene: SKScene {
    private let state: DistrictWitnessState

    init(size: CGSize, state: DistrictWitnessState) {
        self.state = state
        super.init(size: size)
        scaleMode = .resizeFill
        backgroundColor = SKColor(red: 0.15, green: 0.15, blue: 0.18, alpha: 1)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        removeAllChildren()

        let quay = SKShapeNode(rectOf: CGSize(width: size.width * 0.92, height: size.height * 0.75), cornerRadius: 28)
        quay.fillColor = .init(red: 0.22, green: 0.23, blue: 0.27, alpha: 1)
        quay.strokeColor = .clear
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
    }
}

struct WorldSceneContainer: View {
    let state: DistrictWitnessState

    var body: some View {
        SpriteView(scene: EmberQuayScene(size: CGSize(width: 360, height: 260), state: state))
            .frame(height: 260)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .accessibilityLabel("Ember Quay district scene in \(state.stageTitle) state")
    }
}
