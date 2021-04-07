//
//  AppDelegate.swift
//  QuickExample
//
//  Created by Seoksoon Jang on 2019/12/05.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

func generateRandomString(upto: Int = 1,
                          initNumber: Int = 1,
                          isDuplicateAllowed: Bool = false,
                          output: [String] = []) -> [String] {
    // TODO: TCO or Trampoline to avoid call stack overflow
    var initNumber = initNumber
    
    if output.isEmpty {
        initNumber = upto
    }
    
    if isDuplicateAllowed ? (upto <= 0) : (initNumber <= Set(output).count) {
        return isDuplicateAllowed ? output : Array(Set(output))
    } else {
        let randomString = String((0...Int.random(in: (0...10))).map{ _ in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()!
        })
        
        return generateRandomString(
            upto: upto-1,
            initNumber: initNumber,
            isDuplicateAllowed: isDuplicateAllowed,
            output: output + [randomString])
    }
}


