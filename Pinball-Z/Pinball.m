//
//  Pinball.m
//  Pinball-Z
//
//  Created by Alexander Russ on 4/14/14.
//
//

#import "Pinball.h"
#import "PinballMachineScene.h"
#define PINBALL_RADIUS 12

@implementation Pinball

+(Pinball*)defaultPinball;
{
    Pinball* pinball = [Pinball spriteNodeWithImageNamed:@"pinball.png"];
    pinball.size = CGSizeMake(PINBALL_RADIUS*2,PINBALL_RADIUS*2);
    pinball.isCharged = NO;
    pinball.isDead = NO;
    pinball.physicsBody.affectedByGravity = YES;
    pinball.physicsBody.velocity = CGVectorMake(0, 0);

    pinball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:pinball.frame.size.width/2];
    pinball.physicsBody.friction = 0.0f;
    pinball.physicsBody.restitution = 0.2f;
    pinball.physicsBody.allowsRotation = NO;
    pinball.physicsBody.categoryBitMask  = CategoryPinball;
    pinball.physicsBody.collisionBitMask = CategoryBumper | CategoryPinball | CategoryScene | CategoryFlipper;
    pinball.physicsBody.contactTestBitMask = CategoryBumper | CategoryPinball | CategoryScene | CategoryFlipper;

    return pinball;
}

// + before a method means static method, - means instance
@end
