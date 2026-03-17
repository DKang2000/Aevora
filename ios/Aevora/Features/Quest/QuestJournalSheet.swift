import SwiftUI

struct QuestJournalSheet: View {
    let content: LaunchContent
    let copy: CopyCatalog
    let currentDay: Int
    let completionDayCount: Int

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(content.starterArcDays, id: \.day) { day in
                        let quest = content.questTemplates.first(where: { $0.id == day.questId })
                        let status = starterStatus(for: day.day)
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Day \(day.day)")
                                    .font(AevoraTokens.Typography.caption)
                                    .foregroundStyle(AevoraTokens.Color.text.secondary)
                                Spacer()
                                Text(status)
                                    .font(AevoraTokens.Typography.caption)
                                    .foregroundStyle(statusColor(status))
                            }
                            Text(copy.text(quest?.titleKey ?? "", fallback: "Quest"))
                                .font(AevoraTokens.Typography.headline)
                            Text(copy.text(quest?.summaryKey ?? "", fallback: "Keep your cadence."))
                                .font(AevoraTokens.Typography.subheadline)
                                .foregroundStyle(AevoraTokens.Color.text.secondary)
                        }
                        .padding(.vertical, 4)
                        .listRowBackground(rowBackground(status))
                    }
                } header: {
                    sectionHeader(
                        title: "Starter arc",
                        subtitle: "Day \(max(1, min(currentDay, 7))) remains in motion until the first week closes."
                    )
                }

                if !content.chapterOneMilestones.isEmpty {
                    Section {
                        ForEach(content.chapterOneMilestones) { milestone in
                            let quest = content.questTemplates.first(where: { $0.id == milestone.questId })
                            let status = chapterOneStatus(for: milestone)
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text("Days \(milestone.startDay)-\(milestone.endDay)")
                                        .font(AevoraTokens.Typography.caption)
                                        .foregroundStyle(AevoraTokens.Color.text.secondary)
                                    Spacer()
                                    Text(status)
                                        .font(AevoraTokens.Typography.caption)
                                        .foregroundStyle(statusColor(status))
                                }
                                Text(copy.text(quest?.titleKey ?? "", fallback: "Chapter beat"))
                                    .font(AevoraTokens.Typography.headline)
                                Text(copy.text(quest?.summaryKey ?? "", fallback: "Keep the district moving."))
                                    .font(AevoraTokens.Typography.subheadline)
                                    .foregroundStyle(AevoraTokens.Color.text.secondary)
                                Text(copy.text(milestone.tomorrowPromptKey, fallback: "Return tomorrow to keep the district moving."))
                                    .font(AevoraTokens.Typography.footnote)
                                    .foregroundStyle(AevoraTokens.Color.text.secondary)
                            }
                            .padding(.vertical, 4)
                            .listRowBackground(rowBackground(status))
                        }
                    } header: {
                        sectionHeader(
                            title: "Chapter One",
                            subtitle: "Milestones stay visible without turning the journal into a dense lore wall."
                        )
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(AevoraTokens.Color.surface.app)
            .navigationTitle("Quest Journal")
        }
        .presentationBackground(AevoraTokens.Color.surface.app)
    }

    private func starterStatus(for day: Int) -> String {
        if day <= min(completionDayCount, 7) {
            return day == min(completionDayCount, 7) && completionDayCount < 7 ? "Current" : "Completed"
        }
        return "Upcoming"
    }

    private func chapterOneStatus(for milestone: LaunchContent.ChapterOneMilestone) -> String {
        let chapterOneDay = max(0, completionDayCount - 7)
        if chapterOneDay >= milestone.endDay {
            return "Completed"
        }
        if chapterOneDay >= milestone.startDay {
            return "Current"
        }
        return "Upcoming"
    }

    private func statusColor(_ status: String) -> Color {
        switch status {
        case "Completed":
            return AevoraTokens.Color.text.success
        case "Current":
            return AevoraTokens.Color.action.primaryFill
        default:
            return AevoraTokens.Color.text.secondary
        }
    }

    private func rowBackground(_ status: String) -> Color {
        switch status {
        case "Completed":
            return AevoraTokens.Color.state.successWash
        case "Current":
            return AevoraTokens.Color.surface.cardElevated
        default:
            return AevoraTokens.Color.surface.cardPrimary
        }
    }

    private func sectionHeader(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(AevoraTokens.Typography.caption)
                .foregroundStyle(AevoraTokens.Color.text.secondary)
            Text(subtitle)
                .font(AevoraTokens.Typography.footnote)
                .foregroundStyle(AevoraTokens.Color.text.secondary)
        }
        .textCase(nil)
    }
}
