//
//  MyMarqueeLabel.m
//  CaoPanBao
//
//  Created by zhuojian on 14-5-14.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import "MyMarqueeLabel.h"

@interface MyMarqueeLabel()
@property(nonatomic,strong)NSMutableArray* lines;
@property(nonatomic,assign)int index;
@property(nonatomic,assign)BOOL start;
@end

@implementation MyMarqueeLabel

/** 
 装在走马灯并开始跑动画
 @param 显示文本列表
 */
-(void)loadMarquee:(NSMutableArray*)list{
    self.lines=list;
    self.index=0;
    if(!self.start)
        [self startMarquee];

}

-(NSString*)getMarquee{
    if([self.lines count]==0)
        return nil;
    
    if(self.index>[self.lines count]-1)  // 如果到达末尾重置，继续循环
    {
        self.index=0;
    }
    
    NSString* marquee= [self.lines objectAtIndex:self.index];
    
    self.index++;
    
    return marquee;
}

//int test=0;

-(void)startMarquee
{
    self.start=YES;
    NSString* marquee=[self getMarquee];
    self.text=marquee;


    [self sizeToFit];
    
    CGRect parentRect=[self.superview frame];
    
    int fromX=parentRect.size.width;
    
   int toX=0-self.frame.size.width;
    
    self.frame=CGRectMake(fromX, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    
    float perSecondOfPixel=40.f; // 每秒移动40像素
    
    float seconds= self.frame.size.width/perSecondOfPixel;
    
    if(seconds<=11)  // 每个动画最低11秒移动完毕
        seconds=11;
    
    [UIView animateWithDuration:seconds delay:0.f options:UIViewAnimationOptionCurveLinear animations:^{
        self.frame=CGRectMake(toX, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self performSelector:@selector(startMarquee) withObject:nil afterDelay:1.f];

    }];
    
}


@end
