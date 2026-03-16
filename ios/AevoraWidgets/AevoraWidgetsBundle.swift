import SwiftUI
import WidgetKit

#if canImport(ActivityKit)
import ActivityKit
#endif

private struct AevoraWidgetEntry: TimelineEntry {
    let date: Date
    let payload: GlanceSurfacePayload
}

private struct AevoraWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> AevoraWidgetEntry {
        AevoraWidgetEntry(date: .now, payload: .placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (AevoraWidgetEntry) -> Void) {
        completion(AevoraWidgetEntry(date: .now, payload: GlanceSurfacePersistence.load()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<AevoraWidgetEntry>) -> Void) {
        let entry = AevoraWidgetEntry(date: .now, payload: GlanceSurfacePersistence.load())
        completion(Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(1_800))))
    }
}

private struct TodayWidgetView: View {
    let payload: GlanceSurfacePayload

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(payload.today.dayTitle)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            Text(payload.today.chapterTitle)
                .font(.headline)
            Text("\(payload.today.completedVowCount)/\(max(payload.today.activeVowCount, 1)) vows kept")
                .font(.title3.bold())
            Text(payload.today.districtStageTitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(payload.today.witnessPrompt)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding()
        .containerBackground(for: .widget) {
            LinearGradient(
                colors: [Color(red: 0.98, green: 0.95, blue: 0.91), Color(red: 0.89, green: 0.83, blue: 0.74)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

private struct PremiumWidgetView: View {
    let payload: GlanceSurfacePayload

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Premium witness")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            if payload.subscription.hasPremiumBreadth {
                Text(payload.today.chapterTitle)
                    .font(.headline)
                HStack {
                    metric(title: "Chain", value: "\(payload.today.topChainLength)")
                    metric(title: "Stage", value: payload.today.districtStageTitle)
                }
                Text("Reminder at \(String(format: "%02d:%02d", payload.today.reminderHour, payload.today.reminderMinute))")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            } else {
                Text("Upgrade to unlock deeper witness surfaces.")
                    .font(.headline)
                Text("The free Today widget stays available on the starter path.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .containerBackground(for: .widget) {
            LinearGradient(
                colors: [Color(red: 0.90, green: 0.93, blue: 0.89), Color(red: 0.79, green: 0.86, blue: 0.78)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    private func metric(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.headline)
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct AevoraTodayWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "AevoraTodayWidget", provider: AevoraWidgetProvider()) { entry in
            TodayWidgetView(payload: entry.payload)
                .widgetURL(GlanceSurfacePersistence.deepLinkURL(for: .basicWidget))
        }
        .configurationDisplayName("Aevora Today")
        .description("See your starter-arc progress and today’s vow count at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct AevoraPremiumWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "AevoraPremiumWidget", provider: AevoraWidgetProvider()) { entry in
            PremiumWidgetView(payload: entry.payload)
                .widgetURL(GlanceSurfacePersistence.deepLinkURL(for: .premiumWidget))
        }
        .configurationDisplayName("Aevora Witness+")
        .description("Premium glance surface for deeper chapter and chain context.")
        .supportedFamilies([.systemMedium])
    }
}

#if canImport(ActivityKit)
@available(iOSApplicationExtension 16.2, *)
struct AevoraLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AevoraStarterArcAttributes.self) { context in
            VStack(alignment: .leading, spacing: 8) {
                Text(context.attributes.chapterTitle)
                    .font(.headline)
                Text(context.state.districtStageTitle)
                    .font(.subheadline)
                ProgressView(value: Double(context.state.progressPercent), total: 100)
                Text("\(context.state.activeVowCount) active vows")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .activityBackgroundTint(Color(red: 0.18, green: 0.20, blue: 0.16))
            .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text(context.state.districtStageTitle)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("\(context.state.progressPercent)%")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.attributes.chapterTitle)
                }
            } compactLeading: {
                Text("Ae")
            } compactTrailing: {
                Text("\(context.state.progressPercent)%")
            } minimal: {
                Text("Ae")
            }
            .widgetURL(GlanceSurfacePersistence.deepLinkURL(for: .liveActivity))
        }
    }
}
#endif

@main
struct AevoraWidgetsBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        AevoraTodayWidget()
        AevoraPremiumWidget()
#if canImport(ActivityKit)
        if #available(iOSApplicationExtension 16.2, *) {
            AevoraLiveActivityWidget()
        }
#endif
    }
}
