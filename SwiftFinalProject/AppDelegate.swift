//
//  AppDelegate.swift
//  SwiftFinalProject
//
//  Created by Dam Vu Duy on 4/6/16.
//  Copyright © 2016 dotRStudio. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert , categories: nil))
        
        Parse.enableLocalDatastore()
        
        let parseConfiguration = ParseClientConfiguration(block: { (ParseMutableClientConfiguration) -> Void in
            
            User.registerSubclass()
            Job.registerSubclass()
            
            ParseMutableClientConfiguration.applicationId = "jobvietnamgroup5"
            //ParseMutableClientConfiguration.clientKey = "dfghjnb67854HIHKL"
            ParseMutableClientConfiguration.clientKey = nil
            ParseMutableClientConfiguration.server = "https://jobvietnam.herokuapp.com/parse"
        })
        
        Parse.initializeWithConfiguration(parseConfiguration)
        
        PFUser.enableAutomaticUser()
        
        let defaultACL = PFACL();
        
        // If you would like all objects to be private by default, remove this line.
        defaultACL.publicReadAccess = true
        
        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser: true)
        
        NSNotificationCenter.defaultCenter().addObserverForName(User.USER_DID_LOGOUT_NOTIFICATION, object: nil, queue: NSOperationQueue.mainQueue()) { (noti: NSNotification) in
            if PFUser.currentUser() != nil {
                PFUser.logOutInBackgroundWithBlock() { (error: NSError?) -> Void in if error != nil {
                    print("logout fail \(error)")
                } else {
                    NSUserDefaults.standardUserDefaults().setValue(nil, forKey: KEY_UID)
                    }
                }
            }else {
                Facebook.logout()
            }
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            self.window?.rootViewController = vc
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(User.USER_DID_LOGIN_NOTIFICATION, object: nil, queue: NSOperationQueue.mainQueue()) { (noti: NSNotification) in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let mainJobsView = storyboard.instantiateViewControllerWithIdentifier("JobViewController") as! UINavigationController
            mainJobsView.tabBarItem.title = "Job"
            mainJobsView.tabBarItem.titlePositionAdjustment = UIOffsetMake(CGFloat(0), CGFloat(-3))
            mainJobsView.tabBarItem.image = UIImage(named: "recent")
            
            let mainSeekersView = storyboard.instantiateViewControllerWithIdentifier("JobViewController") as! UINavigationController
            mainSeekersView.tabBarItem.title = "Seeker"
            mainSeekersView.tabBarItem.titlePositionAdjustment = UIOffsetMake(CGFloat(0), CGFloat(-3))
            mainSeekersView.tabBarItem.image = UIImage(named: "seekercat")
            (mainSeekersView.viewControllers[0] as! JobsViewController).dataMode = .Seeker
            
            let savedJobsView = storyboard.instantiateViewControllerWithIdentifier("JobViewController") as! UINavigationController
            savedJobsView.tabBarItem.title = "Saved"
            savedJobsView.tabBarItem.titlePositionAdjustment = UIOffsetMake(CGFloat(0), CGFloat(-3))
            savedJobsView.tabBarItem.image = UIImage(named: "love")
            (savedJobsView.viewControllers[0] as! JobsViewController).dataMode = .Saved
            
            let userDetail = storyboard.instantiateViewControllerWithIdentifier("UserDetailController") as! UINavigationController
            userDetail.tabBarItem.title = "Profile"
            userDetail.tabBarItem.titlePositionAdjustment = UIOffsetMake(CGFloat(0), CGFloat(-3))
            userDetail.tabBarItem.image = UIImage(named: "info")
            
            (userDetail.viewControllers[0] as! UserDetailViewController).user = PFUser.currentUser()
            (userDetail.viewControllers[0] as! UserDetailViewController).navigationItem.leftBarButtonItems = []
            let tabbar = UITabBarController()
            tabbar.viewControllers = [mainJobsView, mainSeekersView, savedJobsView, userDetail]
            
            tabbar.tabBar.barTintColor = UIColor.blackColor()
            tabbar.tabBar.tintColor = UIColor.grayColor()
            self.window?.rootViewController = tabbar
        }
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil
            || PFUser.currentUser()?.username != nil{
            NSNotificationCenter.defaultCenter().postNotificationName(User.USER_DID_LOGIN_NOTIFICATION, object: nil)
        }
        else {
            if application.applicationState != UIApplicationState.Background {
                let preBackgroundPush = !application.respondsToSelector(Selector("backgroundRefreshStatus"))
                let oldPushHandlerOnly = !self.respondsToSelector(#selector(UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)))
                var noPushPayload = false;
                if let options = launchOptions {
                    noPushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil;
                }
                if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
                    PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
                }
            }
            return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }


}

