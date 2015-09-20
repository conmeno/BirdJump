//
//  AppDelegate.swift
//  UberJump
//
//  Created by Alexander Frolov on 04/02/15.
//  Copyright (c) 2015 Alexander Frolov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,ChartboostDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //RevMobAds.startSessionWithAppID("55d9875a2c3f445b0c14893a",
        //   withSuccessHandler: nil, andFailHandler: nil)

        
        Chartboost.startWithAppId("55fe047304b0165bb5ed45f7", appSignature: "337b3553b5dac47a4c4a2b0c7d2720de3bf9d480", delegate: self)
        
        //vungle
        // Override point for customization after application launch.
//        var appID = "55d6cb65ce017d4011000287"
//        var sdk = VungleSDK.sharedSDK()
//        // start vungle publisher library
//        sdk.startWithAppId(appID)
//        sdk.setLoggingEnabled(true)
        
        //end vung le
        //adcolony\
        AdColony.configureWithAppID("appf72e33325e794b9cb0", zoneIDs: ["vz52c7bc9733a145f497"], delegate: nil, logging: true)
        
        
        MobileCore.initWithToken("3D2A61TO0BGWAT07RD8KE6PBLZK7S", logLevel: DEBUG_LOG_LEVEL, adUnits:
            [NSNumber (unsignedInt: AD_UNIT_ALL_UNITS.value)])

        
       
        
       
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


}

