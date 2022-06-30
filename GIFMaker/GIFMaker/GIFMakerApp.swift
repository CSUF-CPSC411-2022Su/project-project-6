//
//  GIFMakerApp.swift
//  GIFMaker
//
//  Created by csuftitan on 6/21/22.
//

import FacebookCore
import Firebase
import GoogleSignIn
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool
    {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }
}

@main
struct GIFMakerApp: App {
    // MARK: Intialize Firebase

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        setupAuthentication()
    }

    var body: some Scene {
        WindowGroup {
//            ContentView()
            SplashScreenView()
        }
    }
}

extension GIFMakerApp {
    private func setupAuthentication() {
        FirebaseApp.configure()
    }
}
