//
//  DTPushClient.m
//  pntestapp
//
//  Created by Stefan Herold on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DTPushClient.h"
#import "DTSynthesizeSingleton.h"
#import "DTLogger.h"

// The provider base url
NSString * const DTPushClientBaseProviderURLAsString = @"http://byte-welt.net:8080/PNServer";

// Provider ressources
NSString * const DTPushClientBaseProviderRessourceRegister = @"register";
NSString * const DTPushClientBaseProviderRessourceSend = @"send";

// The error domain for this class
NSString * const DTPushClientErrorDomain = @"de.telekom.iphoneapp.dtpushclient.errordomain";

// NSUserDefaults Keys
NSString * const DTPushClientUniqueDeviceIDDefaultsKey = @"DTPushClientUniqueDeviceIDDefaultsKey";

// Keys for the request parameter dictionary
NSString * const DTPushClientRequestParameterKeyDeviceType = @"devicetype";
NSString * const DTPushClientRequestParameterKeyAppKey = @"appKey";		// HACK: appKey needs to be lowerCcase with registering and upper case with sending RN's
NSString * const DTPushClientRequestParameterKeyDeviceToken = @"devkey";
NSString * const DTPushClientRequestParameterKeyDeviceID = @"deviceid";
NSString * const DTPushClientRequestParameterKeyDebugMode = @"d";

NSString * const DTPushClientRequestParameterKeyRNReceiver = @"receiver";
NSString * const DTPushClientRequestParameterKeyRNMessageDictionary = @"message";
NSString * const DTPushClientRequestParameterKeyRNMessage = @"message";
NSString * const DTPushClientRequestParameterKeyRNType = @"type";
NSString * const DTPushClientRequestParameterKeyRNTarget = @"target";
NSString * const DTPushClientRequestParameterKeyRNTitle = @"title";
NSString * const DTPushClientRequestParameterKeyRNMessageTarget = @"messageTarget";



// Private Methods and Properties
@interface DTPushClient ()
- (void)executeCompletionHandlerOnMainThread:(DTPushClientOperationCompletionHandler)completionHandler forError:(NSError*)error;
- (void)providerSendRequestWithParameters:(NSDictionary*)paramDic writeParamsToBody:(BOOL)writeParamsToBody toRessource:(NSString*)ressource completionHandler:(DTPushClientOperationCompletionHandler)completionHandler;
- (NSString*)registerUniqueDeviceID;
+ (NSString*)uniqueDeviceID;
+ (NSError*)errorWithCode:(NSInteger)code message:(NSString*)message;
+ (NSString *)URLEncodeString:(NSString*)string;
+ (NSString *)jsonStringForObject:(id)object;

@property(strong, nonatomic)DTPushClientOperationCompletionHandler completionHandler;
@property(strong, nonatomic)NSURLConnection * connection;
@property(strong, nonatomic)NSMutableData * receivedData;
@property(strong, nonatomic)NSHTTPURLResponse * response;
@end

@implementation DTPushClient
@synthesize debugMode = _debugMode;
@synthesize completionHandler = _completionHandler;
@synthesize connection = _connection;
@synthesize receivedData = _receivedData;
@synthesize response = _response;

SYNTHESIZE_SINGLETON_FOR_CLASS(DTPushClient);

- (id)init
{
	self = [super init];
	if( self ) {
		self.debugMode = NO;
	}
	return self;
}

- (void)registerRemoteNotificationTypesWithApple:(UIRemoteNotificationType)rnTypes
{
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:rnTypes];
}

