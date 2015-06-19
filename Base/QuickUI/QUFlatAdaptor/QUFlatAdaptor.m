//
//  QUFlatAdaptor.m
//  CaoPanBao
//
//  Created by zhuojian on 14-6-25.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "QUFlatAdaptor.h"
#import "QUSource.h"
#import "QUTableView.h"
#import "QUNibHelper.h"
#import "QUSection.h"
#import "QUKeyboardToolbar.h"
#import "QUTextField.h"
#import "QUFlatLine.h"

@interface QUFlatAdaptor()
@end

@implementation QUFlatAdaptor


#pragma mark - FlatAdaptor

-(void)bindSource:(QUSource *)sources andTableView:(QUTableView *)tableView nibArray:(NSArray *)nibArray backgroundClr:(UIColor*)clr{
    tableView.backgroundColor=clr;
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    NSMutableArray* array=[NSMutableArray arrayWithArray:nibArray];
    
    [array addObject:@"QUFlatEmptySection"]; // attach QUFlatEmptySection.xib
    [array addObject:@"QUFlatSection"]; // attach QUFlatEmptySection.xib
    
    [super bindSource:sources andTableView:tableView nibArray:array];
}

-(void)bindSource:(QUSource *)sources andTableView:(QUTableView *)tableView nibArray:(NSArray *)nibArray{
    [self bindSource:sources andTableView:tableView nibArray:nibArray backgroundClr:QU_FLAT_COLOR_TABLE_BG];
}

