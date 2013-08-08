//
//  PCLTableViewDataSource.h
//  Public Code Library
//
//  Created by Stefan Herold on 11.07.13.
//  Copyright (c) 2013 Stefan Herold. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^PCLCellConfigurationBlock)(UITableViewCell* cell, id dataObject);

@interface PCLTableViewDataSource : NSObject <UITableViewDataSource>

- (id)initWithItems:(NSArray*)items
	 cellIdentifier:(NSString*)cellIdentifier
 configureCellBlock:(PCLCellConfigurationBlock)cellConfigurationBlock;

@end