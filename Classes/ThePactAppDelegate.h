//
//  ThePactAppDelegate.h
//  ThePact
//
//  Created by iDev on 12/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ThePactViewController;
@class Reachability;


@interface ThePactAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ThePactViewController *viewController;
    BOOL internetActive;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ThePactViewController *viewController;
@property (nonatomic, retain) Reachability* internetReachable;
@property (nonatomic, retain) Reachability* hostReachable;
@property (nonatomic, retain) NSString *isWirelessAvailable;

@end

