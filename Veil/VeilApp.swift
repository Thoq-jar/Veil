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
                .frame(minWidth: 700, minHeight: 700)
                .background(VisualEffectView())
        }
    }
}
