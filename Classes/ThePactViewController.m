//
//  ThePactViewController.m
//  ThePact
//
//  Created by iDev on 12/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ThePactViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "ScriptViewController.h"
#import "ThePactAppDelegate.h"

#define degreesToRadians(x) (M_PI * x / 180.0)

static NSUInteger kFrameFixer = 1;

@implementation ThePactViewController

//logo image
@synthesize playButton02;
@synthesize playButton03;
@synthesize movieThumb02;
@synthesize movieThumb03;
@synthesize logoImage, url, movieTag;

// photos stack on main menu
@synthesize photoStack, photoThumb;

// logo, blurb
@synthesize blurbLabel;

// web buttons
@synthesize equityWeb, westburyWeb;

@synthesize videoText, photoText, webTextReflection;

// movie controls
@synthesize playButton, movieThumb, movieShadow, delegate, playerViewController, player;
@synthesize movieViewTop, movieViewBottom, movieViewBlack, movieBtns, arr_Timecode;

// wireless indicator view
@synthesize wirelessIndicatorView, progressIndicator;

// leaves
@synthesize leaves, leave01, leave02, leave03, leave04, leave05, leave06, leave07;


-(void)viewWillAppear:(BOOL)animated {
    [UIApplication sharedApplication].statusBarHidden = YES;
}

-(void)viewDidLoad {
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    
//    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGallery)];
//    [tapRecognizer setNumberOfTapsRequired:1];
//    [tapRecognizer setDelegate:self];
//    [photoStack addGestureRecognizer:tapRecognizer];

    // make logo image transparent
    logoImage.alpha = 0.0;
    
    // make black moviethumb transparent
    movieViewBlack.alpha = 0.0;
    
//    // animate, hide the leaves on the left after rotating it off screen
//    leaves.transform = CGAffineTransformMakeRotation(degreesToRadians(90));
//    leaves.transform = CGAffineTransformTranslate(leaves.transform, -300, 250);
//    leaves.alpha = 0.0;
//   [self animateLeaves];
    
    //hide, scale down the photo and movie thumbs
//    photoThumb.transform = CGAffineTransformMakeScale(0.8, 0.8);
//    photoThumb.alpha = 0.0;
//    movieThumb.transform = CGAffineTransformMakeScale(0.8, 0.8);
//    movieThumb.alpha = 0.0;
//    movieShadow.alpha = 0.0;
//    playButton.alpha = 0.0;
//    
//    //web text / button hide
////    webTextReflection.alpha = 0.0;
////    westburyWeb.alpha = 0.0;
//    
//    // hide thumb text
//    photoText.alpha = 0.0;
//    videoText.alpha = 0.0;
    
    // get the individual leaves ready
//    CGAffineTransform transformA = CGAffineTransformMakeRotation(degreesToRadians(90));
//    CGAffineTransform transformB = CGAffineTransformMakeTranslation(-10, -10);
//    leave01.transform = CGAffineTransformConcat(transformA, transformB);
//    leave01.alpha = 0.0;
//    
//    CGAffineTransform transformC = CGAffineTransformMakeRotation(degreesToRadians(90));
//    CGAffineTransform transformD = CGAffineTransformMakeScale(0.8, 0.8);
//    leave02.transform = CGAffineTransformConcat(transformC, transformD);
//    leave02.alpha = 0.0;
//    
//    CGAffineTransform transformE = CGAffineTransformMakeRotation(degreesToRadians(90));
//    CGAffineTransform transformF = CGAffineTransformMakeScale(0.8, 0.8);
//    leave03.transform = CGAffineTransformConcat(transformE, transformF);
//    leave03.alpha = 0.0;
//    
//    CGAffineTransform transformG = CGAffineTransformMakeRotation(degreesToRadians(90));
//    CGAffineTransform transformH = CGAffineTransformMakeScale(0.8, 0.8);
//    leave04.transform = CGAffineTransformConcat(transformG, transformH);
//    leave04.alpha = 0.0;
//    
//    CGAffineTransform transformI = CGAffineTransformMakeRotation(degreesToRadians(90));
//    CGAffineTransform transformJ = CGAffineTransformMakeScale(0.8, 0.8);
//    leave05.transform = CGAffineTransformConcat(transformI, transformJ);
//    leave05.alpha = 0.0;
//    
//    CGAffineTransform transformK = CGAffineTransformMakeRotation(degreesToRadians(90));
//    CGAffineTransform transformL = CGAffineTransformMakeScale(0.8, 0.8);
//    leave06.transform = CGAffineTransformConcat(transformK, transformL);
//    leave06.alpha = 0.0;
//    
//    CGAffineTransform transformM = CGAffineTransformMakeRotation(degreesToRadians(90));
//    CGAffineTransform transformN = CGAffineTransformMakeScale(0.8, 0.8);
//    leave07.transform = CGAffineTransformConcat(transformM, transformN);
//    leave07.alpha = 0.0;
    
    // animate the alpha of the loading image
    //[self performSelector:@selector(fadeImage) withObject:nil afterDelay:0];
    
    // hide wirless view before load - this way I can see it in IB withoiut hiding/unhiding
	// wirelessIndicatorView.hidden = YES;
    
    // now check wireless
    //[self performSelector:@selector(checkWireless) withObject:nil afterDelay:0.5];
	
	[self performSelector:@selector(animateTitle) withObject:nil afterDelay:2.5];

//    UIImage *dividerimg = [UIImage imageNamed:@"aa"];
//    [movieBtns setDividerImage:dividerimg
//                    forLeftSegmentState:UIControlStateNormal
//                    rightSegmentState:UIControlStateNormal
//                    barMetrics:UIBarMetricsDefault];
//    [movieBtns setDividerImage:dividerimg
//                    forLeftSegmentState:UIControlStateSelected
//                    rightSegmentState:UIControlStateNormal
//                    barMetrics:UIBarMetricsDefault];
//    [movieBtns setDividerImage:dividerimg
//                    forLeftSegmentState:UIControlStateNormal
//                    rightSegmentState:UIControlStateSelected
//                    barMetrics:UIBarMetricsDefault];
}

