//
//  AppDelegate.m
//  XBImageFilters
//
//  Created by xiss burg on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "DemoBlurViewController.h"
@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	self.window.rootViewController = [[DemoBlurViewController alloc] init];
	[self.window makeKeyAndVisible];
    return YES;
}


@end
