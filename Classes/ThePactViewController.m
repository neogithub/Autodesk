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
{
    UIButton                        *uib_closeProfile;
    UIButton                        *uib_closeMainPlayer;
    UIView                          *uiv_profileContainer;
    UIButton                        *uib_userProfile;
    UIImageView                     *uiiv_profileDetail;
    UIView                          *uiv_detailVideoContainer;
    AVPlayer                        *profilePlayer;
    AVPlayerLayer                   *profilePlayerLayer;
    AVPlayerItem                    *profileItem;
    UITapGestureRecognizer          *tapDetailVideo;
    UISlider                        *uisl_timerBar;
    UISlider                        *uisl_profileTimeBar;
    NSTimer                         *sliederTimer;
    UISwipeGestureRecognizer        *swipeProfileMovieUp;
    UISwipeGestureRecognizer        *swipeProfileMovieDown;
}
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
@synthesize playButton, movieThumb, movieShadow, delegate;
@synthesize movieViewTop, movieViewBottom, movieViewBlack, movieBtns, arr_Timecode;

// wireless indicator view
@synthesize wirelessIndicatorView, progressIndicator;

// leaves
@synthesize leaves, leave01, leave02, leave03, leave04, leave05, leave06, leave07;

// AVPlayer
@synthesize uiv_myPlayerContainer;
@synthesize myAVPlayer;
@synthesize myAVPlayerLayer;
@synthesize playerItem;

-(void)viewWillAppear:(BOOL)animated {
    [UIApplication sharedApplication].statusBarHidden = YES;
}

-(void)viewDidLoad {
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    // make logo image transparent
    logoImage.alpha = 0.0;
    
    // make black moviethumb transparent
    movieViewBlack.alpha = 0.0;
	
    arr_Timecode = [[NSArray alloc] initWithObjects:
                    [NSNumber numberWithFloat:0], //intro
                    [NSNumber numberWithFloat:50+kFrameFixer], //map
                    [NSNumber numberWithFloat:61+kFrameFixer], // cont - OK
                    [NSNumber numberWithFloat:92+kFrameFixer], //2 level
                    [NSNumber numberWithFloat:128+kFrameFixer], //glass
                    nil];
    
	[self performSelector:@selector(animateTitle) withObject:nil afterDelay:2.5];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    
    UIFont *font = [UIFont fontWithName:@"TradeGothicLTStd-Cn18" size:16.0];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:UITextAttributeFont];
    [movieBtns setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];

    for (UILabel *label in [movieBtns subviews]) {
        label.transform = CGAffineTransformMakeTranslation(0.0, 3.0);
    }
    [movieBtns setContentPositionAdjustment:UIOffsetMake(0, 2) forSegmentType:UISegmentedControlSegmentAny barMetrics:UIBarMetricsDefault];
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
                                          }
                                          completion:^(BOOL finished) {
                                          }];                     
                     }];
}

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

-(void)swipeUpPlay:(id)sender
{
    [myAVPlayer play];
}


-(void)swipeDownPause:(id)sender
{
    [myAVPlayer pause];
}

#pragma mark - Play Move
#pragma mark Init AvPlayer and play the movie
-(IBAction)playThisMovie:(id)sender {
	
	movieTag = [sender tag];

    playButton.hidden = YES;
	playButton02.hidden = YES;
	playButton03.hidden = YES;
    
	url = nil;
	
	if ([sender tag]==0) {
		url = [[NSBundle mainBundle] pathForResource:@"AutodeskBimCityEngineeringAppleTV" ofType:@"mov"];
	} else if ([sender tag]==1) {
		url = [[NSBundle mainBundle] pathForResource:@"AutodeskBimCityConstructionAppleTV" ofType:@"mov"];
	} else {
		url = [[NSBundle mainBundle] pathForResource:@"AutodeskBimCityTransportationAppleTV" ofType:@"mov"];
	}	
	NSLog(@"%@", url);
    [self createMainAVPlayer:url];
    [self addGestureToAvPlayer];
    
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
                         [self.view addSubview: uiv_myPlayerContainer];
                         [myAVPlayer play];
                         [self createUserProfleBtn:(int)[sender tag]];
                     }];

}

#pragma mark - Create Main AVPlayer

