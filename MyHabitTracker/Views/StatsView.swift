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

    @Bindable var habitsVM: HabitsViewModel

    enum StatsRange { case week, month }
    @State private var selectedRange: StatsRange = .week

    private var weekData: [StatsObject] {
        guard let firstDate = selectedList.last?.date else { return [] }

        let calendar = Calendar.current
        let weekStart = calendar.date(
            from: calendar.dateComponents(
                [.yearForWeekOfYear, .weekOfYear],
                from: firstDate
            )
        )!

        return (0..<7).map { offset in
            let day = calendar.date(
                byAdding: .day,
                value: offset,
                to: weekStart
            )!
            return selectedList.first(where: {
                calendar.isDate($0.date, inSameDayAs: day)
            })
                ?? StatsObject(date: day, statsCount: 0)
        }
    }

    private var monthData: [StatsObject] {
        guard let referenceDate = selectedList.last?.date else { return [] }

        let calendar = Calendar.current

        let startOfMonth = calendar.date(
            from: calendar.dateComponents([.year, .month], from: referenceDate)
        )!

        let range = calendar.range(of: .day, in: .month, for: referenceDate)!
        let numberOfDays = range.count

        let allDays = (0..<numberOfDays).compactMap { offset -> Date in
            calendar.date(byAdding: .day, value: offset, to: startOfMonth)!
        }

        let filled = allDays.map { day in
            selectedList.first { calendar.isDate($0.date, inSameDayAs: day) }
                ?? StatsObject(date: day, statsCount: 0)
        }

        return filled.sorted { $0.date < $1.date }
    }

    private var filteredStats: [StatsObject] {

        switch selectedRange {
        case .week:
            return weekData
        case .month:
            return monthData
        }
    }

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
                        ForEach(habitsVM.habits.map(\.name), id: \.self) {
                            item in
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

                                            if let habit = habitsVM.habits
                                                .first(where: {
                                                    $0.name == item
                                                })
                                            {
                                                selectedList = habit.stats
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

                HStack {
                    Button("Week") { selectedRange = .week }
                        .foregroundColor(
                            selectedRange == .week ? .green.opacity(0.8) : .gray
                        )

                    Button("Month") { selectedRange = .month }
                        .foregroundColor(
                            selectedRange == .month
                                ? .green.opacity(0.8) : .gray
                        )
                }
                .bold()

                Chart {
                    ForEach(filteredStats) { statsObject in
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

                HStack {
                    Image(systemName: "line.diagonal")
                        .rotationEffect(Angle(degrees: 45))
                        .foregroundStyle(.orange)

                    Text("Daily Goal: \(selectedListGoal) \(selectedListUnit)")
                        .foregroundStyle(.secondary)
                        .fontDesign(.rounded)
                }

                List {
                    ForEach(filteredStats) { statsObject in
                        HStack {
                            Text(statsObject.date, style: .date)
                            Spacer()
                            Text(
                                "\(statsObject.statsCount) \(selectedListUnit)"
                            )
                            .bold()
                        }
                    }
                }
            }
            .padding()
        }
        .alert(
            "Something went wrong",
            isPresented: Binding(
                get: { habitsVM.errorMessage != nil },
                set: {
                    if !$0 {
                        habitsVM.errorMessage = nil
                    }
                }
            ),
            presenting: habitsVM.errorMessage
        ) { _ in
            Button("OK", role: .cancel) {}
        } message: { message in
            Text(message)
        }
    }
}

#Preview {
    StatsView(habitsVM: HabitsViewModel())
}
