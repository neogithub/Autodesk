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

@interface ThePactViewController : UIViewController <ModalViewDelegate, UIGestureRecognizerDelegate>
{
    UISwipeGestureRecognizer        *swipeRightRecognizer;
    UISwipeGestureRecognizer        *swipeLeftRecognizer;
    UISwipeGestureRecognizer        *swipeUpRecognizer;
    UISwipeGestureRecognizer        *swipeDownRecognizer;
}

@property (nonatomic, retain) id<ModalViewDelegate>             delegate;
@property (nonatomic, retain) IBOutlet UIButton                 *uib_playBtn1;
@property (retain, nonatomic) IBOutlet UIButton                 *uib_playBtn2;
@property (retain, nonatomic) IBOutlet UIButton                 *uib_playBtn3;
@property (nonatomic, retain) IBOutlet UIImageView              *uiiv_movieThumb1;
@property (retain, nonatomic) IBOutlet UIImageView              *uiiv_movieThumb2;
@property (retain, nonatomic) IBOutlet UIImageView              *uiiv_movieThumb3;
@property (nonatomic, retain) IBOutlet UIView                   *uiv_movieViewTop;
@property (nonatomic, retain) IBOutlet UIView                   *uiv_movieViewBottom;
@property (nonatomic, retain) IBOutlet UIView                   *uiv_movieViewBlack;
@property (retain, nonatomic) IBOutlet UILabel                  *uil_version;
@property (nonatomic, retain) IBOutlet UISegmentedControl       *movieBtns;

@property (nonatomic, retain) NSArray                           *arr_Timecode;
@property (nonatomic) NSUInteger                                movieTag;
@property (nonatomic, retain) NSString                          *url;

-(void)dismissModal;
-(IBAction)playThisMovie:(id)sender;
-(IBAction)movieShouldJump:(id)sender;

@end

