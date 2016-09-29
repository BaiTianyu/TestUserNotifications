//
//  AppDelegate+TestLocalNotification.m
//  TestUserNotifications
//
//  Created by Baitianyu on 9/20/16.
//  Copyright © 2016 Baitianyu. All rights reserved.
//

#import "AppDelegate+TestLocalNotification.h"
#import "ViewController.h"

@implementation AppDelegate (TestLocalNotification)

- (void)testLocalNotificationWithLaunchOptions:(NSDictionary *)launchOptions {
    // 处理未读的本地通知
    UILocalNotification *localNotif =
    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        NSString *itemName = [localNotif.userInfo objectForKey:@"LocalNotification"];
        [self.windowRootController displayNotification:[NSString stringWithFormat:@"%@ receive from didFinishLaunch", itemName]];  // custom method
        [UIApplication sharedApplication].applicationIconBadgeNumber = localNotif.applicationIconBadgeNumber-1;
    }
    
    [self registerNotificationTypes];
    [self scheduleLocalNotification];
    
//    [self registerLocalBasedNotification];
//    [self scheduleLocalNotification];
}

- (void)registerNotificationTypes {
    // 只有 iOS8 and later 才需要
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
        // 这里 types 可以自定义，如果 types 为 0，那么所有的用户通知均会静默的接收，系统不会给用户任何提示(当然，App 可以自己处理并给出提示)
        UIUserNotificationType types = (UIUserNotificationType) (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert);
        // 这里 categories 可暂不深入，本文后面会详细讲解。
        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        // 当应用安装后第一次调用该方法时，系统会弹窗提示用户是否允许接收通知
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    }
}

- (void)scheduleLocalNotification {
    NSDate *itemDate = [NSDate date];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    localNotif.fireDate = [itemDate dateByAddingTimeInterval:10];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotif.alertBody = [NSString stringWithFormat:NSLocalizedString(@"%@ after %i seconds scheduled.", nil), @"本地通知", 10];
    // 只有iOS8.2 and later 可用
//    localNotif.alertTitle = NSLocalizedString(@"Local Notification Title", nil);

    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)] &&
        ([[UIApplication sharedApplication] currentUserNotificationSettings].types & UIUserNotificationTypeSound)) {
        localNotif.soundName = UILocalNotificationDefaultSoundName;
    }

    localNotif.applicationIconBadgeNumber = 1;
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"ID10" forKey:@"LocalNotification"];
    localNotif.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

- (void)application: (UIApplication*)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // 只有 iOS8 and later 会收到此回调
    if (notificationSettings.types & UIUserNotificationTypeBadge) {
        NSLog(@"Badge Nofitication type is allowed");
    }
    if (notificationSettings.types & UIUserNotificationTypeAlert) {
        NSLog(@"Alert Notfication type is allowed");
    }
    if (notificationSettings.types & UIUserNotificationTypeSound) {
        NSLog(@"Sound Notfication type is allowed");
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSString *itemName = [notification.userInfo objectForKey:@"LocalNotification"];
    [self.windowRootController displayNotification:[NSString stringWithFormat:@"%@ receive from didReceiveLocalNotificaition", itemName]];
    application.applicationIconBadgeNumber = notification.applicationIconBadgeNumber - 1;
}

- (void)registerLocalBasedNotification {
    CLLocationManager *locMan = [[CLLocationManager alloc] init];
    locMan.delegate = self;
    [locMan requestWhenInUseAuthorization];
}

- (void)scheduleLocalBasedNotification {
//    UILocalNotification *locationNotification = [[UILocalNotification alloc] init];
//    locationNotification.alertBody = @"到达xxx";
//    locationNotification.regionTriggersOnce = NO; // 表示每次跨越指定区域就会发送通知
//    
//    locationNotification.region = [[CLCircularRegion alloc] initWithCenter:LOC_COORDINATE                                 radius:LOC_RADIUS identifier:LOC_IDENTIFIER];
//    
//    [[UIApplication sharedApplication] scheduleLocalNotification:locNotification];
}


#pragma mark - CLLocationManagerDelegate.

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self scheduleLocalBasedNotification];
    }
}

@end
