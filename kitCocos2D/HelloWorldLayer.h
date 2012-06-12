//
//  HelloWorldLayer.h
//  kitCocos2D
//
//  Created by Sofía Swidarowicz on 26/01/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    CCSprite   * vspriteFromSheet; 
    CCSpriteBatchNode  *vBatchNode;
    
    CCAction *vwalkAction;
    
    CCAction *vmoveAction;
    BOOL vmoving;
}
@property (nonatomic, retain) CCSprite *spriteFromSheet;
@property (nonatomic, retain) CCAction *walkAction;
@property (nonatomic, retain) CCAction *moveAction;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