- (void)createMainAVPlayer:(NSString *)movieUrl
{
    if (uiv_myPlayerContainer) {
        [uiv_myPlayerContainer removeFromSuperview];
        uiv_myPlayerContainer = nil;
        [uiv_myPlayerContainer release];
    }
    
    uiv_myPlayerContainer = [[UIView alloc] initWithFrame:CGRectMake(0.0, 86.0, 1024.0, 576.0)];
    playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:movieUrl]];
    myAVPlayer = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    myAVPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:myAVPlayer];
    myAVPlayerLayer.frame = uiv_myPlayerContainer.bounds;
    myAVPlayerLayer.backgroundColor = [UIColor clearColor].CGColor;
    [uiv_myPlayerContainer.layer addSublayer:myAVPlayerLayer];
    
    uib_closeMainPlayer = [UIButton buttonWithType:UIButtonTypeCustom];
    uib_closeMainPlayer.frame = CGRectMake(35.0, 25.0, 80.0, 30.0);
    uib_closeMainPlayer.backgroundColor = [UIColor clearColor];
    [uib_closeMainPlayer setTitle:@"DONE" forState:UIControlStateNormal];
    [uib_closeMainPlayer.titleLabel setFont:[UIFont fontWithName:@"TradeGothicLTStd-Cn18" size:16]];
    [uib_closeMainPlayer setTitleEdgeInsets: UIEdgeInsetsMake(6.0, 0.0, 0.0, 0.0)];
    uib_closeMainPlayer.layer.borderColor = [UIColor colorWithRed:115.0/255.0 green:142.0/255.0 blue:174.0/255.0 alpha:1.0].CGColor;
    uib_closeMainPlayer.layer.borderWidth = 1.5;
    uib_closeMainPlayer.layer.cornerRadius = 6.0;
    [uib_closeMainPlayer setTitleColor:[UIColor colorWithRed:115.0/255.0 green:142.0/255.0 blue:174.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.view addSubview: uib_closeMainPlayer];
    [uib_closeMainPlayer addTarget:self action:@selector(closeMainPlayer:) forControlEvents:UIControlEventTouchUpInside];
    
    [self createSlider];
    [self createSliderTimer];
}
#pragma mark Slider Action
- (void)createSlider
{
    uisl_timerBar = [UISlider new];
    uisl_timerBar.frame = CGRectMake(250.0, 0.0, 500.0, 40.0);
    uisl_timerBar.translatesAutoresizingMaskIntoConstraints = NO;
    [uisl_timerBar setBackgroundColor:[UIColor clearColor]];
    uisl_timerBar.minimumValue = 0.0;
    uisl_timerBar.maximumValue = CMTimeGetSeconds([[myAVPlayer.currentItem asset] duration]);
    uisl_timerBar.continuous = YES;
    uisl_timerBar.tag = 1;
    [uisl_timerBar addTarget:self action:@selector(sliding:) forControlEvents:UIControlEventValueChanged];
    [uisl_timerBar addTarget:self action:@selector(finishedSliding:) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];
    [uiv_myPlayerContainer addSubview:uisl_timerBar];
}

- (void)sliding:(id)sender
{
    if ([sender tag] == 1) {
        [myAVPlayer pause];
        UISlider *slider = sender;
        CMTime newTime = CMTimeMakeWithSeconds(slider.value,600);
        [myAVPlayer seekToTime:newTime
               toleranceBefore:kCMTimeZero
                toleranceAfter:kCMTimeZero];
    }
    else {
        [profilePlayer pause];
        UISlider *slider = sender;
        CMTime newTime = CMTimeMakeWithSeconds(slider.value,600);
        [profilePlayer seekToTime:newTime
               toleranceBefore:kCMTimeZero
                toleranceAfter:kCMTimeZero];
    }
}

- (void)finishedSliding:(id)sender
{
    if ([sender tag] == 1)
    {
        NSNumber *currentTime = [NSNumber numberWithFloat:CMTimeGetSeconds(myAVPlayer.currentTime)];
        int segIndex = 0;
        for (NSNumber *time in arr_Timecode) {
            if ([currentTime floatValue] <= [time floatValue]) {
                segIndex = (int)[arr_Timecode indexOfObject: time]-1;
                break;
            }
        }
        if ([currentTime floatValue] > [[arr_Timecode objectAtIndex:(arr_Timecode.count - 1)] floatValue]) {
            segIndex = (int)movieBtns.numberOfSegments - 1;
        }
        NSLog(@"The current index is %i", segIndex);
        movieBtns.selectedSegmentIndex = segIndex;
        [myAVPlayer play];
    }
    else
    {
        [profilePlayer play];
    }
}

