//
//  QLAddItemViewController.h
//  QuickLook
//
//  Created by Stefan Herold on 11/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QLAddItemViewControllerDelegate;

@interface QLAddItemViewController : UIViewController <UITextFieldDelegate>
{
	IBOutlet UITextField *URLTextField;
}
@property(weak, nonatomic)IBOutlet id<QLAddItemViewControllerDelegate>delegate;

@end


@protocol QLAddItemViewControllerDelegate <NSObject>

@required
- (void)addItemViewController:(QLAddItemViewController *)controller savedItem:(NSString *)urlAsString;
- (void)addItemViewControllerCancelled:(QLAddItemViewController*)controller;

@end
