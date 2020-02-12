//
//  PCLFontProviderProtocol.h
//  iOS7DynamicType
//
//  Created by Stefan Herold on 15.08.13.
//  Copyright (c) 2013 Stefan Herold. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PCLTextStyle)
{
	PCLTextStyleBody,
	PCLTextStyleHeader
};

@protocol PCLFontProvider <NSObject>
- (UIFont*)fontForContentSizeCategory:(NSString*)category textStyle:(PCLTextStyle)style;
@end
