//
//  SHViewController.m
//  TableViewDatasourceExternalization
//
//  Created by Stefan Herold on 11.07.13.
//  Copyright (c) 2013 Stefan Herold. All rights reserved.
//

#import "SHViewController.h"
#import "PCLTableViewDataSource.h"

@interface SHViewController ()
@property(nonatomic, strong)PCLTableViewDataSource * tableViewDataSource;
@end

@implementation SHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	NSString * cellIdentifier = @"cellIdentifier";
	NSArray * items = @[@[@"Hello World 0.0"], @[@"Hello World 1.0", @"Hello World 1.1"], @[@"Hello World 2.0", @"Hello World 2.1", @"Hello World 2.2"]];
	
	PCLCellConfigurationBlock block = ^(UITableViewCell * cell, NSString * dataObject) {
		cell.textLabel.text = dataObject;
	};
	
	_tableViewDataSource = [[PCLTableViewDataSource alloc] initWithItems:items
														  cellIdentifier:cellIdentifier
													  configureCellBlock:block];
	
	UITableView * tv = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	[tv registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
	tv.dataSource = _tableViewDataSource;
	tv.delegate = self;
	[self.view addSubview:tv];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
