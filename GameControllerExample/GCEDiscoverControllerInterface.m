//
//  GCEDiscoverControllerInterface.m
//  GameControllerExample
//
//  Created by Tim Chilvers on 07/01/2014.
//  Copyright (c) 2014 Tim Chilvers. All rights reserved.
//

#import "GCEDiscoverControllerInterface.h"

@interface GCEDiscoverControllerInterface ()

@property (nonatomic,copy) void (^controllerCallbackSetup)(GCController *gameController);

@end

@implementation GCEDiscoverControllerInterface

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:GCControllerDidConnectNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:GCControllerDidDisconnectNotification
                                                  object:nil];
}

- (void)discoverController:(void (^)(GCController *gameController))controllerCallbackSetup {

    self.controllerCallbackSetup = controllerCallbackSetup;
    
    if ([self hasControllerConnected]) {
        NSLog(@"Discovery finished on first pass");
        [self foundController];
    } else {
        NSLog(@"Discovery happening patiently");
        [self patientlyDiscoverController];
    }
}

- (void)stop {
    
    NSLog(@"Discovery stopped");
    [GCController stopWirelessControllerDiscovery];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:GCControllerDidConnectNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:GCControllerDidDisconnectNotification
                                                  object:nil];
}

- (void)patientlyDiscoverController {
    
    [GCController startWirelessControllerDiscoveryWithCompletionHandler:^{
        if ([self hasControllerConnected]) {
            [self foundController];
        }
    }];
 
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(foundController)
                                                 name:GCControllerDidConnectNotification
                                               object:nil];
}

- (void)foundController {
    
    NSLog(@"Found Controller");
    if (self.controllerCallbackSetup) {
        self.controllerCallbackSetup([[GCController controllers] firstObject]);
    }
    [self stop];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(patientlyDiscoverController)
                                                 name:GCControllerDidDisconnectNotification
                                               object:nil];
}

- (BOOL)hasControllerConnected {
    return [[GCController controllers] count] > 0;
}

@end
