//
//  DTPushClient.h
//  pntestapp
//
//  Created by Stefan Herold on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// The error domain for this class
extern NSString * const DTPushClientErrorDomain;

// Keys for the request parameter dictionary
extern NSString * const DTPushClientRequestParameterKeyAppKey;

typedef void (^DTPushClientOperationCompletionHandler)(NSError *);

typedef enum _DTPushClientErrorCode {
  DTPushClientErrorCodeUnknown = 800000,
  DTPushClientErrorCodeParameterDictionaryEmpty = 800001,
  DTPushClientErrorCodeAppKeyMissing = 800002,
  DTPushClientErrorCodeRessourceIdentifierMissing = 800003,
  DTPushClientErrorCodeInvalidURL = 800004,
  DTPushClientErrorCodeInvalidRequest = 800005,
  DTPushClientErrorCodeOngoingRegistrationProcessInterruption = 800006,
  DTPushClientErrorCodeInvalidResponseStatusCode = 800007
} DTPushClientErrorCode;

@interface DTPushClient : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property(assign, nonatomic, getter=isDebugMode)BOOL debugMode;

+ (DTPushClient*)sharedInstance;
- (void)registerRemoteNotificationTypesWithApple:(UIRemoteNotificationType)rnTypes;
- (void)registerDeviceTokenWithProvider:(NSData*)deviceToken parameters:(NSDictionary*)paramDic completionHandler:(DTPushClientOperationCompletionHandler)completionHandler;

//! @brief Used only for debug purposes
- (void)sendRemoteNotificationWithParameters:(NSDictionary*)paramDic completionHandler:(DTPushClientOperationCompletionHandler)completionHandler;

@end