//
//  PNViewController.m
//  PushNote
//
//  Created by Stefan Herold on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PNViewController.h"
#import "DTLogger.h"
#import "DTPushClient.h"

#define LogWindowTag 999

@interface PNViewController ()
@property(strong, nonatomic)NSTimer * logPollTimer;
@end

@implementation PNViewController
@synthesize logPollTimer = _logPollTimer;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	CGRect textViewFrame = self.view.frame;
	textViewFrame.size.height -= 80;
	UITextView * logWindow = [[UITextView alloc] initWithFrame:textViewFrame];
	logWindow.tag = LogWindowTag;
	[logWindow setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[logWindow setEditable:NO];
	[logWindow setText:[DTLogger logFileContentFrom:nil to:nil]];
	[self.view addSubview:logWindow];
	
	UIButton * actionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[actionButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
	[actionButton setTitle:@"Action" forState:UIControlStateNormal];
	actionButton.frame = CGRectMake(10, textViewFrame.origin.y + textViewFrame.size.height + 10, self.view.frame.size.width - 20, self.view.frame.size.height - (textViewFrame.origin.y + textViewFrame.size.height + 20));
	[actionButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
	[self.view addSubview:actionButton];
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		self.logPollTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(logPollTimerFired:) userInfo:nil repeats:YES];
		
		do {
			[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
		} while (_logPollTimer);
	});
}

- (void)logPollTimerFired:(NSTimer*)timer 
{
	dispatch_async(dispatch_get_main_queue(), ^{
	
		NSString * newText = [DTLogger logFileContentFrom:nil to:nil];
		UITextView * logView = (UITextView*)[self.view viewWithTag:LogWindowTag];
		
		if( ![newText isEqualToString:logView.text] )
		{
			UIView * blendView = [[UIView alloc] initWithFrame:logView.bounds];
			blendView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			blendView.backgroundColor = [UIColor orangeColor];
			blendView.alpha = 1.0;
			[logView addSubview:blendView];
			[UIView animateWithDuration:0.75 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
			{
				blendView.alpha = 0;
			}
			completion:^(BOOL finished)
			{
				[blendView removeFromSuperview];
			}];
			[logView setText:newText];
		}
	});
}

- (IBAction)onAction:(id)sender
{
	UIActionSheet * as = [[UIActionSheet alloc] initWithTitle:@"Select Action" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Delete Log", @"Send RN", nil];
	[as showInView:self.view];
}

- (IBAction)onDeleteLogs:(id)sender
{
	[DTLogger deleteLogFiles];
	[(UITextView*)[self.view viewWithTag:LogWindowTag] setText:nil];
}

- (IBAction)onSend:(id)sender
{
	NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:
		@"testApp",	DTPushClientRequestParameterKeyAppKey,	// An ID for this app (ask the provider for it)
		nil];
		
	[[DTPushClient sharedInstance] sendRemoteNotificationWithParameters:params completionHandler:^(NSError * error)
	{
		if( error )	{
			DT_LOG(@"PUSH_NOTE_DEBUG", @"Failed send RN with error: %@", error);
		}
		else {
			DT_LOG(@"PUSH_NOTE_DEBUG", @"Sending RN Successful!");
		}
	}];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if( buttonIndex == actionSheet.cancelButtonIndex )
		return;
		
	if( [[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Delete Log"] ) {
		[self onDeleteLogs:nil];
	}
	else if( [[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Send RN"] ) {
		[self onSend:nil];
	}
}

- (IBAction)onSendRN:(id)sender
{
	[[DTPushClient sharedInstance] sendRemoteNotificationWithParameters:nil completionHandler:^(NSError* error)
	{
		if( error )	{
			DT_LOG(@"PUSH_NOTE_DEBUG", @"Failed to RN with error: %@", error);
		}
		else {
			DT_LOG(@"PUSH_NOTE_DEBUG", @"Send RN Successful!");
		}
	}];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	
	[self.logPollTimer invalidate];
	self.logPollTimer = nil;
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
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
	    return YES;
	}
}

@end
