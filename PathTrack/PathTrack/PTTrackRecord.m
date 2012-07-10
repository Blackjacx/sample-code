//
//  PTTrackRecord.m
//  PathTrack
//
//  Created by Stefan Herold on 7/10/12.
//  Copyright (c) 2012 Blackjacx. All rights reserved.
//

#import "PTTrackRecord.h"

PCL_DEFINE_KEY(PTTrackRecordNSCodingKeyCLLocationRecordID)
PCL_DEFINE_KEY(PTTrackRecordNSCodingKeyCLLocationObjectList)
PCL_DEFINE_KEY(PTTrackRecordNSCodingKeyRecordName)
PCL_DEFINE_KEY(PTTrackRecordNSCodingKeyCreationDate)

@interface PTTrackRecord ()

@property(nonatomic, copy, readwrite)NSString * recordID;
@property(nonatomic, copy, readwrite)NSArray * CLLocationObjectList;

@end

@implementation PTTrackRecord

// MARK:
// MARK: Initialization

- (id)init {
	self = [super init];
	if( self ) {
		self.recordID = [NSString uniqueID];
		self.CLLocationObjectList = [[NSArray alloc] init];
		self.recordName = [[NSString alloc] init];
		self.creationDate = [[NSDate alloc] init];
	}
	return self;
}

// MARK:
// MARK: Public Accessors

- (void)addLocationObject:(CLLocation*)aLocation {
	
	if( [aLocation isKindOfClass:[CLLocation class]] ) {
		self.CLLocationObjectList = [self.CLLocationObjectList arrayByAddingObject:aLocation];
	}
}

- (void)removeLocationObject:(CLLocation*)aLocation {
	
	NSMutableArray * tmpArray = [self.CLLocationObjectList mutableCopy];
	[tmpArray removeObject:aLocation];
	self.CLLocationObjectList = tmpArray;
}

// MARK:
// MARK: NSCoding Protocol

- (id)initWithCoder:(NSCoder *)aDecoder {
	
	self = [super init];
	
	if( self ) {

		self.recordID = [aDecoder decodeObjectForKey:PTTrackRecordNSCodingKeyCLLocationRecordID];
		self.CLLocationObjectList = [aDecoder decodeObjectForKey:PTTrackRecordNSCodingKeyCLLocationObjectList];
		self.recordName = [aDecoder decodeObjectForKey:PTTrackRecordNSCodingKeyRecordName];
		self.creationDate = [aDecoder decodeObjectForKey:PTTrackRecordNSCodingKeyCreationDate];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	
	[aCoder encodeObject:self.recordID forKey:PTTrackRecordNSCodingKeyCLLocationRecordID];
	[aCoder encodeObject:self.CLLocationObjectList forKey:PTTrackRecordNSCodingKeyCLLocationObjectList];
	[aCoder encodeObject:self.recordName forKey:PTTrackRecordNSCodingKeyRecordName];
	[aCoder encodeObject:self.creationDate forKey:PTTrackRecordNSCodingKeyCreationDate];
}

@end