//
//  MyScene.h
//  Pinball-Z
//

//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Flipper.h"

typedef enum
{
    CategoryFlipper = 0x1 << 0,
    CategoryPinball = 0x1 << 1,
    CategoryBumper  = 0x1 << 2,
    CategoryScene   = 0x1 << 3
} Category;

@interface PinballMachineScene : SKScene

@property (nonatomic) CFTimeInterval lastUpdateTime;
@property (nonatomic, strong) NSMutableArray* pinballs;
@property (nonatomic, weak) Flipper* leftFlipper;
@property (nonatomic, weak) Flipper* rightFlipper;
@property (nonatomic) NSUInteger score;

@property (nonatomic, weak) SKLabelNode* scoreLabel;

@end
