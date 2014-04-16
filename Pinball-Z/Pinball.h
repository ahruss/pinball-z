//
//  Pinball.h
//  Pinball-Z
//
//  Created by Alexander Russ on 4/14/14.
//
//

#import <SpriteKit/SpriteKit.h>

@interface Pinball : SKSpriteNode

+(Pinball*)defaultPinball;

@property (nonatomic) bool isCharged;
@property (nonatomic) bool isDead;

@end