+(id)adaptorWithTableView:(QUTableView *)tableView nibArray:(NSArray *)array delegate:(id<QUAdaptorDelegate>)delegate backGroundClr:(UIColor*)clr{
    QUAdaptor* adaptor=[super adaptorWithTableView:tableView nibArray:array delegate:delegate];
    
    tableView.backgroundColor=clr;
    
    return adaptor;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QUEntity* et=[self.pSources entityAtSection:indexPath.section rows:indexPath.row];
    
    NSString* sectionClassName=[self.pSources sectionAtKey:et.key];
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sectionClassName];
    
    //    QULog(@"row:%d",indexPath.row);
    
    if (cell == nil) {
        
        Class cls=NSClassFromString(sectionClassName);
        
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sectionClassName];
        
        
        QUSection* section;
        
        /** 如果实现了自定义Section初始化委托，用于notifyChangeForSection 时，复用现有Section */
        if([self.delegate respondsToSelector:@selector(QUAdaptor:initSectionClass:)])
        {
            section= [self.delegate QUAdaptor:self initSectionClass:cls];
            if(!section)
                section= [QUNibHelper loadNibArray:self.pNibNameArray ofClass:cls];
        }
        
        else
            section= [QUNibHelper loadNibArray:self.pNibNameArray ofClass:cls];
        
        
        if(!section)
            QULog(@"QUNibHelper: failed to load nib");
        
        [section sectionWillLoad]; // 初始化Section 数据
        
        [cell.contentView addSubview:section];
        CGRect frame = cell.frame;
        CGRect window = [[UIScreen mainScreen] bounds];
        frame.size.width = window.size.width;
        cell.contentView.frame = frame;          //将contentView设置成屏幕宽度
        //        cell.contentView.frame=section.frame;
        
        
        
        float cellWidth=cell.contentView.frame.size.width;
        
        
        //        float iosVer=[[[UIDevice currentDevice] systemVersion] floatValue];
        //        if(iosVer>=7.f) // must be ios7+
        //            cell.separatorInset=et.separatorInset;
        
        {
            
            //            if(!et.selectedBgColor)
            //                et.selectedBgColor=[UIColor clearColor];
            
            if(!et.borderLineColor)
                et.borderLineColor=[UIColor clearColor];
            
            //取消选中颜色
            //            UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
            //            backView.backgroundColor=QU_FLAT_COLOR_CELL_BG_SELECTED ;//et.selectedBgColor;
            
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = et.selectedBgColor;
            
            // top line
            Class lineTopClass=et.lineTopColorClass?et.lineTopColorClass:[QUFlatLine class];
            
            Class lineBottomClass=et.lineBottomColorClass?et.lineBottomColorClass:[QUFlatLine class];
            
            QUFlatLine* line=[[lineTopClass alloc] initWithFrame:CGRectMake(0,0, cellWidth, 1.f)];
            line.backgroundColor=[UIColor clearColor];
            //            line.lineColor=[UIColor colorWithRed:200.f/255.f green:200.f/255.f blue:200.f/255.f alpha:1.f];
            line.tag=0;
            section.line_top=line;
            [section addSubview:line];
            
            // bottom line
            QUFlatLine* line2=[[lineBottomClass alloc] initWithFrame:CGRectMake(0,section.frame.size.height-1, cellWidth, 1.f)];
            line2.backgroundColor=[UIColor clearColor];
            //            line2.lineColor=[UIColor colorWithRed:200.f/255.f green:200.f/255.f blue:200.f/255.f alpha:1.f];
            line2.tag=1;
            section.line_bottom=line2;
            
            et.pSection=section;
            
            [section addSubview:line2];
            
            
            //取消边框线
            [cell setBackgroundView:[[UIView alloc] init]];          //取消边框线
            cell.backgroundColor = et.borderLineColor;
        }
        
        /** 初始化构造Section时调用 */
        if([self.delegate respondsToSelector:@selector(QUAdaptor:willDidLoadSection:willDidLoadEntity:)])
        {
            [self.delegate QUAdaptor:self willDidLoadSection:section willDidLoadEntity:et];
        }
        
    }
    
    QUSection* section=[[cell.contentView subviews] objectAtIndex:0];
    CGRect frame = section.frame;
    CGRect window = [[UIScreen mainScreen] bounds];
    frame.size.width = window.size.width;
    section.frame = frame;     //强制填充高度
    
    
    section.pIndexPath=indexPath;  // Cell行信息记录
    
    section.section=indexPath.section;
    section.rows=indexPath.row;
    
    section.pAdaptor=self;
    
    section.entity=et;
    
    et.pSection=section;
    //
    section.line_top.hidden=YES;
    section.line_bottom.hidden=YES;
    
    cell.accessoryType = et.accessoryType; //显示最右边的箭头
    cell.selectionStyle=et.selectionStyle;
    //
    
    QUSectionInfo* info=[self.pSectionInfo objectForKey:NSStringFromClass(section.class)];
    
    if(et.LineTopColor) // 如果存在顶边线，则整体高度+1像素
    {
        section.line_top.hidden=NO;
        
        section.frame=CGRectMake(section.frame.origin.x, section.frame.origin.y, section.frame.size.width,info.frame.size.height+1.f);
        
        if(et.lineBottomColor)
            section.line_bottom.frame=CGRectMake(0, section.frame.size.height-0.5f, section.frame.size.width,0.5f);
    }
    else // 否则只存在底边线，则整体高度+0.5像素
    {
        section.frame=CGRectMake(section.frame.origin.x, section.frame.origin.y, section.frame.size.width,info.frame.size.height+0.5f);
        
        section.line_bottom.frame=CGRectMake(0, section.frame.size.height-.5f, section.frame.size.width,0.5f);
    }
    
    if(!et.selectedBgColor) // 没有设置了选择背景色
    {
        cell.selectedBackgroundView.backgroundColor=nil;
        cell.backgroundView.backgroundColor=[section backgroundColor];
    }
    else
        cell.selectedBackgroundView.backgroundColor=et.selectedBgColor; // 设置了背景色
    
    
    if(et.lineBottomColor)
        section.line_bottom.hidden=NO;
    
    
    {
        if(et.LineTopColor)
        {
            section.line_top.lineColor=et.LineTopColor;
        }
        
        if(et.lineBottomColor)
            section.line_bottom.lineColor=et.lineBottomColor;
    }
    
    if(self.delegate)
    {
        
        [section layoutSection];
        
        if([self.delegate respondsToSelector:@selector(QUAdaptor:forSection:forEntity:)])
        {
            [self.delegate QUAdaptor:self forSection:section forEntity:et];
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    QUEntity* et=[self.pSources entityAtSection:indexPath.section rows:indexPath.row];
    
    //    NSString* sectionClassName=[self.pSources sectionAtIndex:indexPath.section];
    
    NSString* sectionClassName=[self.pSources sectionAtKey:et.key];
    
    QUSectionInfo* info=[self.pSectionInfo objectForKey:sectionClassName];
    
    CGRect frame=[info frame];
    
    if(et.LineTopColor)
    {
        frame=CGRectMake(frame.origin.x, frame.origin.y, frame.size.width,info.frame.size.height+1.f);
    }
    else{
        frame=CGRectMake(frame.origin.x, frame.origin.y, frame.size.width,info.frame.size.height+0.5f);
    }
    
    return frame.size.height;
}

-(void)dealloc{
    
}


@end
