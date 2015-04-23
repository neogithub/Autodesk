//
//  ThePactViewController.h
//  ThePact
//
//  Created by iDev on 12/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVAudioMix.h>
#import <AVFoundation/AVAssetTrack.h>
#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@protocol ModalViewDelegate

-(void) didReceiveMessage:(NSString *)message;

@end

@interface ThePactViewController : UIViewController <ModalViewDelegate, UIGestureRecognizerDelegate> {
    UIView                          *previousView;
    UINavigationController          *galleryNavigationController;
    UISwipeGestureRecognizer        *pinchInRecognizer;
    UISwipeGestureRecognizer        *swipeLeftRecognizer;
    UISwipeGestureRecognizer        *swipeUpRecognizer;
    UISwipeGestureRecognizer        *swipeDownRecognizer;
}

@property (nonatomic, retain) id<ModalViewDelegate> delegate;

@property (nonatomic, retain) IBOutlet UIImageView *logoImage;

@property (nonatomic, retain) IBOutlet UIImageView *photoThumb;

@property (nonatomic, retain) IBOutlet UIButton *playButton;
@property (retain, nonatomic) IBOutlet UIButton *playButton02;
@property (retain, nonatomic) IBOutlet UIButton *playButton03;

@property (nonatomic, retain) IBOutlet UIImageView *movieThumb;
@property (retain, nonatomic) IBOutlet UIImageView *movieThumb02;
@property (retain, nonatomic) IBOutlet UIImageView *movieThumb03;
@property (nonatomic, retain) NSString *url;

@property (nonatomic, retain) IBOutlet UIView *movieShadow;

@property (nonatomic, retain) IBOutlet UIView *wirelessIndicatorView;

@property (nonatomic, retain) IBOutlet UIView *movieViewTop;
@property (nonatomic, retain) IBOutlet UIView *movieViewBottom;
@property (nonatomic, retain) IBOutlet UIView *movieViewBlack;

@property (nonatomic, retain) IBOutlet UISegmentedControl *movieBtns;

@property (nonatomic, retain) NSArray *arr_Timecode;
@property (nonatomic) NSUInteger movieTag;

@property (nonatomic, retain) UISlider *progressIndicator;

@property (retain, nonatomic) IBOutlet UILabel *uil_version;

-(void)dismissModal;
-(IBAction)playThisMovie:(id)sender;
-(IBAction)movieShouldJump:(id)sender;

@end

