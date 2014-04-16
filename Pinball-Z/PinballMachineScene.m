//
//  MyScene.m
//  Pinball-Z
//
//  Created by Alexander Russ on 4/14/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "PinballMachineScene.h"
#import "Pinball.h"
#import "Flipper.h"
#import "Bumper.h"
#import <CoreMotion/CoreMotion.h>

@interface PinballMachineScene() <SKPhysicsContactDelegate>
@end

@implementation PinballMachineScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor whiteColor];

        // Initialize the array
        //    @selector(methodName:withOtherStuff:)
        //        [obj methodName:parameter withOtherStuff:anotherParameter];
        //        [NSArray arrayWithObjects:obj1, obj2, nil];
        self.pinballs = NSMutableArray.array;

        Pinball* p = Pinball.defaultPinball;
        p.position = CGPointMake(100,self.frame.size.height);
        p.physicsBody.velocity = CGVectorMake(400, 10);
        [self addChild:p];
        [self.pinballs addObject:p];

        self.lastUpdateTime = 0;

        CGMutablePathRef border = CGPathCreateMutable();
        CGFloat width          = self.frame.size.width;
        CGFloat height         = self.frame.size.height;
        CGFloat holeWidth      = 0.2;
        CGFloat flipperPadding = 0.15;

        CGPathMoveToPoint(border,    NULL,  width*(0.5-holeWidth/2), 0);
        CGPathAddLineToPoint(border, NULL,  0,       height/5);
        CGPathAddLineToPoint(border, NULL,  0,       height);
        CGPathAddLineToPoint(border, NULL,  width,   height);
        CGPathAddLineToPoint(border, NULL,  width,   height/5);
        CGPathAddLineToPoint(border, NULL,  width*(0.5+holeWidth/2),   0);

        SKShapeNode *shape = [SKShapeNode node];
        CGPathCloseSubpath(border);

        shape.path = border;
        shape.fillColor = [SKColor blackColor];
        shape.zPosition = -1;
        [self addChild:shape];

        self.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:border];
//        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.friction = 0.0f;
        self.physicsBody.restitution = 0.4;
        self.physicsWorld.gravity = CGVectorMake(0, -10);
        self.physicsWorld.contactDelegate = self;
        self.physicsBody.contactTestBitMask = CategoryPinball | CategoryFlipper | CategoryBumper;
        self.physicsBody.collisionBitMask = CategoryFlipper | CategoryFlipper | CategoryPinball | CategoryScene;
        self.physicsBody.categoryBitMask = CategoryScene;

        Flipper* leftFlipper = [Flipper flipperWithOrientation:FlipperOrientationLeft];
        leftFlipper.position = CGPointMake(width*(0.5-flipperPadding/2)-(1-leftFlipper.anchorPoint.x)*leftFlipper.size.width,
                                            height*0.07);
        [self addChild:leftFlipper];
        self.leftFlipper = leftFlipper;

        Flipper* rightFlipper = [Flipper flipperWithOrientation:FlipperOrientationRight];
        rightFlipper.position = CGPointMake(width*(0.5+flipperPadding/2)+(1-rightFlipper.anchorPoint.x)*rightFlipper.size.width,
                                            height*0.07);
        [self addChild:rightFlipper];
        self.rightFlipper = rightFlipper;

        Bumper* b = [Bumper bumper];
        b.position = CGPointMake(width*0.5, height*0.7);
        [self addChild:b];

        SKLabelNode* scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        scoreLabel.position = CGPointMake(10, height-90);
        scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        [self addChild:scoreLabel];
        self.scoreLabel.zPosition = 100;
        self.scoreLabel = scoreLabel;


        self.score = 0;
    }
    return self;
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    if (contact.bodyA.categoryBitMask & CategoryBumper || contact.bodyB.categoryBitMask & CategoryBumper)
    {
        self.score++;
    }
    else if (contact.bodyA.categoryBitMask & CategoryFlipper && [(Flipper*)(contact.bodyA.node) isActivating])
    {
        NSLog(@"applying impulse");
        CGFloat distanceFromCenter = abs(contact.bodyA.node.position.x - self.frame.size.width/2);
        CGFloat maxDist = self.frame.size.width/2;
        [contact.bodyB applyImpulse:CGVectorMake(0, 10*(1-distanceFromCenter/maxDist))];
    }
    else if (contact.bodyB.categoryBitMask & CategoryFlipper && [(Flipper*)(contact.bodyB.node) isActivating])
    {
        NSLog(@"applying impulse");
        CGFloat distanceFromCenter = abs(contact.bodyB.node.position.x - self.frame.size.width/2);
        CGFloat maxDist = self.frame.size.width/2;
        [contact.bodyA applyImpulse:CGVectorMake(0, 10*(1-distanceFromCenter/maxDist))];
    }
}

-(void)setScore:(NSUInteger)score
{
    static NSInteger oldHighScore = -1;
    if (oldHighScore < 0)
    {
        oldHighScore = [[NSUserDefaults.standardUserDefaults objectForKey:@"highScore"]intValue];
    }

    _score = score;
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", score];

    if (score > oldHighScore)
    {
        [NSUserDefaults.standardUserDefaults setObject:@(score) forKey:@"highScore"];
        oldHighScore = score;
    }

    NSLog(@"score: %u", score);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches)
    {
        CGPoint touchLocation = [touch locationInNode:self];
        if (touchLocation.y < 100 && touchLocation.x < self.frame.size.width/2)  self.leftFlipper.isActive = YES;
        else if (touchLocation.y < 100 && touchLocation.x > self.frame.size.width/2) self.rightFlipper.isActive = YES;
        else if (self.pinballs.count < 100)
        {
            Pinball* p = Pinball.defaultPinball;
            p.position = [touch locationInNode:self];
            p.physicsBody.velocity = CGVectorMake(((int)arc4random_uniform(3)-1)*200, 100);
            [self addChild:p];
            [self.pinballs addObject:p];
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint touchLocation = [touch locationInNode:self];
        if (touchLocation.y < 100 && touchLocation.x < self.frame.size.width/2)  self.leftFlipper.isActive = YES;
        else if (touchLocation.y < 100 && touchLocation.x > self.frame.size.width/2) self.rightFlipper.isActive = YES;
        else if (self.pinballs.count < 100)
        {
            Pinball* p = Pinball.defaultPinball;
            p.position = [touch locationInNode:self];
            p.physicsBody.velocity = CGVectorMake(((int)arc4random_uniform(3)-1)*200, 100);
            [self addChild:p];
            [self.pinballs addObject:p];
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch* touch in touches)
    {
        CGPoint touchLocation = [touch locationInNode:self];
        if (touchLocation.y < 100 && touchLocation.x < self.frame.size.width/2)  self.leftFlipper.isActive = NO;
        else if (touchLocation.y < 100 && touchLocation.x > self.frame.size.width/2) self.rightFlipper.isActive = NO;
    }
}

-(void)update:(CFTimeInterval)currentTime
{

    [self.pinballs enumerateObjectsUsingBlock:^(Pinball* obj, NSUInteger idx, BOOL *stop) {
        if (obj.position.y < 0)
        {
            [self.pinballs removeObject:obj];
            [obj removeFromParent];
        }
    }];

    if (self.lastUpdateTime != 0)
    {
        CFTimeInterval delta = currentTime - self.lastUpdateTime;
    }

    self.lastUpdateTime = currentTime;
}

@end
