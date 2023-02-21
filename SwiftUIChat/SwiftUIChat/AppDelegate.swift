//
//  AppDelegate.swift
//  SwiftUIChat
//
//  Created by Korashi on 24/01/2023.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import UserNotifications

// MARK: - AppDelegate

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        configureFirebase()
        registerForPushNotification {
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
        configureMessaging()
        return true
    }
    
    // MARK: - Config
    
    func configureFirebase() {
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
    }
    
    private func registerForPushNotification(_ onAuthGranted: @escaping () -> Void) {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { isAuthorized, error in
            guard error == nil, isAuthorized else {
                print(error?.localizedDescription ?? "")
                return
            }
            onAuthGranted()
        }
    }
    
    private func configureMessaging() {
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = false
    }
}

// MARK: - Messaging Delegate

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCMToken: \(String(describing: fcmToken))")
        let dataDict: [String: String] = ["FCMToken": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
}

// MARK: - Notification Delegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response)
        completionHandler()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Registered for remote notification with device token: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Registeration error: ", error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        print(userInfo)
        return UIBackgroundFetchResult.newData
    }
}
