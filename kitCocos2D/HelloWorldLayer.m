//
//  HelloWorldLayer.m
//  kitCocos2D
//
//  Created by Sofía Swidarowicz on 26/01/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer
@synthesize spriteFromSheet = vspriteFromSheet;
@synthesize walkAction = vwalkAction;
@synthesize moveAction = vmoveAction;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        
       // CCDirector *director = [CCDirector sharedDirector];
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *background = [CCSprite spriteWithFile:@"backgroundRetina.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];

        
        CCSprite *sprite = [CCSprite spriteWithFile:@"bug.png"];
        sprite.position =  ccp( size.width/2 , size.height/2);
        [self addChild:sprite];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"NCat.plist"];
        CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"NCat.png"];
        [self addChild:spriteSheet];
        
        self.spriteFromSheet = [CCSprite spriteWithSpriteFrameName:@"capatostada1.png"];
		vspriteFromSheet.position =  ccp(size.width * 0.1, size.height * 0.5);
		[spriteSheet addChild:vspriteFromSheet];
        
        
        NSMutableArray *walkAnimFrames = [NSMutableArray array];
        for(int i = 1; i <= 12; ++i) {
            [walkAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"capa%d.png", i]]];
        }
        
        CCAnimation *walkAnim = [CCAnimation animationWithFrames:walkAnimFrames delay:0.1f];
        self.walkAction = [CCRepeatForever actionWithAction:
                           [CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
        
        [vBatchNode addChild:vspriteFromSheet z:-1];
        [vspriteFromSheet runAction:vwalkAction];
        
        self.isTouchEnabled = YES;

    
    }
    
	return self;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {    
    
    CGPoint touchLocation = [touch locationInView: [touch view]];		
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    
    //Para que el gato se mueva por el ancho de la pantalla del iPhone (480 pixels), estimamos 3 seg  
    // V = d/t  480 pixeles / 3 seg
    
    float catVelocity = 480.0/3.0;
    
    // se calcula la posición del toque y del gato, para luego obtener la diferencia entre ambos. Es lo
    // que se tendrá que mover el gato al punto del touch
    CGPoint moveDifference = ccpSub(touchLocation, vspriteFromSheet.position);
    
    //Se calcula la distancia real en la que ha movido el gato en una línea recta. Una hipotenusa que ya calcula 
    // ccpLenght emplean o la diferencia de posición obtenida entre el punto a y b (el gato con el touch)
    float distanceToMove = ccpLength(moveDifference);
    
    //Lo que durará el gato en movimiento al trasladarse. Lo obtenido del calculo de la hipotenusa, lo que debe
    //moverse en realidad sobre la velocidad (pix / seg)
    float moveDuration = distanceToMove / catVelocity;
    
    //Ahora se debe saber si el gato se debe mover a la izq o a la derecha. Si es menor a cero debe voltearse.
    //Como Nyan Cat está mirando a la derecha, pues si es >0 se queda como está, sino debe voltearse para que mire a 	//la izq. De este modo COCOS2D nos facilita la tarea de no tener que crear varios sprites (uno mirando para un 		//lado y otro mirando para el contrario)
    if (moveDifference.x > 0) {
        vspriteFromSheet.flipX = NO;
    } else {
        vspriteFromSheet.flipX = YES;
    }
    
    
    //Hacemos que el sprite se detenga la acción de movimiento, porque debemos anular cualquier comando 
    //que ya existiera para decirle que mueva el gato a otra posición :D
    [vspriteFromSheet stopAction:vmoveAction];
    [vspriteFromSheet stopAction:vwalkAction];
    
    //Le indicamos que se mueva al lugar que hemos calculado, proveniente del touch
    if (!vmoving) {
        [vspriteFromSheet runAction:vwalkAction];
    }
    
    //
    self.moveAction = [CCSequence actions:                          
                       [CCMoveTo actionWithDuration:moveDuration position:touchLocation],
                       [CCCallFunc actionWithTarget:self selector:@selector(catMoveEnded)],
                       nil];
    
    [vspriteFromSheet runAction:vmoveAction];   
    vmoving = TRUE; 
}




-(void) registerWithTouchDispatcher
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 
                                              swallowsTouches:YES];
}
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	return YES;
}

-(void)catMoveEnded {
    [vspriteFromSheet stopAction:vwalkAction];
    [vspriteFromSheet runAction:vwalkAction];
    vmoving = FALSE;
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
