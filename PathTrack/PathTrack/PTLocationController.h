//
//  PTLocationController.h
//  PathTrack
//
//  Created by Stefan Herold on 6/25/12.
//  Copyright (c) 2012 Blackjacx. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PTLocationControllerDelegate;

@interface PTLocationController : NSObject <CLLocationManagerDelegate>

@property(nonatomic, strong) id<PTLocationControllerDelegate> delegate;
@property(nonatomic, assign) CLLocationAccuracy currentAccuracy;
@property(nonatomic, assign, getter = isPowerSavingEnabled) BOOL powerSavingEnabled;

@property(nonatomic, readonly) NSString * currentAccuracyAsString;

// MARK:
// MARK: Location Controller Interaction

- (void)startLocationDelivery;
- (void)stopLocationDelivery;
- (BOOL)isLocationServiceAvailable;

// MARK:
// MARK: Increasing / Decreasing Accuracy

- (void)decreaseAccuracyByValue:(NSUInteger)aValue;
- (void)increaseAccuracyByValue:(NSUInteger)aValue;
- (NSUInteger)numberOfAccuracies;
- (NSUInteger)currentAccuracyIndex;

@end


@protocol PTLocationControllerDelegate <NSObject>

- (void)locationController:(PTLocationController*)controller didUpdateToLocation:(CLLocation*)toLocation fromLocation:(CLLocation*)fromLocation;
- (void)locationController:(PTLocationController*)controller didFailWithError:(NSError*)error;

@end
