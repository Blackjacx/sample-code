//
//  PTFileManager.m
//  PathTrack
//
//  Created by Stefan Herold on 7/10/12.
//  Copyright (c) 2012 Blackjacx. All rights reserved.
//

#import "PTFileManager.h"

@interface PTFileManager ()

// @brief Directory where the data is stored
@property(nonatomic, strong, readwrite)NSString * dataDirectory;

@end

@implementation PTFileManager

- (NSString *)dataDirectory {
	
	if( !_dataDirectory ) {
		_dataDirectory = [[[self class] documentsDirectoryPath] copy];
	}
	return _dataDirectory;
}

- (NSArray *)allSavedTrackRecords {

	NSString * dataDirectory = self.dataDirectory;
	NSError * fileManagerError = nil;
	NSArray * directoryContentNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dataDirectory
																					  error:&fileManagerError];
	NSMutableArray * mutableDirectoryContentPaths = [NSMutableArray arrayWithCapacity:[directoryContentNames count]];
	
	[directoryContentNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		@autoreleasepool {
			NSString * pathWithName = [dataDirectory stringByAppendingPathComponent:obj];
			[mutableDirectoryContentPaths addObject:pathWithName];
		}
	}];
	
	if( !fileManagerError )
		return [mutableDirectoryContentPaths copy];
	
	return nil;
}

// MARK:
// MARK: Private

+ (NSString *)documentsDirectoryPath {
	
	NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString * documentsDirectoryPath = [paths objectAtIndex:0]; // Get documents folder
	return documentsDirectoryPath;
}

+ (NSURL *)documentsDirectoryURL {
	
	NSString * documetsDirectoryPath = [self documentsDirectoryPath];
	return [NSURL fileURLWithPath:documetsDirectoryPath isDirectory:YES];
}

@end
