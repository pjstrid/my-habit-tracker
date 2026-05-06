//
//  StatsView.swift
//  MyHabitTracker
//
//  Created by Jonathan Strid on 2026-05-06.
//

import SwiftUI

struct StatsView: View {

    let items: [String] = [
        "Steps",
        "Eat Fruit",
    ]

    @State private var selected = ""

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
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.green.opacity(0.2), lineWidth: 3)
                )

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    StatsView()
}
