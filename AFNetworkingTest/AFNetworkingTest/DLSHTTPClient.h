//
//  DLSHTTPClient.h
//  AFNetworkingTest
//
//  Created by Stefan Herold on 11/19/12.
//  Copyright (c) 2012 Blackjacx. All rights reserved.
//

#import <Foundation/Foundation.h>

// MARK: Block Definitions

typedef void (^DLSHTTPClientJSONSuccessHandler)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON);
typedef void (^DLSHTTPClientJSONFailureHandler)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON);

typedef void (^DLSHTTPClientDownloadProgressHandler)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);
typedef void (^DLSHTTPClientUploadProgressHandler)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);


@interface DLSHTTPClient : NSObject


// MARK: Discovery Information

- (void)getDiscoveryInformationWithSuccessHandler:(DLSHTTPClientJSONSuccessHandler)hSuccess
								   failureHanlder:(DLSHTTPClientJSONFailureHandler)hFailure
						  downloadProgressHandler:(DLSHTTPClientUploadProgressHandler)hDownloadProgress;

- (void)getDiscoveryInformationWithSuccessHandler:(DLSHTTPClientJSONSuccessHandler)hSuccess
								   failureHanlder:(DLSHTTPClientJSONFailureHandler)hFailure;
@end
