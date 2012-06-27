//
//  PTAppDelegate.m
//  PathTrack
//
//  Created by Stefan Herold on 6/25/12.
//  Copyright (c) 2012 Blackjacx. All rights reserved.
//

#import "PTAppDelegate.h"

#import "PTViewController.h"

@implementation PTAppDelegate
{
	UIBackgroundTaskIdentifier _bgTask;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	if( [launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey] ) {
		
		return YES;
	}
	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
	self.viewController = [[PTViewController alloc] init];
	self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
//    _bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
//        // Clean up any unfinished task business by marking where you.
//        // stopped or ending the task outright.
//        [application endBackgroundTask:bgTask];
//        _bgTask = UIBackgroundTaskInvalid;
//    }];
//	
//    // Start the long-running task and return immediately.
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//		
//		BOOL done = NO;
//		
//		do {
//			@autoreleasepool {
//				
//				[[NSRunLoop mainRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:0.1]];
//				NSLog(@"BG-Time: %f", [[UIApplication sharedApplication] backgroundTimeRemaining]);
//			}
//			
//		} while ( _bgTask != UIBackgroundTaskInvalid );
//		
//        [application endBackgroundTask:bgTask];
//        _bgTask = UIBackgroundTaskInvalid;
//    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{	
//	[application endBackgroundTask:bgTask];
//	bgTask = UIBackgroundTaskInvalid;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
