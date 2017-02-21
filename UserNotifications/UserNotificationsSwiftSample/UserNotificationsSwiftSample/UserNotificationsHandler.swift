//
//  UserNotificationsHandler.swift
//  UserNotificationsSwiftSample
//
//  Created by Nikolay Andonov on 11/9/16.
//  Copyright © 2016 Mentormate. All rights reserved.
//

import UIKit
import UserNotifications

private let sharedInstance = UserNotificationsHandler()

let RemindLaterActionIdentifier = "remindLater"
let LogoAttachmentIdentifier = "logo"
let NotificationCategoryIdentifier = "myCategory"
let NotificationRequestIdentifier = "myNotificationRequest"


class UserNotificationsHandler: NSObject, UNUserNotificationCenterDelegate {

    class var sharedHandler: UserNotificationsHandler {
        return sharedInstance
    }
    
    func userNotificationsInitialSetup() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {(accepted, error) in
            if !accepted {
                print("Notification access denied.")
            }
        }
        
        let action = UNNotificationAction(identifier: RemindLaterActionIdentifier, title: "Remind me later", options: [])
        let category = UNNotificationCategory(identifier: NotificationCategoryIdentifier, actions: [action], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    func scheduleNotification(at date: Date) {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Reminder to do some generic activity"
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = NotificationCategoryIdentifier
        
        if let path = Bundle.main.path(forResource: "logo", ofType: "png") {
            let url = URL(fileURLWithPath: path)
            
            do {
                let attachment = try UNNotificationAttachment(identifier: LogoAttachmentIdentifier, url: url, options: nil)
                content.attachments = [attachment]
            } catch {
                print("The attachment was not loaded.")
            }
        }
        
        let request = UNNotificationRequest(identifier: NotificationRequestIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Error occured: \(error)")
            }
        }
    }

    //MARK: - UNUserNotificationCenterDelegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
        if response.actionIdentifier == RemindLaterActionIdentifier {
            let newDate = Date(timeInterval: 60 * 5, since: Date())
            scheduleNotification(at: newDate)
        }
    }
}
