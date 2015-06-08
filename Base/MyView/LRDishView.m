//
//  LRDishView.m
//  QianFangGuJie
//
//  Created by 李荣 on 15/2/4.
//  Copyright (c) 2015年 余龙. All rights reserved.
//

#import "LRDishView.h"
@interface LRDishView(){
    
}
@property(strong,nonatomic)NSString* hasFill;   //判断当前盘口流水填充数据否
@end
@implementation LRDishView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)initAll{
    [self drawLine];
    self.hasFill = @"NO";
}

-(void)drawLine{
    [self initLayer];
    linePath = CGPathCreateMutable();
    CGPathAddRect(linePath, nil, CGRectMake(content_frame.origin.x, content_frame.origin.y, content_frame.size.width, textLength*11));
    float y = content_frame.origin.y + 5.5 * textLength;
    //坐标中间横线
    CGPathAddRect(linePath, nil, CGRectMake(content_frame.origin.x, y, content_frame.size.width*0.58, 0.25));
    //中间竖线
    CGPathAddRect(linePath, nil, CGRectMake(content_frame.origin.x + content_frame.size.width*0.58, content_frame.origin.y, 0.25, textLength*11));
    y =content_frame.origin.y + 11* textLength;
    CGPathAddRect(linePath, nil, CGRectMake(content_frame.origin.x, y, content_frame.size.width, 0.25));
  //  CGPathAddRect(linePath, nil, CGRectMake(content_frame.origin.x+content_frame.size.width/4, y, 0.25, content_frame.size.height-y));
    lineShape.path = linePath;
    lineShape.strokeColor = [[UIColor grayColor]CGColor];
  //  [self.layer addSublayer:lineShape];
    
}


-(void)initLayer{
    margin_bottom=5;
    margin_left=22.5;
    margin_right=23;
    margin_top=5;
    textSize = 13.f;
    if (iPhone4) {
        textSize = 8.f;
    }
    CGRect rect = [UIScreen mainScreen].bounds;
    content_frame = CGRectMake(0, 0, self.frame.size.width*rect.size.width/375 ,276*rect.size.height/667);
    if (iPhone4) {
        content_frame.size.height = 150;
        textLength = 15;
    }
    textWidth = content_frame.size.width/2;
  //  textLength = content_frame.size.height/12;
    if (iPhone5) {
        textLength = 27*HEIGTH6TO5;
        margin_right = 23*WIDTH6TO5;
        margin_left = 22.5*WIDTH6TO5;
    }else if(iPhone6 || iPhone6Plus)
       textLength = 27;
    
    [self initLabels];
}


