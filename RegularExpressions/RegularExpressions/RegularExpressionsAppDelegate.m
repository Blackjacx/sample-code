//
//  RegularExpressionsAppDelegate.m
//  RESTOperations
//
//  Created by *** *** on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RegularExpressionsAppDelegate.h"

@implementation RegularExpressionsAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// --- regular expression taken from (read the discussion): 
	// --- http://www.regular-expressions.info/email.html
	
	NSString * regexPattern = @"^[A-Z0-9._%+-]+@-Z0-9-]+\.)+[A-Z]{2,4}$";
	NSString * testString = @"a@gmail.b"; // Won't match
	NSError * error = nil;
	BOOL result = [testString matchesRegularExpression:regexPattern forError:&error];
	
	NSLog(@"Regex: %@ matching string: %@ <result: %d> <error: %@>", 
			regexPattern, testString, result, error);
			
	NSError * err = [NSError errorWithDomain:@"blubb" code:255];
	NSLog(@"%@", err);
	
	[self.window makeKeyAndVisible];
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}

- (void)dealloc
{
	[_window release];
    [super dealloc];
}

@end
