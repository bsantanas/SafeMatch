//
//  AppDelegate.swift
//  SafeMatch
//
//  Created by Bernardo Santana on 5/30/15.
//  Copyright (c) 2015 BUM. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var backgroundTask : UIBackgroundTaskIdentifier?
    var window: UIWindow?
    var mcManager:MCManager?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Register for push in iOS 8
        UIApplication.sharedApplication().registerForRemoteNotifications()
        let settings = UIUserNotificationSettings(forTypes: .Alert, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        
        
        if UIApplication.instancesRespondToSelector(Selector("registerUserNotificationSettings:"))
        {
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Sound | .Alert | .Badge, categories: nil))
        }
        else
        {
            //do iOS 7 stuff, which is pretty much nothing for local notifications.
        }
        
        mcManager = MCManager()
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        self.backgroundTask = application.beginBackgroundTaskWithExpirationHandler({
            
            //Here: Kill the session, advertisers, nil its delegates,
            //      which should correctly send a disconnect signal to other peers
            //      it's important if we want to be able to reconnect later,
            //      as the MC framework is still buggy
            application.endBackgroundTask(self.backgroundTask!)
            self.backgroundTask = UIBackgroundTaskInvalid
        })
            
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        application.endBackgroundTask(self.backgroundTask!)
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        // Here: We should init back the session, start the advertising and set the delegates from scratch
        // This should allow the app to reconnect to the same session with more often than not
        self.backgroundTask = UIBackgroundTaskInvalid; //Here we invalidate the background task if the timer didn't end already
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!) {
        println("received a request from watch")
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        println("My token is: \(deviceToken)")
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("Failed to get token, error: \(error)")
    }
    
    func registerSettingsAndCategories() {
        var categories = NSMutableSet()
        
        var acceptAction = UIMutableUserNotificationAction()
        acceptAction.title = NSLocalizedString("Accept", comment: "Accept invitation")
        acceptAction.identifier = "accept"
        acceptAction.activationMode = UIUserNotificationActivationMode.Background
        acceptAction.authenticationRequired = false
        
        var declineAction = UIMutableUserNotificationAction()
        declineAction.title = NSLocalizedString("Decline", comment: "Decline invitation")
        declineAction.identifier = "decline"
        declineAction.activationMode = UIUserNotificationActivationMode.Background
        declineAction.authenticationRequired = false
        
        var inviteCategory = UIMutableUserNotificationCategory()
        inviteCategory.setActions([acceptAction, declineAction],
            forContext: UIUserNotificationActionContext.Default)
        inviteCategory.identifier = "invitation"
        
        categories.addObject(inviteCategory)
        
        // Configure other actions and categories and add them to the set...
        
        var settings = UIUserNotificationSettings(forTypes: (.Alert | .Badge | .Sound),
            categories: categories as Set<NSObject>)
        
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }

}

