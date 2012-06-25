//
//  SynthesizeSingleton.h
//
//  Created by Stefan Herold 02/02/2012
//  Copyright 2012 Stefan Herold. All rights reserved.
//
//  Permission is given to use this source code file without charge in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
 \
static classname * _instance = nil; \
 \
+ (classname *)sharedInstance \
{ \
	@synchronized(self) \
	{ \
		if (_instance == nil) \
		{ \
			_instance = [[self alloc] init]; \
		} \
	} \
	 \
	return _instance; \
} \
 \
+ (id)allocWithZone:(NSZone *)zone \
{ \
	@synchronized(self) \
	{ \
		if (_instance == nil) \
		{ \
			_instance = [super allocWithZone:zone]; \
			return _instance; \
		} \
	} \
	 \
	return nil; \
} \
 \
- (id)copyWithZone:(NSZone *)zone \
{ \
	return self; \
}