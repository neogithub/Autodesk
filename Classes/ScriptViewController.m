    //
//  CouponViewController.m
//  PureHockey
//
//  Created by iDev on 10/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ScriptViewController.h"
#import "Reachability.h"
#import "ThePactViewController.h"

@implementation ScriptViewController

@synthesize webView;
@synthesize couponCover;
@synthesize activityIndicator;
@synthesize delegate;

-(IBAction)switchBack {
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft | interfaceOrientation == UIInterfaceOrientationLandscapeRight); 
}


- (void)webViewDidStartLoad:(UIWebView *)webPage
{
	activityIndicator.hidden = NO;
	[activityIndicator startAnimating];


}

- (void)webViewDidFinishLoad:(UIWebView *)webPage {
	[activityIndicator stopAnimating];
	activityIndicator.hidden = YES;
}


-(void)viewDidAppear:(BOOL)animated {
		//[self.view addSubview: activityIndicator];
}

- (void)viewWillAppear:(BOOL)animated {
		//[super viewWillAppear:animated];
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self openCoupon];
	
}

-(void)openCoupon {
	
    //[webView setBackgroundColor:[UIColor blackColor]];
	NSURL *url = [NSURL URLWithString:@"http://www.equityone.net/westbury/"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[[self webView] setDelegate:self];
	[webView loadRequest:request];	
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[webView release];

	[couponCover release];
	[activityIndicator release];
    
}


@end