/*
 Add Timer to slider
 */
- (void)createSliderTimer
{
    sliederTimer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(updateSliderAndTimelabel) userInfo:nil repeats:YES];
}

/*
 Slider action -- adjust slider's positon and update number of time label
 */
- (void)updateSliderAndTimelabel
{
    if (uiv_detailVideoContainer.frame.size.width > 1000) {
        uisl_profileTimeBar.maximumValue = CMTimeGetSeconds([[profilePlayer.currentItem asset] duration]);
        uisl_profileTimeBar.value = CMTimeGetSeconds(profilePlayer.currentTime);
    }
    else {
        uisl_timerBar.maximumValue = CMTimeGetSeconds([[myAVPlayer.currentItem asset] duration]);
        uisl_timerBar.value = CMTimeGetSeconds(myAVPlayer.currentTime);
        
        NSNumber *currentTime = [NSNumber numberWithFloat:CMTimeGetSeconds(myAVPlayer.currentTime)];
        int segIndex = 0;
        for (NSNumber *time in arr_Timecode)
        {
            if ([currentTime floatValue] <= [time floatValue])
            {
                segIndex = (int)[arr_Timecode indexOfObject: time]-1;
                break;
            }
        }
        if ([currentTime floatValue] > [[arr_Timecode objectAtIndex:(arr_Timecode.count - 1)] floatValue])
        {
            segIndex = (int)movieBtns.numberOfSegments - 1;
        }
        movieBtns.selectedSegmentIndex = segIndex;
    }
}


#pragma mark Close Main Movie Player
- (void)closeMainPlayer:(id)sender
{
    [UIView animateWithDuration:0.50 delay:0.0 options:0
                     animations:^{
                         uib_closeMainPlayer.alpha = 0.0;
                         
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
                         movieViewBottom.transform = CGAffineTransformIdentity;
                         movieViewTop.transform = CGAffineTransformIdentity;
                         uiv_profileContainer.alpha = 0.0;
                         [uiv_myPlayerContainer removeFromSuperview];
                         [self.view bringSubviewToFront:playButton03];
                         [self.view bringSubviewToFront:playButton02];
                         [self.view bringSubviewToFront:playButton];
                         
                     }
                     completion:^(BOOL finished) {
                         playButton.hidden = NO;
                         playButton02.hidden = NO;
                         playButton03.hidden = NO;
                         
                         movieViewTop.layer.cornerRadius = 0;
                         movieViewTop.layer.shadowOffset = CGSizeMake(0,0);
                         movieViewTop.layer.shadowRadius = 0;
                         movieViewTop.layer.shadowOpacity = 0.0;
                         
                         //Kill AVplayer
                         [myAVPlayer pause];
                         [myAVPlayerLayer removeFromSuperlayer];
                         [myAVPlayerLayer release];
                         myAVPlayerLayer = nil;
                         myAVPlayer = nil;
                         playerItem = nil;
                         
                         //Kill profiles container
                         [uiv_profileContainer removeFromSuperview];
                         [uiv_profileContainer release];
                         uiv_profileContainer = nil;
                         [sliederTimer invalidate];
                         
                         //Kill Done button
                         [uib_closeMainPlayer removeFromSuperview];
                         [uib_closeMainPlayer release];
                         uib_closeMainPlayer = nil;
                         
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

#pragma mark add Gesture to AVPlayer container

- (void)addGestureToAvPlayer
{
    pinchInRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeNextSection:)];
    [pinchInRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [pinchInRecognizer setDelegate:self];
    [uiv_myPlayerContainer addGestureRecognizer:pinchInRecognizer];
    
    swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipePrevSection:)];
    [swipeLeftRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [swipeLeftRecognizer setDelegate:self];
    [uiv_myPlayerContainer addGestureRecognizer:swipeLeftRecognizer];
    
    swipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUpPlay:)];
    [swipeUpRecognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [swipeUpRecognizer setDelegate:self];
    [uiv_myPlayerContainer addGestureRecognizer:swipeUpRecognizer];
    
    swipeDownRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownPause:)];
    [swipeDownRecognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [swipeDownRecognizer setDelegate:self];
    [uiv_myPlayerContainer addGestureRecognizer:swipeDownRecognizer];
}

