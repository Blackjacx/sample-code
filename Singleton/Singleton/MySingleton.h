//
//  MySingleton.h
//  Singleton
//
//  Created by Stefan Herold on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySingleton : NSObject
{
}
+ (MySingleton *)sharedInstance;

@end
