//
//  PTViewController.m
//  PathTrack
//
//  Created by Stefan Herold on 6/25/12.
//  Copyright (c) 2012 Blackjacx. All rights reserved.
//

#import "PTViewController.h"
#import "PTLocationController.h"

PCL_DEFINE_STRING_WITH_AUTO_VALUE(PTViewControllerActionSheetButtonTitleLocalizablaKeyIncreaseAccuracy)
PCL_DEFINE_STRING_WITH_AUTO_VALUE(PTViewControllerActionSheetButtonTitleLocalizablaKeyDecreaseAccuracy)
PCL_DEFINE_STRING_WITH_AUTO_VALUE(PTViewControllerActionSheetButtonTitleLocalizablaKeyStop)
PCL_DEFINE_STRING_WITH_AUTO_VALUE(PTViewControllerActionSheetButtonTitleLocalizablaKeyShowSavedTracks)

@interface PTViewController ()

@property(nonatomic, readonly)NSString * storageDirectory;

@end

@implementation PTViewController
{
	PTLocationController * _locationController;
	UILabel * _locationLabel;
	UILabel * _accuracyLabel;
	NSMutableArray * _collectedLocationList;
	UIActionSheet * _actionSheet;
	UIBarButtonItem * _moreActionButtonItem;
}
@synthesize storageDirectory = _storageDirectory;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	if( self ) {
		
		_collectedLocationList = [[NSMutableArray alloc] init];
		
		_locationController = [[PTLocationController alloc] init];
		_locationController.powerSavingEnabled = YES;
		_locationController.delegate = self;
	}
	return self;
}

- (void)loadView {
	
	CGRect bounds = [[UIScreen mainScreen] bounds];
	CGFloat W = bounds.size.width;
	CGFloat H = bounds.size.height;
	
	UIView * bgView = [[UIView alloc] initWithFrame:bounds];
	bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	bgView.backgroundColor = [[[UIApplication sharedApplication] keyWindow] backgroundColor];
	self.view = bgView;
	
	CGRect accuracyLabelFrame = CGRectMake(0, 0, W, 50);
	_accuracyLabel = [[UILabel alloc] initWithFrame:accuracyLabelFrame];
	_accuracyLabel.backgroundColor = [UIColor greenColor];
	_accuracyLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_accuracyLabel.numberOfLines = 1;
	[self updateAccuracyLabel];
	[bgView addSubview:_accuracyLabel];
	
	CGRect locationLabelFrame = accuracyLabelFrame;
	locationLabelFrame.origin.y = accuracyLabelFrame.size.height;
	locationLabelFrame.size.height = H - locationLabelFrame.origin.y;
	_locationLabel = [[UILabel alloc] initWithFrame:locationLabelFrame];
	_locationLabel.backgroundColor = [UIColor orangeColor];
	_locationLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_locationLabel.numberOfLines = 0;
	[bgView addSubview:_locationLabel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	_moreActionButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
																		  target:self
																		  action:@selector(onMoreActions:)];
	[self.navigationItem setRightBarButtonItem:_moreActionButtonItem];

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
// MARK: Raw Data Handling

- (NSString *)storageDirectory {
	
	if( !_storageDirectory ) {
		_storageDirectory = NSTemporaryDirectory();
	}
	return _storageDirectory;
}

- (NSArray *)allSavedTrackFilePaths {
	
	return nil;
}

// MARK:
// MARK: Action Handling

- (IBAction)onStop:(id)sender
{
	[_locationController stopLocationDelivery];
	
	// Save collected Location Data
	NSLocale * deLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"];
	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setLocale:deLocale];
	
	NSString * archiveFileName = [dateFormatter stringFromDate:[NSDate date]];
	NSString * targetDir = self.storageDirectory;
	NSString * completePath = [targetDir stringByAppendingPathComponent:archiveFileName];
	
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

- (IBAction)onIncreaseAccuracy:(id)sender {
	[_locationController increaseAccuracyByValue:1];
	[self updateAccuracyLabel];
}

- (IBAction)onDecreaseAccuracy:(id)sender {
	[_locationController decreaseAccuracyByValue:1];
	[self updateAccuracyLabel];
}

- (IBAction)onShowSavedTracks:(id)sender {
	
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

// MARK:
// MARK: Action Sheet

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
	
	if( actionSheet.cancelButtonIndex == buttonIndex ) {
		return;
	}
	else if ( [[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(PTViewControllerActionSheetButtonTitleLocalizablaKeyStop, @"")] ) {
		[self onStop:actionSheet];
	}
	else if ( [[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(PTViewControllerActionSheetButtonTitleLocalizablaKeyIncreaseAccuracy, @"")] ) {
		[self onIncreaseAccuracy:actionSheet];
	}
	else if ( [[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(PTViewControllerActionSheetButtonTitleLocalizablaKeyDecreaseAccuracy, @"")] ) {
		[self onDecreaseAccuracy:actionSheet];
	}
	else if ( [[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(PTViewControllerActionSheetButtonTitleLocalizablaKeyShowSavedTracks, @"")] ) {
		[self onShowSavedTracks:actionSheet];
	}
	else {
		NSAssert1(NO, @"Unknown ButtonIndex %i", buttonIndex);
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	
	[self dismissActionSheetAnimated:YES];
}

- (void)displayActionSheet {
	
	if( [_actionSheet isVisible] ) {
		
		[self dismissActionSheetAnimated:YES];
		return;
	}
	
	_actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"PTViewControllerActionSheetTitle", @"")
											   delegate:self
									  cancelButtonTitle:nil
								 destructiveButtonTitle:nil
									  otherButtonTitles:nil];
	
	[_actionSheet addButtonWithTitle:NSLocalizedString(PTViewControllerActionSheetButtonTitleLocalizablaKeyStop, @"")];
	[_actionSheet addButtonWithTitle:NSLocalizedString(PTViewControllerActionSheetButtonTitleLocalizablaKeyIncreaseAccuracy, @"")];
	[_actionSheet addButtonWithTitle:NSLocalizedString(PTViewControllerActionSheetButtonTitleLocalizablaKeyDecreaseAccuracy, @"")];
	[_actionSheet addButtonWithTitle:NSLocalizedString(PTViewControllerActionSheetButtonTitleLocalizablaKeyShowSavedTracks, @"")];
	[_actionSheet setCancelButtonIndex:[_actionSheet addButtonWithTitle:NSLocalizedString(@"PTStringCancel", @"")]];
	
	[_actionSheet showFromBarButtonItem:_moreActionButtonItem animated:YES];
}

- (IBAction)onMoreActions:(id)sender {
	[self displayActionSheet];
}

- (void)dismissActionSheetAnimated:(BOOL)animated {
	
	if( [_actionSheet isVisible] ) {
		[_actionSheet dismissWithClickedButtonIndex:_actionSheet.cancelButtonIndex animated:animated];
	}
	_actionSheet = nil;
}

// MARK:
// MARK: Helper

- (void)updateAccuracyLabel {
	
	_accuracyLabel.text = [NSString stringWithFormat:@"Accuracy: %@", [_locationController currentAccuracyAsString]];
}

@end
