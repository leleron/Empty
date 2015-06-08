//
//  QUNibHelper.m
//  WeiPay
//
//  Created by zhuojian on 14-3-25.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "QUNibHelper.h"

@interface QUNibHelper()
@property(nonatomic,strong)NSMutableDictionary* dictNib;

@end

@implementation QUNibHelper

-(instancetype)init{
    self=[super init];
    
    self.dictNib=[NSMutableDictionary dictionaryWithCapacity:20];
    
    return self;
}


+ (id)loadNibNamed:(NSString *)nibName ofClass:(Class)objClass {
    if (nibName && objClass) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:nibName
                                                         owner:nil
                                                       options:nil];
        for (id currentObject in objects ){
            if ([currentObject isMemberOfClass:objClass])
                return currentObject;
        }
    }
    
    return nil;
}

+ (id)loadNibArray:(NSArray *)nibArray ofClass:(Class)objClass {
    for (NSString* nibName in nibArray) {
        id obj=[self loadNibNamed:nibName ofClass:objClass];
        if(obj)
            return obj;
    }
    
    return nil;
}

+(NSArray*)loadNibNamed:(NSString *)nibName{
    return [[NSBundle mainBundle] loadNibNamed:nibName
                                                     owner:nil
                                                   options:nil];
}


#pragma mark - instance

- (id)loadNibNamed:(NSString *)nibName ofClass:(Class)objClass {
    
    id currentObj;
    
    if (nibName && objClass) {
        
        NSString* currentKey=NSStringFromClass(objClass);

        currentObj=self.dictNib[currentKey];
        
        // 未载入nib，初次加载操作
        if(!currentObj)
        {
          NSArray *objects = [[NSBundle mainBundle] loadNibNamed:nibName
                                                         owner:nil
                                                       options:nil];
        
        // 缓存载入的nib视图
         for (id obj in objects) {
            NSString* key=NSStringFromClass([obj class]);
            if(!self.dictNib[key])
            {
                self.dictNib[key]=obj;
            }
         }
        }
        
        currentObj= self.dictNib[currentKey];
        
//        for (id currentObject in objects ){
//            if ([currentObject isMemberOfClass:objClass])
//                return currentObject;
//        }
    }
    
    return currentObj;
}

- (id)loadNibArray:(NSArray *)nibArray ofClass:(Class)objClass {
    for (NSString* nibName in nibArray) {
        id obj=[self loadNibNamed:nibName ofClass:objClass];
        if(obj)
            return obj;
    }
    
    return nil;
}

-(void)dealloc{
    [self.dictNib removeAllObjects];
    self.dictNib=nil;
}

@end

