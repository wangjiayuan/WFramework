//
//  AppDelegate.h
//  dahuozu
//
//  Created by apple on 15/12/23.
//  Copyright © 2015年 cheniue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabBarController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong)MainTabBarController *mainBarController;

@end

