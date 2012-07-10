//
//  PTViewController.m
//  PathTrack
//
//  Created by Stefan Herold on 6/25/12.
//  Copyright (c) 2012 Blackjacx. All rights reserved.
//

#import "PTViewController.h"
#import "PTLocationController.h"
#import "PTFileManager.h"
#import "PTTrackRecord.h"

PCL_DEFINE_STRING_WITH_AUTO_VALUE(PTViewControllerActionSheetButtonTitleLocalizablaKeyIncreaseAccuracy)
PCL_DEFINE_STRING_WITH_AUTO_VALUE(PTViewControllerActionSheetButtonTitleLocalizablaKeyDecreaseAccuracy)
PCL_DEFINE_STRING_WITH_AUTO_VALUE(PTViewControllerActionSheetButtonTitleLocalizablaKeyStop)
PCL_DEFINE_STRING_WITH_AUTO_VALUE(PTViewControllerActionSheetButtonTitleLocalizablaKeyShowSavedTracks)

@interface PTViewController ()

@property(nonatomic, strong)PTFileManager * fileManager;
@property(nonatomic, strong)PTLocationController * locationController;
@property(nonatomic, strong)PTTrackRecord * trackRecord;

@end

@implementation PTViewController
{
	UILabel * _locationLabel;
	UILabel * _accuracyLabel;
	UIActionSheet * _actionSheet;
	UIBarButtonItem * _moreActionButtonItem;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	if( self ) {
		
		self.trackRecord = [[PTTrackRecord alloc] init];
		
		self.locationController = [[PTLocationController alloc] init];
//		_locationController.powerSavingEnabled = YES;
		_locationController.delegate = self;
		
		self.fileManager = [[PTFileManager alloc] init];
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
	
	UIStepper * accuracyModifierCtrl = [[UIStepper alloc] initWithFrame:CGRectZero];
	accuracyModifierCtrl.continuous = NO;
	accuracyModifierCtrl.minimumValue = 0;
	accuracyModifierCtrl.maximumValue = [self.locationController numberOfAccuracies]-1;
	accuracyModifierCtrl.value = [self.locationController currentAccuracyIndex];
	UIBarButtonItem * accuracyModifierBarItem = [[UIBarButtonItem alloc] initWithCustomView:accuracyModifierCtrl];
	[self.navigationItem setLeftBarButtonItem:accuracyModifierBarItem];
	
	[accuracyModifierCtrl addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];

	[self.locationController startLocationDelivery];
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
	[self.locationController stopLocationDelivery];
	
	// Save collected Location Data
	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];
	
	NSString * archiveFileName = [dateFormatter stringFromDate:self.trackRecord.creationDate];
	NSString * dataDir = self.fileManager.dataDirectory;
	NSString * completePath = [dataDir stringByAppendingPathComponent:archiveFileName];
	
	NSLog(@"FilePath: %@", completePath);
	
	BOOL archiveResult = [NSKeyedArchiver archiveRootObject:self.trackRecord toFile:completePath];
	NSLog(@"Data Archived: %d", archiveResult);
	
	id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:completePath];
	
	if( ![obj isKindOfClass:[PTTrackRecord class]] )
		return;
	
	PTTrackRecord * unarchivedRecord = (PTTrackRecord*)obj;
	
	NSMutableString * stringLocations = [[NSMutableString alloc] init];
	for( CLLocation * location in unarchivedRecord.CLLocationObjectList ) {
		@autoreleasepool {
			CLLocationDistance altitude = location.altitude * 3;
			[stringLocations appendFormat:@"\n%.15f,%.15f,%d",
								   location.coordinate.longitude, location.coordinate.latitude, (NSInteger)altitude];
		}
	}
	
	MFMailComposeViewController * composer = [[MFMailComposeViewController alloc] init];
	[composer setSubject:[NSString stringWithFormat:@"New GPS-Track Data Available From: %@", unarchivedRecord.creationDate]];
	[composer setMessageBody:stringLocations isHTML:NO];
	[composer setMailComposeDelegate:self];
	[self presentViewController:composer animated:YES completion:NULL];
}

- (IBAction)onIncreaseAccuracy:(id)sender {
	[self.locationController increaseAccuracyByValue:1];
	[self updateAccuracyLabel];
}

- (IBAction)onDecreaseAccuracy:(id)sender {
	[self.locationController decreaseAccuracyByValue:1];
	[self updateAccuracyLabel];
}

- (IBAction)onShowSavedTracks:(id)sender {
	__block NSString * message = @"";
	
	[[self.fileManager allSavedTrackRecords] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if( idx == 0 )
			message = [message stringByAppendingFormat:@"%@", [obj lastPathComponent]];
		else
			message = [message stringByAppendingFormat:@"\n%@", [obj lastPathComponent]];
	}];
	[[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	
	if( [object isKindOfClass:[UIStepper class]] ) {
		NSUInteger oldValue = (NSUInteger)[[change objectForKey:NSKeyValueChangeOldKey] doubleValue];
		NSUInteger newValue = (NSUInteger)[[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
		
		if( newValue > oldValue ) {
			[self.locationController increaseAccuracyByValue:1];
		}
		else if( newValue < oldValue ) {
			[self.locationController decreaseAccuracyByValue:1];
		}
		[self updateAccuracyLabel];
	}
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
	
	[self.trackRecord addLocationObject:toLocation];
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
	
	_accuracyLabel.text = [NSString stringWithFormat:@"Accuracy: %@", [self.locationController currentAccuracyAsString]];
}

@end
