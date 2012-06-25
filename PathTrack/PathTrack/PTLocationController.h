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

- (void)startLocationDelivery;
- (void)stopLocationDelivery;
- (BOOL)isLocationServiceAvailable;
	
@end


@protocol PTLocationControllerDelegate <NSObject>

- (void)locationController:(PTLocationController*)controller didUpdateToLocation:(CLLocation*)toLocation fromLocation:(CLLocation*)fromLocation;
- (void)locationController:(PTLocationController*)controller didFailWithError:(NSError*)error;

@end
