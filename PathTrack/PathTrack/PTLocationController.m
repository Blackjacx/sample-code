//
//  PTLocationController.m
//  PathTrack
//
//  Created by Stefan Herold on 6/25/12.
//  Copyright (c) 2012 Blackjacx. All rights reserved.
//

#import "PTLocationController.h"

@interface PTLocationController ()

@property(nonatomic, strong) CLLocationManager * locationManager;
@property(nonatomic, copy) NSDictionary * locationAccuracyNamesForAccuracies;
@property(nonatomic, assign) BOOL locationServiceStarted;
@property(nonatomic, assign) BOOL significantLocationServiceStarted;

@end

@implementation PTLocationController

- (id) init
{
    self = [super init];
	
    if ( self ) {
		
		self.locationAccuracyNamesForAccuracies = @{
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
		
		self.powerSavingEnabled = NO;
		
		[self createLocationManager];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(applicationDidDidEnterBackground:)
													 name:UIApplicationDidEnterBackgroundNotification
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(applicationWillEnterForeground:)
													 name:UIApplicationWillEnterForegroundNotification
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(applicationDidFinishLaunching:)
													 name:UIApplicationDidFinishLaunchingNotification
												   object:nil];
    }
    return self;
}

- (void)dealloc {
	
	self.delegate = nil;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationDidFinishLaunching:(NSNotification*)note {
	
	NSDictionary * userInfo = note.userInfo;
	
	NSLog(@"%@\nOptions: %@", NSStringFromSelector(_cmd), userInfo);
	
	if( [userInfo objectForKey:UIApplicationLaunchOptionsLocationKey] ) {
		
		BOOL updateServiceStartedBefore = self.locationServiceStarted;
//		BOOL significantUpdateServiceStartedBefore = self.significantLocationServiceStarted;
		
		// Initialize a new location Manager object here
		[self stopAllLocationServices];
		[self createLocationManager];
		
		if( updateServiceStartedBefore ) {
			[self startLocationDelivery];
		}
	}
}

- (void)createLocationManager {
	
	[self stopAllLocationServices];

	// Clean up old manager
	self.locationManager.delegate = nil;
	
	// Initiate new manager
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self; // send loc updates to myself
	
	self.currentAccuracy = kCLLocationAccuracyBest;
}

// MARK:
// MARK: Setter: Accuracy Property

- (void)setCurrentAccuracy:(CLLocationAccuracy)currentAccuracy {

	_currentAccuracy = currentAccuracy;
	self.locationManager.desiredAccuracy = currentAccuracy;
}


- (void)applicationDidDidEnterBackground:(NSNotification*)note {
	
	NSLog(@"%@", NSStringFromSelector(_cmd));
	
	if( self.powerSavingEnabled ) {
		[self stopLocationDelivery];
		[self startSignificantLocationDelivery];
	}
}

- (void)applicationWillEnterForeground:(NSNotification*)note {
	
	NSLog(@"%@", NSStringFromSelector(_cmd));
	[self stopSignificantLocationDelivery];
	[self startLocationDelivery];
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
	if( self.locationServiceStarted == NO ) {
		[self.locationManager startUpdatingLocation];
	}
	self.locationServiceStarted = YES;
}

- (void)stopLocationDelivery {
	if( self.locationServiceStarted == YES ) {
		[self.locationManager stopUpdatingLocation];
	}
	self.locationServiceStarted = NO;
}

- (void)startSignificantLocationDelivery {
	if( self.significantLocationServiceStarted == NO ) {
		[self.locationManager startMonitoringSignificantLocationChanges];
	}
	self.significantLocationServiceStarted = YES;
}

- (void)stopSignificantLocationDelivery {
	if( self.significantLocationServiceStarted == YES ) {
		[self.locationManager stopMonitoringSignificantLocationChanges];
	}
	self.significantLocationServiceStarted = NO;
}

- (void)stopAllLocationServices {
	
	[self stopLocationDelivery];
	[self stopSignificantLocationDelivery];
}

- (BOOL)isLocationServiceAvailable {
	BOOL isServiceAvailable = [CLLocationManager locationServicesEnabled];
	BOOL isAppAuthorized = [CLLocationManager authorizationStatus];
	return isServiceAvailable && isAppAuthorized;
}

@end
