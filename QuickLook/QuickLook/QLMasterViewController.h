//
//  QLMasterViewController.h
//  QuickLook
//
//  Created by Stefan Herold on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLAddItemViewController.h"

@interface QLMasterViewController : UITableViewController <
	QLAddItemViewControllerDelegate>
{
	@private
	
	NSMutableArray * urlList;
}

@end
