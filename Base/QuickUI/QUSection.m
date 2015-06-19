//
//  QUSection.m
//  WeiPay
//
//  Created by zhuojian on 14-3-13.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "QUSection.h"
#import "QuickUI.h"


@implementation QUSectionInfo
//-(CGRect)sectionRect{
//    return [self.section frame];
//}

@end



@interface QUSection()
{
    BOOL bLoaded;
}
@end

@implementation QUSection

// default is 1
-(NSUInteger)count{
    return 1;
}

-(NSIndexPath*)indexPath{
    return [NSIndexPath indexPathForRow:self.rows inSection:self.section];
}

-(void)fillParent{
    /*
     CGRect tableRect=self.pAdaptor.pTableView.frame;
     if(tableRect.size.width==self.frame.size.width && tableRect.size.height==self.frame.size.height)
     {
     return;
     }
     
     self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.pAdaptor.pTableView.frame.size.width, self.pAdaptor.pTableView.frame.size.height);
     
     NSString* clsName=NSStringFromClass([self class]);
     QUSectionInfo* info=[self.pAdaptor.pSectionInfo objectForKey:clsName];
     info.frame=self.frame;
     
     [self.pAdaptor.pTableView reloadData];
     */
    
    CGRect tableRect=self.pAdaptor.pTableView.frame;
    if(tableRect.size.width==self.frame.size.width && tableRect.size.height==self.frame.size.height)
    {
        return;
    }
    //        parentView.frame=CGRectMake(parentView.frame.origin.x, parentView.frame.origin.y, self.pAdaptor.pTableView.frame.size.width, self.pAdaptor.pTableView.frame.size.height);
    
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.pAdaptor.pTableView.frame.size.width,_isSlideOniPhone4?kWindowHeightiPhone5:self.pAdaptor.pTableView.frame.size.height);
    
    NSString* clsName=NSStringFromClass([self class]);
    QUSectionInfo* info=[self.pAdaptor.pSectionInfo objectForKey:clsName];
    info.frame=self.frame;
    
    [self.pAdaptor.pTableView reloadData];
    
    
    //    CGRect tableRect=self.pAdaptor.pTableView.frame;
    //
    //    NSString* clsName=NSStringFromClass([self class]);
    //    QUSectionInfo* info=[self.pAdaptor.pSectionInfo objectForKey:clsName];
    //
    //    if(tableRect.size.width==info.frame.size.width && tableRect.size.height==info.frame.size.height)
    //    {
    //        return;
    //    }
    //
    //    self.frame=CGRectMake(info.frame.origin.x, info.frame.origin.y, info.frame.size.width, info.frame.size.height);
    //
    //    [self.pAdaptor.pTableView reloadData];
}



-(CGRect)rectSection{
    return self.frame;
}


/** 布局视图 */
-(void)layoutSection{
    if(!bLoaded)
    {
        bLoaded=YES;
        [self sectionDidLoad];
        return;
    }
    
}

/** 已经载入视图 */
-(void)sectionDidLoad{
    
}

/** 将要载入视图 */
-(void)sectionWillLoad{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QUTableViewSelectedCellReloadNotify:) name:QU_TABLE_CELL_SELECTED_RELOAD_NOTIFY object:nil];
}

+(instancetype)section{
    return [[self alloc] init];
}



-(void)inflate:(QUEntity *)entity{
    
}

/** 获取某个类别数组 */
-(NSArray*)viewWithClass:(Class)viewClass{
    NSMutableArray* array=[NSMutableArray arrayWithCapacity:10];
    
    for (UIView *aView in [self subviews])  // 四层搜索
    {
        if([aView isMemberOfClass:viewClass])
            [array addObject:aView];
        
        for (UIView *bView in [aView subviews])
        {
            if([aView isMemberOfClass:viewClass])
                [array addObject:bView];
            
            for (UIView *cView in [bView subviews])
            {
                if([aView isMemberOfClass:viewClass])
                    [array addObject:cView];
                
                for (UIView *dView in [cView subviews])
                {
                    if([aView isMemberOfClass:viewClass])
                        [array addObject:dView];
                }
            }
        }
    }
    
    return array;
}


#pragma mark notify delegate


-(void)QUTableViewSelectedCellReloadNotify:(NSNotification*)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        Class sectionClass=[notification.userInfo objectForKey:@"sectionClass"];
        
        NSNumber* animation=[notification.userInfo objectForKey:@"animation"];
        
        NSNumber* tag=[notification.userInfo objectForKey:@"tag"];
        
        if([self isMemberOfClass:sectionClass])
        {
            if(!tag)  // 没有设置标记，则发送给匹配的Section
            {
                [self.pAdaptor.pTableView reloadRowsAtIndexPaths:@[self.pIndexPath] withRowAnimation:[animation integerValue]];
            }
            else      // 如果设置了标记，直接发送调用
            {
                if(self.entity.tag==[tag integerValue])
                {
                    [self.pAdaptor.pTableView reloadRowsAtIndexPaths:@[self.pIndexPath] withRowAnimation:[animation integerValue]];
                }
            }
        }
    });
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
