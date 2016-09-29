//
//  AppDelegate+TestActionableNotification.m
//  TestUserNotifications
//
//  Created by Baitianyu on 9/21/16.
//  Copyright © 2016 Baitianyu. All rights reserved.
//

#import "AppDelegate+TestActionableNotification.h"
#import "ViewController.h"

@implementation AppDelegate (TestActionableNotification)

- (void)testActionableNotificationWithLaunchOptions:(NSDictionary *)launchOptions {
    if (![[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        // iOS8 以下不适用
        return;
    }
    [self registerActionableNotification];
}

- (void)registerActionableNotification {
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    // 为该操作设置一个 id
    acceptAction.identifier = @"accept";
    // 设置该操作对应的 button 显示的字符串
    acceptAction.title = @"Accept";
    // 指定是否需要应用处于运行状态
    acceptAction.activationMode = UIUserNotificationActivationModeBackground;
    // 表示该操作是否有害，若设置为 YES，则对应的button会有高亮
    acceptAction.destructive = NO;
    // 当锁屏时收到可操作通知，该属性表示是否必须解锁才能执行该操作
    acceptAction.authenticationRequired = NO;
    
    UIMutableUserNotificationAction *maybeAction = [[UIMutableUserNotificationAction alloc] init];
    maybeAction.identifier = @"maybe";
    maybeAction.title = @"Maybe";
    maybeAction.activationMode = UIUserNotificationActivationModeBackground;
    maybeAction.destructive = NO;
    maybeAction.authenticationRequired = NO;
    
    UIMutableUserNotificationAction *declineAction = [[UIMutableUserNotificationAction alloc] init];
    declineAction.identifier = @"decline";
    declineAction.title = @"Decline";
    declineAction.activationMode = UIUserNotificationActivationModeBackground;
    declineAction.destructive = YES;
    declineAction.authenticationRequired = NO;
    
    // 这里为了测试，又新建了两个 action，declineAction 和 maybeAction ，代码可见 demo
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    // 设置一个 ID，用于本地通知或远程通知时指定该通知可执行的操作group
    inviteCategory.identifier = @"Action";
    // 为弹窗模式设置 actions
    [inviteCategory setActions:@[acceptAction, declineAction, maybeAction] forContext:UIUserNotificationActionContextDefault];
    // 为横幅模式设置 actions
    [inviteCategory setActions:@[acceptAction, declineAction] forContext:UIUserNotificationActionContextMinimal];

    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    // 这里 types 可以自定义，如果 types 为 0，那么所有的用户通知均会静默的接收，系统不会给用户任何提示(当然，App 可以自己处理并给出提示)
    UIUserNotificationType types = (UIUserNotificationType) (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert);
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    // 当应用安装后第一次调用该方法时，系统会弹窗提示用户是否允许接收通知
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
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
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // 将 token 发送给 Provider
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Error in registration for apns service. Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    NSData *infoData = [NSJSONSerialization dataWithJSONObject:userInfo options:0 error:nil];
    NSString *info = [[NSString alloc] initWithData:infoData encoding:NSUTF8StringEncoding];
    [self.windowRootController displayNotification:[NSString stringWithFormat:@"From didReceiveRemoteNotification: %@", info]];
    completionHandler(UIBackgroundFetchResultNoData);
}

- (void)application:(UIApplication *) application handleActionWithIdentifier: (NSString *) identifier forRemoteNotification: (NSDictionary *) notification completionHandler: (void (^)()) completionHandler {
    
    if ([identifier isEqualToString: @"accept"]) {
        NSLog(@"Accepted");
    }
    
    // 执行自定义代码完成后必须调用
    completionHandler();
}

@end
