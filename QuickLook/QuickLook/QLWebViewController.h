//
//  QLWebViewController.h
//  QuickLook
//
//  Created by Stefan Herold on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QLWebViewController : UIViewController <UIWebViewDelegate, UIAlertViewDelegate>
{
	@private
	IBOutlet UIWebView * webView;
}
@property(strong, nonatomic)NSURL * URL;

@end
