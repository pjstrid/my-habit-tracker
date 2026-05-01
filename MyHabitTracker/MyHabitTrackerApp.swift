//
//  MyHabitTrackerApp.swift
//  MyHabitTracker
//
//  Created by Jonathan Strid on 2026-04-29.
//

import FirebaseCore
import SwiftUI

@main
struct MyHabitTrackerApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
