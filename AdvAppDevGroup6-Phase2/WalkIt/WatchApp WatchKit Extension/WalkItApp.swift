//
//  WalkItApp.swift
//  WatchApp WatchKit Extension
//
//  Created by user on 2021-12-05.
//

import SwiftUI

@main
struct WalkItApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
