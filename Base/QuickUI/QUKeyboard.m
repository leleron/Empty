//
//  QUKeyboard.h
//  CaoPanBao
//
//  Created by 陈宏伟 on 14-6-25.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "QUKeyboard.h"
#define kLineWidth 0.5
#define kNumFont [UIFont systemFontOfSize:27]
@implementation QUKeyboard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bounds = CGRectMake(0, 0, 320, 216);

        for (int i=0; i<4; i++)
        {
            for (int j=0; j<3; j++)
            {
                UIButton *button = [self creatButtonWithX:i Y:j];
                [self addSubview:button];
            }
        }
        
        UIColor *color = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1];
        //
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(105, 0, kLineWidth, 216)];
        line1.backgroundColor = color;
        [self addSubview:line1];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(214, 0, kLineWidth, 216)];
        line2.backgroundColor = color;
        [self addSubview:line2];
        
        for (int i=0; i<3; i++)
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 54*(i+1), 320, kLineWidth)];
            line.backgroundColor = color;
            [self addSubview:line];
        }
        
    }
    return self;
}

-(UIButton *)creatButtonWithX:(NSInteger) x Y:(NSInteger) y
{
    UIButton *button;
    //
    CGFloat frameX;
    CGFloat frameW;
    switch (y)
    {
        case 0:
            frameX = 0.0;
            frameW = 106.0;
            break;
        case 1:
            frameX = 105.0;
            frameW = 110.0;
            break;
        case 2:
            frameX = 214.0;
            frameW = 106.0;
            break;
            
        default:
            break;
    }
    CGFloat frameY = 54*x;
    
    //
    button = [[UIButton alloc] initWithFrame:CGRectMake(frameX, frameY, frameW, 54)];
    
    //
    NSInteger num = y+3*x+1;
    button.tag = num;
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIColor *colorNormal = [UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1];
    UIColor *colorHightlighted = [UIColor colorWithRed:186.0/255 green:189.0/255 blue:194.0/255 alpha:1.0];
    
    if (num == 10 || num == 12)
    {
        UIColor *colorTemp = colorNormal;
        colorNormal = colorHightlighted;
        colorHightlighted = colorTemp;
    }
    button.backgroundColor = colorNormal;
    CGSize imageSize = CGSizeMake(frameW, 54);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [colorHightlighted set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [button setImage:pressedColorImg forState:UIControlStateHighlighted];
    
    

    if (num<10)
    {
        UILabel *labelNum = [[UILabel alloc] initWithFrame:CGRectMake(0,12, frameW, 28)];
        labelNum.text = [NSString stringWithFormat:@"%ld",(long)num];
        labelNum.textColor = [UIColor blackColor];
        labelNum.backgroundColor = [UIColor clearColor];
        labelNum.textAlignment = NSTextAlignmentCenter;
        labelNum.font = kNumFont;
        [button addSubview:labelNum];
        
    }
    else if (num == 11)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, frameW, 28)];
        label.text = @"0";
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = kNumFont;
        [button addSubview:label];
    }
    else if (num == 10)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, frameW, 28)];
        label.text = @"X";
        label.font = [UIFont systemFontOfSize:22];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [button addSubview:label];
    }
    else
    {
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(42, 19, 22, 17)];
        arrow.image = [UIImage imageNamed:@"arrowInKeyboard"];
        [button addSubview:arrow];
        
    }
    
    return button;
}


-(void)clickButton:(UIButton *)sender
{
    if (sender.tag == 10)
    {
        NSString *num = @"X";
        [self.delegate numberKeyboardInput:num];
    }
    else if(sender.tag == 12)
    {
        [self.delegate numberKeyboardBackspace];
    }
    else
    {
        NSInteger num = sender.tag;
        if (sender.tag == 11)
        {
            num = 0;
        }
        [self.delegate numberKeyboardInput:[NSString stringWithFormat:@"%ld",(long)num]];
    }
}



@end
