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
    
    if ([[GCController controllers] count] == 0) {
        if ([[GCController controllers] count] > 0) {
            NSLog(@"Discovery finished on first pass");
            controllerCallbackSetup([[GCController controllers] firstObject]);
        } else {
            NSLog(@"Discovery happening patiently");
            [self patientlyDiscoverController:controllerCallbackSetup];
        }
    } else {
        if (controllerCallbackSetup) {
            controllerCallbackSetup([[GCController controllers] firstObject]);
        }
    }
}

- (void)stop {
    
    NSLog(@"Discovery stopped");
    [self.pingForHardwareControllerTimer invalidate];
    [GCController stopWirelessControllerDiscovery];
}

- (void)patientlyDiscoverController:(void (^)(GCController *gameController))controllerCallbackSetup {
    
    [GCController startWirelessControllerDiscoveryWithCompletionHandler:^{
        if (controllerCallbackSetup && [[GCController controllers] count] > 0) {
            controllerCallbackSetup([[GCController controllers] firstObject]);
        }
    }];
    
    [self.pingForHardwareControllerTimer invalidate];
    self.controllerCallbackSetup = controllerCallbackSetup;
    self.pingForHardwareControllerTimer = [NSTimer scheduledTimerWithTimeInterval:hardwareControllerPingTimer
                                                                           target:self
                                                                         selector:@selector(attemptFindingWiredController)
                                                                         userInfo:nil
                                                                          repeats:YES];
    self.pingForHardwareControllerTimer.tolerance = hardwareControllerPingTolerance;
}

- (void)attemptFindingWiredController {
    
    NSLog(@"Discovery pinged");
    if ([[GCController controllers] count] > 0) {
        NSLog(@"Patiently discovered");
        [self.pingForHardwareControllerTimer invalidate];
        if (self.controllerCallbackSetup) {
            self.controllerCallbackSetup([[GCController controllers] firstObject]);
        }
        [GCController stopWirelessControllerDiscovery];
    }
}

@end
