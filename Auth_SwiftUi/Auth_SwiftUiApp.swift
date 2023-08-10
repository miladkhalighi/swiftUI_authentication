//
//  Auth_SwiftUiApp.swift
//  Auth_SwiftUi
//
//  Created by Milad Khalighi on 2023-07-27.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct Auth_SwiftUiApp: App {
    let persistenceController = PersistenceController.shared
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var authController = AuthenticationController()
    @StateObject var alertDialog = AlertManager()
    @StateObject var firestoreManager = FirestoreManager()
    @StateObject var storageManager = FStorageManager()

    var body: some Scene {
        WindowGroup {
            AuthView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(authController)
                .environmentObject(alertDialog)
                .environmentObject(firestoreManager)
                .environmentObject(storageManager)
                .preferredColorScheme(.dark)
        }
    }
}
