//
//  CouponViewController.h
//  PureHockey
//
//  Created by iDev on 10/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModalViewDelegate;

@class Reachability;

@interface ScriptViewController : UIViewController <UIWebViewDelegate>{
	
	id<ModalViewDelegate> delegate;
	
	IBOutlet UIWebView *webView;
	IBOutlet UIImageView *couponCover;
	UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) id<ModalViewDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIWebView *webView;

@property (nonatomic, retain) IBOutlet UIImageView *couponCover;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

-(void)openCoupon;
-(IBAction)switchBack;

@end
