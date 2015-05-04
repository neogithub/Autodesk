//
//  ThePactViewController.m
//  ThePact
//
//  Created by iDev on 12/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TheRootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "AutoDeskAppDelegate.h"

static NSUInteger kFrameFixer = 1;

@implementation TheRootViewController
{
    UIButton                        *uib_closeMainPlayer;
    UISlider                        *uisl_timerBar;
    NSTimer                         *sliederTimer;
    // AVPlayer of Main movie
    UIView                          *uiv_myPlayerContainer;
    AVPlayerItem                    *playerItem;
    AVPlayer                        *myAVPlayer;
    AVPlayerLayer                   *myAVPlayerLayer;
    // Avplayer of Porfile movie
    AVPlayer                        *profilePlayer;
    AVPlayerLayer                   *profilePlayerLayer;
    AVPlayerItem                    *profileItem;
    // Items in profle movie container
    UIButton                        *uib_closeProfile;
    UIView                          *uiv_profileContainer;
    UIButton                        *uib_userProfile;
    UIImageView                     *uiiv_profileDetail;
    UIView                          *uiv_detailVideoContainer;
    UITapGestureRecognizer          *tapDetailVideo;
    UISlider                        *uisl_profileTimeBar;
    UISwipeGestureRecognizer        *swipeProfileMovieUp;
    UISwipeGestureRecognizer        *swipeProfileMovieDown;
}

//logo image
@synthesize uib_playBtn2;
@synthesize uib_playBtn3;
@synthesize uiiv_movieThumb2;
@synthesize uiiv_movieThumb3;
@synthesize url, movieTag;
// movie controls
@synthesize uib_playBtn1, uiiv_movieThumb1, delegate;
@synthesize uiv_movieViewTop, uiv_movieViewBottom, uiv_movieViewBlack, movieBtns, arr_Timecode;
// Version label
@synthesize uil_version;

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated {
    // Check app's version num
    [UIApplication sharedApplication].statusBarHidden = YES;
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    [uil_version setText:[NSString stringWithFormat:@"v%@", version]];
}

-(void)viewDidLoad {
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    // make black moviethumb transparent
    uiv_movieViewBlack.alpha = 0.0;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        // Set up Time array for movie's secitons
        arr_Timecode = [[NSArray alloc] initWithObjects:
                        [NSNumber numberWithFloat:0], //intro
                        [NSNumber numberWithFloat:50+kFrameFixer], //map
                        [NSNumber numberWithFloat:61+kFrameFixer], // cont - OK
                        [NSNumber numberWithFloat:92+kFrameFixer], //2 level
                        [NSNumber numberWithFloat:128+kFrameFixer], //glass
                        nil];
    });
    
    // Listen avmovie player reach the end of movies
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    // Set segment's button title font
    UIFont *font = [UIFont fontWithName:@"TradeGothicLTStd-Cn18" size:16.0];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [movieBtns setTitleTextAttributes:attributes
                            forState:UIControlStateNormal];
    for (UILabel *label in [movieBtns subviews]) {
        label.transform = CGAffineTransformMakeTranslation(0.0, 3.0);
    }
    [movieBtns setContentPositionAdjustment:UIOffsetMake(0, 2) forSegmentType:UISegmentedControlSegmentAny barMetrics:UIBarMetricsDefault];
}