-(void)swipePrevSection:(id)sender {
    NSLog(@"Swipe left");
    if([(UISwipeGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
                                 
        if (movieBtns.selectedSegmentIndex != 0) {
            movieBtns.selectedSegmentIndex--;
			UISegmentedControl *button = (UISegmentedControl *)sender;
			[self movieShouldJump:button];
        } else {
            return;
        }
    }
}

-(void)swipeNextSection:(id)sender {
    NSLog(@"Swipe right");
    if([(UISwipeGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        if (movieBtns.selectedSegmentIndex == 6) {
            return;
        } else {
            NSLog(@"Not Yet");
            movieBtns.selectedSegmentIndex++;
			UISegmentedControl *button = (UISegmentedControl *)sender;
			[self movieShouldJump:button];
        }
    }
}


//-(void)animateLeaves {
//    
//    UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction  | UIViewAnimationOptionCurveEaseInOut;
//    [UIView animateWithDuration:2.00 delay:0.0 options:options 
//                     animations:^{
//                         CGAffineTransform transformA = CGAffineTransformMakeRotation(degreesToRadians(0));
//                         CGAffineTransform transformB = CGAffineTransformMakeScale(1.0, 1.0);
//                         leaves.transform = CGAffineTransformConcat(transformA, transformB);
//                         leaves.alpha = 1.0;
//                         [self performSelector:@selector(animateMovies) withObject:nil afterDelay:1.5];
//                     }
//                     completion:^(BOOL finished) {
//                         
//                     }];
//
//}
//
-(void)animateTitle {
    UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction  | UIViewAnimationOptionCurveEaseInOut;
    [UIView animateWithDuration:0.5 delay:0.0 options:options 
                     animations:^{
                         photoThumb.transform = CGAffineTransformMakeScale(4.05, 4.05);
                         photoThumb.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction  | UIViewAnimationOptionCurveEaseInOut;
                         [UIView animateWithDuration:0.30 delay:0.0 options:options 
                                          animations:^{
//                                              photoThumb.transform = CGAffineTransformMakeScale(1.0, 1.0);
//                                              photoText.alpha = 1.0;
                                          }
                                          completion:^(BOOL finished) {
                                          }];                     
                     }];
}

-(void)animateMovies {
    UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction  | UIViewAnimationOptionCurveEaseInOut;
    [UIView animateWithDuration:0.3 delay:0.0 options:options 
                     animations:^{
                         movieThumb.transform = CGAffineTransformMakeScale(1.05, 1.05);
                         movieThumb.alpha = 1.0;
                         movieShadow.alpha = 1.0;
                         movieShadow.transform = CGAffineTransformMakeScale(1.05, 1.05);
                     }
                     completion:^(BOOL finished) {
                         UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction  | UIViewAnimationOptionCurveEaseInOut;
                         [UIView animateWithDuration:0.30 delay:0.0 options:options 
                                          animations:^{
                                              movieThumb.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                              movieShadow.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                              videoText.alpha = 1.0;
                                              playButton.alpha = 1.0;

											  //  [self performSelector:@selector(animatePhotos)]; 
                                          }
                                          completion:^(BOOL finished) {
                                          }];                     
                     }];
}

//-(void)animateEachLeave {
//    UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction  | UIViewAnimationOptionCurveEaseInOut;
//    [UIView animateWithDuration:0.10 delay:0.0 options:options 
//                     animations:^{
//                         CGAffineTransform transformA = CGAffineTransformMakeRotation(degreesToRadians(-90));
//                         CGAffineTransform transformB = CGAffineTransformMakeScale(1.0, 1.0);
//                         leave01.transform = CGAffineTransformConcat(transformA, transformB);
//                         leave01.alpha = 1.0;
//                     }
//                     completion:^(BOOL finished) {
//                         [self performSelector:@selector(animateEachLeave2)];
//                     }];
//}
//
//-(void)animateEachLeave2 {
//    UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction  | UIViewAnimationOptionCurveEaseInOut;
//    [UIView animateWithDuration:0.10 delay:0.0 options:options 
//                     animations:^{
//                         CGAffineTransform transformA = CGAffineTransformMakeRotation(degreesToRadians(-90));
//                         CGAffineTransform transformB = CGAffineTransformMakeScale(1.0, 1.0);
//                         leave02.transform = CGAffineTransformConcat(transformA, transformB);
//                         leave02.alpha = 1.0;
//                     }
//                     completion:^(BOOL finished) {
//                         [self performSelector:@selector(animateEachLeave3)];
//                     }];  
//}
//
//-(void)animateEachLeave3 {
//    UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction  | UIViewAnimationOptionCurveEaseInOut;
//    [UIView animateWithDuration:0.10 delay:0.0 options:options 
//                     animations:^{
//                         CGAffineTransform transformA = CGAffineTransformMakeRotation(degreesToRadians(-90));
//                         CGAffineTransform transformB = CGAffineTransformMakeScale(1.0, 1.0);
//                         leave03.transform = CGAffineTransformConcat(transformA, transformB);
//                         leave03.alpha = 1.0;
//                     }
//                     completion:^(BOOL finished) {
//                         [self performSelector:@selector(animateEachLeave4)];
//                     }]; 
//}
//
//-(void)animateEachLeave4 {
//    UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction  | UIViewAnimationOptionCurveEaseInOut;
//    [UIView animateWithDuration:0.10 delay:0.0 options:options 
//                     animations:^{
//                         CGAffineTransform transformA = CGAffineTransformMakeRotation(degreesToRadians(-90));
//                         CGAffineTransform transformB = CGAffineTransformMakeScale(1.0, 1.0);
//                         leave04.transform = CGAffineTransformConcat(transformA, transformB);
//                         leave04.alpha = 1.0;
//                     }
//                     completion:^(BOOL finished) {
//                         [self performSelector:@selector(animateEachLeave5)];
//                     }]; 
//}
//
//-(void)animateEachLeave5 {
//    UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction  | UIViewAnimationOptionCurveEaseInOut;
//    [UIView animateWithDuration:0.10 delay:0.0 options:options 
//                     animations:^{
//                         CGAffineTransform transformA = CGAffineTransformMakeRotation(degreesToRadians(-90));
//                         CGAffineTransform transformB = CGAffineTransformMakeScale(1.0, 1.0);
//                         leave05.transform = CGAffineTransformConcat(transformA, transformB);
//                         leave05.alpha = 1.0;
//                     }
//                     completion:^(BOOL finished) {
//                         [self performSelector:@selector(animateEachLeave6)];
//                     }]; 
//}
//
//-(void)animateEachLeave6 {
//    UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction  | UIViewAnimationOptionCurveEaseInOut;
//    [UIView animateWithDuration:0.10 delay:0.0 options:options 
//                     animations:^{
//                         CGAffineTransform transformA = CGAffineTransformMakeRotation(degreesToRadians(-90));
//                         CGAffineTransform transformB = CGAffineTransformMakeScale(1.0, 1.0);
//                         leave06.transform = CGAffineTransformConcat(transformA, transformB);
//                         leave06.alpha = 1.0;
//                     }
//                     completion:^(BOOL finished) {
//                         [self performSelector:@selector(animateEachLeave7)];
//                     }]; 
//}
//
//-(void)animateEachLeave7 {
//    UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction  | UIViewAnimationOptionCurveEaseInOut;
//    [UIView animateWithDuration:0.10 delay:0.0 options:options 
//                     animations:^{
//                         CGAffineTransform transformA = CGAffineTransformMakeRotation(degreesToRadians(-90));
//                         CGAffineTransform transformB = CGAffineTransformMakeScale(1.0, 1.0);
//                         leave07.transform = CGAffineTransformConcat(transformA, transformB);
//                         leave07.alpha = 1.0;
//                     }
//                     completion:^(BOOL finished) {
//                         UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction  | UIViewAnimationOptionCurveEaseInOut;
//                         [UIView animateWithDuration:0.30 delay:0.0 options:options 
//                                          animations:^{
//                                              westburyWeb.transform = CGAffineTransformTranslate(westburyWeb.transform, 0.0, -5.0);
//                                              webTextReflection.alpha = 1.0;
//                                              westburyWeb.alpha = 1.0;
//                                          }
//                                          completion:^(BOOL finished) {
//                                          }]; 
//                     }]; 
//}
//
//
//-(void)checkWireless {
//    ThePactAppDelegate *appDelegate = (ThePactAppDelegate *)[[UIApplication sharedApplication] delegate];
//    
//    NSLog(@"Reading as %@", appDelegate.isWirelessAvailable);
//    
//    if ([appDelegate.isWirelessAvailable isEqualToString:@"NO"]) {
//        NSLog(@"Saying YES");
//        wirelessIndicatorView.hidden = NO;
//        equityWeb.enabled = NO;
//        westburyWeb.enabled = NO;
//    } else {
//        NSLog(@"NO");
//    }
//}

-(void)fadeImage {
    UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction  | UIViewAnimationOptionCurveEaseInOut;
    [UIView animateWithDuration:0.30 delay:0.0 options:options 
                     animations:^{
                         logoImage.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         //movieThumb.alpha = 1.0;                 
                                              }];
}

-(void)outlineMovieThumb {
    // add border to button 01
    CALayer *layer = movieThumb.layer;
    layer.masksToBounds = NO;
    layer.cornerRadius = 0.0;
    layer.borderWidth = 3.0;
    layer.borderColor = [UIColor blueColor].CGColor;
    layer.borderColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(3, 3);
    layer.shadowRadius = 3;
    layer.shadowOpacity = 0.3;
}

//-(void)openCatalogViewer {
//    
//        //UIViewController *vc = [[[CatalogListViewController alloc] init] autorelease];
//        UIViewController *vc = [[[ImageBrowserViewController alloc] initWithImageCatalog:[ImageCatalog catalogNamed:@"foo"]] autorelease];
//        galleryNavigationController = [[UINavigationController alloc] initWithRootViewController:vc];
//        galleryNavigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
//        vc.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissCatalog)] autorelease];
//        
//        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
//    window.backgroundColor = [UIColor colorWithRed:22.0f/255.0f green:22.0f/255.0f blue:22.0f/255.0f alpha:1.0];
//        previousView = [[window.subviews objectAtIndex:0] retain];
//        [UIView transitionFromView:previousView toView:galleryNavigationController.view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
//        }];
//}

//- (void)dismissCatalog {
//    [UIView transitionFromView:galleryNavigationController.view toView:previousView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
//        [previousView release], previousView = nil;
//        [galleryNavigationController release], galleryNavigationController = nil;
//    }];
//}

//-(void)tapGallery {
//    [self openCatalogViewer];
//}

-(void)swipeUpPlay:(id)sender {
    [player play];
    player.controlStyle = MPMovieControlStyleNone;//MPMovieControlModeHidden;
}


-(void)swipeDownPause:(id)sender {

    [player pause];
    player.controlStyle = MPMovieControlStyleNone;//MPMovieControlModeHidden;

}

-(IBAction)playThisMovie:(id)sender {
	
	movieTag = [sender tag];
	NSLog(@"my tag %i", movieTag);
    pinchInRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeNextSection:)];
    [pinchInRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
	[pinchInRecognizer setDelegate:self];
	[self.view addGestureRecognizer:pinchInRecognizer];
    
    swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipePrevSection:)];
    [swipeLeftRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
	[swipeLeftRecognizer setDelegate:self];
	[self.view addGestureRecognizer:swipeLeftRecognizer];
    
    swipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUpPlay:)];
    [swipeUpRecognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [swipeUpRecognizer setDelegate:self];
    [self.view addGestureRecognizer:swipeUpRecognizer];
    
    swipeDownRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownPause:)];
    [swipeDownRecognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [swipeDownRecognizer setDelegate:self];
    [self.view addGestureRecognizer:swipeDownRecognizer];
    

    playButton.hidden = YES;
	playButton02.hidden = YES;
	playButton03.hidden = YES;
    
	url = nil;
	
	if ([sender tag]==0) {
		url = [[NSBundle mainBundle] pathForResource:@"AutodeskBimCityEngineeringAppleTV" ofType:@"m4v"];
	} else if ([sender tag]==1) {
		url = [[NSBundle mainBundle] pathForResource:@"AutodeskBimCityConstructionAppleTV" ofType:@"m4v"];
	} else {
		url = [[NSBundle mainBundle] pathForResource:@"AutodeskBimCityTransportationAppleTV" ofType:@"m4v"];
	}
	
	//NSURL *movieURL = [[NSBundle mainBundle] URLForResource:@"movie" withExtension:@"mp4"];
	
	//url = [[NSBundle mainBundle] URLForResource:@"AutodeskBimCityEngineeringAppleTV" withExtension:@"m4v"];
	
	NSLog(@"%@", url);
	playerViewController = [[MPMoviePlayerViewController alloc]
							initWithContentURL:[NSURL fileURLWithPath:url]];
    
	[[NSNotificationCenter defaultCenter] removeObserver:playerViewController
													name:MPMoviePlayerPlaybackDidFinishNotification
												  object:playerViewController.moviePlayer];
	
		
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidecontrol)
												 name:MPMoviePlayerLoadStateDidChangeNotification
											   object:playerViewController.moviePlayer];

    // Register this class as an observer instead
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(movieFinishedCallback:)
												 name:MPMoviePlayerPlaybackDidFinishNotification
											   object:playerViewController.moviePlayer];
	
