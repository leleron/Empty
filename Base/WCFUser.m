//
//  WpUser.m
//  CaoPanBao
//
//  Created by QDS on 14-4-15.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import "WCFUser.h"
#import "WpCommonFunction.h"

@implementation WCPUser

@synthesize wcpUserId;
@synthesize wcpUserPhoto;
@synthesize wcpNickName;

@synthesize profitAmount;
@synthesize withdrawAmount;
@synthesize freezeAmount;

@end


#pragma mark - WCFUser

static WCFUser *_globalUser = nil;
static dispatch_once_t wpdispath = 0;

@implementation WCFUser

@synthesize memberId;
@synthesize activeStatus;
@synthesize certified;
@synthesize mobileBinded;
@synthesize realName;
@synthesize identityCard;
// @synthesize headImg;
@synthesize mobile;
@synthesize lastLoginTime;
@synthesize bindUid;
@synthesize wbId;
@synthesize headImgURL;

@synthesize loginFlowId;
@synthesize enterLoginSysTag;
@synthesize userLoggedInTag;
@synthesize requestCookies;

@synthesize wcpUser;


//@synthesize needValidMobile;
//@synthesize wbNickname;
//@synthesize cpbToken;
//@synthesize cpbBalance;
@synthesize availableBalance;
@synthesize frozenBalance;
@synthesize withdrawAvailableBalance;
@synthesize bankcardList;


// 获得全局的WpUser
+ (WCFUser *)sharedUser
{
    // 主线程适用
//    if (!_globalUser)
//    {
//        _globalUser = [[WpUser alloc] init];
//    }
    
    // 当在其他线程时能避免出错
    
    dispatch_once(&wpdispath, ^{
        _globalUser = [[WCFUser alloc] init];
    });
    
    return _globalUser;
}

// 清空全局WpUser
+ (void)resetSharedUser
{
    _globalUser = nil;
    wpdispath = 0;
}

// 根据保存在本地的用户信息判断用户是否登录
- (BOOL)isUserLoggedin
{
    if ([userLoggedInTag isEqualToString:@"1"])
    {
        return YES;
    }
    
    return NO;
}

//  是否绑定微博
- (BOOL)isBindWeibo
{
    if ([bindUid isEqualToString:@"1"])
    {
        return YES;
    }
    
    return NO;
}

- (id)init
{
    self = [super init];
    if (self) {
        // a = [[A alloc] init];
        
        wcpUser = [[WCPUser alloc] init];
    }
    return self;
}

// 用户是否为激活状态
- (BOOL)isUserActivate
{
    if ([activeStatus isEqualToString:@"1"])
    {
        return YES;
    }
    return NO;
}

