//
//  AppDelegate.swift
//  CallKitSwiftSample
//
//  Created by Nikolay Andonov on 11/15/16.
//  Copyright © 2016 Mentormate. All rights reserved.
//

import UIKit
import Intents
import PushKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PKPushRegistryDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let pushRegistry = PKPushRegistry.init(queue: DispatchQueue.main)
        pushRegistry.delegate = self;
        pushRegistry.desiredPushTypes = [PKPushType.voIP]
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        let intent = userActivity.interaction?.intent
        if intent is INStartAudioCallIntent {
            
           let person = (intent as! INStartAudioCallIntent).contacts?.first
           let phoneNumber = person?.personHandle?.value
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: CallViewController.self)) as! CallViewController
            viewController.phoneNumber = phoneNumber
            
            let mainViewController = window?.rootViewController
            mainViewController?.present(viewController, animated: true, completion: nil)
        }
        return true
    }
    
    //MARK: - PKPushRegistryDelegate
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, forType type: PKPushType) {
        
        if credentials.token.count > 0 {
            print("voip token NULL")
            return
        }
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, forType type: PKPushType) {
        let uuidString = payload.dictionaryPayload["UUID"] as! String
        let uuid = UUID.init(uuidString: uuidString)
        let phoneNumber = payload.dictionaryPayload["PhoneNumber"] as! String
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: CallViewController.self)) as! CallViewController
        viewController.phoneNumber = phoneNumber
        viewController.isIncoming = true
        viewController.uuid = uuid
        
        let mainViewController = window?.rootViewController
        mainViewController?.present(viewController, animated: true, completion: nil)
    }
}

