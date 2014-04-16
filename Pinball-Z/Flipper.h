//
//  Flipper.h
//  Pinball-Z
//
//  Created by Alexander Russ on 4/14/14.
//
//

#import <SpriteKit/SpriteKit.h>

#define FLIPPER_MIN_ANGLE -(10.0/180*M_PI)
#define FLIPPER_MAX_ANGLE (40.0/180*M_PI)

typedef enum
{
    FlipperOrientationLeft,
    FlipperOrientationRight
} FlipperOrientation;

@interface Flipper : SKSpriteNode

+(Flipper*)flipperWithOrientation:(FlipperOrientation)orientation;

@property (nonatomic) BOOL isActivating;
@property (nonatomic) BOOL isActive;
@property (nonatomic) FlipperOrientation orientation;

@end
