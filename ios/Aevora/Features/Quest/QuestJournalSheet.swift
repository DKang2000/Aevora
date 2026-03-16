import SwiftUI

struct QuestJournalSheet: View {
    let content: LaunchContent
    let copy: CopyCatalog
    let currentDay: Int
    let completionDayCount: Int

    var body: some View {
        NavigationStack {
            List {
                ForEach(content.starterArcDays, id: \.day) { day in
                    let quest = content.questTemplates.first(where: { $0.id == day.questId })
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Day \(day.day)")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)
                            Spacer()
                            if day.day < currentDay {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundStyle(.green)
                            } else if day.day == currentDay {
                                Text(completionDayCount >= 7 ? "Complete" : "Current")
                                    .font(.caption.bold())
                                    .foregroundStyle(.orange)
                            } else {
                                Text("Upcoming")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Text(copy.text(quest?.titleKey ?? "", fallback: "Quest"))
                            .font(.headline)
                        Text(copy.text(quest?.summaryKey ?? "", fallback: "Keep your cadence."))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(copy.text(day.tomorrowPromptKey, fallback: "Return tomorrow to keep the district moving."))
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 6)
                }
            }
            .navigationTitle("Quest Journal")
        }
    }
}
