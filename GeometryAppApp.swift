//
//  GeometryAppApp.swift
//  GeometryApp
//
//  Created by Наталя Грицишин on 07.09.2024.
//

import SwiftUI

@main
struct GeometryAppApp: App {
    @State private var showMainView: Bool = false

    var body: some Scene {
        WindowGroup {
            if showMainView {
                ContentView()
            } else {
                SplashScreen(showMainView: $showMainView)
            }
        }
    }
}