#pragma mark - User Profile Panel
- (void)createUserProfleBtn:(int)index
{
    if (uib_userProfile) {
        uib_userProfile = nil;
        [uib_userProfile release];
    }
    
    // Profile Container
    uiv_profileContainer = [[UIView alloc] initWithFrame:CGRectMake(885.0, 500.0, 137.0, 142.0)];
    [self.view addSubview: uiv_profileContainer];
    uiv_profileContainer.clipsToBounds = YES;
    uiv_profileContainer.backgroundColor = [UIColor clearColor];
    
    // Profile Button
    uib_userProfile = [UIButton buttonWithType:UIButtonTypeCustom];
    uib_userProfile.frame = CGRectMake(0.0, 0.0, 137.0, 142.0);
    [uib_userProfile setImage:[UIImage imageNamed:@"icon-user-profile-alert.png"] forState:UIControlStateNormal];
    [uiv_profileContainer addSubview: uib_userProfile];
    uib_userProfile.tag = index;
    [uib_userProfile addTarget:self action:@selector(tapUserProfile:) forControlEvents:UIControlEventTouchUpInside];
    uiv_profileContainer.transform = CGAffineTransformMakeTranslation(160.0, 0.0);
    [UIView animateWithDuration:0.3 delay:5.5 options:0 animations:^{
        uiv_profileContainer.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){    }];
    // Profile detail view image
    UIImage *detailImage;
    switch (index) {
        case 0:
            detailImage = [UIImage imageNamed:@"profile-anna-jones.png"];
            break;
        case 1:
            detailImage = [UIImage imageNamed:@"profile-gary blogg.png"];
            break;
        case 2:
            detailImage = [UIImage imageNamed:@"profile-charles-smith.png"];
            break;
        default:
            break;
    }
    uiiv_profileDetail = [[UIImageView alloc] initWithImage:detailImage];
    uiiv_profileDetail.frame = CGRectMake(0.0, 0.0, detailImage.size.width, detailImage.size.height);
    uiiv_profileDetail.alpha = 0.0;
    [uiv_profileContainer addSubview: uiiv_profileDetail];
    
    // Profile AVPlayer
    uiv_detailVideoContainer = [[UIView alloc] initWithFrame: CGRectMake(20, 55, 200, 200)];
    uiv_detailVideoContainer.backgroundColor = [UIColor clearColor];
    [uiv_profileContainer insertSubview:uiv_detailVideoContainer aboveSubview:uiiv_profileDetail];
    uiv_detailVideoContainer.hidden = YES;
    uiv_detailVideoContainer.userInteractionEnabled = YES;
    tapDetailVideo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapVideoDetail:)];
    [uiv_detailVideoContainer addGestureRecognizer:tapDetailVideo];
    uiv_detailVideoContainer.tag = index;
    
    //Close Profile button
    uib_closeProfile = [UIButton buttonWithType:UIButtonTypeCustom];
    uib_closeProfile.backgroundColor = [UIColor clearColor];
    uib_closeProfile.frame = CGRectMake(0.0, 0.0, 240.0, 50.0);
    [uib_closeProfile addTarget:self action:@selector(closeProfile:) forControlEvents:UIControlEventTouchUpInside];
    uib_closeProfile.enabled = NO;
    [uiv_profileContainer addSubview: uib_closeProfile];
}

- (void)closeProfile:(id)sender
{
    if (uiv_detailVideoContainer.hidden)
    {
        return;
    }
    else
    {
        [self hideProfileDetail];
        uib_closeProfile.enabled = NO;
    }
}

- (void)tapUserProfile:(id)sender
{
    [UIView animateWithDuration:0.33 animations:^{
        uiv_profileContainer.frame =  CGRectMake(885.0, 240.0, 137.0, 142);
    }completion:^(BOOL finshed){
        [UIView animateWithDuration:0.33 animations:^{
            uiv_profileContainer.frame = CGRectMake(1024 - uiiv_profileDetail.frame.size.width, 240.0, uiiv_profileDetail.frame.size.width, uiiv_profileDetail.frame.size.height);
            uib_userProfile.alpha = 0.0;
            uiiv_profileDetail.alpha = 1.0;
            [uiv_detailVideoContainer addGestureRecognizer:tapDetailVideo];
            uiv_detailVideoContainer.hidden = NO;
            uib_closeProfile.enabled = YES;
        }];
    }];
}

