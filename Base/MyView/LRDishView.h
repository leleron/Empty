//
//  LRDishView.h
//  QianFangGuJie
//
//  Created by 李荣 on 15/2/4.
//  Copyright (c) 2015年 余龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LRDishView : UIView
{
    CAShapeLayer* lineShape;        //实线
    CATextLayer* sellLabel[5];      //卖1-5
    CATextLayer* sellPriceLabel[5];
    CATextLayer* sellVolumeLabel[5];
    CATextLayer* buyLabel[5];       //买1-5
    CATextLayer* buyPriceLabel[5];
    CATextLayer* buyVolumeLabel[5];
    CATextLayer* timeLineLabel[10];  //时间流水
    CATextLayer* timePriceLabel[12];  //时间流水价格
    CATextLayer* timeVolumeLabel[12];  //时间流水成交量
    CATextLayer* weibiLabel;        //委比
    CATextLayer* weichaLabel;      //委差
    CATextLayer* weibiValue;       //委比值
    CATextLayer* weichaValue;      //委差值
    CGRect content_frame;          //边框范围
    CGMutablePathRef linePath;      
    
    
    int margin_left;               //左边距
    int margin_right;               //右边距
    int margin_bottom;              //下边距
    int margin_top;              //上边距
    
    float textLength;               //文本长度
    float textWidth;                //文本宽度
    float textSize;                //文本大小
    

}
@property(strong,nonatomic)NSMutableArray* sellPrice;     //卖价1-5
@property(strong,nonatomic)NSMutableArray* buyPrice;      //买价1-5
@property(strong,nonatomic)NSMutableArray* sellAmount;    //卖量1-5
@property(strong,nonatomic)NSMutableArray* buyAmount;     //买量1-5
@property(strong,nonatomic)NSString* currentPrice;            //最新价
@property(strong,nonatomic)NSString* volume;          //成交量
@property(strong,nonatomic)NSString* currentTime;    //当前时间
@property(strong,nonatomic)NSString* weibi;
@property(strong,nonatomic)NSString* weicha;    
@property(strong,nonatomic)NSString* amount;    //成交量
@property(strong,nonatomic)NSString* open;
@property(copy,nonatomic)NSString* YClose;
@property(copy,nonatomic)NSString* price_max;
@property(copy,nonatomic)NSString* price_min;
@property(copy,nonatomic)NSString* High;
@property(copy,nonatomic)NSString* Low;


-(void)initAll;
@end
