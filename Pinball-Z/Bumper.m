//
//  Bumper.m
//  Pinball-Z
//
//  Created by Alexander Russ on 4/15/14.
//
//

#import "Bumper.h"
#import "PinballMachineScene.h"

#define BUMPER_RADIUS 24

@implementation Bumper

+(Bumper*)bumper
{

    Bumper* bumper = [Bumper spriteNodeWithImageNamed:@"bumper.png"];
    bumper.size = CGSizeMake(BUMPER_RADIUS*2, BUMPER_RADIUS*2);
    bumper.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:BUMPER_RADIUS];
    bumper.physicsBody.categoryBitMask  = CategoryBumper;
    bumper.physicsBody.collisionBitMask = CategoryBumper | CategoryPinball;
    bumper.physicsBody.contactTestBitMask = CategoryBumper | CategoryPinball | CategoryScene;
    bumper.physicsBody.restitution = 2;
    [bumper.physicsBody setDynamic: NO];
    return bumper;
}

@end