//	movieController = [[MPMoviePlayerViewController alloc] 
//														 initWithContentURL:[NSURL fileURLWithPath:url]];
//    
//	
//	movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:url]];
//	
//    // Register to receive a notification when the movie has finished playing. 
//	[[NSNotificationCenter defaultCenter] addObserver:self 
//											 selector:@selector(moviePlayBackDidFinish:) 
//												 name:MPMoviePlayerPlaybackDidFinishNotification 
//											   object:nil];
	
	if (movieTag==0) {
		[self.view bringSubviewToFront:movieThumb];
		movieViewBlack.frame = CGRectMake(26, 180, 314, 180);
	} else if (movieTag==1) {
		[self.view bringSubviewToFront:movieThumb02];
		movieViewBlack.frame = CGRectMake(354, 284, 314, 180);
	} else if (movieTag==2){
		[self.view bringSubviewToFront:movieThumb03];
		movieViewBlack.frame = CGRectMake(682, 284, 314, 180);
	}
	
    UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction  | UIViewAnimationOptionCurveEaseInOut;
    [UIView animateWithDuration:0.5 delay:0.0 options:options 
                     animations:^{
                         
                         movieViewBottom.transform = CGAffineTransformTranslate(movieViewBottom.transform, 0, -110);
                         movieViewTop.transform = CGAffineTransformTranslate(movieViewBottom.transform, 0, +200);
                         
						 if ([sender tag]==0) {
							 movieThumb.frame = CGRectMake(0, 86, 1024, 576);
						 } else if ([sender tag]==1) {
							 movieThumb02.frame = CGRectMake(0, 86, 1024, 576);
						 } else {
							 movieThumb03.frame = CGRectMake(0, 86, 1024, 576);
						 }
						 
					
						 // movieThumb.frame = CGRectMake(0, 86, 1024, 576);
                         movieViewBlack.alpha = 1.0;
                         movieViewBlack.frame = CGRectMake(0, 86, 1024, 576);
						 [self.view bringSubviewToFront: movieViewBlack];
                         movieShadow.alpha = 0.0;
                         
                         movieViewTop.layer.masksToBounds = NO;
                         movieViewTop.layer.cornerRadius = 0;
                         movieViewTop.layer.shadowOffset = CGSizeMake(0,10);
                         movieViewTop.layer.shadowRadius = 5;
                         movieViewTop.layer.shadowOpacity = 0.25;
                         movieViewTop.layer.shadowPath = [UIBezierPath bezierPathWithRect:movieViewTop.bounds].CGPath;

                     }
                     completion:^(BOOL finished) {
                         [self.view insertSubview:playerViewController.view atIndex:25];
                         self.playerViewController.view.frame = CGRectMake(0, 86, 1024, 576);
                         //---play movie---
                         player = [playerViewController moviePlayer];
						 // player.fullscreen = YES;
						 
						 player = [playerViewController moviePlayer];
						 player.repeatMode=MPMovieRepeatModeOne;
						 player.allowsAirPlay = YES;
						 player.controlStyle =  MPMovieControlStyleNone;
                         [player play];
						 //player.controlStyle = MPMovieControlStyleFullscreen;
                     }];
	//player.controlStyle = MPMovieControlStyleFullscreen;

}

