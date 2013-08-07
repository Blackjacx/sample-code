//
//  SAViewController.m
//  iOS7TableView
//
//  Created by Stefan Herold on 7/31/13.
//  Copyright (c) 2013 Blackjacx. All rights reserved.
//

#import "SAViewController.h"

static NSString * const cellID = @"kDefaultCellID";

@interface SAViewController ()

@end

@implementation SAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.title = @"iOS7 Style Table View";

	CGRect bounds = self.view.bounds;

	UITableView * tableView = [[UITableView alloc] initWithFrame:bounds style:UITableViewStylePlain];
	[tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	tableView.contentInset = UIEdgeInsetsMake(63, 0, 0, 0);
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.tag = 100;
	[self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {

	UIView * view = [self.view viewWithTag:100];
	if( [view isKindOfClass:[UITableView class]] ) {
		UITableView * tableView = (UITableView*)view;
		CGFloat contentInsetY = UIInterfaceOrientationIsLandscape(toInterfaceOrientation) ? 51 : 63;
		tableView.contentInset = UIEdgeInsetsMake(contentInsetY, 0, 0, 0);
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	cell.textLabel.text = [NSString stringWithFormat:@"Cell No. %d", indexPath.row];

	return cell;
}

- (BOOL)isPositive:(NSInteger)arg {
	return arg >= 0;
}

@end
