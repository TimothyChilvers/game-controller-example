//
//  GCEControllerBehaviour.m
//  GameControllerExample
//
//  Created by Tim Chilvers on 07/01/2014.
//  Copyright (c) 2014 Tim Chilvers. All rights reserved.
//

#import "GCEControllerBehaviour.h"

NSString *const GCEAButtonKey = @"GCEAButtonKey";

@interface GCEControllerBehaviour()

@property (nonatomic,strong) NSMutableDictionary *buttonDownStates;

@end

@implementation GCEControllerBehaviour

- (id)init {
    self = [super init];
    
    if (self != nil) {
        _buttonDownStates = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setupGameController:(GCController *)controller controllingGame:(GCEGameBehaviour *)gameBehaviour {
    
    __weak typeof(self) weakSelf = self;
    
    GCControllerButtonInput *aButton = nil;
    if (controller.gamepad) {
        aButton = controller.gamepad.buttonA;
    } else if (controller.extendedGamepad) {
        aButton = controller.extendedGamepad.buttonA;
    }
    
    aButton.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) {
        
        BOOL firstExecutionForPress = [weakSelf.buttonDownStates[GCEAButtonKey] boolValue] ? NO : YES;
        
        if (pressed && firstExecutionForPress) {
            [gameBehaviour playerJump];
        }
        weakSelf.buttonDownStates[GCEAButtonKey] = @(pressed);
    };

    GCControllerDirectionPad *dpad = nil;
    if (controller.gamepad) {
        dpad = controller.gamepad.dpad;
    } else if (controller.extendedGamepad) {
        dpad = controller.extendedGamepad.dpad;
    }
    
    dpad.valueChangedHandler = ^ (GCControllerDirectionPad *dpad, float xValue, float yValue) {
        NSLog(@"Changed xValue = %f",xValue);
        
        [gameBehaviour playerForceX:xValue];
    };
    
    controller.extendedGamepad.leftThumbstick.valueChangedHandler = dpad.valueChangedHandler;
}

@end
