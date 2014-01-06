//
//  GCEGameViewController.m
//  GameControllerExample
//
//  Created by Tim Chilvers on 06/01/2014.
//  Copyright (c) 2014 Tim Chilvers. All rights reserved.
//

#import "GCEGameViewController.h"
#import <GameController/GameController.h>

@interface GCEGameViewController ()

@property (nonatomic,strong) NSArray *platformViews;

@end

const NSInteger platformViewCount = 17;
const NSInteger platformMinimumSize = 10;
const NSInteger platformMaximumSize = 88; // Actually +minimum size
const CGFloat platformInsetFromEdges = 22.0f;

@implementation GCEGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupPlatformViews];
}

- (void)setupPlatformViews {
    
    NSMutableArray *tempPlatformViews = [NSMutableArray arrayWithCapacity:platformViewCount];
    
    CGPoint maxOrigin = {self.view.bounds.size.width - platformInsetFromEdges,self.view.bounds.size.height - platformInsetFromEdges};
    
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

@end
