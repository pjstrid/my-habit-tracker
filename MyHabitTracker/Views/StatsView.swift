//
//  StatsView.swift
//  MyHabitTracker
//
//  Created by Jonathan Strid on 2026-05-06.
//

import Charts
import SwiftUI

struct StatsView: View {

    let items: [String] = [
        "Steps",
        "Eat Fruit",
    ]

    let stepsStatsView: [StatsObject] = [
        .init(date: Date.from(year: 2026, month: 5, day: 1), statsCount: 10000, unit: "steps"),
        .init(date: Date.from(year: 2026, month: 5, day: 2), statsCount: 9500, unit: "steps"),
        .init(date: Date.from(year: 2026, month: 5, day: 3), statsCount: 11000, unit: "steps"),
        .init(date: Date.from(year: 2026, month: 5, day: 4), statsCount: 8300, unit: "steps"),
        .init(date: Date.from(year: 2026, month: 5, day: 5), statsCount: 7600, unit: "steps"),
        .init(date: Date.from(year: 2026, month: 5, day: 6), statsCount: 10500, unit: "steps"),
        .init(date: Date.from(year: 2026, month: 5, day: 7), statsCount: 10900, unit: "steps"),
    ]

    let eatFruitStatsView: [StatsObject] = [
        .init(date: Date.from(year: 2026, month: 5, day: 1), statsCount: 3, unit: "pcs"),
        .init(date: Date.from(year: 2026, month: 5, day: 2), statsCount: 4, unit: "pcs"),
        .init(date: Date.from(year: 2026, month: 5, day: 3), statsCount: 1, unit: "pcs"),
        .init(date: Date.from(year: 2026, month: 5, day: 4), statsCount: 3, unit: "pcs"),
        .init(date: Date.from(year: 2026, month: 5, day: 5), statsCount: 5, unit: "pcs"),
        .init(date: Date.from(year: 2026, month: 5, day: 6), statsCount: 2, unit: "pcs"),
        .init(date: Date.from(year: 2026, month: 5, day: 7), statsCount: 1, unit: "pcs"),
    ]

    @State private var selected = ""
    @State private var selectedList: [StatsObject] = []
    @State private var selectedListGoal = 0

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
                        ForEach(items, id: \.self) { item in
                            VStack(spacing: 4) {
                                Text(item)
                                    .bold()
                                    .foregroundColor(
                                        selected == item ? .white : .gray
                                    )
                                    .onTapGesture {
                                        withAnimation(.easeInOut) {
                                            selected = item

                                            if selected == "Steps" {
                                                selectedList = stepsStatsView
                                                selectedListGoal = 8500
                                            } else if selected == "Eat Fruit" {
                                                selectedList = eatFruitStatsView
                                                selectedListGoal = 3

                                            }
                                        }
                                    }

                                Rectangle()
                                    .frame(height: 3)
                                    .foregroundColor(
                                        selected == item
                                            ? .green.opacity(0.5) : .clear
                                    )
                            }
                        }
                    }
                    .padding()
                }
                .onAppear {
                    selected = items.first ?? ""
                    selectedList = stepsStatsView
                    selectedListGoal = 8500
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.green.opacity(0.2), lineWidth: 3)
                )
                .padding(.bottom, 10)

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

                    Text("Daily Goal: \(selectedListGoal)")
                        .foregroundStyle(.secondary)
                        .fontDesign(.rounded)
                }

                List {
                    ForEach(selectedList) { statsObject in
                        HStack {
                            Text(statsObject.date, style: .date)
                            Spacer()
                            Text("\(statsObject.statsCount) \(statsObject.unit)")
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
    StatsView()
}