#pragma mark - Play Move
#pragma mark Init AvPlayer and play the movie
-(IBAction)playThisMovie:(id)sender {
	
	movieTag = [sender tag];

    uib_playBtn1.hidden = YES;
	uib_playBtn2.hidden = YES;
	uib_playBtn3.hidden = YES;
    
	url = nil;
	
    //Set movie file accroding to the movie tag
	if ([sender tag]==0) {
		url = [[NSBundle mainBundle] pathForResource:@"AutodeskBimCityEngineeringAppleTV" ofType:@"mov"];
	} else if ([sender tag]==1) {
		url = [[NSBundle mainBundle] pathForResource:@"AutodeskBimCityConstructionAppleTV" ofType:@"mov"];
	} else {
		url = [[NSBundle mainBundle] pathForResource:@"AutodeskBimCityTransportationAppleTV" ofType:@"mov"];
	}
    
    [self createMainAVPlayer:url];
    [self addGestureToAvPlayer];
    
    // Move the movie black view
	if (movieTag==0) {
		[self.view bringSubviewToFront:uiiv_movieThumb1];
		uiv_movieViewBlack.frame = CGRectMake(28, 287, 314, 185);
	} else if (movieTag==1) {
		[self.view bringSubviewToFront:uiiv_movieThumb2];
		uiv_movieViewBlack.frame = CGRectMake(358, 287, 314, 185);
	} else if (movieTag==2){
		[self.view bringSubviewToFront:uiiv_movieThumb3];
		uiv_movieViewBlack.frame = CGRectMake(686, 287, 314, 185);
	}
	
    UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction  | UIViewAnimationOptionCurveEaseInOut;
    [UIView animateWithDuration:0.5 delay:0.0 options:options 
                     animations:^(void){
                         
                         uiv_movieViewBottom.transform = CGAffineTransformTranslate(uiv_movieViewBottom.transform, 0, -110);
                         uiv_movieViewTop.transform = CGAffineTransformTranslate(uiv_movieViewBottom.transform, 0, +200);
                         
						 if ([sender tag]==0) {
							 uiiv_movieThumb1.frame = CGRectMake(0, 86, 1024, 576);
                             
						 } else if ([sender tag]==1) {
							 uiiv_movieThumb2.frame = CGRectMake(0, 86, 1024, 576);
                             
						 } else {
							 uiiv_movieThumb3.frame = CGRectMake(0, 86, 1024, 576);
						 }
						 
                         uiv_movieViewBlack.alpha = 1.0;
                         uiv_movieViewBlack.frame = CGRectMake(0, 86, 1024, 576);
						 [self.view bringSubviewToFront: uiv_movieViewBlack];
                         
                         uiv_movieViewTop.layer.masksToBounds = NO;
                         uiv_movieViewTop.layer.cornerRadius = 0;
                         uiv_movieViewTop.layer.shadowOffset = CGSizeMake(0,10);
                         uiv_movieViewTop.layer.shadowRadius = 5;
                         uiv_movieViewTop.layer.shadowOpacity = 0.25;
                         uiv_movieViewTop.layer.shadowPath = [UIBezierPath bezierPathWithRect:uiv_movieViewTop.bounds].CGPath;
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
    [self creatMainMovieCloseBtn];
    [self createSlider];
    [self createSliderTimer];
}

#pragma mark Create close movie button

- (void)creatMainMovieCloseBtn
{
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
}

#pragma mark Close Main Movie Player
- (void)closeMainPlayer:(id)sender
{
    [UIView animateWithDuration:0.50 delay:0.0 options:0
                     animations:^{
                         uib_closeMainPlayer.alpha = 0.0;
                         
                         movieBtns.selectedSegmentIndex = 0;
                         
                         uiiv_movieThumb1.frame = CGRectMake(26, 284, 314, 180);
                         uiiv_movieThumb2.frame = CGRectMake(354, 284, 314, 180);
                         uiiv_movieThumb3.frame = CGRectMake(682, 284, 314, 180);
                         
                         if (movieTag==0) {
                             uiv_movieViewBlack.frame = CGRectMake(26, 284, 314, 180);
                         } else if (movieTag==1) {
                             uiv_movieViewBlack.frame = CGRectMake(354, 284, 314, 180);
                         } else if (movieTag==2){
                             uiv_movieViewBlack.frame = CGRectMake(682, 284, 314, 180);
                         }
                         uiv_movieViewBlack.alpha = 0.0;
                         uiv_movieViewBottom.transform = CGAffineTransformIdentity;
                         uiv_movieViewTop.transform = CGAffineTransformIdentity;
                         uiv_profileContainer.alpha = 0.0;
                         [uiv_myPlayerContainer removeFromSuperview];
                         [self.view bringSubviewToFront:uib_playBtn3];
                         [self.view bringSubviewToFront:uib_playBtn2];
                         [self.view bringSubviewToFront:uib_playBtn1];
                         
                     }
                     completion:^(BOOL finished) {
                         uib_playBtn1.hidden = NO;
                         uib_playBtn2.hidden = NO;
                         uib_playBtn3.hidden = NO;
                         
                         uiv_movieViewTop.layer.cornerRadius = 0;
                         uiv_movieViewTop.layer.shadowOffset = CGSizeMake(0,0);
                         uiv_movieViewTop.layer.shadowRadius = 0;
                         uiv_movieViewTop.layer.shadowOpacity = 0.0;
                         
                         //Kill AVplayer
                         [myAVPlayer pause];
                         [myAVPlayerLayer removeFromSuperlayer];
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
                         uib_closeMainPlayer = nil;
                         
                         //kill swipe gestures
                         swipeRightRecognizer.enabled = NO;
                         swipeRightRecognizer.delegate = nil;
                         swipeLeftRecognizer.enabled = NO;
                         swipeLeftRecognizer.delegate = nil;
                         swipeUpRecognizer.enabled = NO;
                         swipeUpRecognizer.delegate = nil;
                         swipeDownRecognizer.enabled = NO;
                         swipeDownRecognizer.delegate = nil;
                     }];
    
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

// Actions of sliding & finish sliding
- (void)sliding:(id)sender
{
    if ([sender tag] == 1) {
        
        [uiv_profileContainer.layer removeAllAnimations];
        uiv_profileContainer.transform = CGAffineTransformIdentity;
        
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

#pragma mark - Create timer to check status of moive
// Loop the movie, update slider, update highlighting segment button
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
    // If porfile movie is loaded then only loop profile movie
    if (uiv_detailVideoContainer.frame.size.width > 1000) {
        uisl_profileTimeBar.maximumValue = CMTimeGetSeconds([[profilePlayer.currentItem asset] duration]);
        uisl_profileTimeBar.value = CMTimeGetSeconds(profilePlayer.currentTime);
    }
    // Loop main movie and update highlighted segment button
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
        if ([currentTime floatValue] < 0.1) {
            segIndex = 0;
        }
        movieBtns.selectedSegmentIndex = segIndex;
    }
}

#pragma mark - add Gesture to AVPlayer container

- (void)addGestureToAvPlayer
{
    swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeNextSection:)];
    [swipeRightRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [swipeRightRecognizer setDelegate:self];
    [uiv_myPlayerContainer addGestureRecognizer:swipeRightRecognizer];
    
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

#pragma mark Gesture action on main movie
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

-(void)swipeUpPlay:(id)sender
{
    [uiv_profileContainer.layer removeAllAnimations];
    uiv_profileContainer.transform = CGAffineTransformIdentity;
    [myAVPlayer play];
}


-(void)swipeDownPause:(id)sender
{
    [uiv_profileContainer.layer removeAllAnimations];
    uiv_profileContainer.transform = CGAffineTransformIdentity;
    [myAVPlayer pause];
}

#pragma mark - User Profile Panel
- (void)createUserProfleBtn:(int)index
{
    if (uib_userProfile) {
        uib_userProfile = nil;
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
    
    //Close Profile Detail button
    uib_closeProfile = [UIButton buttonWithType:UIButtonTypeCustom];
    uib_closeProfile.backgroundColor = [UIColor clearColor];
    uib_closeProfile.frame = CGRectMake(0.0, 0.0, 240.0, 50.0);
    [uib_closeProfile addTarget:self action:@selector(closeProfile:) forControlEvents:UIControlEventTouchUpInside];
    uib_closeProfile.enabled = NO;
    [uiv_profileContainer addSubview: uib_closeProfile];
}

#pragma mark Close profile detail action
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

// Touch on screen to load profile button immediately
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [uiv_profileContainer.layer removeAllAnimations];
    [UIView animateWithDuration:0.33 delay:0.1 options:0 animations:^{
        uiv_profileContainer.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){  }];
}

#pragma mark Tap profile button and expand detail view
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
        
        // Set up profile movie player
        if (profilePlayerLayer != nil) {
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
        [uiv_detailVideoContainer.layer addSublayer: profilePlayerLayer];
        
        // Fade in animation to profile movie player
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.duration = 0.33;
        animation.fromValue = [NSNumber numberWithFloat:0.0f];
        animation.toValue = [NSNumber numberWithFloat:1.0f];
        animation.removedOnCompletion = NO;
        [profilePlayerLayer addAnimation:animation forKey:@"opacityFadeIn"];
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
}

#pragma mark Add slider control to profile movie
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
// Action of gestures on profile movie
- (void)playProfileMovie:(UIGestureRecognizer *)gesture
{
    [profilePlayer play];
}

- (void)pauseProfileMovie:(UIGestureRecognizer *)gesture
{
    [profilePlayer pause];
}

#pragma mark Action of closing  profile movie
- (void)closeProfileMovie:(id)sender
{
    UIButton *closeBtn = sender;
    [UIView animateWithDuration:0.33 animations:^{
        uiv_detailVideoContainer.frame = CGRectMake(825, 300, 181, 181);
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
    
    [uiv_profileContainer.layer removeAllAnimations];
    uiv_profileContainer.transform = CGAffineTransformIdentity;
    
    NSUInteger i = movieBtns.selectedSegmentIndex;
    
    [myAVPlayer pause];
    
   NSString *myString = [arr_Timecode objectAtIndex:i];
   Float64 stringfloat = [myString floatValue];
    
    CMTime jumpTime = CMTimeMakeWithSeconds(stringfloat, 1);
    [myAVPlayer seekToTime:jumpTime];
    [myAVPlayer pause];
}

-(void)dismissModal {
	[self dismissViewControllerAnimated:YES completion:^{   }];
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
	[self setUib_playBtn3:nil];
	[self setUib_playBtn2:nil];
	[self setUiiv_movieThumb3:nil];
	[self setUiiv_movieThumb2:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft | interfaceOrientation == UIInterfaceOrientationLandscapeRight); 
}

- (void)dealloc {
    [uib_playBtn1 release];
    [uiiv_movieThumb1 release];
    [uib_playBtn1 release];
    [uiv_movieViewTop release];
    [uiv_movieViewBottom release];
    [uiv_movieViewBlack release];
    [movieBtns release];
    [arr_Timecode release];
	[uiiv_movieThumb2 release];
	[uiiv_movieThumb3 release];
	[uib_playBtn2 release];
	[uib_playBtn3 release];
    [myAVPlayer release];
    [myAVPlayerLayer release];
    [profilePlayer release];
    [profilePlayerLayer release];
    [profileItem release];
	[super dealloc];
}

@end
