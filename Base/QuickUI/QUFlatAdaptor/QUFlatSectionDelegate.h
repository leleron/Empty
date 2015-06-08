//
//  QUFlatSectionDelegate.h
//  IWithYou
//
//  Created by zhuojian on 14-9-1.
//
//

#import <Foundation/Foundation.h>
@class QUSection;
@class QUBackgroundButton;

@protocol QUFlatSectionDelegate <NSObject>

@end



@protocol QUFlatSubmitSectionDelegate <NSObject>
@optional
-(void)flatSubmitSection:(QUSection*)section upInsideButton:(QUBackgroundButton*)button;
@end