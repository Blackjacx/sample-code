//
//  QLMasterViewController.m
//  QuickLook
//
//  Created by Stefan Herold on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "QLMasterViewController.h"
#import "QLWebViewController.h"

static NSString * const defaulsKey = @"QLMasterViewControllerURLListDefaultsKey";

@interface QLMasterViewController()

- (void)setEditMode:(BOOL)makeEditable;
- (BOOL)moveURLInListFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

@end

@implementation QLMasterViewController

- (BOOL)moveURLInListFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
	@try {
		id objectToMove = [self->urlList objectAtIndex:fromIndex];
		[self->urlList removeObjectAtIndex:fromIndex];
		[self->urlList insertObject:objectToMove atIndex:toIndex];
	}
	@catch (NSException *exception) {
		return NO;
	}	
	return YES;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
	
	self->urlList = [[[NSUserDefaults standardUserDefaults] arrayForKey:defaulsKey] mutableCopy];
	
	if( !self->urlList ) {
		self->urlList = [[NSMutableArray alloc] initWithObjects:
			@"http://www.google.com",
			@"http://www.telekom.de",
			@"http://www.apple.com",
			nil];
	}
		
	[self setEditMode:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		[self->urlList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
	
	[[NSUserDefaults standardUserDefaults] setObject:self->urlList forKey:defaulsKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
	[tableView moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
	[self moveURLInListFromIndex:fromIndexPath.row toIndex:toIndexPath.row];
	
	[[NSUserDefaults standardUserDefaults] setObject:self->urlList forKey:defaulsKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return (NSInteger)[self->urlList count];
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CELL_ID_REUSE";

    UITableViewCell *cell = [atableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
	NSString * urlAsString = [self->urlList objectAtIndex:indexPath.row];
	cell.textLabel.text = urlAsString;
	
    return cell;
}

// MARK: 
// MARK: Add Items

- (BOOL)addItemAndUpdateDefaults:(NSString *)urlAsString {

	if( [urlAsString length] ) {
		[self->urlList insertObject:urlAsString atIndex:0];
		[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
		
		[[NSUserDefaults standardUserDefaults] setObject:self->urlList forKey:defaulsKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
		return YES;
	}
	return NO;
}

// MARK: 
// MARK: Actions

- (void)setEditMode:(BOOL)makeEditable {
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] 
			initWithBarButtonSystemItem:(makeEditable ? UIBarButtonSystemItemDone : UIBarButtonSystemItemEdit)
			target:self 
			action:@selector(switchEditMode:)];
	
	[self.tableView setEditing:makeEditable animated:YES];
}

- (IBAction)switchEditMode:(id)sender {
		
	BOOL editing = self.tableView.editing;
	[self setEditMode:!editing];
}

// MARK: 
// MARK: Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	NSString * const segueID = segue.identifier;
	
	if( [segueID isEqualToString:@"SeguePushFromTableCell"] ) {
	
		UITableViewCell * cell = (UITableViewCell*)sender;
		NSIndexPath * fromIndexPath = [self.tableView indexPathForCell:cell];
		NSIndexPath * toIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];

		// --- Send data to the destination controller
		
		QLWebViewController * webviewController = (QLWebViewController*)segue.destinationViewController;
		NSString * urlAsString = [self->urlList objectAtIndex:fromIndexPath.row];
		webviewController.URL = [NSURL URLWithString:urlAsString];
		
		// --- Move the cell to the top and update data source
		
		[self.tableView moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
		[self moveURLInListFromIndex:fromIndexPath.row toIndex:toIndexPath.row];
	}
	else if( [segueID isEqualToString:@"SegueModalFromAdd"] ) {

		UINavigationController * navController = 
				(UINavigationController*)segue.destinationViewController;
		
		QLAddItemViewController * addItemViewController = 
				(QLAddItemViewController*)[[navController viewControllers] objectAtIndex:0];
				
		addItemViewController.delegate = self;
	}
}

// MARK: 
// MARK: QLAddItemViewController - Delegate

- (void)addItemViewControllerCancelled:(QLAddItemViewController *)controller {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)addItemViewController:(QLAddItemViewController *)controller savedItem:(NSString *)urlAsString {
	if( [self addItemAndUpdateDefaults:urlAsString] ) {
		[self dismissModalViewControllerAnimated:YES];
	}
}

@end
