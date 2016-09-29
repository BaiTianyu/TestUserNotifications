//
//  ViewController.m
//  TestUserNotifications
//
//  Created by Baitianyu on 9/20/16.
//  Copyright © 2016 Baitianyu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *notificationLabel;

@end

@implementation ViewController

#pragma mark - Life cycle.

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubviews];
    self.view.backgroundColor = [UIColor whiteColor];
    self.situation = TestSituationLocal;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _label.center = self.view.center;
    _notificationLabel.frame = CGRectMake(0, _label.frame.origin.y + 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - _label.frame.origin.y - 20);
}


#pragma mark - Load views.

- (void)loadSubviews {
    _label = [[UILabel alloc] init];
    _label.font = [UIFont systemFontOfSize:15];
    _label.textColor = [UIColor blackColor];
    [self.view addSubview:_label];
    
    _notificationLabel = [[UILabel alloc] init];
    _notificationLabel.font = [UIFont systemFontOfSize:13];
    _notificationLabel.textColor = [UIColor blackColor];
    _notificationLabel.textAlignment = NSTextAlignmentCenter;
    _notificationLabel.numberOfLines = 0;
    [self.view addSubview:_notificationLabel];
}


#pragma mark - Getter & Setter.

- (void)setSituation:(TestSituation)situation {
    if (_situation == situation) {
        return;
    }
    
    _situation = situation;
    switch (_situation) {
        case TestSituationNone:
            _label.text = NSLocalizedString(@"Test None", nil);
            break;
        case TestSituationLocal: {
            _label.text = NSLocalizedString(@"TestLocalNotification", nil);
            break;
        }
        case TestSituationRemote: {
            _label.text = NSLocalizedString(@"TestRemoteNotification", nil);
            break;
        }
        case TestSituationActionable: {
            _label.text = NSLocalizedString(@"TestActionableNotification", nil);
            break;
        }
    }
    [_label sizeToFit];
}

- (void)displayNotification:(NSString *)noti {
    _notificationLabel.text = noti;
}

@end
