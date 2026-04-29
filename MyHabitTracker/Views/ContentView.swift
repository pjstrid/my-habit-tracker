//
//  ContentView.swift
//  MyHabitTracker
//
//  Created by Jonathan Strid on 2026-04-29.
//

import SwiftUI

struct MenuItem: Identifiable {
    let id: UUID = UUID()
    let iconName: String
    let name: String
    let todaysProgress: String
}

struct ContentView: View {

    @State private var testList: [MenuItem] = [
        MenuItem(
            iconName: "shoeprints.fill",
            name: "Steps",
            todaysProgress: "10 000 steps"
        ),
        MenuItem(
            iconName: "book.fill",
            name: "Reading",
            todaysProgress: "25 pages"
        ),
        MenuItem(
            iconName: "carrot.fill",
            name: "Fruits and Veggies",
            todaysProgress: "3 pieces"
        ),
    ]

    var body: some View {
        Text("My Habit Tracker")
            .font(.title)
            .bold()
        
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(.black),
                        Color(red: 0.1, green: 0.15, blue: 0.1),
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                List {
                    ForEach(testList) { menuItem in
                        NavigationLink {

                        } label: {
                            HStack {
                                Image(systemName: menuItem.iconName)
                                    .font(.system(size: 22))
                                    .frame(width: 44, height: 44)
                                    .background(.green.opacity(0.1))
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 12)
                                    )
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(menuItem.name)
                                        .font(.title3)
                                        .fontDesign(.rounded)
                                        .bold()
                                    Text("Today: \(menuItem.todaysProgress)")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .bold()
                                }
                            }
                        }
                    }
                }
                
                Button {

                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add progress")
                            .padding(10)
                    }
                }
                .buttonStyle(.glass)
                .font(Font.title2.bold())
                
            }
        }
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    ContentView()
}
