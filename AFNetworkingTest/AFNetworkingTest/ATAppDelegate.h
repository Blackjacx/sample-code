//
//  ATAppDelegate.h
//  AFNetworkingTest
//
//  Created by Stefan Herold on 11/19/12.
//  Copyright (c) 2012 Blackjacx. All rights reserved.
//

//#if !defined (CONFIGURATION_Release)
#import "BWHockeyManager.h"
//#endif

#import <UIKit/UIKit.h>

@class ATViewController;

@interface ATAppDelegate : UIResponder <UIApplicationDelegate, BWHockeyManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ATViewController *viewController;

@end
