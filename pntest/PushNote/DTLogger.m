//
//  DTLogger.m
//  DTLibrary
//
//  Created by Stefan Herold on 2/2/12.
//  Copyright (c) 2012 Deutsche Telekom AG. All rights reserved.
//

#import "DTLogger.h"

NSString * const DTDebuggingEnvironmentVariableLogTopics = @"DT_LOG_TOPICS";
NSString * const DTDebuggingLogDateTimeFormat = @"yyyy-MM-dd_hh-mm-ss";
NSString * const DTDebuggingLogFileEntryDelimiter = @"#####_______________________________________________________#####";
NSString * const DTDebuggingLogFileEntryDateDelimiter = @": ";

static NSSet * DTDebuggingLogTopics = nil;
static NSDateFormatter * dateFormatter = nil;

@implementation DTLogger

+ (void)initialize
{
	//
	// Initialise, if not done yet, the set of topics to log.
	//
	
	// --- Obtain environment variables.
	
	NSDictionary * const environment = [[NSProcessInfo processInfo] environment];
	NSString * const logTopicsAsString = [environment objectForKey:
		DTDebuggingEnvironmentVariableLogTopics];
	
	if ( [logTopicsAsString isKindOfClass:[NSString class]] && [logTopicsAsString length] ) 
	{
		// --- Determine log topics.
		
		NSArray * const logTopics = [logTopicsAsString componentsSeparatedByString:@","];
		NSMutableSet * const mutableLogTopicsAsSet = [NSMutableSet set];
		NSCharacterSet * const whitespaceAndNewLineCharacterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
		
		[logTopics enumerateObjectsUsingBlock:^(NSString * logTopic, NSUInteger idx, BOOL * stop){
			[mutableLogTopicsAsSet addObject:[logTopic 
				stringByTrimmingCharactersInSet:whitespaceAndNewLineCharacterSet]];
		}];
		
		DTDebuggingLogTopics = [mutableLogTopicsAsSet copy];
	}
		
	//
	// Initialise the date formatter
	//
	
	dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:DTDebuggingLogDateTimeFormat];
}

+ (NSString*)logFileDirectory
{
	NSString * documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString * logFileDirectoryPath = [documentsDirectory stringByAppendingPathComponent:@"DT_APPLICATION_LOG_FILES"];
	return  logFileDirectoryPath;
}

+ (NSString*)logFilePathWithDate:(NSString*)formattedDate
{
	NSString * timeStamp = [formattedDate length] ? [NSString stringWithFormat:@"-%@", formattedDate] : @"";
	NSString * logFileDirectoryPath = [self logFileDirectory];
	NSString * logFilename = [NSString stringWithFormat:@"log%@.txt", timeStamp];
	NSString * logFilePath = [logFileDirectoryPath stringByAppendingPathComponent:logFilename];
	
	NSError	*error = nil;
	NSFileManager * fileManager = [NSFileManager defaultManager];
	BOOL directoryExists = [fileManager fileExistsAtPath:logFileDirectoryPath];
	BOOL fileExists = [fileManager fileExistsAtPath:logFilePath];
	
	if( !directoryExists && ![fileManager createDirectoryAtPath:logFileDirectoryPath withIntermediateDirectories:YES attributes:nil error:&error] )
	{
		return nil;
	}
	if ( !fileExists && ![fileManager createFileAtPath:logFilePath contents:nil attributes:nil] )
	{
		return nil;
	}

	return logFilePath;
}

+ (void)deleteLogFiles {
	NSFileManager * const fileManager = [NSFileManager defaultManager];
	NSError * error = nil;
	NSString * const directoryPath = [self logFileDirectory];
	
	// Delete the log directory
	[fileManager removeItemAtPath:directoryPath error:&error];
	
	NSAssert(error == nil, @"Deleting log file directory led to error: %@", error);
}

