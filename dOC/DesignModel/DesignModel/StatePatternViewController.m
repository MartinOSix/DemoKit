//
//  StatePatternViewController.m
//  DesignModel
//
//  Created by runo on 17/2/21.
//  Copyright © 2017年 com.runo. All rights reserved.
//

#import "StatePatternViewController.h"

@class Context,LiftState,OpenningStates,ClosingState,RunningState,StoppingState;
@interface LiftState : NSObject
@property(nonatomic,strong)Context *context;
-(void)open;
-(void)close;
-(void)run;
-(void)stope;
-(void)getElectricty;
@end

@interface Electricty : LiftState
@end

@interface OpenningStates : LiftState
@end

@interface ClosingState : LiftState
@end

@interface Context : NSObject
@property(nonatomic,strong)LiftState *liftState;
@end

@interface RunningState : LiftState
@end

@interface StoppingState : LiftState
@end

@implementation Context{
}

-(void)setLiftState:(LiftState *)liftState{
    _liftState = liftState;
    _liftState.context = self;
}

-(void)open{
    [self.liftState open];
}

-(void)close{
    [self.liftState close];
}

-(void)run{
    [self.liftState run];
}

-(void)stop{
    [self.liftState stope];
}

-(void)getElectricty{
    [self.liftState getElectricty];
}

+(OpenningStates *)opnningState{
    static OpenningStates *open = nil;
    if (open == nil) {
        open = [OpenningStates new];
    }
    return open;
}

+(ClosingState *)closingState{
    static ClosingState *open = nil;
    if (open == nil) {
        open = [ClosingState new];
    }
    return open;
}

+(RunningState *)runningState{
    static RunningState *open = nil;
    if (open == nil) {
        open = [RunningState new];
    }
    return open;
}

+(StoppingState *)stoppingState{
    static StoppingState *open = nil;
    if (open == nil) {
        open = [StoppingState new];
    }
    return open;
}

+(Electricty *)electrictyState{
    static Electricty *open = nil;
    if (open == nil) {
        open = [Electricty new];
    }
    return open;
}

@end


@implementation LiftState
-(void)open{};
-(void)close{};
-(void)run{};
-(void)stope{};
-(void)getElectricty{};
@end


@implementation OpenningStates

-(void)close{
    self.context.liftState = [Context closingState];
    [self.context.liftState close];
}

-(void)open{
    NSLog(@"电梯门开门");
}

-(void)run{
    
}

-(void)stope{
    
}
-(void)getElectricty{
 
 
}
@end

@implementation ClosingState
-(void)close{
    NSLog(@"电梯门关闭...");
}
-(void)open{
    self.context.liftState = [Context opnningState];
    [self.context.liftState open];
}
-(void)run{
    self.context.liftState = [Context runningState];
    [self.context.liftState run];
}
-(void)stope{
    
}
-(void)getElectricty{
    self.context.liftState = [Context electrictyState];
    [self.context.liftState getElectricty];
}
@end

@implementation RunningState
-(void)close{
    
}
-(void)open{
    
}
-(void)run{
    NSLog(@"电梯上下跑...");
}
-(void)stope{
    self.context.liftState = [Context stoppingState];
    [self.context.liftState stope];
}
-(void)getElectricty{
    
}
@end


@implementation StoppingState
-(void)open{
    self.context.liftState = [Context opnningState];
    [self.context.liftState open];
}
-(void)run{
    self.context.liftState = [Context runningState];
    [self.context.liftState run];
}
-(void)close{
    
}
-(void)stope{
    NSLog(@"电梯停止了");
}
-(void)getElectricty{
    self.context.liftState = [Context electrictyState];
    [self.context.liftState getElectricty];
}
@end

@implementation Electricty

-(void)getElectricty{
    NSLog(@"通电中...");
}

-(void)open{
    self.context.liftState = [Context opnningState];
    [self.context.liftState open];
}

-(void)close{
    
}

-(void)run{
    self.context.liftState = [Context runningState];
    [self.context.liftState run];
}

-(void)stope{
    self.context.liftState = [Context stoppingState];
    [self.context.liftState stope];
}

@end

@interface StatePatternViewController ()
@end
@implementation StatePatternViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    Context *context = [[Context alloc]init];
    context.liftState = [ClosingState new];
    [context open];
    [context close];
    [context run];
    [context stop];
    [context getElectricty];
    [context open];
    
}




@end
