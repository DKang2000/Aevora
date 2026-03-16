import SwiftUI

struct QuestJournalSheet: View {
    let content: LaunchContent
    let copy: CopyCatalog
    let currentDay: Int
    let completionDayCount: Int

    var body: some View {
        NavigationStack {
            List {
                Section("Starter arc") {
                    ForEach(content.starterArcDays, id: \.day) { day in
                        let quest = content.questTemplates.first(where: { $0.id == day.questId })
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Day \(day.day)")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(starterStatus(for: day.day))
                                    .font(.caption.bold())
                                    .foregroundStyle(day.day < min(completionDayCount, 7) ? .green : .secondary)
                            }
                            Text(copy.text(quest?.titleKey ?? "", fallback: "Quest"))
                                .font(.headline)
                            Text(copy.text(quest?.summaryKey ?? "", fallback: "Keep your cadence."))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }

                if !content.chapterOneMilestones.isEmpty {
                    Section("Chapter One") {
                        ForEach(content.chapterOneMilestones) { milestone in
                            let quest = content.questTemplates.first(where: { $0.id == milestone.questId })
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text("Days \(milestone.startDay)-\(milestone.endDay)")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                    Text(chapterOneStatus(for: milestone))
                                        .font(.caption.bold())
                                        .foregroundStyle(chapterOneStatus(for: milestone) == "Completed" ? .green : .secondary)
                                }
                                Text(copy.text(quest?.titleKey ?? "", fallback: "Chapter beat"))
                                    .font(.headline)
                                Text(copy.text(quest?.summaryKey ?? "", fallback: "Keep the district moving."))
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Text(copy.text(milestone.tomorrowPromptKey, fallback: "Return tomorrow to keep the district moving."))
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Quest Journal")
        }
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
}