- (void)hidecontrol {
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:MPMoviePlayerNowPlayingMovieDidChangeNotification
												  object:playerViewController];
	playerViewController.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)movieFinishedCallback:(NSNotification*)aNotification {
    // Obtain the reason why the movie playback finished
    NSNumber *finishReason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
	// Dismiss the view controller ONLY when the reason is not "playback ended"
    if ([finishReason intValue] != MPMovieFinishReasonPlaybackEnded)
    {
        MPMoviePlayerController *moviePlayer = [aNotification object];
		
        // Remove this class from the observers
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:moviePlayer];
        // Dismiss the view controller
        //[self dismissModalViewControllerAnimated:YES];
		UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction  | UIViewAnimationOptionCurveEaseInOut;
		[UIView animateWithDuration:0.50 delay:0.0 options:options 
						 animations:^{
							 movieBtns.selectedSegmentIndex = 0;
							 
							 movieThumb.frame = CGRectMake(26, 284, 314, 180);
							 movieThumb02.frame = CGRectMake(354, 284, 314, 180);
							 movieThumb03.frame = CGRectMake(682, 284, 314, 180);

							 if (movieTag==0) {
								 movieViewBlack.frame = CGRectMake(26, 284, 314, 180);
							 } else if (movieTag==1) {
								 movieViewBlack.frame = CGRectMake(354, 284, 314, 180);
							 } else if (movieTag==2){
								 movieViewBlack.frame = CGRectMake(682, 284, 314, 180);
							 }
							 movieViewBlack.alpha = 0.0;
							 movieShadow.alpha = 1.0;
							 self.playerViewController.view.frame = CGRectMake(0, 86, 1024, 576);
							 movieViewBottom.transform = CGAffineTransformIdentity;
							 movieViewTop.transform = CGAffineTransformIdentity;
							 
							 [player.view removeFromSuperview];
							 [self.view bringSubviewToFront:playButton03];
							 [self.view bringSubviewToFront:playButton02];
							 [self.view bringSubviewToFront:playButton];
							 
						 }
						 completion:^(BOOL finished) {
							 [player stop];
							 //[player release];
							 playButton.hidden = NO;
							 playButton02.hidden = NO;
							 playButton03.hidden = NO;

							 movieViewTop.layer.cornerRadius = 0;
							 movieViewTop.layer.shadowOffset = CGSizeMake(0,0);
							 movieViewTop.layer.shadowRadius = 0;
							 movieViewTop.layer.shadowOpacity = 0.0;
							 
							 //kill swipe gestures
							 pinchInRecognizer.enabled = NO;
							 pinchInRecognizer.delegate = nil;
							 swipeLeftRecognizer.enabled = NO;
							 swipeLeftRecognizer.delegate = nil;
							 swipeUpRecognizer.enabled = NO;
							 swipeUpRecognizer.delegate = nil;
							 swipeDownRecognizer.enabled = NO;
							 swipeDownRecognizer.delegate = nil;
						 }];

    }
}

