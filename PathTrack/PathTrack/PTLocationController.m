//
//  PTLocationController.m
//  PathTrack
//
//  Created by Stefan Herold on 6/25/12.
//  Copyright (c) 2012 Blackjacx. All rights reserved.
//

#import "PTLocationController.h"

//! @brief A constant array containing the available accuracies of CoreLocation.
static NSArray * _locationAccuracies = nil;

@interface PTLocationController ()

@property(nonatomic, strong) CLLocationManager * locationManager;
@property(nonatomic, assign) CLLocationAccuracy accuracyBeforeAppDidEnterBackground;
@property(nonatomic, assign) BOOL locationServiceStarted;

@end

@implementation PTLocationController

// MARK: 
// MARK: Lifecycle

+ (void)initialize {
	
	if( !_locationAccuracies ) {
		
		_locationAccuracies = [[NSArray alloc] initWithObjects:
							   @(kCLLocationAccuracyThreeKilometers),
							   @(kCLLocationAccuracyKilometer),
							   @(kCLLocationAccuracyHundredMeters),
							   @(kCLLocationAccuracyNearestTenMeters),
							   @(kCLLocationAccuracyBest),
							   @(kCLLocationAccuracyBestForNavigation),
							   nil];
	}
}

- (id) init
{
    self = [super init];
	
    if ( self ) {
		
//		self.powerSavingEnabled = NO;
		
		[self createLocationManager];

//		[[NSNotificationCenter defaultCenter] addObserver:self
//												 selector:@selector(applicationDidDidEnterBackground:)
//													 name:UIApplicationDidEnterBackgroundNotification
//												   object:nil];
//		
//		[[NSNotificationCenter defaultCenter] addObserver:self
//												 selector:@selector(applicationWillEnterForeground:)
//													 name:UIApplicationWillEnterForegroundNotification
//												   object:nil];
    }
    return self;
}

- (void)dealloc {
	
	self.delegate = nil;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
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

// MARK: 
// MARK: Application Delegate Notifications

//- (void)applicationDidDidEnterBackground:(NSNotification*)note {
//	
//	NSLog(@"%@", NSStringFromSelector(_cmd));
//	
//	if( self.powerSavingEnabled ) {
//		self.accuracyBeforeAppDidEnterBackground = self.currentAccuracy;
//		[self decreaseAccuracyByValue:1];
//	}
//}

//- (void)applicationWillEnterForeground:(NSNotification*)note {
//	
//	NSLog(@"%@", NSStringFromSelector(_cmd));
//	
//	self.currentAccuracy = self.accuracyBeforeAppDidEnterBackground;
//}

// MARK: 
// MARK: CLLocationManager Delegate

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

// MARK: 
// MARK: Location Controller Interaction

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

- (void)stopAllLocationServices {
	
	[self stopLocationDelivery];
}

// MARK: 
// MARK: Accuracy Management

- (void)decreaseAccuracyByValue:(NSUInteger)aValue {
	NSInteger currentAccuracyIndex = [_locationAccuracies indexOfObject:@(self.currentAccuracy)];
	NSInteger newAccuracyIndex = MAX( 0, currentAccuracyIndex-(NSInteger)aValue );

	if( currentAccuracyIndex != newAccuracyIndex )
		self.currentAccuracy = [[_locationAccuracies objectAtIndex:newAccuracyIndex] doubleValue];
}

- (void)increaseAccuracyByValue:(NSUInteger)aValue {
	NSInteger currentAccuracyIndex = [_locationAccuracies indexOfObject:@(self.currentAccuracy)];
	NSInteger newAccuracyIndex = MIN( [_locationAccuracies count]-1, currentAccuracyIndex+(NSInteger)aValue );
	
	if( currentAccuracyIndex != newAccuracyIndex )
		self.currentAccuracy = [[_locationAccuracies objectAtIndex:newAccuracyIndex] doubleValue];
}

- (NSUInteger)numberOfAccuracies {
	return [_locationAccuracies count];
}

- (NSUInteger)currentAccuracyIndex {
	return [_locationAccuracies indexOfObject:@(self.currentAccuracy)];
}

- (BOOL)isLocationServiceAvailable {
	BOOL isServiceAvailable = [CLLocationManager locationServicesEnabled];
	BOOL isAppAuthorized = [CLLocationManager authorizationStatus];
	return isServiceAvailable && isAppAuthorized;
}

- (NSString *)currentAccuracyAsString {
	return [self stringForAccuracy:self.currentAccuracy];
}


// MARK: 
// MARK: Private

- (NSString *)stringForAccuracy:(CLLocationAccuracy)accuracy {
	if( accuracy == kCLLocationAccuracyBestForNavigation )
		return NSLocalizedString(@"PTLocationControllerAccuracyBestForNavigation", @"");
	else if( accuracy == kCLLocationAccuracyBest )
		return NSLocalizedString(@"PTLocationControllerAccuracyBest", @"");
	else if( accuracy == kCLLocationAccuracyNearestTenMeters )
		return NSLocalizedString(@"PTLocationControllerAccuracyNearestTenMeters", @"");
	else if( accuracy == kCLLocationAccuracyHundredMeters )
		return NSLocalizedString(@"PTLocationControllerAccuracyHundretMeters", @"");
	else if( accuracy == kCLLocationAccuracyKilometer )
		return NSLocalizedString(@"PTLocationControllerAccuracyKilometer", @"");
	else if( accuracy == kCLLocationAccuracyThreeKilometers )
		return NSLocalizedString(@"PTLocationControllerAccuracyThreeKilometers", @"");
	else
		return NSLocalizedString(@"PTLocationControllerAccuracyUnknown", @"");
}

@end
