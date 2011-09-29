//
//  RESTOperationsAppDelegate.h
//  RESTOperations
//
//  Created by Stefan Herold on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RESTOperationsAppDelegate : NSObject <UIApplicationDelegate, PCLRestCommandDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
