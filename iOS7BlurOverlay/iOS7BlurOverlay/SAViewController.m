//
//  SAViewController.m
//  iOS7BlurOverlay
//
//  Created by Stefan Herold on 8/2/13.
//  Copyright (c) 2013 Blackjacx. All rights reserved.
//

#import "SAViewController.h"

@import CoreImage;

@interface SAViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (strong, nonatomic) UIImageView * draggableBlurView;
@property (assign, nonatomic) CGFloat firstX;
@property (assign, nonatomic) CGFloat firstY;

@end

@implementation SAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	_draggableBlurView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
	_draggableBlurView.center = self.view.center;
	_draggableBlurView.layer.borderColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5].CGColor;
	_draggableBlurView.layer.borderWidth = 2;
	_draggableBlurView.userInteractionEnabled = YES;
	[self.view addSubview:_draggableBlurView];

	UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    [_draggableBlurView addGestureRecognizer:panRecognizer];
}

- (IBAction)move:(UIPanGestureRecognizer*)panRecognizer {

	CGPoint translatedPoint = [panRecognizer translationInView:_draggableBlurView];

	if([panRecognizer state] == UIGestureRecognizerStateBegan) {
		_firstX = _draggableBlurView.center.x;
		_firstY = _draggableBlurView.center.y;
	}

	translatedPoint = CGPointMake(_firstX/*+translatedPoint.x*/, _firstY+translatedPoint.y);

	[_draggableBlurView setCenter:translatedPoint];



	UIImage * blurredImage = [self blurredImageOfArea:_draggableBlurView.frame
											   inView:self.backgroundImageView];

	_draggableBlurView.image = blurredImage;
}

- (UIImage *)blurredImageOfArea:(CGRect)blurArea inView:(UIView*)view {

	if( CGRectEqualToRect(CGRectZero, blurArea) || CGRectEqualToRect(CGRectNull, blurArea) ) {
		blurArea = self.view.bounds;
	}

	// Get a UIImage from the UIView
	UIGraphicsBeginImageContext(view.bounds.size);
	[view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage * viewImage = UIGraphicsGetImageFromCurrentImageContext();
	CGImageRef croppedImage = CGImageCreateWithImageInRect(viewImage.CGImage, blurArea);
	UIGraphicsEndImageContext();

	// Blur the UIImage
	CIImage *imageToBlur = [CIImage imageWithCGImage:croppedImage];
	CIFilter * gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
	[gaussianBlurFilter setValue:imageToBlur forKey:kCIInputImageKey];
	[gaussianBlurFilter setValue:[NSNumber numberWithFloat:10] forKey:kCIInputRadiusKey];
	CIImage *resultImage = [gaussianBlurFilter valueForKey:kCIOutputImageKey];

	CIContext * ciContext = [CIContext contextWithOptions:nil];
	CGImageRef croppedEndImageRef = [ciContext createCGImage:resultImage fromRect:[imageToBlur extent]];
	UIImage *croppedEndImage = [[UIImage alloc] initWithCGImage:croppedEndImageRef];

	return croppedEndImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