/*---------------------------------------------------------------------------
 * 
 *--------------------------------------------------------------------------*/
//- (void) moviePlayBackDidFinish:(NSNotification*)notification 
//{    	
//    // Remove observer
//	[[NSNotificationCenter 	defaultCenter] 
//	 removeObserver:self
//	 name:MPMoviePlayerPlaybackDidFinishNotification 
//	 object:nil];
//    
//    UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction  | UIViewAnimationOptionCurveEaseInOut;
//    [UIView animateWithDuration:0.50 delay:0.0 options:options 
//                     animations:^{
//                         movieBtns.selectedSegmentIndex = 0;
//
//                         movieThumb.frame = CGRectMake(56, 318, 436, 246);
//                         movieViewBlack.frame = CGRectMake(56, 318, 436, 246);
//                         movieViewBlack.alpha = 0.0;
//                         movieShadow.alpha = 1.0;
//                         self.movieController.view.frame = CGRectMake(0, 86, 1024, 576);
//                         movieViewBottom.transform = CGAffineTransformIdentity;
//                         movieViewTop.transform = CGAffineTransformIdentity;
//
//                         [player.view removeFromSuperview];
//
//                     }
//                     completion:^(BOOL finished) {
//                         [player stop];
//                         //[player release];
//                         playButton.hidden = NO;
//                         movieViewTop.layer.cornerRadius = 0;
//                         movieViewTop.layer.shadowOffset = CGSizeMake(0,0);
//                         movieViewTop.layer.shadowRadius = 0;
//                         movieViewTop.layer.shadowOpacity = 0.0;
//                         
//                         //kill swipe gestures
//                         pinchInRecognizer.enabled = NO;
//                         pinchInRecognizer.delegate = nil;
//                         swipeLeftRecognizer.enabled = NO;
//                         swipeLeftRecognizer.delegate = nil;
//                         swipeUpRecognizer.enabled = NO;
//                         swipeUpRecognizer.delegate = nil;
//                         swipeDownRecognizer.enabled = NO;
//                         swipeDownRecognizer.delegate = nil;
//                     }];
//}

