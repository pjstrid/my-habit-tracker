//
//  StatsView.swift
//  MyHabitTracker
//
//  Created by Jonathan Strid on 2026-05-06.
//

import Charts
import SwiftUI

struct StatsView: View {

    @State private var selectedMenuItem = ""
    @State private var selectedList: [StatsObject] = []
    @State private var selectedListGoal = 0
    @State private var selectedListUnit = ""

    @Bindable var statsVM: StatsViewModel
    @Bindable var habitsVM: HabitsViewModel

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(.black),
                    Color(red: 0.1, green: 0.18, blue: 0.1),
                ],
                startPoint: .center,
                endPoint: .topTrailing
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {

                Text("Stats")
                    .font(.largeTitle)
                    .bold()

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(habitsVM.habits.map(\.name), id: \.self) { item in
                            VStack(spacing: 4) {
                                Text(item)
                                    .bold()
                                    .foregroundColor(
                                        selectedMenuItem == item
                                            ? .white : .gray
                                    )
                                    .onTapGesture {
                                        withAnimation(.easeInOut) {
                                            selectedMenuItem = item

                                            if let habit = habitsVM.habits.first(where: { $0.name == item }) {
                                                selectedList = habit.stats.sorted { $0.date < $1.date }
                                                selectedListGoal = habit.goal
                                                selectedListUnit = habit.unit
                                            }
                                        }
                                    }

                                Rectangle()
                                    .frame(height: 3)
                                    .foregroundColor(
                                        selectedMenuItem == item
                                            ? .green.opacity(0.5) : .clear
                                    )
                            }
                        }
                    }
                    .padding()
                }
                .padding(.bottom, 10)
                .task {
                    if let first = habitsVM.habits.first {
                        selectedMenuItem = first.name
                        selectedList = first.stats.sorted { $0.date < $1.date }
                        selectedListGoal = first.goal
                        selectedListUnit = first.unit
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.green.opacity(0.2), lineWidth: 3)
                )

                Chart {
                    ForEach(selectedList) { statsObject in
                        BarMark(
                            x: .value("Day", statsObject.date, unit: .day),
                            y: .value("Steps", statsObject.statsCount)
                        )
                        .foregroundStyle(Color.green.gradient)
                    }

                    RuleMark(y: .value("Goal", selectedListGoal))
                        .foregroundStyle(Color.orange)
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))

                }
                .frame(height: 200)
                .chartXAxis {
                    AxisMarks(values: selectedList.map { $0.date }) { date in
                        AxisValueLabel()
                    }
                }

                HStack {
                    Image(systemName: "line.diagonal")
                        .rotationEffect(Angle(degrees: 45))
                        .foregroundStyle(.orange)

                    Text("Daily Goal: \(selectedListGoal) \(selectedListUnit)")
                        .foregroundStyle(.secondary)
                        .fontDesign(.rounded)
                }

                List {
                    ForEach(selectedList) { statsObject in
                        HStack {
                            Text(statsObject.date, style: .date)
                            Spacer()
                            Text("\(statsObject.statsCount) \(selectedListUnit)")
                            .bold()
                        }
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    StatsView(statsVM: StatsViewModel(), habitsVM: HabitsViewModel())
}
