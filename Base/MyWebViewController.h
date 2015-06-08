//
//  MyWebViewController.h
//  CaoPanBao
//
//  Created by zhuojian on 14-4-30.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import "MyViewController.h"

@interface MyWebViewController : MyViewController<UIWebViewDelegate>
@property(nonatomic,strong)IBOutlet UIWebView* viewWeb;
@property(nonatomic,strong)NSString* url;
@property (nonatomic,assign)float fontScale;

+(instancetype)controllerWithUrl:(NSString*)url;
@end
