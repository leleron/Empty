
//
//  WHLabelView.m
//  自定义label demo
//
//  Created by 陈宏伟 on 14-6-11.
//  Copyright (c) 2014年 sunlight. All rights reserved.
//

#import "WHLabelView.h"
#define X frame.origin.x
#define Y frame.origin.y
#define WIDTH frame.size.width
#define HEIGHT frame.size.height

@implementation WHLabelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)createSubView:(NSArray *)textArray{
    int numCount = 1,widthCount=0;
    
    for (NSArray *tempArray in textArray) {
        UILabel *tempLabel = (UILabel*) [self viewWithTag:numCount];
        float y = tempLabel.Y;
        float height = tempLabel.HEIGHT;
        tempLabel.text = [tempArray objectAtIndex:0];
        [tempLabel sizeToFit];
        tempLabel.frame = CGRectMake(0+widthCount, y, tempLabel.WIDTH, height);
        if (tempArray.count > 1) {
            NSString *spacing = [tempArray objectAtIndex:1];
            widthCount += tempLabel.WIDTH+spacing.floatValue;
        }
        numCount++;
    }
    
}



- (NSString *)getText{
    NSMutableString *nowText = [[NSMutableString alloc]init];
    int numCount = 1;
    for (id subView in [self subviews]) {
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *tempLabel = (UILabel*) [self viewWithTag:numCount];
            [nowText appendString:tempLabel.text];
            numCount++;
        }
    }

    return nowText;
}
@end
