//
//  AppDelegate.m
//  TestUserNotifications
//
//  Created by Baitianyu on 9/20/16.
//  Copyright © 2016 Baitianyu. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "AppDelegate+TestLocalNotification.h"
#import "AppDelegate+TestRemoteNotification.h"
#import "AppDelegate+TestActionableNotification.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _windowRootController = [[ViewController alloc] init];
    self.window.rootViewController = _windowRootController;
    [self.window makeKeyAndVisible];

    // 测试本地通知
//    _windowRootController.situation = TestSituationLocal;
//    [self testLocalNotificationWithLaunchOptions:launchOptions];
    
    // 测试远程通知
    _windowRootController.situation = TestSituationRemote;
    [self testRemoteNotificationWithLaunchOptions:launchOptions];
    
    // 测试可操作通知
//    _windowRootController.situation = TestSituationActionable;
//    [self testActionableNotificationWithLaunchOptions:launchOptions];
    
    return YES;
}


@end
