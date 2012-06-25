//
//  DTLogger.m
//  DTLibrary
//
//  Created by Stefan Herold on 2/2/12.
//  Copyright (c) 2012 Deutsche Telekom AG. All rights reserved.
//

#if defined( DEBUG ) && DEBUG != 0
#define DT_LOG( topic, format, ... ) { [DTLogger logFromObject:self method:_cmd logTopic:topic message:[NSString stringWithFormat:format, ##__VA_ARGS__]]; }
#else
#define DT_LOG( topic, format, ... ) {}
#endif
	
@interface DTLogger : NSObject

+ (void)logFromObject:(id const)logger method:(SEL const)selector logTopic:(NSString * const)topic message:(NSString * const)message;
+ (NSString*)logFileContentFrom:(NSDate*)fromDate to:(NSDate*)toDate;
+ (void)deleteLogFiles;

@end
