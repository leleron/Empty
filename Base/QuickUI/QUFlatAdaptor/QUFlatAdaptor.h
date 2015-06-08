//
//  QUFlatAdaptor.h
//  CaoPanBao
//
//  Created by zhuojian on 14-6-25.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "QUAdaptor.h"

#define QU_FLAT_COLOR_CELL_BG_SELECTED [UIColor colorWithRed:210.f/255.f green:210.f/255.f blue:210.f/255.f alpha:1.f] // 选中单元格背景色

#define QU_FLAT_COLOR_CELL_BG_UNSELECTED [UIColor whiteColor]; // 未选中的背景色

#define QU_FLAT_COLOR_LINE [UIColor colorWithRed:210.f/255.f green:210.f/255.f blue:210.f/255.f alpha:1.f] // 水平线颜色

#define QU_FLAT_COLOR_TABLE_BG [UIColor colorWithRed:240.f/255.f green:240.f/255.f blue:240.f/255.f alpha:1.f] // 表格背景色

#define QU_FLAT_LINE_INDENT 4 // 线条缩进4
#define QU_FLAT_LINE_INDENT_NIL 0 // 线条不缩进


#define QU_FLAT_COLOR_CLEAR [UIColor clearColor] // 透明背景色

#define QU_FLAT_TEXTFIELD_OFFSET_Y 90.f

@interface QUFlatAdaptor : QUAdaptor<UIGestureRecognizerDelegate>

-(void)bindSource:(QUSource *)sources andTableView:(QUTableView *)tableView nibArray:(NSArray *)nibArray backgroundClr:(UIColor*)clr;

+(id)adaptorWithTableView:(QUTableView *)tableView nibArray:(NSArray *)array delegate:(id<QUAdaptorDelegate>)delegate backGroundClr:(UIColor*)clr;
@end
