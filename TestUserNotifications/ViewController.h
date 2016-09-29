//
//  ViewController.h
//  TestUserNotifications
//
//  Created by Baitianyu on 9/20/16.
//  Copyright © 2016 Baitianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TestSituation){
    TestSituationNone = 0,
    TestSituationLocal,
    TestSituationRemote,
    TestSituationActionable
};

@interface ViewController : UIViewController

@property (nonatomic, assign) TestSituation situation;

- (void)displayNotification:(NSString *)noti;

@end

