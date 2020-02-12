//
//  PCLFontProvider.m
//  iOS7DynamicType
//
//  Created by Stefan Herold on 15.08.13.
//  Copyright (c) 2013 Stefan Herold. All rights reserved.
//

#import "PCLFonts.h"

@implementation PCLFonts

- (UIFont*)fontForContentSizeCategory:(NSString*)category textStyle:(PCLTextStyle)style
{
	CGFloat styleFontSize = [[self class] fontSizeForTextStyle:style];
	CGFloat categoryDeviation = [[self class] fontSizeDeviationForCategory:category];
	CGFloat fontSize = styleFontSize + categoryDeviation;

	UIFont * font = [UIFont systemFontOfSize:fontSize];
	
	return font;
}

// MARK: Private

+ (CGFloat)fontSizeForTextStyle:(PCLTextStyle)style
{
	CGFloat defaultSize = 12.0f;
	CGFloat headerSize = defaultSize + 6.0f;
	
	switch (style)
	{
		case PCLTextStyleBody:
			return defaultSize;
			
		case PCLTextStyleHeader:
			return headerSize;
	}
	return defaultSize;
}

+ (CGFloat)fontSizeDeviationForCategory:(NSString*)category
{
	static NSDictionary * deviatonsForCategory = nil;
	
	if( &UIContentSizeCategoryLarge != NULL && !deviatonsForCategory )
	{
		deviatonsForCategory = @{UIContentSizeCategoryExtraSmall			: @(-4),
								 UIContentSizeCategorySmall					: @(-2),
								 UIContentSizeCategoryMedium				: @(0),
								 UIContentSizeCategoryLarge					: @(2),
								 UIContentSizeCategoryExtraLarge			: @(4),
								 UIContentSizeCategoryExtraExtraLarge		: @(6),
								 UIContentSizeCategoryExtraExtraExtraLarge	: @(8)};
	}
	return [deviatonsForCategory[category] floatValue];
}

@end
