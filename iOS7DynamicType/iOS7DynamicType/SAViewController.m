//
//  SAViewController.m
//  iOS7DynamicType
//
//  Created by Stefan Herold on 15.08.13.
//  Copyright (c) 2013 Stefan Herold. All rights reserved.
//

#import "SAViewController.h"
#import "PCLDynamicTypeLabel.h"

@interface SAViewController ()
@property (weak, nonatomic) IBOutlet PCLDynamicTypeLabel *label;
@property (strong, nonatomic) id<PCLFontProvider> fontProvider;
@end

@implementation SAViewController

- (void)awakeFromNib
{
	_fontProvider = [[PCLFonts alloc] init];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if(self)
	{
		
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	_label.fontProvider = _fontProvider;
}

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskAll;
}

-(void)updateViewConstraints {
    [super updateViewConstraints];
    _label.preferredMaxLayoutWidth = self.view.bounds.size.width - 2 * _label.frame.origin.x;
}


@end
