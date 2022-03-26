//
//  CarafeApp.swift
//  Carafe
//
//  Created by Sam Burkhard on 10/21/21.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return AppDelegate.orientationLock
        }
}

@main
struct CarafeApp: App {
    
    @StateObject var mainStore = Store()
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("useDarkMode") var useDarkMode: Bool = false
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView(mainStore: mainStore)
                .environment(\.colorScheme, (useDarkMode || colorScheme == .dark) ? .dark : .light)
//                .environment(\.colorScheme, (mainStore.storage.defaults.themeMode == .light) ? .light : .dark)
        }
    }
}
