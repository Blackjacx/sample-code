//
//  MySingleton.m
//  Singleton
//
//  Created by Stefan Herold on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MySingleton.h"

@implementation MySingleton

// MARK: -
// MARK: Singleton Pattern using GCD

+ (id)allocWithZone:(NSZone *)zone { return [[self sharedInstance] retain]; }
- (id)copyWithZone:(NSZone *)zone { return self; }
- (id)autorelease { return self; }
- (oneway void)release { /* Singletons can't be released */ }
- (void)dealloc { [super dealloc]; /* should never be called */ }
- (id)retain { return self; }
- (NSUInteger)retainCount {	return NSUIntegerMax; /* That's soooo non-zero */ }

+ (MySingleton *)sharedInstance
{
	static MySingleton * instance = nil;
	
	static dispatch_once_t predicate;	
	dispatch_once(&predicate, ^{
		// --- call to super avoids a deadlock with the above 
		// --- allocWithZone: method
		instance = [[super allocWithZone:nil] init];
	});
	
	return instance;
}

// MARK: -
// MARK: Initialization

- (id)init
{
	self = [super init];
	if (self) 
	{
		// Initialization code here.
	}
	return self;
}

@end
