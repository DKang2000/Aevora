import XCTest
@testable import Aevora

final class OnboardingRootViewTests: XCTestCase {
    func testFooterConfigurationOnlyAllowsInlineCompletionAtSoftPaywall() {
        let copy = CopyCatalog()

        for step in OnboardingFlowStep.allCases {
            let configuration = OnboardingRootView.footerConfiguration(for: step, copy: copy)

            switch step {
            case .signIn:
                XCTAssertEqual(configuration.mode, .backOnly)
                XCTAssertNil(configuration.primaryTitle)
            case .softPaywall:
                XCTAssertEqual(configuration.mode, .inlineCompletion)
                XCTAssertNil(configuration.primaryTitle)
            default:
                XCTAssertEqual(configuration.mode, .advance, "Only the soft paywall should own onboarding completion actions.")
                XCTAssertNotNil(configuration.primaryTitle)
            }
        }
    }

    func testLateSequenceUsesDedicatedAdvanceLabels() {
        let copy = CopyCatalog()

        XCTAssertEqual(
            OnboardingRootView.footerConfiguration(for: .starterVows, copy: copy),
            OnboardingFooterConfiguration(mode: .advance, primaryTitle: "Preview quest")
        )
        XCTAssertEqual(
            OnboardingRootView.footerConfiguration(for: .questPreview, copy: copy),
            OnboardingFooterConfiguration(mode: .advance, primaryTitle: "See first witness")
        )
        XCTAssertEqual(
            OnboardingRootView.footerConfiguration(for: .magicalMoment, copy: copy),
            OnboardingFooterConfiguration(mode: .advance, primaryTitle: "See options")
        )
    }
}
