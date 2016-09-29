//
//  AppDelegate+TestRemoteNotification.m
//  TestUserNotifications
//
//  Created by Baitianyu on 9/21/16.
//  Copyright © 2016 Baitianyu. All rights reserved.
//

#import "AppDelegate+TestRemoteNotification.h"
#import "ViewController.h"

@implementation AppDelegate (TestRemoteNotification)

- (void)testRemoteNotificationWithLaunchOptions:(NSDictionary *)launchOptions {
    // 处理未读的远程通知
    NSDictionary *remoteNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotif) {
        NSData *infoData = [NSJSONSerialization dataWithJSONObject:remoteNotif options:0 error:nil];
        NSString *info = [[NSString alloc] initWithData:infoData encoding:NSUTF8StringEncoding];
        [self.windowRootController displayNotification:[NSString stringWithFormat:@"From didFinishLaunch: %@", info]];
        [UIApplication sharedApplication].applicationIconBadgeNumber -= 1;
    }
    
    [self registerRemoteNotifications];
}

- (void)registerRemoteNotifications {
    // 区分是否是 iOS8 or later
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
        // 这里 types 可以自定义，如果 types 为 0，那么所有的用户通知均会静默的接收，系统不会给用户任何提示(当然，App 可以自己处理并给出提示)
        UIUserNotificationType types = (UIUserNotificationType) (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert);
        // 这里 categories 可暂不深入，本文后面会详细讲解。
        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        // 当应用安装后第一次调用该方法时，系统会弹窗提示用户是否允许接收通知
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    } else {
        UIRemoteNotificationType types = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(nonnull UIUserNotificationSettings *)notificationSettings {
    // Register for remote notifications.
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

// Handle register result.
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //获得 device token
    NSString *token = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" "                    withString:@""];
    NSLog(@"DeviceToken string, %@", token);
    // 将 token 发送给 Provider
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Error in registration for apns service. Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        NSLog(@"Receive silent notification");
    }
    NSData *infoData = [NSJSONSerialization dataWithJSONObject:userInfo options:0 error:nil];
    NSString *info = [[NSString alloc] initWithData:infoData encoding:NSUTF8StringEncoding];
    [self.windowRootController displayNotification:[NSString stringWithFormat:@"From didReceiveRemoteNotification: %@", info]];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber -= 1;
    
    completionHandler(UIBackgroundFetchResultNoData);
}

@end
