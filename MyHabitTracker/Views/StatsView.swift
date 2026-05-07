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
                        ForEach(statsVM.habitNames, id: \.self) { item in
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
                                            Task {
                                                await statsVM.fetchStats(
                                                    name: item
                                                )
                                                selectedList = statsVM.statsList
                                                selectedListGoal = statsVM.statsList[0].goal
                                                selectedListUnit = statsVM.statsList[0].unit
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
                    await statsVM.fetchHabitNames()

                    if let first = statsVM.habitNames.first {
                        selectedMenuItem = first
                        await statsVM.fetchStats(name: first)
                        selectedList = statsVM.statsList
                        selectedListGoal = statsVM.statsList[0].goal
                        selectedListUnit = statsVM.statsList[0].unit
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
                            Text(
                                "\(statsObject.statsCount) \(statsObject.unit)"
                            )
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
    StatsView(statsVM: StatsViewModel())
}
