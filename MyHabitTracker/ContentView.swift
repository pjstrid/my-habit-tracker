//
//  ContentView.swift
//  MyHabitTracker
//
//  Created by Jonathan Strid on 2026-04-29.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "hand.wave")
                .imageScale(.large)
                .foregroundStyle(.tint)
                .font(Font.largeTitle.bold())
            Text("Hello and Welcome to MyHabitTracker!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
