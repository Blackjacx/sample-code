//
//  DLSHTTPClient.m
//  AFNetworkingTest
//
//  Created by Stefan Herold on 11/19/12.
//  Copyright (c) 2012 Blackjacx. All rights reserved.
//

#import "DLSHTTPClient.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

@interface DLSHTTPClient ()

@property(nonatomic, strong)AFHTTPClient * httpClient;

@end

@implementation DLSHTTPClient

// MARK: Init

- (DLSHTTPClient *)sharedInstance {

	static DLSHTTPClient * instance = nil;
	static dispatch_once_t predicate;

	dispatch_once(&predicate, ^{

		instance = [[DLSHTTPClient alloc] init];
	});
	return instance;
}

- (id)init {

	self = [super init];

	if( self ) {

		NSURL * baseURL = [NSURL URLWithString:@""];
		_httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
	}
	return self;
}

// MARK: Discovery Information



@end
