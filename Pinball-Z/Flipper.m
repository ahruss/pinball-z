//
//  Flipper.m
//  Pinball-Z
//
//  Created by Alexander Russ on 4/14/14.
//
//

#define FLIPPER_WIDTH 100
#define FLIPPER_HEIGHT 48

#import "Flipper.h"
#import "PinballMachineScene.h"

@implementation Flipper

+(Flipper*)flipperWithOrientation:(FlipperOrientation)orientation
{
    Flipper* flipper = [Flipper spriteNodeWithImageNamed:@"flipper.png"];
    flipper.size = CGSizeMake(FLIPPER_WIDTH, FLIPPER_HEIGHT);
    flipper.anchorPoint = CGPointMake(0.2, 0.5);
    CGFloat xScale = flipper.xScale = (orientation == FlipperOrientationLeft) ? 1 : -1;
//    flipper.yScale = xScale;

    CGAffineTransform t = CGAffineTransformMakeScale(xScale, xScale);

    CGMutablePathRef physicsPath = CGPathCreateMutable();
    CGPathMoveToPoint(physicsPath,    &t,  0,                   0.5*FLIPPER_HEIGHT);
    CGPathAddLineToPoint(physicsPath, &t,  0.8*FLIPPER_WIDTH,  -0.3*FLIPPER_HEIGHT);
    CGPathAddLineToPoint(physicsPath, &t,  0,                  -0.5*FLIPPER_HEIGHT);
    CGPathAddLineToPoint(physicsPath, &t, -0.2*FLIPPER_WIDTH,   0.0);
    CGPathAddLineToPoint(physicsPath, &t,  0,                   0.5*FLIPPER_HEIGHT);
    CGPathAddLineToPoint(physicsPath, &t,  0,                   0.0);
    flipper.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:physicsPath];

    flipper.isActive = NO;

    flipper.physicsBody.categoryBitMask  = CategoryFlipper;
    flipper.physicsBody.collisionBitMask = CategoryFlipper | CategoryPinball | CategoryBumper;
    flipper.physicsBody.contactTestBitMask = CategoryPinball | CategoryFlipper | CategoryBumper | CategoryScene;
    return flipper;
}

-(void)setIsActive:(BOOL)isActive
{
    CGFloat newAngle = self.xScale * (isActive? FLIPPER_MAX_ANGLE : FLIPPER_MIN_ANGLE);
    CFTimeInterval time = 0.08;
    if (isActive && !_isActive)
    {
        [self runAction:[SKAction sequence:@[[SKAction runBlock:^{
            self.physicsBody.restitution = 1.8;
            self.isActivating = YES;
        }],
                             [SKAction waitForDuration:time*2],
                             [SKAction runBlock:^{
            self.physicsBody.restitution = 0.3;
            self.isActivating = NO;

        }]]]];
//        NSArray* bodies = self.physicsBody.allContactedBodies;
//        for (SKPhysicsBody* body in bodies)
//        {
//            NSLog(@"%@", body);
//        }
    }
    else
    {
        self.physicsBody.restitution = 0.3;
    }


    SKAction* flipAction = [SKAction rotateToAngle:newAngle duration:time];
    [self runAction:flipAction];
    _isActive = isActive;
}

@end
