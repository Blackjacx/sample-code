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


// MARK: HTTP Method Definitions

static NSString * const kHttpMethodGet = @"GET";
static NSString * const kHttpMethodPost = @"POST";
static NSString * const kHttpMethodPut = @"PUT";
static NSString * const kHttpMethodDelete = @"DELETE";


// MARK: Path Format Denitions

static NSString * const kDLSHTTPClientPathDiscovery = @"discovery01";


// MARK: Class Extension

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
//		[_httpClient setDefaultHeader:@"User-Agent" value:@""];
	}
	return self;
}


// MARK: Discovery Information

- (void)getDiscoveryInformationWithSuccessHandler:(DLSHTTPClientJSONSuccessHandler)hSuccess
								   failureHanlder:(DLSHTTPClientJSONFailureHandler)hFailure
						  downloadProgressHandler:(DLSHTTPClientUploadProgressHandler)hDownloadProgress {

	NSMutableURLRequest * request = [self.httpClient requestWithMethod:kHttpMethodGet
																  path:kDLSHTTPClientPathDiscovery
															parameters:nil];
	AFJSONRequestOperation * op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
																				  success:hSuccess
																				  failure:hFailure];
	[op setDownloadProgressBlock:hDownloadProgress];
	[self.httpClient enqueueHTTPRequestOperation:op];
}

- (void)getDiscoveryInformationWithSuccessHandler:(DLSHTTPClientJSONSuccessHandler)hSuccess
								   failureHanlder:(DLSHTTPClientJSONFailureHandler)hFailure {

	[self getDiscoveryInformationWithSuccessHandler:hSuccess
									 failureHanlder:hFailure
							downloadProgressHandler:nil];
}

@end
