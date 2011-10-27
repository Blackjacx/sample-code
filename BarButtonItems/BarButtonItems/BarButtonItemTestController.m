//
//  BarButtonItemTestController.m
//  BarButtonItems
//
//  Created by Stefan Herold on 10/27/11.
//  Copyright (c) 2011 Blackjacx & Co. All rights reserved.
//

#import "BarButtonItemTestController.h"

@implementation BarButtonItemTestController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	self.title = @"Bar Button Test";
	self.view.backgroundColor = [UIColor greenColor];
	
	
	
	UIView * customView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)] autorelease];
	customView.backgroundColor = [UIColor redColor];
	
	
	/*
		You can neither influence a bar button item using the appearance 
		protocol (for all instances) nor using the appearance methods of the 
		class (for influencing a single instance) because it is setup with a 
		custom view. 
	 */
	UIBarButtonItem * bbItem = [[[UIBarButtonItem alloc] initWithCustomView:customView] autorelease];
	
	// --- no effect ...
	bbItem.tintColor = [UIColor blackColor];
	
	
	self.navigationItem.leftBarButtonItem = bbItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