- (void)hideProfileDetail
{
    [UIView animateWithDuration:0.33 animations:^{
        uiv_profileContainer.frame = CGRectMake(885.0, 240.0, 137.0, 142.0);
        uib_userProfile.alpha = 1.0;
        uiiv_profileDetail.alpha = 0.0;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.33 animations:^{
            uiv_profileContainer.frame = CGRectMake(885.0, 500.0, 137.0, 142.0);
            uiv_detailVideoContainer.hidden = YES;
        }];
    }];
}

- (void)tapVideoDetail:(UIGestureRecognizer *)gesture
{
    [myAVPlayer pause];
    NSLog(@"should load detail video");
    int index = (int)gesture.view.tag;
    NSString *videoUrl;
    switch (index) {
        case 0:
            videoUrl = [[NSBundle mainBundle] pathForResource:@"2015_02_27_Autodesk_BimCity_CharacterProfile_AnnaJones_HD" ofType:@"mov"];
            break;
        case 1:
            videoUrl = [[NSBundle mainBundle] pathForResource:@"2015_02_27_Autodesk_BimCity_CharacterProfile_GaryBlogg_HD" ofType:@"mov"];
            break;
        case 2:
            videoUrl = [[NSBundle mainBundle] pathForResource:@"2015_02_27_Autodesk_BimCity_CharacterProfile_CharlesSmith_HD" ofType:@"mov"];
            break;
        default:
            break;
    }
    [uiv_detailVideoContainer removeFromSuperview];
    [self.view addSubview: uiv_detailVideoContainer];
    uiv_detailVideoContainer.frame = CGRectMake(825, 300, 181, 181);
    
    [UIView animateWithDuration:0.33 animations:^{
        uiv_detailVideoContainer.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
        uiv_detailVideoContainer.frame = self.view.bounds;
    }completion:^(BOOL finished){
        [uiv_detailVideoContainer removeGestureRecognizer:tapDetailVideo];
        if (profilePlayerLayer) {
            [profilePlayerLayer removeFromSuperlayer];
            profilePlayerLayer = nil;
            profilePlayer = nil;
            profileItem = nil;
        }
        profileItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath: videoUrl]];
        profilePlayer = [[AVPlayer alloc] initWithPlayerItem:profileItem];
        profilePlayerLayer = [AVPlayerLayer playerLayerWithPlayer:profilePlayer];
        profilePlayerLayer.frame = uiv_myPlayerContainer.frame;
        profilePlayerLayer.transform = CATransform3DMakeScale(0.9, 0.9, 1.0);
        profilePlayerLayer.opacity = 0.0;
        [uiv_detailVideoContainer.layer addSublayer: profilePlayerLayer];
        [UIView animateWithDuration:0.33 animations:^{
            profilePlayerLayer.opacity = 1.0;
        } completion:^(BOOL finished){
            [profilePlayer play];
            UIButton *uib_detailClose = [UIButton buttonWithType:UIButtonTypeCustom];
            uib_detailClose.frame = CGRectMake(50.0, 50.0, 50.0, 50.0);
            uib_detailClose.backgroundColor = [UIColor blackColor];
            [uib_detailClose setTitle:@"X" forState:UIControlStateNormal];
            [uiv_detailVideoContainer addSubview: uib_detailClose];
            [uib_detailClose addTarget:self action:@selector(closeProfileMovie:) forControlEvents:UIControlEventTouchUpInside];
            [self createProfileMovieGesture];
            [self addSliderToProfileMovie];
        }];
    }];
}

