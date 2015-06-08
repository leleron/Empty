//
//  QUButton.m
//  CaoPanBao
//
//  Created by zhuojian on 14-6-27.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "QUButton.h"
#import "UIImage+RTTint.h"
#import "QUSection.h"
@interface QUButton()
@property(nonatomic,assign)BOOL bInit;

@end

@implementation QUButton

-(void)awakeFromNib{
    
    UIView* parent=[self superview];
    
    if(![parent isKindOfClass:[QUSection class]])
    {
        
    }
    
}

-(void)layoutSubviews{

    [super layoutSubviews];
    
    
}

-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    NSArray* allTarget=[[self allTargets] allObjects];
    
    for (id t in allTarget) {
        NSArray* actionArray=[self actionsForTarget:t forControlEvent:UIControlEventTouchUpInside];
        
        for (NSString* action in actionArray) {
            [self removeTarget:t action:NSSelectorFromString(action) forControlEvents:UIControlEventTouchUpInside];
        }
    }

    [super addTarget:target action:action forControlEvents:controlEvents];
}

@end

@interface QUBackgroundButton()
@property(nonatomic,assign)BOOL bInit;
@property(nonatomic,weak)id outsideTarget;      // 外部target
@property(nonatomic,assign)SEL outsideSelector; // 外部selector
@end

@implementation QUBackgroundButton

-(void)awakeFromNib{
    
    [self refreshImageState];
}

-(void)refreshImageState{
    UIImage* normal= [self backgroundImageForState:UIControlStateNormal];
    self.pBackgroundNormal=normal;
    self.pBackgroundHighLight=[normal rt_darkenWithLevel:0.5];
}

-(void)stateBefore{
//    dispatch_async(dispatch_get_main_queue(), ^{
    
        [self setBackgroundImage:self.pBackgroundHighLight forState:UIControlStateHighlighted];
        [self setBackgroundImage:self.pBackgroundHighLight forState:UIControlStateNormal];
        
//    });
    
    
}

-(void)stateAfter{
//    dispatch_async(dispatch_get_main_queue(), ^{
        [self setBackgroundImage:self.pBackgroundNormal forState:UIControlStateNormal];
        [self setBackgroundImage:self.pBackgroundHighLight forState:UIControlStateHighlighted];
    
//    });
}

-(IBAction)clickedDown:(id)sender
{
    [self stateBefore];
    
    for (id t in [[self allTargets] allObjects]) // 遍历目标监听对象
    {
        NSArray* actionArray=[self actionsForTarget:t forControlEvent:UIControlEventTouchUpInside];
        
        if(t!=self)
        {
            
            self.outsideTarget=t;
            
            self.outsideSelector=NSSelectorFromString([actionArray objectAtIndex:0]);
            
            [super removeTarget:t action:self.outsideSelector forControlEvents:UIControlEventTouchUpInside];

            return;
        }
       
    }
}


-(IBAction)clickedUp:(id)sender{
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05f * NSEC_PER_SEC)); // 1
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
        [self stateAfter];
        
        if(self.outsideTarget)
        {
            [self.outsideTarget performSelectorOnMainThread:self.outsideSelector withObject:self waitUntilDone:YES];
        }
        
    });
}

-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    
    // 移除Background clickedDown 事件
    NSArray* allTarget=[[self allTargets] allObjects];
    
    
    for (id t in allTarget) // 遍历目标监听对象
    {
        NSArray* actionArray=[self actionsForTarget:t forControlEvent:UIControlEventTouchUpInside];
        
        for (NSString* action in actionArray) {
                [super removeTarget:t action:NSSelectorFromString(action) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    [super addTarget:target action:action forControlEvents:controlEvents]; // 外部自定义事件
    
    [super addTarget:self action:@selector(clickedDown:) forControlEvents:UIControlEventTouchDown]; // 内部事件
 
    [super addTarget:self action:@selector(clickedUp:) forControlEvents:UIControlEventTouchUpInside]; // 内部事件

    [super addTarget:self action:@selector(stateAfter) forControlEvents:UIControlEventTouchUpOutside]; // 内部事件

}


@end

@interface QUSwitchButton()
@property(nonatomic,weak)   id  outsideTarget;      // 外部target
@property(nonatomic,assign)SEL  outsideSelector;    // 外部selector
@end
@implementation QUSwitchButton
-(void)awakeFromNib{
    
    [self refreshImageState];
}

-(void)refreshImageState{
    
    UIImage* normal= [self imageForState:UIControlStateNormal];
    UIImage* selected=[self imageForState:UIControlStateSelected];
    
    self.pBackgroundNormal=normal;
    self.pBackgroundSelected=selected;
    
    [self setChecked:NO];  // 默认未选中状态
    
}

-(void)setChecked:(BOOL)checked
{
    
    self.bChecked=checked;
    
    if(checked)
    {
        [self setImage:self.pBackgroundSelected forState:UIControlStateNormal];
        [self setImage:[self.pBackgroundSelected rt_darkenWithLevel:0.1f] forState:UIControlStateHighlighted];
    }
    else{
        [self setImage:self.pBackgroundNormal forState:UIControlStateNormal];
        [self setImage:[self.pBackgroundNormal rt_darkenWithLevel:0.1f] forState:UIControlStateHighlighted];
    }
}


-(void)stateBefore{}

-(void)stateAfter{}

-(IBAction)clickedDown:(id)sender
{
    [self stateBefore];
    
    for (id t in [[self allTargets] allObjects]) // 遍历目标监听对象
    {
        NSArray* actionArray=[self actionsForTarget:t forControlEvent:UIControlEventTouchUpInside];
        
        if(t!=self)
        {
            
            self.outsideTarget=t;
            
            self.outsideSelector=NSSelectorFromString([actionArray objectAtIndex:0]);
            
            [super removeTarget:t action:self.outsideSelector forControlEvents:UIControlEventTouchUpInside];
            
            return;
        }
        
    }
}


-(IBAction)clickedUp:(id)sender{
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05f * NSEC_PER_SEC)); // 1
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
        if(self.bChecked)
            self.bChecked=NO;
        else
            self.bChecked=YES;
        
        [self setChecked:self.bChecked];
        
        if(self.outsideTarget)
        {
            [self.outsideTarget performSelectorOnMainThread:self.outsideSelector withObject:self waitUntilDone:YES];
        }
    });
}

-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    
    // 移除Background clickedDown 事件
    NSArray* allTarget=[[self allTargets] allObjects];
    
    
    for (id t in allTarget) // 遍历目标监听对象
    {
        NSArray* actionArray=[self actionsForTarget:t forControlEvent:UIControlEventTouchUpInside];
        
        for (NSString* action in actionArray) {
            [super removeTarget:t action:NSSelectorFromString(action) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    [super addTarget:target action:action forControlEvents:controlEvents]; // 外部自定义事件
    
    [super addTarget:self action:@selector(clickedDown:) forControlEvents:UIControlEventTouchDown]; // 内部事件
    
    [super addTarget:self action:@selector(clickedUp:) forControlEvents:UIControlEventTouchUpInside]; // 内部事件
    
    [super addTarget:self action:@selector(stateAfter) forControlEvents:UIControlEventTouchUpOutside]; // 内部事件
    
}


@end

@implementation QUImageButton
@end