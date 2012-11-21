//
//  ATViewController.m
//  AFNetworkingTest
//
//  Created by Stefan Herold on 11/19/12.
//  Copyright (c) 2012 Blackjacx. All rights reserved.
//

#import "ATViewController.h"

@interface ATViewController ()

@end

@implementation ATViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
	_versionLabel.text = [NSString stringWithFormat:@"version: %@", version];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCrash:(id)sender {

	[NSException raise:@"AppCrashedManuallyException" format:@"You pressed the button to crash..."];
}

@end
