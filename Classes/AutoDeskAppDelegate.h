//
//  ThePactAppDelegate.h
//  ThePact
//
//  Created by iDev on 12/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TheRootViewController;
@class Reachability;


@interface AutoDeskAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TheRootViewController *viewController;
    BOOL internetActive;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TheRootViewController *viewController;
@property (nonatomic, retain) Reachability* internetReachable;
@property (nonatomic, retain) Reachability* hostReachable;
@property (nonatomic, retain) NSString *isWirelessAvailable;

@end

