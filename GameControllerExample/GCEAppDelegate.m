//
//  GCEAppDelegate.m
//  GameControllerExample
//
//  Created by Tim Chilvers on 06/01/2014.
//  Copyright (c) 2014 Tim Chilvers. All rights reserved.
//

#import "GCEAppDelegate.h"
#import "GCEGameViewController.h"

@implementation GCEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    GCEGameViewController *gameViewController = [[GCEGameViewController alloc] init];
    [self.window setRootViewController:gameViewController];
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
