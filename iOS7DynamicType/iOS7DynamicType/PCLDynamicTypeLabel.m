//
//  PCLDynamicTypeLabel.m
//  iOS7DynamicType
//
//  Created by Stefan Herold on 15.08.13.
//  Copyright (c) 2013 Stefan Herold. All rights reserved.
//

#import "PCLDynamicTypeLabel.h"
#import "PCLFonts.h"

@implementation PCLDynamicTypeLabel

- (id)initializationMainWithStyle:(PCLTextStyle)style frame:(CGRect)frame
{
	if (self)
	{
		NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
		
		if( &UIContentSizeCategoryDidChangeNotification != NULL )
		{
			[center addObserver:self
					   selector:@selector(contentSizeDidChange:)
						   name:UIContentSizeCategoryDidChangeNotification
						 object:nil];
		}
		
		_textStyle = style;
    }
	return self;
}

- (id)initWithTextStyle:(PCLTextStyle)style frame:(CGRect)frame
{
	self = [super initWithFrame:frame];
    return [self initializationMainWithStyle:style frame:frame];
}

- (id)initWithTextStyle:(PCLTextStyle)style
{
    return [self initWithTextStyle:style frame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithTextStyle:PCLTextStyleBody frame:frame];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	return [self initializationMainWithStyle:PCLTextStyleBody frame:CGRectZero];
}

- (id)init
{
	return [self initWithTextStyle:PCLTextStyleBody frame:CGRectZero];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
	[self updateToPreferredFontSize];
}

// MARK: Notification Handling: Content Size Change

- (void)contentSizeDidChange:(NSNotification*)note
{
	UIApplication * sharedApp = [UIApplication sharedApplication];
	NSString * category = nil;
	
	if( [sharedApp respondsToSelector:@selector(preferredContentSizeCategory)] )
	{
		category = sharedApp.preferredContentSizeCategory;
	}
	self.font = [_fontProvider fontForContentSizeCategory:category textStyle:_textStyle];
}

// MARK: Private Methods

- (void)updateToPreferredFontSize
{
	[self contentSizeDidChange:nil];
}

@end