- (void)registerDeviceTokenWithProvider:(NSData*)deviceToken parameters:(NSDictionary*)paramDic completionHandler:(DTPushClientOperationCompletionHandler)completionHandler
{	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
	
		//
		// Populate Parameter Dictionary
		// 

		NSMutableDictionary * mutableParamDic = [[NSMutableDictionary alloc] initWithDictionary:paramDic];

		// populate unique device ID
		NSString * uniqueDeviceID = [self registerUniqueDeviceID];
		[mutableParamDic setObject:uniqueDeviceID forKey:DTPushClientRequestParameterKeyDeviceID];

		// populate device type
		[mutableParamDic setObject:@"4" forKey:DTPushClientRequestParameterKeyDeviceType];	// means iOS Device

		// populate device token
		NSCharacterSet * trimSet = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
		NSString * deviceTokenAsString = [[[deviceToken description] stringByTrimmingCharactersInSet:trimSet] stringByReplacingOccurrencesOfString:@" " withString:@""];
		[mutableParamDic setObject:deviceTokenAsString forKey:DTPushClientRequestParameterKeyDeviceToken];
		
		//
		// Send request - completion handler is either called during an error 
		// or when the connection fails/finishes
		//
		
		[self 
			providerSendRequestWithParameters:[mutableParamDic copy] 
			writeParamsToBody:NO
			toRessource:DTPushClientBaseProviderRessourceRegister 
			completionHandler:completionHandler];
	});
}

- (void)sendRemoteNotificationWithParameters:(NSDictionary*)paramDic completionHandler:(DTPushClientOperationCompletionHandler)completionHandler
{	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
	
		//
		// Populate Parameter Dictionary
		// 

		NSMutableDictionary * mutableParamDic = [NSMutableDictionary dictionaryWithDictionary:paramDic];
		NSMutableArray * notificationList = [NSMutableArray array];
		NSMutableDictionary * notificationDict = [NSMutableDictionary dictionary];

		[notificationDict setObject:@"Message Text" forKey:DTPushClientRequestParameterKeyRNMessage];
		[notificationDict setObject:@"alert" forKey:DTPushClientRequestParameterKeyRNType];
		[notificationDict setObject:@"ios" forKey:DTPushClientRequestParameterKeyRNTarget];
		[notificationDict setObject:@"Title Text" forKey:DTPushClientRequestParameterKeyRNTitle];
		[notificationDict setObject:@"INAPP_DESTINATION_VIEW_ID" forKey:DTPushClientRequestParameterKeyRNMessageTarget];
		[notificationList addObject:notificationDict];
		
		[mutableParamDic setObject:@"all" forKey:DTPushClientRequestParameterKeyRNReceiver];
		[mutableParamDic setObject:notificationList forKey:DTPushClientRequestParameterKeyRNMessageDictionary];

		//
		// Send request - completion handler is either called during an error 
		// or when the connection fails/finishes
		//
		
		[self 
			providerSendRequestWithParameters:[mutableParamDic copy] 
			writeParamsToBody:YES
			toRessource:DTPushClientBaseProviderRessourceSend
			completionHandler:completionHandler];
	});
}
		
