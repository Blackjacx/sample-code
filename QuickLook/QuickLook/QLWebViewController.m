//
//  QLWebViewController.m
//  QuickLook
//
//  Created by Stefan Herold on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "QLWebViewController.h"

@implementation QLWebViewController
@synthesize URL;

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

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	NSURLRequest * request = [NSURLRequest requestWithURL:self.URL];
	[self->webView loadRequest:request];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	// Stop webviewloading when view disappears
	[self ->webView stopLoading];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


// MARK: 
// MARK: UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	
	if( error.code == NSURLErrorCancelled ) {
		return;
	}

	NSString * message = [NSString stringWithFormat:@"The URL could not be "
	"opened. Maybe you have a typo? Always enter URL's with preceding protocol "
	"(http://etc.de)!\nError was: %@", error];

	UIAlertView * alert = [[UIAlertView alloc] 
				initWithTitle:@"Info"
				message:message
				delegate:self
				cancelButtonTitle:@"OK" 
				otherButtonTitles:nil];
	[alert show];
}


// MARK: 
// MARK UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

@end
