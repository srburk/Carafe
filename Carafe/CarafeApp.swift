//
//  CarafeApp.swift
//  Carafe
//
//  Created by Sam Burkhard on 10/21/21.
//

import SwiftUI

@main
struct CarafeApp: App {
    
    @StateObject var mainStore = Store()

    var body: some Scene {
        WindowGroup {
            ContentView(mainStore: mainStore)
//                .environment(\.colorScheme, (mainStore.storage.defaults.themeMode == .light) ? .light : .dark)
        }
    }
}
