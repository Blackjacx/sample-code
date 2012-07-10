//
//  PTTrackRecord.h
//  PathTrack
//
//  Created by Stefan Herold on 7/10/12.
//  Copyright (c) 2012 Blackjacx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTTrackRecord : NSObject <NSCoding>

@property(nonatomic, copy, readonly)NSString * recordID;
@property(nonatomic, copy, readonly)NSArray * CLLocationObjectList;
@property(nonatomic, copy)NSString * recordName;
@property(nonatomic, strong)NSDate * creationDate;

- (void)addLocationObject:(CLLocation*)aLocation;
- (void)removeLocationObject:(CLLocation*)aLocation;

@end