-(IBAction)movieStop {
    [player stop];
}

-(IBAction)movieShouldJump:(id)sender {
    // Remove observer
	[[NSNotificationCenter defaultCenter] removeObserver:playerViewController
													name:MPMoviePlayerPlaybackDidFinishNotification
												  object:playerViewController.moviePlayer];
    
    NSUInteger i = movieBtns.selectedSegmentIndex;
    
    [playerViewController.moviePlayer pause];
    
    arr_Timecode = [[NSArray alloc] initWithObjects:
                    [NSNumber numberWithFloat:0], //intro
                    [NSNumber numberWithFloat:50+kFrameFixer], //map
                    [NSNumber numberWithFloat:61+kFrameFixer], // cont - OK
                    [NSNumber numberWithFloat:92+kFrameFixer], //2 level
                    [NSNumber numberWithFloat:128+kFrameFixer], //glass
//                    [NSNumber numberWithFloat:59+kFrameFixer], // gallery
//                    [NSNumber numberWithFloat:63], // plaza
//                    [NSNumber numberWithFloat:78+kFrameFixer], // aerial
                 nil];
    
   NSString *myString = [arr_Timecode objectAtIndex:i];
   float stringfloat = [myString floatValue];
    
    //player.initialPlaybackTime = 63.0;
	player.currentPlaybackTime = stringfloat;

    
    [playerViewController.moviePlayer play];
	 [playerViewController.moviePlayer pause];
    NSLog(@"jump time should be %f", stringfloat);
    // Register to receive a notification when the movie has finished playing. 
    // Register this class as an observer instead
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(movieFinishedCallback:)
												 name:MPMoviePlayerPlaybackDidFinishNotification
											   object:playerViewController.moviePlayer];
}

	///////////////////
	// Load Web nib //
	///////////////////
	//when the web button is pressed load it

