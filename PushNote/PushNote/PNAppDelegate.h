//
//  PNAppDelegate.h
//  PushNote
//
//  Created by Stefan Herold on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PNViewController;

@interface PNAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PNViewController *viewController;

@end
