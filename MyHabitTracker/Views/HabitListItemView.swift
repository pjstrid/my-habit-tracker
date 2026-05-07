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
    
    @State private var showingProgressSheet = false
    @State private var progressInput = ""

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
                
                Text(
                    "Progress: \(habit.progress) \(habit.unit)"
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
        .onTapGesture {
            showingProgressSheet = true
        }
        .sheet(isPresented: $showingProgressSheet) {
            ZStack{
                LinearGradient(
                    colors: [
                        Color(.black),
                        Color(red: 0.1, green: 0.20, blue: 0.1),
                    ],
                    startPoint: .center,
                    endPoint: .topTrailing
                )
                .ignoresSafeArea()
                VStack(spacing: 20) {
                    Text("Update progress on '\(habit.name)'")
                        .font(.title2)
                        .bold()
                    
                    Text("Current progress is: \(habit.progress) \(habit.unit)")
                        .font(.subheadline)
                        .bold()
                    
                    TextField("Progress", text: $progressInput)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    
                    Button("Save") {
                        Task {
                            if let progress = Int(progressInput) {
                                await viewModel.updateProgress(for: habit, updatedProgress: progress)
                            }
                            
                            progressInput = ""
                            showingProgressSheet = false
                        }
                    }
                    .buttonStyle(.glass)
                    .font(.title2)
                    .bold()
                    
                    Spacer()
                    
                    Button("Cancel") {
                        Task {
                            progressInput = ""
                            showingProgressSheet = false
                        }
                    }
                    .buttonStyle(.glass)
                    .foregroundStyle(.red.opacity(0.8))
                    .font(.title2)
                    .bold()
                }
                .padding()
            }
        }
    }
}
