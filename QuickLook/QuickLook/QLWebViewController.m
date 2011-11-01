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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	return [self initWithURLToLoad:[NSURL URLWithString:@"http://www.example.com"]];
}

- (id)initWithURLToLoad:(NSURL*)anUrl {
	self = [super initWithNibName:nil bundle:nil];
    if (self) {
		self.URL = anUrl;
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self->webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
	self->webView.delegate = self;
	[self.view addSubview:self->webView];
	
	NSURLRequest * request = [NSURLRequest requestWithURL:self.URL];
	[self->webView loadRequest:request];
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] 
			initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
			target:self.parentViewController
			action:@selector(dismissModalViewControllerAnimated:)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


// MARK: 
// MARK: UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	UIAlertView * alert = [[UIAlertView alloc] 
				initWithTitle:@"Info"
				message:@"The URL could not be opened. Maybe you have a typo? "
				"Always enter URL's with preceding protocol (http://etc.de)!"
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
