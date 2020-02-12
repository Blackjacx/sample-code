//
//  PCLDynamicTypeLabel.h
//  iOS7DynamicType
//
//  Created by Stefan Herold on 15.08.13.
//  Copyright (c) 2013 Stefan Herold. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCLFonts.h"

@interface PCLDynamicTypeLabel : UILabel

@property(nonatomic, assign)PCLTextStyle textStyle;
@property(nonatomic, weak)id<PCLFontProvider> fontProvider;

- (id)initializationMainWithStyle:(PCLTextStyle)style frame:(CGRect)frame;
- (id)initWithTextStyle:(PCLTextStyle)style;

@end
