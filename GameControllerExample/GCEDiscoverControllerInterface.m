//
//  GCEDiscoverControllerInterface.m
//  GameControllerExample
//
//  Created by Tim Chilvers on 07/01/2014.
//  Copyright (c) 2014 Tim Chilvers. All rights reserved.
//

#import "GCEDiscoverControllerInterface.h"

@interface GCEDiscoverControllerInterface ()

@property (nonatomic,strong) NSTimer *pingForHardwareControllerTimer;
@property (nonatomic,copy) void (^controllerCallbackSetup)(GCController *gameController);
@end

const NSTimeInterval hardwareControllerPingTimer = 2.0;
const NSTimeInterval hardwareControllerPingTolerance = 0.5;

@implementation GCEDiscoverControllerInterface

- (void)dealloc {
    
    [_pingForHardwareControllerTimer invalidate];
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
    [self.pingForHardwareControllerTimer invalidate];
    [GCController stopWirelessControllerDiscovery];
}

- (void)patientlyDiscoverController {
    
    [GCController startWirelessControllerDiscoveryWithCompletionHandler:^{
        if ([self hasControllerConnected]) {
            [self foundController];
        }
    }];
    
    [self.pingForHardwareControllerTimer invalidate];
    self.pingForHardwareControllerTimer = [NSTimer scheduledTimerWithTimeInterval:hardwareControllerPingTimer
                                                                           target:self
                                                                         selector:@selector(attemptFindingWiredController)
                                                                         userInfo:nil
                                                                          repeats:YES];
    self.pingForHardwareControllerTimer.tolerance = hardwareControllerPingTolerance;
}

- (void)attemptFindingWiredController {
    
    NSLog(@"Discovery pinged");
    if ([self hasControllerConnected]) {
        NSLog(@"Patiently discovered");
        [self foundController];
    }
}

- (void)foundController {
    if (self.controllerCallbackSetup) {
        self.controllerCallbackSetup([[GCController controllers] firstObject]);
    }
    [self stop];
}

- (BOOL)hasControllerConnected {
    return [[GCController controllers] count] > 0;
}

@end
