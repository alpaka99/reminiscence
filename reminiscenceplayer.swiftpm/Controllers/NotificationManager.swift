//
//  NotificationManager.swift
//  reminiscenceplayer
//
//  Created by user on 2023/04/18.
//

import Foundation
import UIKit

class NotificationManager: NSObject, ObservableObject {
    @Published var currentViewId: UUID?
}


extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //App is in foreground
        completionHandler([.sound, .list, .badge, .banner])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        //App is in background, user has tapped on the notification
        currentViewId = UUID()
    }
}
