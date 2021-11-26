//
//  WalkItApp.swift
//  WalkIt
//
//  Created by Arzen Edillo on 2021-10-03.
//

import SwiftUI

@main
struct WalkItApp: App {
    let locationHelper = LocationHelper()
    let persistenceController = PersistenceController.shared
    let coreDBHelper = CoreDBHelper(context: PersistenceController.shared.container.viewContext)

    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(locationHelper).environmentObject(coreDBHelper)
        }
    }
}
