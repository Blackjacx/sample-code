//
//  STViewController.m
//  iOS7SpeachTest
//
//  Created by Stefan Herold on 23.09.13.
//  Copyright (c) 2013 Deutsche Telekom AG. All rights reserved.
//

#import "STViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface STViewController ()

@end

@implementation STViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	
	AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
	AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"Hello, World!"];
	utterance.rate = AVSpeechUtteranceMinimumSpeechRate; // Tell it to me slowly
	[synthesizer speakUtterance:utterance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
