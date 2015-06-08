//
//  WCFBannerUrlHelper.m
//  CaoPanBao
//
//  Created by zhuojian on 14-8-21.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "WCFBannerUrlHelper.h"

@implementation WCFBannerUrlHelper

+(void)jumpControllerFromDict:(NSDictionary*)dict fromController:(UIViewController*)fromController{

    if(![dict isKindOfClass:[NSDictionary class]])
        return;
    
    
    NSString* ctrlName=[dict objectForKey:@"controller"];
    
    if([ctrlName isKindOfClass:[NSNull class]])
        return;
    
    NSDictionary* maps=[dict objectForKey:@"maps"];
    Class cls=NSClassFromString(ctrlName);
    UIViewController* ctrl=[cls alloc];
    ctrl=[ctrl initWithNibName:ctrlName bundle:nil];
    
    if(!ctrl)
        return;
    
    for (NSString* method in [maps allKeys]) {
//        NSString* setMethod=[NSString stringWithFormat:@"set%@:",[method capitalizedString]];
        
        NSString* firstChar=[[method substringToIndex:1] uppercaseString];
        
        NSString* secondChar=[method substringFromIndex:1];
        
        NSString* setMethod=[NSString stringWithFormat:@"set%@%@:",firstChar,secondChar];
        
        id param=maps[method]; 
        
        SEL sel=NSSelectorFromString(setMethod);
        
        if([ctrl respondsToSelector:sel])
        {
            [ctrl performSelector:sel withObject:param];  // 赋值操作
        }
    }
    
    
    // 弹出控制器
    [fromController.navigationController pushViewController:ctrl animated:YES];
}


@end
