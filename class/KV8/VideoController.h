//
//  VideoController.h
//  KV8
//
//  Created by MasKSJ on 14-8-13.
//  Copyright (c) 2014年 MasKSJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CamObj.h"
#import "DelegateCamera.h"
#import "MBProgressHUD.h"
#import "RJONE_macvideo.h"       //20141128 EngelChen
#import "SKDropDown.h"
@interface VideoController : UIViewController<DelegateCamera,MBProgressHUDDelegate,RJONE_macvideoDelegate,SKDropDownDelegate>
{
    NSInteger m_nWidth, m_nHeight;
    NSInteger m_nImgDataSize;
    CGColorSpaceRef m_colorSpaceRGB;
	size_t			m_bytesPerRow;
    CGRect mImageVFrame;
    
    char m_bSpeak;
    NSThread *mThreadTimer;
    NSConditionLock *mLockTimer;
    volatile BOOL m_bTimer;
    
    int     SaveImage;  //保存图片是否成功   1       -1     -2    //141129 EngelChen
    NSTimer * savetime;
    
    
}
@property (nonatomic,strong)CamObj *cam;
+(VideoController *)share;
@end
