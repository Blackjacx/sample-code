//
//  QLMasterViewController.m
//  QuickLook
//
//  Created by Stefan Herold on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "QLMasterViewController.h"
#import "QLWebViewController.h"

static NSString * const defaulsKey = @"jdsghfsduzfgewzrfgjwezfgjefgjhsdg";

@implementation QLMasterViewController
@synthesize textField = _textField;

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

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
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
	id fromObject = [self->urlList objectAtIndex:fromIndexPath.row];
	[self->urlList insertObject:fromObject atIndex:toIndexPath.row];
	[self->urlList removeObjectAtIndex:fromIndexPath.row];
	
	[tableView moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
	
	[[NSUserDefaults standardUserDefaults] setObject:self->urlList forKey:defaulsKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
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
    static NSString *cellIdentifier = @"OCSAddShareEmailTableCell";
    
    UITableViewCell *cell = [atableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OCSAddShareEmailTableCell"];
    }
    
	NSString * urlAsString = [self->urlList objectAtIndex:indexPath.row];
	cell.textLabel.text = urlAsString;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	id fromObject = [self->urlList objectAtIndex:indexPath.row];
	[self->urlList insertObject:fromObject atIndex:0];
	[self->urlList removeObjectAtIndex:indexPath.row];
	
	[tableView moveRowAtIndexPath:indexPath	toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	
	[[NSUserDefaults standardUserDefaults] setObject:self->urlList forKey:defaulsKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	

	NSURL * url = [NSURL URLWithString:[self->urlList objectAtIndex:0]];
	QLWebViewController * webCtrl = [[QLWebViewController alloc] initWithURLToLoad:url];
	UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:webCtrl];
	[self presentModalViewController:navi animated:YES];
}


// MARK: 
// MARK: TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	NSString * textFromTextField = textField.text;
	
	if( [textFromTextField length] ) {
		[self->urlList insertObject:textFromTextField atIndex:0];
		[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
		[textField setText:@""];
		
		[[NSUserDefaults standardUserDefaults] setObject:self->urlList forKey:defaulsKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	
	[textField resignFirstResponder];
	return YES;
}

// MARK: 
// MARK: Actions

- (void)setEditMode:(BOOL)makeEditable {
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
			initWithBarButtonSystemItem:(makeEditable ? UIBarButtonSystemItemDone : UIBarButtonSystemItemEdit)
			target:self 
			action:@selector(switchEditMode:)];
	
	self.tableView.editing = makeEditable;
}

- (IBAction)switchEditMode:(id)sender {
		
	BOOL editing = self.tableView.editing;
	[self setEditMode:!editing];
}

@end
