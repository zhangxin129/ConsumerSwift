//
//  AppDelegate.swift
//  HSConsumer
//
//  Created by apple on 2016/10/31.
//  Copyright © 2016年 ZX. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var drawerMenuController:DrawerMenuController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
       
        let hdVc = GYHDMainViewController()
        
        let hdNav = UINavigationController (rootViewController: hdVc)
        
        let heSRVc = GYHEVisitSurroundViewController()
        
        let heSRNav = UINavigationController (rootViewController: heSRVc)
        
        let heEBVc = GYHEEasyBuyViewController()
        
        let heEBNav = UINavigationController (rootViewController: heEBVc)
        
        let hsVc = GYHSMainViewController()
    
        let hsNav = UINavigationController (rootViewController: hsVc)
        
        let tabbar = UITabBarController()
        
        let messageItem :UITabBarItem = UITabBarItem.init(title: "消息", image: UIImage (named: "gycommon_tab_message_normal"), tag: 1)
        
        hdVc.tabBarItem = messageItem
        
        let heSRItem :UITabBarItem = UITabBarItem.init(title: "周边逛", image: UIImage (named: "gycommon_tab_around_normal"), tag: 2)
        
        heSRVc.tabBarItem = heSRItem
        
        let heEBItem :UITabBarItem = UITabBarItem.init(title: "轻松购", image: UIImage (named: "gycommon_tab_easybuy_normal"), tag: 3)
        
        heEBVc.tabBarItem = heEBItem
        
        let hsItem :UITabBarItem = UITabBarItem.init(title: "我的互生", image: UIImage (named: "gycommon_tab_mine_normal"), tag: 4)
        
        hsVc.tabBarItem = hsItem
        
        
        tabbar.viewControllers = [hdNav,heSRNav,heEBNav,hsNav]
        
        let rootVc = RootViewController()
        
         rootVc.view.backgroundColor = UIColor.whiteColor()
        
        let hsLoginVc = GYHSloginViewController()
        hsLoginVc.view.backgroundColor = UIColor.brownColor()
        self.drawerMenuController = DrawerMenuController()
        self.drawerMenuController!.rootViewController = tabbar
        self.drawerMenuController!.leftViewController = hsLoginVc
        
        self.window = UIWindow()
        
        self.window!.frame = UIScreen .mainScreen().bounds
        
        self.window!.backgroundColor = UIColor .whiteColor()
        
        self.window!.rootViewController = drawerMenuController
        
        self.window!.makeKeyAndVisible()
        
        
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

