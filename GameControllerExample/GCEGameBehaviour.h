//
//  GCEGameBehaviour.h
//  GameControllerExample
//
//  Created by Tim Chilvers on 07/01/2014.
//  Copyright (c) 2014 Tim Chilvers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameController/GameController.h>

@interface GCEGameBehaviour : NSObject

@property (nonatomic,strong) UIPushBehavior *jumpBehaviour;
@property (nonatomic,strong) UIPushBehavior *walkBehaviour;

-(void)playerJump;
-(void)playerForceX:(CGFloat)forceX;

- (void)setupEnvironmentPhysicsBehavioursInView:(UIView *)referenceView withPlatforms:(NSArray *)platformViews playerView:(UIView *)playerView;
- (void)setupActionsForCharacterView:(UIView *)characterView;
- (void)setupGameController:(GCController *)gameController;

@end
