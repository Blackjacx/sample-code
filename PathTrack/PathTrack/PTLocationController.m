//
//  PTLocationController.m
//  PathTrack
//
//  Created by Stefan Herold on 6/25/12.
//  Copyright (c) 2012 Blackjacx. All rights reserved.
//

#import "PTLocationController.h"

@implementation PTLocationController
{
	CLLocationManager * _locationManager;
	NSDictionary * _locationAccuracyNamesForAccuracies;
	
}

- (id) init
{
    self = [super init];
	
    if ( self ) {
		
		_locationAccuracyNamesForAccuracies = @{
			@(kCLLocationAccuracyBestForNavigation) :
				NSLocalizedString(@"PTLocationControllerAccuracyBestForNavigation", @""),
			@(kCLLocationAccuracyBest) :
				NSLocalizedString(@"PTLocationControllerAccuracyBest", @""),
			@(kCLLocationAccuracyNearestTenMeters) :
				NSLocalizedString(@"PTLocationControllerAccuracyNearestTenMeters", @""),
			@(kCLLocationAccuracyHundredMeters) :
				NSLocalizedString(@"PTLocationControllerAccuracyHundretMeters", @""),
			@(kCLLocationAccuracyKilometer) :
				NSLocalizedString(@"PTLocationControllerAccuracyKilometer", @""),
			@(kCLLocationAccuracyThreeKilometers) :
				NSLocalizedString(@"PTLocationControllerAccuracyThreeKilometers", @"")};
		
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self; // send loc updates to myself
		_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
	SEL selector = @selector(locationController:didUpdateToLocation:fromLocation:);
	if( [self.delegate respondsToSelector:selector] ) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.delegate locationController:self didUpdateToLocation:newLocation fromLocation:oldLocation];
		});
	}
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
	SEL selector = @selector(locationController:didFailWithError:);
	if( [self.delegate respondsToSelector:selector] ) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.delegate locationController:self didFailWithError:error];
		});
	}
}

- (void)startLocationDelivery {
	[_locationManager startUpdatingLocation];
}

- (void)stopLocationDelivery {
	[_locationManager stopUpdatingLocation];
}



- (BOOL)isLocationServiceAvailable {
	BOOL isServiceAvailable = [CLLocationManager locationServicesEnabled];
	BOOL isAppAuthorized = [CLLocationManager authorizationStatus];
	return isServiceAvailable && isAppAuthorized;
}

@end
