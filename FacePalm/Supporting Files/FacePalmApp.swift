//
//  FacePalmApp.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 20.01.23.
//

import SwiftUI

@main
struct FacePalmApp: App {
    @StateObject private var navigation: AppNavigation = AppNavigation()

    var body: some Scene {
        WindowGroup {
            WelcomeScreen()
                .environmentObject(navigation)
        }
    }
}