// 用户是否实名认证过
- (BOOL)isUserCertified
{
    if ([certified isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}


// 将用户设置为实名认证过
- (void)setUserCertifiedWithName:(NSString*)name_ andNO:(NSString*)sfzNO_
{
    if (name_.length > 1 && sfzNO_.length > 14)
    {
        self.certified = @"1";
        self.realName = name_;
        self.identityCard = sfzNO_;
    }
    else
    {
        return;
    }
}

// 得到混淆后的电话号码
+ (NSString*)getConfusePhone:(NSString*)phoneStr
{
    if (phoneStr.length == 11)
    {
        NSRange range = NSMakeRange(0, 3);
        NSString* head = [phoneStr substringWithRange:range];
        range = NSMakeRange(7, 4);
        NSString* tail = [phoneStr substringWithRange:range];
        return [NSString stringWithFormat:@"%@****%@", head, tail];
    }
    return [NSString stringWithString:phoneStr];
}

// 手机号码是否认证
- (BOOL)isPhoneCertified
{
    if ([mobileBinded isEqualToString:@"1"])
    {
        return YES;
    }
    return NO;
}

// 将手机号设置为认证过
- (void)setUserBindPhone:(NSString*)phone_
{
    if (phone_ && phone_.length == 11)
    {
        self.mobileBinded = @"1";
        
        self.mobile = phone_;
    }
}

// 将微博账号设置为绑定
- (void)setUserWbid:(NSString *)awbid
{
    if (awbid && awbid.length > 1)
    {
        self.bindUid = @"1";
        
        self.wbId = awbid;
    }
}

// 用户是否绑定过提现银行卡
- (BOOL) isBindWithdrawalBankCard
{
    if (bankcardList.count < 1) {
        return NO;
    }
    return YES;
}

@end

static WCFGlobalTag *_globalTag = nil;
static dispatch_once_t tagdispath = 0;

@implementation WCFGlobalTag
@synthesize isIgnoreLongtimeNotHandle;

+ (WCFGlobalTag *)sharedTag
{
    dispatch_once(&tagdispath, ^{
        _globalTag = [[WCFGlobalTag alloc] init];
    });
    
    return _globalTag;
}

@end



static WCFGestureTimer *_globalTimer = nil;
static dispatch_once_t timerdispath = 0;
@implementation WCFGestureTimer
@synthesize isInvalidateTimerMark;
@synthesize timeLoopCount;
@synthesize serviceTime;
@synthesize isGestureController;

+ (WCFGestureTimer *) sharedTimer
{
    dispatch_once(&timerdispath, ^{
        _globalTimer = [[WCFGestureTimer alloc] init];
    });
    
    return _globalTimer;
}

- (void) createTime
{
    [self updateTimestampBaseTimeInterval];
    
    [self invalidateTime];
 
    timeInterval = 0;
        
    // 倒计时1min
    timeCount = kShowGesturesViewIntervalTime * 60;
        
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
}

- (void) invalidateTime
{
    if (timer)
    {
        [timer invalidate];
        
        timer = nil;
    }
}

//- (void) onTimer:(NSTimer *) atimer
//{
//    if (timeCount > 0)
//    {
//        -- timeCount;
//        
//        ++ timeInterval;
//        
//        // WPNSLOG(@"%@ --- %d --- %d", [NSDate date], timeCount, timeInterval);
//    }
//    else
//    {
//        // 废弃定时器
//        [self invalidateTime];
//        
//        ++timeLoopCount;
//        
//        // 当用户退出登录后，不需要验证手势密码
//        // 获取memberID
//        
//        NSString *memberID = [[WpCommonFunction getCookiesAndMemberIDFromLocal] firstObject];
//        
//        if (memberID)
//        {
//            // 跳转手势密码页
//            // 若memberid为空，赋值
//            if (!([WCFUser sharedUser].memberId.length > 0))
//            {
//                [WCFUser sharedUser].memberId = memberID;
//            }
//            
//            
//            // 跳转验证手势密码页之前，需要确认是否应该跳验证页
//            // 用户手势密码是否需要验证
//            
//            if ([WHCacheGestPassword needHandleGestpsw:memberID] == kGesturePasswordVerify)
//            {
//                [[ViewControllerManager sharedManager] launchVerifyGesturePswViewController];
//            }
//            else
//            {
//                timeLoopCount = 0;
//            }
//            
//            // 若用户的手势密码处于关闭状态，则无需启动定时器
//            // 启动定时器，需要对网络数据做判断，则一定是需要验证手势密码的情况
//        }
//        else
//        {
//            timeLoopCount = 0;
//        }
//    }
//}

#pragma mark - 根据定时器的时间间隔更新保存在本地的时间戳
- (void) updateTimestampBaseTimeInterval
{
    // 当忽略时，不更新时间戳，在对比完之后更新时间戳
    if (isInvalidateTimerMark)
    {
        // 根据定时器的时间间隔更新保存在本地的时间戳
        double localServerTime = [WpCommonFunction getLocalServiceTime];
        
        // 这步操作的目的是防止重新使用APP时多次弹出验证手势密码页
        if (serviceTime > localServerTime)
        {
            localServerTime = serviceTime;
            
            serviceTime = 0;
        }
        
        // 需要统计当前所处计时器的时间
        // 以下第一个+1的原因：
        // 计时器超过计时区间重启定时器会有一定的时间开销，经统计，误差为1s，故+1
        // 统计基础：iPod Touch 5，不同的设备统计结果应该会有误差。
        
        // 第二个+1的原因，与上类似
        
        localServerTime += (timeLoopCount * (kShowGesturesViewIntervalTime * 60 + 1) +  timeInterval + 1) * 1000;
        
        // 更新时间戳
        [WpCommonFunction saveServiceTime:[NSString stringWithFormat:@"%f", localServerTime]];
    }
}

@end