// MARK: 
// MARK: NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// TODO: Think about wrapping this error into a DTPushClientError
	[self executeCompletionHandlerOnMainThread:_completionHandler forError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	self.response = (NSHTTPURLResponse*)response;
	
	DT_LOG(@"PUSH_NOTE_DEBUG", @"Response from provider: \n%@\n%@\nstatusCode: %d", 
			(NSHTTPURLResponse*)response, 
			[(NSHTTPURLResponse*)response allHeaderFields], 
			[(NSHTTPURLResponse*)response statusCode]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	if(!_receivedData)
		_receivedData = [[NSMutableData alloc] init];
		
	[_receivedData appendData:data];
	
	DT_LOG(@"PUSH_NOTE_DEBUG", @"");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{	
	NSInteger statusCode = _response.statusCode;
	NSError * error = nil;
	
	if( statusCode < 200 || statusCode >= 300 ) {
		NSString * recevedDataAsString = [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding];
		error = [[self class] 
				errorWithCode:DTPushClientErrorCodeInvalidResponseStatusCode 
				message:[NSString stringWithFormat:@"Received Message: \"%@\" (Status: %d)", recevedDataAsString, statusCode]];
	}
	[self executeCompletionHandlerOnMainThread:_completionHandler forError:error];
}
		
// MARK: 
// MARK: Private Methods

- (void)executeCompletionHandlerOnMainThread:(DTPushClientOperationCompletionHandler)completionHandler forError:(NSError*)error
{
	dispatch_async(dispatch_get_main_queue(), ^{
		// Sync the completion handler on the main thread
		completionHandler(error);
		
		// Only clean up if the incoming handler is the persisted one
		if( _completionHandler == completionHandler ) {
			self.completionHandler = nil;
			self.connection = nil;
			self.receivedData = nil;
			self.response = nil;
		}
	});
}

- (void)providerSendRequestWithParameters:(NSDictionary*)paramDic writeParamsToBody:(BOOL)writeParamsToBody toRessource:(NSString*)ressource completionHandler:(DTPushClientOperationCompletionHandler)completionHandler
{	
	//
	// Registration process is ongoing at the moment
	// Cancel this 2nd try and call completion handler immediately
	//
	
	if( _completionHandler ) {
		[self executeCompletionHandlerOnMainThread:completionHandler forError:
				[[self class] 
					errorWithCode:DTPushClientErrorCodeOngoingRegistrationProcessInterruption
					message:[NSString stringWithFormat:@"There is already an ongoing registration process. This second try will be cancelled!"]]];
		return;
	}
	
	//
	// Save the completion handler for later execution
	//
	
	self.completionHandler = [completionHandler copy];
	
	//
	// Error checking
	//
	
	if( ![paramDic count] ) {
		[self executeCompletionHandlerOnMainThread:completionHandler forError:
				[[self class] 
					errorWithCode:DTPushClientErrorCodeParameterDictionaryEmpty
					message:[NSString stringWithFormat:@"Parameter dictionary should neither be empty nor nil!\n"]]];
		return;
	}

	if( ![paramDic objectForKey:DTPushClientRequestParameterKeyAppKey] ) {
		[self executeCompletionHandlerOnMainThread:completionHandler forError:
				[[self class] 
					errorWithCode:DTPushClientErrorCodeAppKeyMissing
					message:[NSString stringWithFormat:@"AppKey missing! Set it by populate the parameter dictionary used in the call to the provider!"]]];
		return;
	}

	if( ![ressource length] ) {
		[self executeCompletionHandlerOnMainThread:completionHandler 
				forError:[[self class] 
					errorWithCode:DTPushClientErrorCodeRessourceIdentifierMissing 
					message:[NSString stringWithFormat:@"Ressource identifier is missing or empty!"]]];
		return;
	}
	
	//
	// Populate the parameter dictionary with values common to all requests
	//
	
	NSMutableDictionary * mutableParamDic = [NSMutableDictionary dictionaryWithDictionary:paramDic];
	
	// populate debug mode
	if( self.isDebugMode ) {
		[mutableParamDic setObject:@"einGeschaltet" forKey:DTPushClientRequestParameterKeyDebugMode];
	}
	
	paramDic = [mutableParamDic copy];

	//
	// Add all parameters url encoded to the url
	//
	
	NSMutableString * urlAsString = [[DTPushClientBaseProviderURLAsString stringByAppendingPathComponent:ressource] mutableCopy];
	
	// Generate url parameter if we don't need to write them to the body
	if( !writeParamsToBody ) {
		[urlAsString appendFormat:@"?"];
		
		NSArray * const paramKeys = [paramDic allKeys];
		NSUInteger paramCount = [paramKeys count];
		for (NSUInteger idx = 0; idx < paramCount; idx++) {
			NSString * key = [paramKeys objectAtIndex:idx];
			NSString * value = [paramDic objectForKey:key];
			
			// HACK: appKey needs to be lower case here
			if(  [key isEqualToString:DTPushClientRequestParameterKeyAppKey] ) {
				key = [key lowercaseString];
			}
			
			[urlAsString appendFormat:@"%@=%@", key, [[self class] URLEncodeString:value]];
			
			if( idx < (paramCount - 1) ) {
				[urlAsString appendString:@"&"];
			}
		}
	}
			
	//
	// Generate the request
	//
	
	DT_LOG(@"PUSH_NOTE_DEBUG", @"Resulting URL: %@", urlAsString);
			
	NSURL * url = [NSURL URLWithString:urlAsString];
	
	if( !url ) {
		[self executeCompletionHandlerOnMainThread:completionHandler 
				forError:[[self class] 
					errorWithCode:DTPushClientErrorCodeInvalidURL 
					message:[NSString stringWithFormat:@"Invalid URL: %@", urlAsString]]];
		return;
	}
	
	NSMutableURLRequest * request = [NSMutableURLRequest
			requestWithURL:url
			cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
			timeoutInterval:60.0];
	[request setHTTPMethod:@"POST"];
	
	// Write json structure from the parameters to the body
	if( writeParamsToBody ) {
		NSString * jsonParameter = [[self class] jsonStringForObject:paramDic];
		[request setHTTPBody:[jsonParameter dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	if( !request ) {
		[self executeCompletionHandlerOnMainThread:completionHandler forError:
			[[self class] 
					errorWithCode:DTPushClientErrorCodeInvalidRequest 
					message:[NSString stringWithFormat:@"Invalid Request!"]]];
		return;
	}
	
	//
	// Start the connection
	//
	
	self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
	
	
	// Run the current thread as long the connection is loading
	do {
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
	} while (_connection);
}

- (NSString*)registerUniqueDeviceID
{
	// Register unique device ID
	// This ID is renewed when the user deletes the app and installs it again
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	NSString * uniqueDeviceID = [defaults objectForKey:DTPushClientUniqueDeviceIDDefaultsKey];
	
	if( !uniqueDeviceID ) {
		uniqueDeviceID = [[self class] uniqueDeviceID];
		[defaults setObject:uniqueDeviceID forKey:DTPushClientUniqueDeviceIDDefaultsKey];
	}
	return uniqueDeviceID;
}

+ (NSString*)uniqueDeviceID
{
	CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
	CFStringRef uuidStringRef = CFUUIDCreateString(kCFAllocatorDefault,uuidRef);
	NSString * uuid = [NSString stringWithString:(__bridge NSString *)uuidStringRef];
	CFRelease(uuidRef);
	CFRelease(uuidStringRef);
	return uuid;
}

+ (NSError*)errorWithCode:(NSInteger)code message:(NSString*)message
{
	NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
				message, NSLocalizedDescriptionKey, 
				@"Error", NSLocalizedFailureReasonErrorKey,
				nil];
	return [NSError errorWithDomain:DTPushClientErrorDomain code:code userInfo:userInfo];
}

+ (NSString *)URLEncodeString:(NSString*)string 
{
    if (self == nil)
		return nil;
	CFStringRef preprocessedString = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, 
																							 (__bridge CFStringRef) string, 
																							 CFSTR(""), 
																							 kCFStringEncodingUTF8);
    NSString *result = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           preprocessedString,
                                                                           NULL,
																		   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8);
	CFRelease(preprocessedString);
	return result;	
}

+ (NSString *)jsonStringForObject:(id)object
{
	NSMutableString * result = [[NSMutableString alloc] init];
	
	if( [object isKindOfClass:[NSDictionary class]] ) 
	{
		[result appendString:@"{"];
		NSArray * const allKeys = [object allKeys];
		NSUInteger keysCount = [allKeys count];
		for (NSUInteger i=0; i<keysCount; i++) {
			NSString * key = [allKeys objectAtIndex:i];
			id value = [object objectForKey:key];
			[result appendFormat:@"%@ : %@", [self jsonStringForObject:key], [self jsonStringForObject:value]];
			
			if( i < (keysCount-1) )
				[result appendString:@","];
		}
		[result appendString:@"}"];
	}
	else if( [object isKindOfClass:[NSArray class]] )
	{
		[result appendString:@"["];
		NSUInteger arrayCount = [object count];
		for (NSUInteger i=0; i<arrayCount; i++) {
			id arraySubObj = [object objectAtIndex:i];
			[result appendString:[self jsonStringForObject:arraySubObj]];
			
			if( i < (arrayCount-1) )
				[result appendString:@","];
		}
		[result appendString:@"]"];
	}
	else if( [object isKindOfClass:[NSSet class]] ) {
		NSArray * allObjectsOfSet = [object allObjects];
		[result appendString:[self jsonStringForObject:allObjectsOfSet]];
	}
	else {
		[result appendFormat:@"\"%@\"", object];
	}
	
	return [result copy];
}
		
@end
