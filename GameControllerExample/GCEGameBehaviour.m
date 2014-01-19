//
//  GCEGameBehaviour.m
//  GameControllerExample
//
//  Created by Tim Chilvers on 07/01/2014.
//  Copyright (c) 2014 Tim Chilvers. All rights reserved.
//

#import "GCEGameBehaviour.h"
#import "GCEControllerBehaviour.h"

const CGFloat chargeMaxValue = 1.0f;
const CGFloat chargeStartValue = 0.f;
const CGFloat chargeStepValue = 0.05f;
const NSTimeInterval chargeTickInterval = 1.0/60.0;

@interface GCEGameBehaviour()

@property (nonatomic,strong) UIDynamicAnimator *animator;
@property (nonatomic,strong) UIGravityBehavior *gravityBehaviour;
@property (nonatomic,strong) UICollisionBehavior *collisionBehaviour;
@property (nonatomic,strong) GCEControllerBehaviour *controllerBehaviour;
@property (nonatomic,strong) NSTimer *chargeTimer;
@property (nonatomic,weak) UIView *playerView;
@end

const CGVector playerJumpVector = (CGVector){0.0f,-1.0f};
const CGFloat walkInputMinimumThreshold = 0.1f;

@implementation GCEGameBehaviour

- (void)dealloc {
    [_chargeTimer invalidate];
}

- (instancetype)init {
    self = [super init];
    
    if (self != nil) {
        _controllerBehaviour = [[GCEControllerBehaviour alloc] init];
    }
    return self;
}

- (BOOL)playerCanJump {
    
    return YES;
}

- (void)playerJump {
    
    if([self playerCanJump]) {
        self.jumpBehaviour.active = YES;
    }
}

- (void)playerForceX:(CGFloat)xForce {
    
    [self.walkBehaviour setMagnitude:xForce];
    CGFloat force = fabsf(xForce);
    
    if (force < walkInputMinimumThreshold) {
        self.walkBehaviour.active = NO;
    } else {
        self.walkBehaviour.active = YES;
    }
}

-(void)playerStartCharge {

    self.playerView.backgroundColor = [UIColor colorWithRed:chargeStartValue green:chargeStartValue blue:chargeStartValue alpha:1.0f];
    self.chargeTimer = [NSTimer scheduledTimerWithTimeInterval:chargeTickInterval target:self selector:@selector(playerChargeTick) userInfo:nil repeats:YES];
}

-(void)playerChargeTick {
    
    UIColor *currentColor = self.playerView.backgroundColor;
    CGFloat red, green, blue, alpha;
    [currentColor getRed:&red green:&green blue:&blue alpha:&alpha];
    red += chargeStepValue;
    green += chargeStepValue;
    self.playerView.backgroundColor = [UIColor colorWithRed:MAX(red, chargeMaxValue)
                                                      green:MAX(green, chargeMaxValue)
                                                       blue:chargeMaxValue
                                                      alpha:1.0f];
}

-(void)playerChargeUnleash {
    
    [self.chargeTimer invalidate];
    self.playerView.backgroundColor = [UIColor blueColor];
}


- (void)setupEnvironmentPhysicsBehavioursInView:(UIView *)referenceView withPlatforms:(NSArray *)platformViews playerView:(UIView *)playerView {
    
    self.gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:platformViews];
    
    
    self.collisionBehaviour = [[UICollisionBehavior alloc] initWithItems:platformViews];
    self.collisionBehaviour.collisionMode = UICollisionBehaviorModeEverything;
    self.collisionBehaviour.translatesReferenceBoundsIntoBoundary = YES;
    
    [self.gravityBehaviour addItem:playerView];
    [self.collisionBehaviour addItem:playerView];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:referenceView];
    
    [self.animator addBehavior:self.collisionBehaviour];
    [self.animator addBehavior:self.gravityBehaviour];
    
    self.playerView = playerView;
}

- (void)setupActionsForCharacterView:(UIView *)characterView {
    
    self.jumpBehaviour = [[UIPushBehavior alloc] initWithItems:@[characterView] mode:UIPushBehaviorModeInstantaneous];
    [self.jumpBehaviour setPushDirection:playerJumpVector];
    [self.animator addBehavior:self.jumpBehaviour];
    
    self.walkBehaviour = [[UIPushBehavior alloc] initWithItems:@[characterView] mode:UIPushBehaviorModeContinuous];
    [self.animator addBehavior:self.walkBehaviour];
}

- (void)setupGameController:(GCController *)gameController {
    
    [self.controllerBehaviour setupGameController:gameController controllingGame:self];
}


@end
