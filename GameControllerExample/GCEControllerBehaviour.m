//
//  GCEControllerBehaviour.m
//  GameControllerExample
//
//  Created by Tim Chilvers on 07/01/2014.
//  Copyright (c) 2014 Tim Chilvers. All rights reserved.
//

#import "GCEControllerBehaviour.h"

NSString *const GCEJumpButtonKey = @"GCEJumpButtonKey";

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
    
    GCControllerButtonInput *jumpButton = nil;
    if (controller.gamepad) {
        jumpButton = controller.gamepad.buttonA;
    } else if (controller.extendedGamepad) {
        jumpButton = controller.extendedGamepad.buttonA;
    }
    
    jumpButton.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) {
        
        BOOL firstExecutionForPress = [weakSelf.buttonDownStates[GCEJumpButtonKey] boolValue] ? NO : YES;
        
        if (pressed && firstExecutionForPress) {
            [gameBehaviour playerJump];
        }
        weakSelf.buttonDownStates[GCEJumpButtonKey] = @(pressed);
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
