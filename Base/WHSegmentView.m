//
//  WHSegmentView.m
//  CaoPanBao
//
//  Created by 陈宏伟 on 14-7-4.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "WHSegmentView.h"
#define R_L_ButtonColor         [UIColor colorWithRed:247.0f/255.0f green:169.0f/255.0f blue:21.0f/255.0f alpha:1.0f]
@interface WHSegmentView()
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, assign) NSInteger arrayCount;
@property (nonatomic, assign) NSInteger lastSelectIndex;
@end
@implementation WHSegmentView
@synthesize buttonArray,arrayCount,lastSelectIndex,delegate;

- (id)initWithFrame:(CGRect)frame WithTitleArray:(NSArray *)titleArray
{
    self = [super initWithFrame:frame];
    if (self) {
        arrayCount = [titleArray count];
        float height = frame.size.height;
        float width = frame.size.width;
        self.buttonArray = [[NSMutableArray alloc]init];
        
        for (int i = 0; i<arrayCount; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
            UIColor *buttonColor = R_L_ButtonColor;
            [button setTitleColor:buttonColor forState:UIControlStateNormal];
            
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            UIImage *btImage = nil;
            
            if (i == 0) {
                btImage = [UIImage imageNamed:@"leftSelect.png"];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else
            {
                btImage = [UIImage imageNamed:@"rightNoSelect.png"];
            }

            [button setBackgroundImage:btImage forState:UIControlStateNormal];
            [button setBackgroundImage:btImage forState:UIControlStateHighlighted];
            
            //当是一个按钮时
            if (arrayCount == 1) {
            button.frame = CGRectMake(i*width/arrayCount, 0, width/(arrayCount*2), height);
//            btImage = [UIImage imageNamed:@"button_bg_red_300.png"];
            [button setBackgroundImage:btImage forState:UIControlStateNormal];
            [button setBackgroundImage:btImage forState:UIControlStateHighlighted];
            }
            else{
            button.frame = CGRectMake(i*width/arrayCount, 0, width/arrayCount, height);
            }
            [button addTarget:self action:@selector(changeButton:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            [self addSubview:button];
            [self.buttonArray addObject:button];
        }
    }
    return self;
}

-(void)changeButton:(UIButton *)button{
    
    if (lastSelectIndex != button.tag) {
        
        UIButton *selectButton =[self.buttonArray objectAtIndex:button.tag];
        NSString *selectImage = nil;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (button.tag == 0) {
            selectImage = @"leftSelect.png";
        }else{
            selectImage = @"rightSelect.png";
        }
        
        [selectButton setBackgroundImage:[UIImage imageNamed:selectImage] forState:UIControlStateNormal];
        [selectButton setBackgroundImage:[UIImage imageNamed:selectImage] forState:UIControlStateHighlighted];
        
        UIButton *lastButton =[self.buttonArray objectAtIndex:self.lastSelectIndex];
        UIColor *buttonColor = R_L_ButtonColor;
        [lastButton setTitleColor:buttonColor forState:UIControlStateNormal];
        UIImage *lastImage = nil;
        
        if (self.lastSelectIndex == 0) {
            lastImage = [UIImage imageNamed:@"leftNoSelect.png"];
        }else
        {
            lastImage = [UIImage imageNamed:@"rightNoSelect.png"];
        }
        
        [lastButton setBackgroundImage:lastImage forState:UIControlStateNormal];
        [lastButton setBackgroundImage:lastImage forState:UIControlStateHighlighted];
        
        lastSelectIndex = selectButton.tag;
        
        
        if ([delegate respondsToSelector:@selector(changeCustomSegmentSelectIndex:OnSegment:)]) {
            [delegate changeCustomSegmentSelectIndex:button.tag OnSegment:self];
            
        }
    }
    
}

@end
