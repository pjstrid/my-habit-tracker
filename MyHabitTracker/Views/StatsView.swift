//
//  StatsView.swift
//  MyHabitTracker
//
//  Created by Jonathan Strid on 2026-05-06.
//

import SwiftUI
import Charts

struct StatsView: View {

    let items: [String] = [
        "Steps",
        "Eat Fruit",
    ]
    
    let stepsStatsView: [StatsObject] = [
        .init(date: Date.from(year: 2026, month: 5, day: 1), statsCount: 10000),
        .init(date: Date.from(year: 2026, month: 5, day: 2), statsCount: 9500),
        .init(date: Date.from(year: 2026, month: 5, day: 3), statsCount: 11000),
        .init(date: Date.from(year: 2026, month: 5, day: 4), statsCount: 8300),
        .init(date: Date.from(year: 2026, month: 5, day: 5), statsCount: 7600),
        .init(date: Date.from(year: 2026, month: 5, day: 6), statsCount: 10500),
        .init(date: Date.from(year: 2026, month: 5, day: 7), statsCount: 10900),
    ]
    
    let eatFruitStatsView: [StatsObject] = [
        .init(date: Date.from(year: 2026, month: 5, day: 1), statsCount: 3),
        .init(date: Date.from(year: 2026, month: 5, day: 2), statsCount: 4),
        .init(date: Date.from(year: 2026, month: 5, day: 3), statsCount: 1),
        .init(date: Date.from(year: 2026, month: 5, day: 4), statsCount: 3),
        .init(date: Date.from(year: 2026, month: 5, day: 5), statsCount: 5),
        .init(date: Date.from(year: 2026, month: 5, day: 6), statsCount: 2),
        .init(date: Date.from(year: 2026, month: 5, day: 7), statsCount: 1),
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

                Chart {
                    
                    ForEach(selectedList) { statsObject in
                        BarMark(x: .value("Day", statsObject.date, unit: .day),
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
                    
                    Text("Daily Goal")
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                
            }
            .padding()
        }
    }
}

struct StatsObject: Identifiable {
    let id = UUID()
    let date: Date
    let statsCount: Int
}

extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }
}

#Preview {
    StatsView()
}