//-(IBAction)viewWeb:(id)sender {
//
//        ScriptViewController *screen1 = [[ScriptViewController alloc] initWithNibName:@"Script" bundle:nil];
//        screen1.delegate = self;
//		screen1.modalTransitionStyle =  UIModalTransitionStyleCoverVertical;
//		[self presentModalViewController:screen1 animated:YES];
//		[screen1 release];
//}

-(void)dismissModal {
	[self dismissModalViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated {
}

-(void)didReceiveMessage:(NSString *)message {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	[self setPlayButton03:nil];
	[self setPlayButton02:nil];
	[self setMovieThumb03:nil];
	[self setMovieThumb02:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft | interfaceOrientation == UIInterfaceOrientationLandscapeRight); 
}

- (void)dealloc {
    [logoImage release];
    [photoStack release];
    [blurbLabel release];
    [equityWeb release];
    [westburyWeb release];
    [playButton release];
    [movieThumb release];
    [logoImage release];
    [photoStack release];
    [photoThumb release];
    [blurbLabel release];
    [equityWeb release];
    [westburyWeb release];
    [playButton release];
    [movieThumb release];
    [movieShadow release];
    [leaves release];
    [leave01 release];
    [leave02 release];
    [leave03 release];
    [leave04 release];
    [leave05 release];
    [leave06 release];
    [leave07 release];
    [videoText release];
    [photoText release];
    [webTextReflection release];
    [wirelessIndicatorView release];
    [movieViewTop release];
    [movieViewBottom release];
    [movieViewBlack release];
    [movieBtns release];
    [arr_Timecode release];
    [playerViewController release];
    [player release];
    [progressIndicator release];
	[movieThumb02 release];
	[movieThumb03 release];
	[playButton02 release];
	[playButton03 release];
	[super dealloc];
}

@end
