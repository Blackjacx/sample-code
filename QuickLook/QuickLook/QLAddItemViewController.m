//
//  QLAddItemViewController.m
//  QuickLook
//
//  Created by Stefan Herold on 11/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "QLAddItemViewController.h"

@implementation QLAddItemViewController
@synthesize delegate;

- (void)awakeFromNib {
	[super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
	URLTextField = nil;
	nameTextField = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// MARK: 
// MARK: Actions 

- (IBAction)onCancel:(id)sender {
	if( [self->delegate respondsToSelector:@selector(addItemViewControllerCancelled:)] ) {
		[self->delegate 
				performSelector:@selector(addItemViewControllerCancelled:) 
				withObject:self];
	}
}

- (IBAction)onSave:(id)sender {
	if( [self->delegate respondsToSelector:@selector(addItemViewController:savedItem:)] ) {
		[self->delegate 
				performSelector:@selector(addItemViewController:savedItem:) 
				withObject:self 
				withObject:[self->URLTextField text]];
	}
}

// MARK: 
// MARK: UITextField - Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

@end
