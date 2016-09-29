//
//  AppDelegate+TestLocalNotification.h
//  TestUserNotifications
//
//  Created by Baitianyu on 9/20/16.
//  Copyright © 2016 Baitianyu. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate (TestLocalNotification) <CLLocationManagerDelegate>

- (void)testLocalNotificationWithLaunchOptions:(NSDictionary *)launchOptions;

@end
