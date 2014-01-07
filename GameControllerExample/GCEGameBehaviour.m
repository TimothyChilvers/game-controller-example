//
//  GCEGameBehaviour.m
//  GameControllerExample
//
//  Created by Tim Chilvers on 07/01/2014.
//  Copyright (c) 2014 Tim Chilvers. All rights reserved.
//

#import "GCEGameBehaviour.h"

@interface GCEGameBehaviour()

@property (nonatomic,strong) UIDynamicAnimator *animator;
@property (nonatomic,strong) UIGravityBehavior *gravityBehaviour;
@property (nonatomic,strong) UICollisionBehavior *collisionBehaviour;
@property (nonatomic,strong) UIPushBehavior *jumpBehaviour;
@property (nonatomic,strong) UIPushBehavior *walkBehaviour;

@end

const CGVector playerJumpVector = (CGVector){0.0f,-1.0f};
const CGFloat walkInputMinimumThreshold = 0.1f;

@implementation GCEGameBehaviour

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
}

- (void)setupActionsForCharacterView:(UIView *)characterView {
    
    self.jumpBehaviour = [[UIPushBehavior alloc] initWithItems:@[characterView] mode:UIPushBehaviorModeInstantaneous];
    [self.jumpBehaviour setPushDirection:playerJumpVector];
    [self.animator addBehavior:self.jumpBehaviour];
    
    self.walkBehaviour = [[UIPushBehavior alloc] initWithItems:@[characterView] mode:UIPushBehaviorModeContinuous];
    [self.animator addBehavior:self.walkBehaviour];
}


@end
