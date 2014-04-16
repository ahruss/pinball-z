//
//  ViewController.m
//  Pinball-Z
//
//  Created by Alexander Russ on 4/14/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"
#import "PinballMachineScene.h"

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
//    skView.showsPhysics = YES;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
//
    // Create and configure the scene.
    SKScene * scene = [PinballMachineScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
