//
//  PTViewController.m
//  PathTrack
//
//  Created by Stefan Herold on 6/25/12.
//  Copyright (c) 2012 Blackjacx. All rights reserved.
//

#import "PTViewController.h"
#import "PTLocationController.h"

@interface PTViewController ()

@end

@implementation PTViewController
{
	PTLocationController * _locationController;
	UILabel * _locationLabel;
	NSMutableArray * _collectedLocationList;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	CGFloat W = self.view.bounds.size.width;
	CGFloat H = self.view.bounds.size.height;
	
	_locationLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
	_locationLabel.numberOfLines = 0;
	[self.view addSubview:_locationLabel];
	
	UIButton * stopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	stopButton.frame = CGRectMake(0, 0, W, 50);
	[stopButton setTitle:NSLocalizedString(@"PTViewControllerStopButtonTitle", @"") forState:UIControlStateNormal];
	[stopButton addTarget:self action:@selector(onStop:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:stopButton];
	
	_collectedLocationList = [[NSMutableArray alloc] init];
	
	_locationController = [[PTLocationController alloc] init];
	_locationController.delegate = self;
	_locationController.powerSavingEnabled = YES;
	[_locationController startLocationDelivery];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
	    return YES;
	}
}

// MARK:
// MARK: Action Handling

- (IBAction)onStop:(id)sender
{
	[_locationController stopLocationDelivery];
	
	// Save collected Location Data
	NSLocale *deLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setLocale:deLocale];
	
	NSString * archiveFileName = [dateFormatter stringFromDate:[NSDate date]];
	NSString * pathToTmpDir = NSTemporaryDirectory();
	NSString * completePath = [pathToTmpDir stringByAppendingPathComponent:archiveFileName];
	
	NSLog(@"FilePath: %@", completePath);
	
	BOOL archiveResult = [NSKeyedArchiver archiveRootObject:_collectedLocationList toFile:completePath];
	NSLog(@"Data Archived: %d", archiveResult);
	
	id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:completePath];
	
	if( ![obj isKindOfClass:[NSArray class]] )
		return;
	
	NSMutableString * stringLocations = [[NSMutableString alloc] init];
	for( CLLocation * location in obj ) {
		@autoreleasepool {
			CLLocationDistance altitude = location.altitude * 3;
			[stringLocations appendFormat:@"\n%.15f,%.15f,%d",
								   location.coordinate.longitude, location.coordinate.latitude, (NSInteger)altitude];
		}
	}
	
	MFMailComposeViewController * composer = [[MFMailComposeViewController alloc] init];
	[composer setSubject:[NSString stringWithFormat:@"New GPS-Track Data Available From: %@", archiveFileName]];
	[composer setMessageBody:stringLocations isHTML:NO];
	[composer setMailComposeDelegate:self];
	[self presentViewController:composer animated:YES completion:NULL];
}

// MARK:
// MARK: Location Controller Delegate

- (void)locationController:(PTLocationController *)controller
	   didUpdateToLocation:(CLLocation *)toLocation
			  fromLocation:(CLLocation *)fromLocation
{
	_locationLabel.text = [NSString stringWithFormat:
						   @"Did Update from Location:\n\n%@\n\nto Location:\n\n%@",
						   fromLocation, toLocation];
	
	[_collectedLocationList addObject:toLocation];
}

- (void)locationController:(PTLocationController *)controller
		  didFailWithError:(NSError *)error
{
	_locationLabel.text = [error description];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	NSLog(@"Eror: %@", error);
	[self dismissViewControllerAnimated:YES completion:NULL];
}

@end
