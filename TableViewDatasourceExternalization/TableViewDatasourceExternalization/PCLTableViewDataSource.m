//
//  PCLTableViewDataSource.m
//  Public Code Library
//
//  Created by Stefan Herold on 11.07.13.
//  Copyright (c) 2013 Stefan Herold. All rights reserved.
//

#import "PCLTableViewDataSource.h"

@interface PCLTableViewDataSource ()
//! An array full with arrays. First layer represents the sections. The second layer the rows.
@property(nonatomic, strong)NSArray * sectionsOfRows;
//! The cell id for all cells of this table view
@property(nonatomic, copy)NSString * cellIdentifier;
//! The block used to configure the cell
@property(nonatomic, strong)PCLCellConfigurationBlock cellConfigurationBlock;
@end

@implementation PCLTableViewDataSource

- (id)initWithItems:(NSArray*)items
	 cellIdentifier:(NSString*)cellIdentifier
 configureCellBlock:(PCLCellConfigurationBlock)cellConfigurationBlock {
	
	if (self = [super  init]) {
		_sectionsOfRows = items;
		_cellIdentifier = cellIdentifier;
		_cellConfigurationBlock = cellConfigurationBlock;
	}
	return self;
}

// MARK: UITableView: DataSource

- (id)itemAtIndexPath:(NSIndexPath*)indexPath {
    return _sectionsOfRows[indexPath.section][indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [_sectionsOfRows count];
}

- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [_sectionsOfRows[section] count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView
		cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    id cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier
                                              forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    _cellConfigurationBlock(cell, item);
    return cell;
}

@end
