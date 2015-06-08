//
//  QuickUI.h
//  CaoPanBao
//
//  Created by zhuojian on 14-4-17.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

// 宏定义
#if !defined(QU_LOG)
#define QULog(...) do {} while (0)
#else
#define QULog(...) NSLog(__VA_ARGS__)
#endif

#define qqEntity(x) ((QUEntity*)(x))

#define QU_MOCK_YES 1 // mock状态

#define QU_MOCK_NO 0  // 非mock状态

#ifndef CaoPanBao_QuickUI_h
#define CaoPanBao_QuickUI_h
#import "QUAdaptor.h"
#import "QUSection.h"
#import "QUSource.h"
#import "QUTableView.h"
#import "MJRefresh.h"
#import "QUTextField.h"
#import "QUEntity.h"
#import "QUMock.h"
#import "QUNetAdaptor.h"
#import "QUNetManager.h"
#import "QUNetResponse.h"
#import "QUHLine.h"

#import "QUFlatAdaptor.h"
#import "QUFlatEmptySection.h"
#import "QUFlatLine.h"
#import "QUFlatEntity.h"
#import "QUButton.h"
#import "QUFlatSubEntity.h"
#import "QUJsonParse.h"
#import "QUKeyboardToolbar.h"
#import "QUURLDownLoadParams.h"
#import "QUNetASIAdaptor.h"

#import "QUPhoneTextField.h"
#import "QUTextField.h"
#import "QUTextView.h"
#import "UITextView+ExtentRange.h"
#import "UITextField+ExtentRange.h"
#import "QUBankCardTextField.h"
#import "QUNibHelper.h"
#import "QUFlatSectionDelegate.h"

#import "QULabel.h"
//#import "QUFlatSection.h"
#endif
