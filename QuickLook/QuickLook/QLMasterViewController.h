//
//  QLMasterViewController.h
//  QuickLook
//
//  Created by Stefan Herold on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QLMasterViewController : UITableViewController <UITextFieldDelegate>
{
	NSMutableArray * urlList;
}
@property(nonatomic, strong)IBOutlet UITextField * textField;

- (void)setEditMode:(BOOL)makeEditable;

@end
