import Foundation

#if canImport(ActivityKit)
import ActivityKit
#endif

@MainActor
final class LiveActivityCoordinator {
    func sync(with payload: GlanceSurfacePayload) async {
#if canImport(ActivityKit)
        if #available(iOS 16.2, *) {
            let existing = Activity<AevoraStarterArcAttributes>.activities

            guard payload.liveActivity.isEnabled else {
                for activity in existing {
                    await activity.end(nil, dismissalPolicy: .immediate)
                }
                return
            }

            let contentState = AevoraStarterArcAttributes.ContentState(
                districtStageTitle: payload.liveActivity.districtStageTitle,
                progressPercent: payload.liveActivity.progressPercent,
                activeVowCount: payload.liveActivity.activeVowCount
            )

            if let activity = existing.first {
                await activity.update(
                    ActivityContent(
                        state: contentState,
                        staleDate: Date().addingTimeInterval(3600)
                    )
                )
                return
            }

            let attributes = AevoraStarterArcAttributes(chapterTitle: payload.liveActivity.chapterTitle)
            try? Activity.request(
                attributes: attributes,
                content: ActivityContent(
                    state: contentState,
                    staleDate: Date().addingTimeInterval(3600)
                )
            )
        }
#endif
    }
}
