//
//  GCEControllerBehaviour.h
//  GameControllerExample
//
//  Created by Tim Chilvers on 07/01/2014.
//  Copyright (c) 2014 Tim Chilvers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameController/GameController.h>
#import "GCEGameBehaviour.h"

@interface GCEControllerBehaviour : NSObject

- (void)setupGameController:(GCController *)controller controllingGame:(GCEGameBehaviour *)gameBehaviour;

@end
