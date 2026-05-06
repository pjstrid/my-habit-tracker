//
//  HabitListItem.swift
//  MyHabitTracker
//
//  Created by Jonathan Strid on 2026-05-06.
//

import SwiftUI

struct HabitListItemView: View {
    let habit: Habit
    @Bindable var viewModel: HabitsViewModel

    var body: some View {

        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(habit.name)
                    .font(.title3)
                    .fontDesign(.rounded)
                    .bold()
                Text(
                    "Goal: \(habit.goal) \(habit.unit)"
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .bold()
            }

            Spacer()

            HStack(spacing: 12) {
                VStack {
                    Text("Today")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .bold()
                    Spacer()
                    Button {
                        Task {
                            await viewModel
                                .toggleToday(
                                    for: habit
                                )
                        }
                    } label: {
                        Image(
                            systemName: habit
                                .isCompletedToday
                                ? "checkmark.circle.fill"
                                : "circle"
                        )
                        .font(.system(size: 26))
                        .foregroundColor(
                            habit.isCompletedToday
                                ? .green.opacity(
                                    0.6
                                )
                                : .gray
                        )
                    }
                    .buttonStyle(.plain)
                }

                VStack {
                    Text("Streak")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .bold()
                    Spacer()
                    Text("🔥\(habit.currentStreak)")
                        .font(.title3)
                        .fontDesign(.rounded)
                        .bold()
                }
            }
        }
    }
}