-(void)initLabels{
    
    
    
    if(!lineShape)
    {
        lineShape=[CAShapeLayer layer];
        lineShape.frame=self.frame;
        lineShape.strokeColor=[[UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:.15] CGColor];
        lineShape.lineWidth=0.5f;
        lineShape.zPosition=1;
        lineShape.fillColor=[[UIColor clearColor] CGColor];
        //        lineShape.lineDashPattern=@[@4,@4];
        
        [self.layer addSublayer:lineShape];
        
        lineShape.frame=content_frame;
    }

    
    
    NSInteger sellCount = [self.sellPrice count];
    for (int i = 0; i<sellCount; i++) {
        
        if (!sellLabel[i]) {
            sellLabel[i] = [CATextLayer layer];
            sellPriceLabel[i] = [CATextLayer layer];
            sellVolumeLabel[i] = [CATextLayer layer];
        }
            sellLabel[i].zPosition = 2;
            sellPriceLabel[i].zPosition =2;
            sellVolumeLabel[i].zPosition = 2;
            float x = content_frame.origin.x +margin_left;
            float y = content_frame.origin.y + textLength * i + margin_top;
            sellLabel[i].frame = CGRectMake(x, y, textWidth, textLength);
   //         CATextLayer* priceLabel = [CATextLayer layer];
   //         CATextLayer* volumeLabel = [CATextLayer layer];
           sellVolumeLabel[i].font = sellPriceLabel[i].font = sellLabel[i].font = (__bridge CFTypeRef)([[UIFont systemFontOfSize:14.0f]fontName]);
            sellVolumeLabel[i].fontSize = sellPriceLabel[i].fontSize = sellLabel[i].fontSize = textSize;
            sellVolumeLabel[i].alignmentMode = kCAAlignmentRight;
            NSString* sellStr = nil;
            switch (i) {
                case 0:
                    sellStr = @"卖五";
                    break;
                case 1:
                    sellStr = @"卖四";
                    break;
                case 2:
                    sellStr = @"卖三";
                    break;
                case 3:
                    sellStr = @"卖二";
                    break;
                case 4:
                    sellStr = @"卖一";
                    break;
                default:
                    break;
            }
            sellLabel[i].string = [NSString stringWithFormat:@"%@",sellStr];
           sellVolumeLabel[i].contentsScale = sellPriceLabel[i].contentsScale =  sellLabel[i].contentsScale = [[UIScreen mainScreen] scale];

            sellPriceLabel[i].string = [NSString stringWithFormat:@"%.2f",[self.sellPrice[i] floatValue]];
            sellVolumeLabel[i].string = [NSString stringWithFormat:@"%d",(int)[self.sellAmount[i] intValue]/100];
           sellVolumeLabel[i].backgroundColor = sellPriceLabel[i].backgroundColor = [[UIColor clearColor]CGColor];
            sellPriceLabel[i].foregroundColor = (__bridge CGColorRef)(Color_Bg_1bc07d);
          sellLabel[i].foregroundColor= sellVolumeLabel[i].foregroundColor = [[UIColor blackColor]CGColor];
            sellPriceLabel[i].frame = CGRectMake(x+textWidth/3, y, textWidth/4, textLength);
            sellVolumeLabel[i].frame = CGRectMake(sellPriceLabel[i].frame.origin.x + textWidth/4, y, textWidth/3, textLength);
            sellVolumeLabel[i].alignmentMode =  kCAAlignmentRight;
            [self.layer addSublayer:sellPriceLabel[i]];
            [self.layer addSublayer:sellVolumeLabel[i]];
            [self.layer addSublayer:sellLabel[i]];
            
            
     //   }
        
        
    }
    
    
    NSInteger buyCount = [self.buyPrice count];
    
    for (int i = 0; i<buyCount; i++) {
        
        if (!buyLabel[i]) {
            buyLabel[i] = [CATextLayer layer];
            buyPriceLabel[i] = [CATextLayer layer];
            buyVolumeLabel[i] = [CATextLayer layer];
        }
            float x = content_frame.origin.x + margin_left;
            float y = content_frame.origin.y + textLength * (i+6) +margin_top;
            buyLabel[i].frame = CGRectMake(x, y, textWidth, textLength);
       //     CATextLayer* priceLabel = [CATextLayer layer];
       //     CATextLayer* volumeLabel = [CATextLayer layer];
            buyVolumeLabel[i].font = buyPriceLabel[i].font = buyLabel[i].font =  (__bridge CFTypeRef)([[UIFont systemFontOfSize:14.0f]fontName]);
             buyVolumeLabel[i].fontSize = buyPriceLabel[i].fontSize = buyLabel[i].fontSize = textSize;
            buyVolumeLabel[i].alignmentMode = kCAAlignmentRight;
            NSString* buyStr = nil;
            switch (i) {
                case 0:
                    buyStr = @"买一";
                    break;
                case 1:
                    buyStr = @"买二";
                    break;
                case 2:
                    buyStr = @"买三";
                    break;
                case 3:
                    buyStr = @"买四";
                    break;
                case 4:
                    buyStr = @"买五";
                    break;
                default:
                    break;
            }
            buyLabel[i].string = [NSString stringWithFormat:@"%@",buyStr];
            buyVolumeLabel[i].contentsScale = buyPriceLabel[i].contentsScale =  buyLabel[i].contentsScale = [[UIScreen mainScreen] scale];
            
            buyPriceLabel[i].string = [NSString stringWithFormat:@"%.2f",[self.buyPrice[i] floatValue]];
            buyVolumeLabel[i].string =[NSString stringWithFormat:@"%d", (int)[self.buyAmount[i] intValue]/100];
            buyVolumeLabel[i].backgroundColor = buyPriceLabel[i].backgroundColor = [[UIColor clearColor]CGColor];
            buyPriceLabel[i].foregroundColor = (__bridge CGColorRef)(Color_Bg_1bc07d);
            buyLabel[i].foregroundColor = buyVolumeLabel[i].foregroundColor = [[UIColor blackColor]CGColor];
            buyPriceLabel[i].frame = CGRectMake(x+textWidth/3, y, textWidth/3, textLength);
            buyVolumeLabel[i].frame = CGRectMake(x+textWidth/1.5, y, textWidth/4, textLength);
            [self.layer addSublayer:buyVolumeLabel[i]];
            [self.layer addSublayer:buyPriceLabel[i]];
            [self.layer addSublayer:buyLabel[i]];
   //     }
        
        
    }
    self.hasFill = @"NO";
//    for ( int i = 0; i<12; i++) {
//        if (!timeLineLabel[i] && self.currentPrice && [self.hasFill isEqualToString:@"NO"]) {
//            self.hasFill = @"YES";
//            timeLineLabel[i] = [CATextLayer layer];
//         //   timeLineLabel[i].zPosition =4;
//            timePriceLabel[i] = [CATextLayer layer];
//            timeVolumeLabel[i] = [CATextLayer layer];
//       //     CATextLayer* priceLabel = [CATextLayer layer];
//        //    CATextLayer* volumeLabel = [CATextLayer layer];
//            
//            
//            
//            
//            float x = content_frame.origin.x + content_frame.size.width/2 + margin_left;
//            float y = content_frame.origin.y + (12-i)*textLength - textLength;
//            timeLineLabel[i].frame = CGRectMake(x, y, textWidth, textLength);
//            
//            timeVolumeLabel[i].backgroundColor = timePriceLabel[i].backgroundColor = [[UIColor clearColor]CGColor];
//            timePriceLabel[i].foregroundColor = (__bridge CGColorRef)(Color_Bg_1bc07d);
//            timeVolumeLabel[i].foregroundColor = timeLineLabel[i].foregroundColor = [[UIColor blackColor]CGColor];
//            timePriceLabel[i].frame = CGRectMake(x+textWidth/3, y, textWidth/3, textLength);
//            timeVolumeLabel[i].frame = CGRectMake(x+textWidth/1.5, y, textWidth/4, textLength);
//
//            
//            
//            timeVolumeLabel[i].font = timePriceLabel[i].font = timeLineLabel[i].font = (__bridge CFTypeRef)([[UIFont systemFontOfSize:15.0f]fontName]);
//            timeVolumeLabel[i].fontSize = timePriceLabel[i].fontSize = timeLineLabel[i].fontSize = 10.0f;
//            timePriceLabel[i].foregroundColor = (__bridge CGColorRef)(Color_Bg_1bc07d);
//            timePriceLabel[i].backgroundColor = timeVolumeLabel[i].backgroundColor = [[UIColor clearColor]CGColor];
//            NSRange range = NSMakeRange(11, 8);
//            self.currentTime = [self.currentTime substringWithRange:range];
//            timeLineLabel[i].string = self.currentTime;
//            timePriceLabel[i].string = self.currentPrice;
//            timeVolumeLabel[i].string = [NSString stringWithFormat:@"%d",[self.volume intValue]/100];
//            timeVolumeLabel[i].alignmentMode = kCAAlignmentRight;
//            [self.layer addSublayer:timePriceLabel[i]];
//            [self.layer addSublayer:timeVolumeLabel[i]];
//            [self.layer addSublayer:timeLineLabel[i]];
//            
//        }
//    }
//    if ([self.hasFill isEqualToString:@"NO"]) {
//        
//        for (int i = 0; i<11; i++) {
//            timeLineLabel[i].string = timeLineLabel[i+1].string;
//            timePriceLabel[i].string = timePriceLabel[i+1].string;
//            timeVolumeLabel[i].string = timeVolumeLabel[i+1].string;
//        }
//        NSRange range = NSMakeRange(11, 8);
//        self.currentTime = [self.currentTime substringWithRange:range];
//        timeLineLabel[11].string = self.currentTime;
//        timePriceLabel[11].string = self.currentPrice;
//        timeVolumeLabel[11].string = [NSString stringWithFormat:@"%d",[self.volume intValue]/100];
//    }
    
for (int i =0; i<10; i++) {
  
    if (!timeLineLabel[i] && self.currentPrice){
    timeLineLabel[i] = [CATextLayer layer];
 //   timeLineLabel[i].zPosition =4;
    timePriceLabel[i] = [CATextLayer layer];
    timeVolumeLabel[i] = [CATextLayer layer];
    }
//     CATextLayer* priceLabel = [CATextLayer layer];
//    CATextLayer* volumeLabel = [CATextLayer layer];
   float x = content_frame.origin.x + content_frame.size.width*0.58 + margin_left;
    float y = content_frame.origin.y + (10-i)*textLength*1.1 - textLength;
    timeLineLabel[i].frame = CGRectMake(x, y, textWidth, textLength);

    timeVolumeLabel[i].backgroundColor = timePriceLabel[i].backgroundColor = [[UIColor clearColor]CGColor];
  //  timePriceLabel[i].foregroundColor = (__bridge CGColorRef)(Color_Bg_1bc07d);
    timeVolumeLabel[i].foregroundColor = timeLineLabel[i].foregroundColor = [[UIColor blackColor]CGColor];
    timePriceLabel[i].frame = CGRectMake(x+textWidth/5, y, textWidth/1.5, textLength);
    timeVolumeLabel[i].frame = CGRectMake(content_frame.origin.x+content_frame.size.width-textWidth/2.8-margin_right, y, textWidth/2.5, textLength);

        timeLineLabel[i].contentsScale = timeVolumeLabel[i].contentsScale = [[UIScreen mainScreen] scale];

    timeVolumeLabel[i].font = timePriceLabel[i].font = timeLineLabel[i].font = (__bridge CFTypeRef)([[UIFont systemFontOfSize:13.0f]fontName]);
    timeVolumeLabel[i].fontSize = timePriceLabel[i].fontSize = timeLineLabel[i].fontSize = textSize;
    timePriceLabel[i].foregroundColor = (__bridge CGColorRef)(Color_Bg_1bc07d);
    timePriceLabel[i].backgroundColor = timeVolumeLabel[i].backgroundColor = [[UIColor clearColor]CGColor];
//    NSRange range = NSMakeRange(11, 8);
//    self.currentTime = [self.currentTime substringWithRange:range];
//    timeLineLabel[i].string = @"开盘";
//    timePriceLabel[i].string = self.currentPrice;
//    timeVolumeLabel[i].string = [NSString stringWithFormat:@"%d",[self.volume intValue]/100];
    
    timeVolumeLabel[i].alignmentMode = kCAAlignmentRight;
//    [self.layer addSublayer:timePriceLabel[i]];
    [self.layer addSublayer:timeVolumeLabel[i]];
    [self.layer addSublayer:timeLineLabel[i]];
// }
}
    if (!weibiLabel) {
        weibiLabel = [CATextLayer layer];
        weibiValue = [CATextLayer layer];
    }
        float x = content_frame.origin.x + margin_left;
        float y = content_frame.origin.y + 11.3*textLength;
        weibiLabel.frame = CGRectMake(x, y, textWidth/4, textLength);
        weibiValue.frame = CGRectMake(x + textWidth/8, y, textWidth/4, textLength);
        weibiLabel.font = weibiValue.font =  (__bridge CFTypeRef)([[UIFont systemFontOfSize:14.0f]fontName]);
        weibiValue.fontSize = weibiLabel.fontSize = 10.0f;
        if ([self.weibi floatValue]>0) {
            weibiValue.foregroundColor = (__bridge CGColorRef)(Color_Bg_fc4653);
        }else
            weibiValue.foregroundColor = (__bridge CGColorRef)(Color_Bg_1bc07d);

        weibiLabel.foregroundColor = [[UIColor blackColor]CGColor];
        weibiLabel.string = @"委比";
        self.weibi = [NSString stringWithFormat:@"%.2f%%",[self.weibi floatValue]];
        weibiValue.contentsScale = weibiLabel.contentsScale = [[UIScreen mainScreen] scale];
        //     [self.layer addSublayer:weibiLabel];
        //     [self.layer addSublayer:weibiValue];
//    }
    
    
    if (!weichaLabel) {
        weichaLabel = [CATextLayer layer];
        weichaValue = [CATextLayer layer];
    }
         x = content_frame.origin.x + margin_left + content_frame.size.width/4;
         y = content_frame.origin.y + 11.3*textLength;
        weichaLabel.frame = CGRectMake(x, y, textWidth/4, textLength);
        weichaValue.frame = CGRectMake(x + textWidth/8, y, textWidth/4, textLength);
        weichaLabel.font = weichaValue.font =  (__bridge CFTypeRef)([[UIFont systemFontOfSize:14.0f]fontName]);
        weichaValue.fontSize = weichaLabel.fontSize = 10.0f;
        
        weichaLabel.foregroundColor = [[UIColor blackColor]CGColor];
        weichaLabel.string = @"委差";
        self.weicha = [NSString stringWithFormat:@"%.2f",[self.weicha floatValue]/100];
        weichaValue.contentsScale = weichaLabel.contentsScale = [[UIScreen mainScreen] scale];
        //        [self.layer addSublayer:weichaLabel];
        //        [self.layer addSublayer:weichaValue];
//    }

    
    timeLineLabel[9].string = @"开盘";
    timeVolumeLabel[9].string = [NSString stringWithFormat:@"%.2f",[self.open floatValue]];
    timeLineLabel[8].string = @"昨收";
    timeVolumeLabel[8].string = [NSString stringWithFormat:@"%.2f",[self.YClose floatValue]];
    timeLineLabel[7].string = @"最高";
    timeVolumeLabel[7].string = [NSString stringWithFormat:@"%.2f",[self.High floatValue]];
    timeLineLabel[6].string = @"最低";
    timeVolumeLabel[6].string = [NSString stringWithFormat:@"%.2f",[self.Low floatValue]];
    timeLineLabel[5].string = @"涨停";
    timeVolumeLabel[5].string = [NSString stringWithFormat:@"%.2f",[self.price_max floatValue]];
    timeLineLabel[4].string = @"跌停";
    timeVolumeLabel[4].string = [NSString stringWithFormat:@"%.2f",[self.price_min floatValue]];
    timeLineLabel[3].string = @"委比";
    timeVolumeLabel[3].string =[NSString stringWithFormat:@"%.2f%%",[self.weibi floatValue]*100];
    timeLineLabel[2].string=@"委差";
    timeVolumeLabel[2].string = [NSString stringWithFormat:@"%.2f",[self.weicha floatValue]/100];
    timeLineLabel[1].string = @"总量";
    timeVolumeLabel[1].string = [NSString stringWithFormat:@"%d",[self.amount intValue]];
    timeLineLabel[0].string = @"总额";
    timeVolumeLabel[0].string = [NSString stringWithFormat:@"%@",self.volume];
//
    if ([self.open floatValue]>[self.YClose floatValue]) {
        timeVolumeLabel[9].foregroundColor = (__bridge CGColorRef)(Color_Bg_fc4653);
    }else
        timeVolumeLabel[9].foregroundColor = (__bridge CGColorRef)(Color_Bg_1bc07d);
    
    if ([self.High floatValue]>[self.YClose floatValue]) {
        timeVolumeLabel[7].foregroundColor = (__bridge CGColorRef)(Color_Bg_fc4653);
    }else
        timeVolumeLabel[7].foregroundColor = (__bridge CGColorRef)(Color_Bg_1bc07d);

    if ([self.Low floatValue]>[self.YClose floatValue]) {
        timeVolumeLabel[6].foregroundColor = (__bridge CGColorRef)(Color_Bg_fc4653);
    }else
        timeVolumeLabel[6].foregroundColor = (__bridge CGColorRef)(Color_Bg_1bc07d);
 
    timeVolumeLabel[5].foregroundColor = (__bridge CGColorRef)(Color_Bg_fc4653);
    timeVolumeLabel[4].foregroundColor = (__bridge CGColorRef)(Color_Bg_1bc07d);
    
    
    if ([self.weibi floatValue]>0) {
        timeVolumeLabel[3].foregroundColor = (__bridge CGColorRef)(Color_Bg_fc4653);
    }else
        timeVolumeLabel[3].foregroundColor = (__bridge CGColorRef)(Color_Bg_1bc07d);

    
    if ([self.weicha floatValue]>0) {
        timeVolumeLabel[2].foregroundColor = (__bridge CGColorRef)(Color_Bg_fc4653);
    }else
       timeVolumeLabel[2].foregroundColor = (__bridge CGColorRef)(Color_Bg_1bc07d);
    

   
}

@end
