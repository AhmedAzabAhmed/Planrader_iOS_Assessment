//
//  PlanRader_iOSApp.swift
//  PlanRader_iOS
//
//  Created by Ahmed Azzab Sanad on 13/12/2025.
//

import SwiftUI

@main
struct PlanRader_iOSApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