+ (NSString*)logFileContentFrom:(NSDate*)fromDate to:(NSDate*)toDate
{
	__block NSMutableString * result = [[NSMutableString alloc] init];
	NSMutableString * unfilteredResult = [[NSMutableString alloc] init];
	NSFileManager * const fileManager = [NSFileManager defaultManager];
	NSString * const filePath = [self logFilePathWithDate:nil];
	NSError * error = nil;
	NSString * content = nil;
	BOOL isDirectory = YES;
	
	if( [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory] && !isDirectory )
	{
		content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];

		NSAssert(error == nil, @"Reading of log file content led to error: %@", error);
		
		if( !error )
			[unfilteredResult appendString:content];
	}
	
	//
	// Filter result
	//
	
	// Be shure to always set correct filter criteria
	if( !fromDate )
		fromDate = [NSDate dateWithTimeIntervalSince1970:0];
	if( !toDate )
		toDate = [NSDate date];
		
	// Check if fromdate <= todate
	NSAssert([fromDate compare:toDate] == NSOrderedAscending || [fromDate compare:toDate] == NSOrderedSame, 
		@"%@ expected to be the same or later than %@!", toDate, fromDate);

	// Filter the entries by date
	NSArray * const logEntryList = [content componentsSeparatedByString:DTDebuggingLogFileEntryDelimiter];
	[logEntryList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL * stop)
	{
		NSString *  logEntry = obj;
		NSString * sDate = [[logEntry componentsSeparatedByString:DTDebuggingLogFileEntryDateDelimiter] objectAtIndex:0];
		NSDate * date = [dateFormatter dateFromString:sDate];
		
		if( !date )
			return;
		
		NSComparisonResult comparedToFromDate = [date compare:fromDate];
		NSComparisonResult comparedToToDate = [date compare:toDate];
		if( (comparedToFromDate == NSOrderedDescending && comparedToToDate == NSOrderedAscending) || comparedToFromDate == NSOrderedSame )
		{
			[result appendString:logEntry];
		}
	}];
	
	return [result copy];
}

+ (void)logFromObject:(id const)logger method:(SEL const)selector logTopic:(NSString * const)topic message:(NSString * const)message
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), 
	^{
	
		//
		// Log if topic is log topic.
		//

		BOOL topicFound = NO;
		BOOL displaySignature = YES;
		NSString * const topicWithMinus = [topic stringByAppendingString:@"-"];

		if ( [DTDebuggingLogTopics containsObject:@"*-"] || [DTDebuggingLogTopics containsObject:topicWithMinus] )
		{
			// Log all topics without their signature
			topicFound = YES;
			displaySignature = NO;
		}
		else if ( [DTDebuggingLogTopics containsObject:@"*"] || [DTDebuggingLogTopics containsObject:topic] )
		{ 
			// Log all topics with their signature
			topicFound = YES;
		}
		
		if ( topicFound )
		{
			if ( displaySignature )
			{
				NSLog( @"<%@> [%@ %@]: %@\n\n", 
					topic,
					NSStringFromClass( [logger class] ),
					NSStringFromSelector( selector ),
					message );
			}
			else 
			{
				NSLog( @"<%@> %@\n\n", 
					topic,
					message );
			}
		}
		
		//
		// Log to file.
		//
		
		NSString * formattedDate = [dateFormatter stringFromDate:[NSDate date]];
		NSString * logFilePath = [self logFilePathWithDate:nil];
		NSString * log = [NSString stringWithFormat:@"%@: <%@> [%@ %@]%@%@\n%@\n\n", 
			formattedDate,
			topic,
			NSStringFromClass( [logger class] ),
			NSStringFromSelector( selector ),
			DTDebuggingLogFileEntryDateDelimiter,
			message,
			DTDebuggingLogFileEntryDelimiter];
		NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:logFilePath];
		[fileHandler seekToEndOfFile];
		[fileHandler writeData:[log dataUsingEncoding:NSUTF8StringEncoding]];
		[fileHandler closeFile];
	

	});
}

@end