//
//  QUURLDownLoadParams.h
//  CaoPanBao
//
//  Created by 陈宏伟 on 14-7-3.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "QUMock.h"

@interface QUURLDownLoadParams : QUMockParam
@property(nonatomic,strong)NSString *downLoadUrl;//下载的url地址
@property(nonatomic,assign)int tag;
@end
