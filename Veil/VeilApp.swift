//
//  VeilApp.swift
//  Veil
//
//  Created by Tristan on 4/23/24.
//

import SwiftUI
import SwiftData

@main
struct VeilApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 500, minHeight: 400)
                .onAppear {
                    NSApp.mainWindow?.title = "Viel - Welcome"
                }
        }
    }
}
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
