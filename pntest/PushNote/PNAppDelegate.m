//
//  PNAppDelegate.m
//  PushNote
//
//  Created by Stefan Herold on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PNAppDelegate.h"

#import "PNViewController.h"
#import "DTLogger.h"
#import "DTPushClient.h"

@implementation PNAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

// MARK: 
// MARK: Push Notifiction Handling

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{		
	DTPushClient * pushClient = [DTPushClient sharedInstance];
	pushClient.debugMode = YES;
	NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:
		@"testApp",	DTPushClientRequestParameterKeyAppKey,	// An ID for this app (ask the provider for it)
		nil];
	[pushClient
			registerDeviceTokenWithProvider:deviceToken 
			parameters:params
			completionHandler:^(NSError * error)
	{
		if( error )	{
			DT_LOG(@"PUSH_NOTE_DEBUG", @"Failed to register with provider with error: %@", error);
		}
		else {
			DT_LOG(@"PUSH_NOTE_DEBUG", @"Proivider Registration Successful!");
		}
	}];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
	DT_LOG(@"PUSH_NOTE_DEBUG", @"Error: %@", error)
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)rmPayload
{
	DT_LOG(@"PUSH_NOTE_DEBUG", @"UserInfo: %@", rmPayload);
}

// MARK: 
// MARK: Application Delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	//
	// Init the APNs
	//
	
	[[DTPushClient sharedInstance] registerRemoteNotificationTypesWithApple:
		UIRemoteNotificationTypeAlert
		| UIRemoteNotificationTypeSound
		| UIRemoteNotificationTypeBadge];
	
	NSDictionary * rmPayload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
	
    if ( rmPayload ) {
		// TODO: The doc can contain following user-defined items: 
		//			timestamp of provider-side creation of PN - gauge how old the note is
		
		// TODO:	• Download new content from the provider
		//			• Init the view hierarchy based on the notification result
		DT_LOG(@"PUSH_NOTE_DEBUG", @"PN UserInfo: %@", rmPayload);
    }
	
	
	
	

	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    self.viewController = [[PNViewController alloc] initWithNibName:@"PNViewController_iPhone" bundle:nil];
	} else {
	    self.viewController = [[PNViewController alloc] initWithNibName:@"PNViewController_iPad" bundle:nil];
	}
	
	self.window.rootViewController = self.viewController;
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

@end