- (void)addSliderToProfileMovie
{
    uisl_profileTimeBar = [UISlider new];
    uisl_profileTimeBar.frame = CGRectMake(250.0, 80.0, 500.0, 40.0);
    uisl_profileTimeBar.translatesAutoresizingMaskIntoConstraints = NO;
    [uisl_profileTimeBar setBackgroundColor:[UIColor whiteColor]];
    uisl_profileTimeBar.minimumValue = 0.0;
    uisl_profileTimeBar.maximumValue = CMTimeGetSeconds([[myAVPlayer.currentItem asset] duration]);
    uisl_profileTimeBar.continuous = YES;
    uisl_profileTimeBar.tag = 2;
    [uisl_profileTimeBar addTarget:self action:@selector(sliding:) forControlEvents:UIControlEventValueChanged];
    [uisl_profileTimeBar addTarget:self action:@selector(finishedSliding:) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];
    [uiv_detailVideoContainer addSubview: uisl_profileTimeBar];
}

#pragma mark Add gesture control to profile video
- (void)createProfileMovieGesture
{
    swipeProfileMovieUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(playProfileMovie:)];
    swipeProfileMovieUp.direction = UISwipeGestureRecognizerDirectionUp;
    [uiv_detailVideoContainer addGestureRecognizer: swipeProfileMovieUp];
    
    swipeProfileMovieDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(pauseProfileMovie:)];
    swipeProfileMovieDown.direction = UISwipeGestureRecognizerDirectionDown;
    [uiv_detailVideoContainer addGestureRecognizer: swipeProfileMovieDown];
}

- (void)playProfileMovie:(UIGestureRecognizer *)gesture
{
    [profilePlayer play];
}

- (void)pauseProfileMovie:(UIGestureRecognizer *)gesture
{
    [profilePlayer pause];
}

- (void)closeProfileMovie:(id)sender
{
    UIButton *closeBtn = sender;
    [UIView animateWithDuration:0.33 animations:^{
        profilePlayerLayer.opacity = 0.0;
        uiv_detailVideoContainer.backgroundColor = [UIColor clearColor];
        closeBtn.alpha = 0.0;
        uisl_profileTimeBar.alpha = 0.0;
    } completion:^(BOOL finished){
        [closeBtn removeFromSuperview];
        [uiv_detailVideoContainer removeFromSuperview];
        uiv_detailVideoContainer.frame = CGRectMake(20, 55, 200, 200);
        [uiv_profileContainer insertSubview:uiv_detailVideoContainer aboveSubview:uiiv_profileDetail];
        [uiv_detailVideoContainer removeGestureRecognizer:swipeProfileMovieDown];
        [uiv_detailVideoContainer removeGestureRecognizer:swipeProfileMovieUp];
        [uiv_detailVideoContainer removeGestureRecognizer:tapDetailVideo];
        [myAVPlayer play];
        [uisl_profileTimeBar removeFromSuperview];
        [uisl_profileTimeBar release];
        uisl_profileTimeBar = nil;
        [self hideProfileDetail];
    }];
}

#pragma mark - AVPlayer Delegate Method
- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    if (CMTimeGetSeconds(myAVPlayer.currentTime) >= CMTimeGetSeconds([[myAVPlayer.currentItem asset] duration]))
    {
        [myAVPlayer seekToTime:kCMTimeZero];
        [myAVPlayer play];
        [uisl_timerBar setValue:0.0];
        return;
    }
    if (CMTimeGetSeconds(profilePlayer.currentTime) >= CMTimeGetSeconds([[profilePlayer.currentItem asset] duration]))
    {
        [profilePlayer seekToTime:kCMTimeZero];
        [profilePlayer play];
        return;
    }
}

#pragma mark - Jump movie
-(IBAction)movieShouldJump:(id)sender {
    
    NSUInteger i = movieBtns.selectedSegmentIndex;
    
    [myAVPlayer pause];
    
   NSString *myString = [arr_Timecode objectAtIndex:i];
   Float64 stringfloat = [myString floatValue];
    
    CMTime jumpTime = CMTimeMakeWithSeconds(stringfloat, 1);
    [myAVPlayer seekToTime:jumpTime];
    [myAVPlayer pause];
}

-(void)dismissModal {
	[self dismissModalViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated {
}

#pragma mark - Clean Memory

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
    [progressIndicator release];
	[movieThumb02 release];
	[movieThumb03 release];
	[playButton02 release];
	[playButton03 release];
    [myAVPlayer release];
    [myAVPlayerLayer release];
    [profilePlayer release];
    [profilePlayerLayer release];
    [profileItem release];
	[super dealloc];
}

@end
