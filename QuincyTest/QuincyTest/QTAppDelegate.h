//
//  QTAppDelegate.h
//  QuincyTest
//
//  Created by Stefan Herold on 11/19/12.
//  Copyright (c) 2012 Blackjacx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QTViewController;

@interface QTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) QTViewController *viewController;

@end
