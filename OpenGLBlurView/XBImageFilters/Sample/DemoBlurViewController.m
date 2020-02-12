//
//  DemoBlurViewController.m
//  XBImageFilters
//
//  Created by Stefan Herold on 21.08.13.
//
//

#import "DemoBlurViewController.h"

#import <CoreGraphics/CoreGraphics.h>


@interface DemoBlurViewController ()
@property(nonatomic, strong)UIImageView * imageView;
@property (strong, nonatomic) XBFilteredImageView * draggableFilteredBlurView;
@property (assign, nonatomic) CGFloat firstX;
@property (assign, nonatomic) CGFloat firstY;
@property (assign, nonatomic) CGFloat newX;
@property (assign, nonatomic) CGFloat newY;
@end

@implementation DemoBlurViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UIImage * bgimg = [UIImage imageNamed:@"bgimage"];
	_imageView = [[UIImageView alloc] initWithImage:bgimg];
	_imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_imageView.userInteractionEnabled = YES;
	[self.view addSubview:_imageView];
	
	UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
	[panRecognizer setMinimumNumberOfTouches:1];
	[panRecognizer setMaximumNumberOfTouches:1];
	[panRecognizer setDelegate:self];
	[self.imageView addGestureRecognizer:panRecognizer];
	
	[self recreateDraggableImageView];
}

- (void)recreateDraggableImageView
{
	if( !_draggableFilteredBlurView )
	{
		_draggableFilteredBlurView = [[XBFilteredImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
		_draggableFilteredBlurView.center = self.view.center;
//		_draggableFilteredBlurView.layer.borderColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5].CGColor;
//		_draggableFilteredBlurView.layer.borderWidth = 2;
		_draggableFilteredBlurView.delegate = self;
		_draggableFilteredBlurView.userInteractionEnabled = NO;
		
		[self.view addSubview:_draggableFilteredBlurView];
		
		[self setupBlurFilter];
	}
	
	_draggableFilteredBlurView.image = [self imageFromRect:_draggableFilteredBlurView.frame inView:_imageView];	
}

- (void)setupBlurFilter
{
    NSString *blurFSPath = [[NSBundle mainBundle] pathForResource:@"Blur" ofType:@"fsh"];
    NSString *hBlurVSPath = [[NSBundle mainBundle] pathForResource:@"HBlur" ofType:@"vsh"];
    NSString *vBlurVSPath = [[NSBundle mainBundle] pathForResource:@"VBlur" ofType:@"vsh"];
    
	NSArray *fsPaths = @[blurFSPath, blurFSPath];
    NSArray *vsPaths = @[vBlurVSPath, hBlurVSPath];
    NSError *error = nil;
	
    if(![self.draggableFilteredBlurView setFilterFragmentShaderPaths:fsPaths vertexShaderPaths:vsPaths error:&error])
	{
		NSLog(@"%@", [error localizedDescription]);
	}
	
	CGFloat radius = 0.05;
	[self setRadius:radius];
}

- (void)setRadius:(CGFloat)radius
{
	for (GLKProgram *p in self.draggableFilteredBlurView.programs) {
		[p setValue:&radius forUniformNamed:@"u_radius"];
	}
}

- (IBAction)move:(UIPanGestureRecognizer*)panRecognizer {
	
	CGPoint translatedPoint = [panRecognizer translationInView:_draggableFilteredBlurView];
	
	if([panRecognizer state] == UIGestureRecognizerStateBegan) {
		_firstX = _draggableFilteredBlurView.center.x;
		_firstY = _draggableFilteredBlurView.center.y;
	}
	
	_newX = _firstX;//+translatedPoint.x;
	_newY = _firstY+translatedPoint.y;
	
	
	translatedPoint = CGPointMake(_newX, _newY);
	
	[_draggableFilteredBlurView setCenter:translatedPoint];
	
	[self recreateDraggableImageView];
}

- (UIImage *)imageFromRect:(CGRect)cropRect inView:(UIView*)view {
	
	if( CGRectEqualToRect(CGRectZero, cropRect) || CGRectEqualToRect(CGRectNull, cropRect) )
	{
		cropRect = self.view.bounds;
	}
	
	// Get a UIImage from the UIView
	UIGraphicsBeginImageContext(view.bounds.size);
	[view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage * viewImage = UIGraphicsGetImageFromCurrentImageContext();
	CGImageRef croppedImageRef = CGImageCreateWithImageInRect(viewImage.CGImage, cropRect);
	UIGraphicsEndImageContext();
	
	UIImage * croppedImage = [[UIImage alloc] initWithCGImage:croppedImageRef];
	CGImageRelease(croppedImageRef);
	
	//	UIImageWriteToSavedPhotosAlbum(croppedImage, nil, nil, nil);
	NSLog(@"%zu", CGImageGetHeight(croppedImageRef));
	
	return croppedImage;
}

- (void)filteredView:(XBFilteredView *)filteredView didChangeMainTexture:(GLuint)mainTexture
{
//    [_draggableFilteredBlurView setNeedsLayout];
}

@end
