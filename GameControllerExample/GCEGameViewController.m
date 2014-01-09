//
//  GCEGameViewController.m
//  GameControllerExample
//
//  Created by Tim Chilvers on 06/01/2014.
//  Copyright (c) 2014 Tim Chilvers. All rights reserved.
//

#import "GCEGameViewController.h"
#import <GameController/GameController.h>
#import "GCEDiscoverControllerInterface.h"
#import "GCEGameBehaviour.h"

@interface GCEGameViewController ()

@property (nonatomic,strong) NSArray *platformViews;
@property (nonatomic,strong) UILabel *playerCharacter;
@property (nonatomic,strong) GCEDiscoverControllerInterface *controllerDiscoveryInterface;
@property (nonatomic,strong) GCEGameBehaviour *gameBehaviour;
@property (nonatomic,strong) UILabel *controllerLabel;
@end

const NSInteger platformViewCount = 6;
const NSInteger platformMinimumSize = 10;
const NSInteger platformMaximumSize = 44; // Actually +minimum size
const CGFloat platformInsetFromEdges = 22.0f;

@implementation GCEGameViewController

- (id)init {
    self = [super init];
    
    if (self != nil) {
        _controllerDiscoveryInterface = [[GCEDiscoverControllerInterface alloc] init];
        _gameBehaviour = [[GCEGameBehaviour alloc] init];
    }
    return self;
}

- (void)dealloc {
    
    [_controllerDiscoveryInterface stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupControllerLabel];
    [self setupPlatformViews];
    [self setupPlayerCharacter];
    [self.gameBehaviour setupEnvironmentPhysicsBehavioursInView:self.view
                                                  withPlatforms:self.platformViews
                                                     playerView:self.playerCharacter];
    [self.gameBehaviour setupActionsForCharacterView:self.playerCharacter];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];


    __weak typeof(self) weakSelf = self;
    
    [self.controllerDiscoveryInterface discoverController:^(GCController *gameController) {
        [weakSelf.gameBehaviour setupGameController:gameController];
        self.controllerLabel.text = @"Connected";
    } disconnectedCallback:^{
        self.controllerLabel.text = @"Disconnected";
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.controllerDiscoveryInterface stop];
}

#pragma mark - View Setup

- (void)setupPlatformViews {
    
    NSMutableArray *tempPlatformViews = [NSMutableArray arrayWithCapacity:platformViewCount];
    
    CGFloat maxOriginConstraint = MIN(self.view.bounds.size.width,self.view.bounds.size.height);
    
    CGPoint maxOrigin = {maxOriginConstraint - platformInsetFromEdges,maxOriginConstraint - platformInsetFromEdges};
    
    for (NSInteger i = 0; i < platformViewCount; i++) {
        
        CGPoint origin = (CGPoint){(arc4random() % (NSInteger)maxOrigin.x) + (platformInsetFromEdges * 0.5f),
                                   (arc4random() % (NSInteger)maxOrigin.y) + (platformInsetFromEdges * 0.5f)};
        CGSize size = (CGSize){platformMinimumSize + arc4random() % platformMaximumSize,
                               platformMinimumSize + arc4random() % platformMaximumSize};
        
        UIView *platformView = [[UIView alloc] initWithFrame:(CGRect){origin,size}];
        [tempPlatformViews addObject:platformView];
        [self.view addSubview:platformView];
        
        CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0f];
        
        platformView.backgroundColor = color;
    }
    
    self.platformViews = [NSArray arrayWithArray:tempPlatformViews];
}


- (void)setupPlayerCharacter {
    
    self.playerCharacter = [[UILabel alloc] init];
    self.playerCharacter.text = @"Jeff";
    [self.playerCharacter sizeToFit];
    
    CGFloat minimumScreenSize = MIN(self.view.bounds.size.width,self.view.bounds.size.height);
    self.playerCharacter.center = (CGPoint){minimumScreenSize * .5f, minimumScreenSize * .5f};
    
    self.playerCharacter.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.playerCharacter];
}

- (void)setupControllerLabel {
    
    self.controllerLabel = [[UILabel alloc] init];
    self.controllerLabel.text = @"Waiting for controller";
    [self.controllerLabel sizeToFit];
    self.controllerLabel.center = (CGPoint){CGRectGetMidX(self.view.bounds),CGRectGetMidY(self.controllerLabel.frame) + 20.f};
    self.controllerLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:self.controllerLabel];
}

@end
