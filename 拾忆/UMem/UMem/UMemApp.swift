//
//  UMemApp.swift
//  UMem
//
//  Created by Jwy John on 2021/12/5.
//

import SwiftUI

@main
struct UMemApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
