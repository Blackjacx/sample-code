//
//  SAViewController.h
//  iOS7TableView
//
//  Created by Stefan Herold on 7/31/13.
//  Copyright (c) 2013 Blackjacx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

/*!
 Simply returns \c YES for positive values and \c NO for negative ones.
 \param arg Integer value that is tested for sign.
 */
- (BOOL)isPositive:(NSInteger)arg;

@end
