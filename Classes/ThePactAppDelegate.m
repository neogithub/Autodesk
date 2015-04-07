//
//  ThePactAppDelegate.m
//  ThePact
//
//  Created by iDev on 12/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ThePactAppDelegate.h"
#import "ThePactViewController.h"
#import "Reachability.h"


@implementation ThePactAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize internetReachable, hostReachable, isWirelessAvailable;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // check for internet connection
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
	
	internetReachable = [[Reachability reachabilityForInternetConnection] retain];
	[internetReachable startNotifier];
	
    // check if a pathway to a random host exists
	hostReachable = [[Reachability reachabilityWithHostName: @"www.apple.com"] retain];
	[hostReachable startNotifier];
    
    // Override point for customization after app launch. 
	[self.window setRootViewController:viewController];
    [self.window makeKeyAndVisible];

	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

//////////////////////////
// Webcheck when loaded //
//////////////////////////
//
- (void) checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
	
	NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
	switch (internetStatus)
	
	{
		case NotReachable:
		{
			NSLog(@"The internet is down.");
			internetActive = NO;
			isWirelessAvailable = @"NO";
			break;
			
		}
		case ReachableViaWiFi:
		{
			NSLog(@"The internet is working via WIFI.");
            //	self.internetActive = YES;
			internetActive = YES;
			isWirelessAvailable = @"YES";
			break;
			
		}
		case ReachableViaWWAN:
		{
			NSLog(@"The internet is working via WWAN.");
            //	self.internetActive = YES;
			internetActive = YES;
            isWirelessAvailable = @"YES";
			break;
			
		}
	}
	
	NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
	switch (hostStatus)
	
	{
		case NotReachable:
		{
			NSLog(@"A gateway to the host server is down.");
            //self.hostActive = NO;
			internetActive = NO;
            isWirelessAvailable = @"NO";
			break;
			
		}
		case ReachableViaWiFi:
		{
			NSLog(@"A gateway to the host server is working via WIFI.");
            //self.hostActive = YES;
			internetActive = YES;			
			isWirelessAvailable = @"YES";
			break;
			
		}
		case ReachableViaWWAN:
		{
			NSLog(@"A gateway to the host server is working via WWAN.");
            //self.hostActive = YES;
			internetActive = YES;			
			isWirelessAvailable = @"YES";
			break;
			
		}
	}
}



#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
    [internetReachable release];
	[hostReachable release];
    [super dealloc];
}


@end
