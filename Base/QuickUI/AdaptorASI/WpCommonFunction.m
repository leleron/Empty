//
//  WpCommonFunction.m
//  WeiboPaySdkLib
//
//  Created by Mark on 13-3-18.
//  Copyright (c) 2013年 Mark. All rights reserved.
//

#import "WpCommonFunction.h"
#import "OpenUDID.h"
#import "WpAlertViewCommon.h"

#import "constant.h"
#import "WpPickerView.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <QuartzCore/CALayer.h>
#import "WHNotifyHUD.h"

#import "MyWebViewController.h"

#import "WHFileManager.h"
#import "WHNotifyHUD.h"

//#import "RESideMenu.h"

#import "WpUpdateView.h"

// 用户登录手机号的保存键
#define kCAOPANBAO_ACCOUNT_MOBILE @"caopanbaoaccountmobile"

// 退出时保存用户请求的Cookie值和memberID
#define kCAOPANBAO_MEMBERID_COOKIES @"caopanbaomemberidcookies"

// 设备是否查看过引导页
#define kCAOPANBAO_LOOKOVER_GUIDEPAGE @"caopanbaolookoverguidepage"


@implementation WpCommonFunction

#pragma mark - 版本升级
// 打开强制更新页
+ (void)appUpdateViewWithType:(NSInteger)type andUrl:(NSString*)url andDelegate:(id)delegate
{
    WpUpdateView* updateView = [[WpUpdateView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    updateView.delegate = delegate;
    updateView.url = url;
    [updateView setControlStatus:type];
    
    [updateView show];
}

+ (NSString*)JsonStringFromDict:(NSDictionary*)dict andKey:(const NSString*)key
{
    if ([dict class] == [NSNull class] || dict == nil)
    {
        return @"";
    }
    
    id jsonObject = [dict objectForKey:key];
    
    if (jsonObject == nil)
    {
        return @"";
    }
    
    if ([jsonObject class] == [NSNull class])
    {
        return @"";
    }
    
    return jsonObject;
}

#pragma mark - 保存信息至本地，系统升级信息

// 得到目录在Document目录下的路径（修改为将文件保存到Cache目录）
+ (NSString*)getFolderPathInDocument:(NSString*)folderPath
{
    WPNSLOG(@"%@", [NSString stringWithFormat:@"%@/%@/", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0], folderPath]);
    
    return [NSString stringWithFormat:@"%@/%@/", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0], folderPath];
}

// 得到文件在Document目录下的路径
+ (NSString*)getFilePathInDocument:(NSString*)folderPath withFileName:(NSString*)fileName andFileType:(NSString*)fileType
{
    return [NSString stringWithFormat:@"%@%@.%@", [WpCommonFunction getFolderPathInDocument:folderPath], fileName, fileType];
}

// 记录系统版本号
+ (void)saveUserAppVersion
{
    // /Documents/version.wbp
    NSString* fileName = [WpCommonFunction getFilePathInDocument:@"" withFileName:VERSIONFILE_UPDATE andFileType:@"cpb"];
    
    NSMutableDictionary *dictWriteProperty = [[NSMutableDictionary alloc] init];
    [dictWriteProperty setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:@"version"];
    [dictWriteProperty writeToFile:fileName atomically:YES];
}

// 判断版本是否更新
+ (BOOL)isAppUpdate
{
    // /Documents/version.wcf
    // /Documents/learn.wcf
    // /Documents/update.wcf
    NSString* fileName = [WpCommonFunction getFilePathInDocument:@"" withFileName:VERSIONFILE_UPDATE andFileType:@"cpb"];
    
    NSMutableDictionary *dictReadProperty = [[NSMutableDictionary alloc] initWithContentsOfFile:fileName];
    
    if (dictReadProperty && [dictReadProperty count] > 0)
    {
        NSString* version = [dictReadProperty objectForKey:@"version"];
        if ([version isEqualToString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]])
        {
            return NO;
        }
    }
    
    return YES;
}

// 将数字转化为带有2位小数的标准浮点型字符串
+ (NSString *) transformStringTo2PointFloatString:(NSString *)floatString
{
    return [NSString stringWithFormat:@"%.2f", [floatString doubleValue]];
}

//获取当前时间的13位时间戳
+ (NSString *)getNowData{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timeInterval=[date timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", timeInterval];
    if ([timeString componentsSeparatedByString:@"."]) {
        NSArray *array = [timeString componentsSeparatedByString:@"."];
        return [array objectAtIndex:0];
    }
    return timeString;
}

// 将豪秒转化为标准时间
+ (NSString *)dateFromMilliscondServer:(NSString*)dateServer
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    double dDateServer = [dateServer longLongValue] / 1000.0;
    NSDateComponents *dateComponents = [calendar components:flags fromDate:[NSDate dateWithTimeIntervalSince1970:dDateServer]];
    NSString *formatDate = [NSString stringWithFormat:@"%d/%02d/%02d %02d:%02d", dateComponents.year, dateComponents.month, dateComponents.day, dateComponents.hour, dateComponents.minute];
    return formatDate;
}

// 按豪秒返回当前的时间 年-月
+ (NSString *) monthFromMilliSecondServer:(NSString *)dateServer
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    double dDateServer = [dateServer longLongValue] / 1000.0;
    NSDateComponents *dateComponents = [calendar components:flags fromDate:[NSDate dateWithTimeIntervalSince1970:dDateServer]];
    int amonth = dateComponents.month;
    
    NSString *monthStr = [NSString stringWithFormat:@"%d", amonth];
    
    if (amonth < 10)
    {
        monthStr = [NSString stringWithFormat:@"0%d", amonth];
    }
    
    NSString *thisTime = [NSString stringWithFormat:@"%d-%@", dateComponents.year, monthStr];
    
    return thisTime;
}

// 将秒转化为标准时间
+ (NSString *)dateFromScondServer:(NSString*)dateServer
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    double dDateServer = [dateServer longLongValue];
    NSDateComponents *dateComponents = [calendar components:flags fromDate:[NSDate dateWithTimeIntervalSince1970:dDateServer]];
    NSString *formatDate = [NSString stringWithFormat:@"%02d-%02d %02d:%02d:%02d", dateComponents.month, dateComponents.day, dateComponents.hour, dateComponents.minute, dateComponents.second];
    return formatDate;
}

// 返回当前的月份
+ (int) monthFromSecondServer:(NSString *)dateServer
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    double dDateServer = [dateServer longLongValue];
    NSDateComponents *dateComponents = [calendar components:flags fromDate:[NSDate dateWithTimeIntervalSince1970:dDateServer]];
    return dateComponents.month;
}

#pragma mark - 字段的校验和整理
// 移除字符串中所有的空格
+ (NSString*)stringRemoveAllWhiteSpace:(NSString*)str
{
    if (!str) return nil;
    
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

// 判断字符串是否为空
+ (BOOL)isStringNull:(NSString*)str
{
    NSString* testStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([testStr isEqualToString:@""])
        return YES;
    
    return NO;
}

// 使用正则表达式校验字符串
+ (BOOL)testRegex:(NSString*)regex WithString:(NSString*)str
{
    NSRegularExpression* regularexpression = [[NSRegularExpression alloc] initWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSUInteger number = [regularexpression numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    
    if (number > 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

// 判断字符是否全部相同
+ (BOOL) isSameWithAllChar:(NSString *)targetString
{
    for (int i = 1; i < targetString.length; i ++)
    {
        if (![[targetString substringWithRange:NSMakeRange(i - 1, 1)] isEqualToString:[targetString substringWithRange:NSMakeRange(i, 1)]])
        {
            return NO;
        }
    }
    
    return YES;
}

// 检查新支付密码的格式 -- 以浮层形式提示
+ (BOOL)verifyPaymentPassword:(NSString*)password onView:(UIView*)view{
    
    if([WpCommonFunction isStringNull:password])
    {
        WHNotifyHUD *notify = [WHNotifyHUD notifyHUDWithImage:[UIImage imageNamed:nil] text:NSLocalizedString(@"PaymentPassword_Error0", @"")];
        notify.frame = CGRectMake(40,view.frame.size.height-216-40, 0, 0);
        [view addSubview:notify];
        [notify presentWithDuration:2.0f speed:0.5f inView:view completion:^{
            [notify removeFromSuperview];
        }];
        return NO;
    }
    
    if (password.length < 6)
    {
        WHNotifyHUD *notify = [WHNotifyHUD notifyHUDWithImage:[UIImage imageNamed:nil] text:NSLocalizedString(@"PaymentPassword_Error1", @"")];
        notify.frame = CGRectMake(40,view.frame.size.height-216-40, 0, 0);
        [view addSubview:notify];
        [notify presentWithDuration:2.0f speed:0.5f inView:view completion:^{
            [notify removeFromSuperview];
        }];
        return NO;
    }
    
    if (password.length > 20)
    {
        WHNotifyHUD *notify = [WHNotifyHUD notifyHUDWithImage:[UIImage imageNamed:nil] text:NSLocalizedString(@"PaymentPassword_Error2", @"")];
        notify.frame = CGRectMake(40,view.frame.size.height-216-40, 0, 0);
        [view addSubview:notify];
        [notify presentWithDuration:2.0f speed:0.5f inView:view completion:^{
            [notify removeFromSuperview];
        }];
        return NO;
    }
    
    if (![WpCommonFunction testRegex:CPB_Regex_PayPassword WithString:password])
    {
        WHNotifyHUD *notify = [WHNotifyHUD notifyHUDWithImage:[UIImage imageNamed:nil] text:NSLocalizedString(@"PaymentPassword_Error3", @"")];
        notify.frame = CGRectMake(40,view.frame.size.height-216-60, 0, 0);
        [view addSubview:notify];
        [notify presentWithDuration:2.0f speed:0.5f inView:view completion:^{
            [notify removeFromSuperview];
        }];
        return NO;
    }
    
    // 所有的字符不能相同
    if ([WpCommonFunction isSameWithAllChar:password]) {
        
        NSString *tintString;
        
        char ch = [password characterAtIndex:0];
        
        // 数字
        if ((int)ch < 58 && (int)ch > 47)
        {
            tintString = NSLocalizedString(@"PaymentPassword_Error_SameNumber", @"不能设置相同的数字");
        }
        // 字母
        else if (((int)ch < 91 && (int)ch >64) || ((int)ch <123 && (int)ch >96))
        {
            tintString = NSLocalizedString(@"PaymentPassword_Error_SameLetter", @"不能设置相同的字母");
        }
        // 其他字符
        else
        {
            tintString = NSLocalizedString(@"PaymentPassword_Error_SameChar", @"不能设置相同的字符");
        }
        
        WHNotifyHUD *notify = [WHNotifyHUD notifyHUDWithImage:[UIImage imageNamed:nil] text:tintString];
        notify.frame = CGRectMake(40,view.frame.size.height-216-80, 0, 0);
        [view addSubview:notify];
        [notify presentWithDuration:2.0f speed:0.5f inView:view completion:^{
            [notify removeFromSuperview];
        }];
        return NO;
    }
    
    // 不是连续的数字[password isMatchedByRegex:@"^[0-9]+$"]
    if ([WpCommonFunction testRegex:@"^[0-9]+$" WithString:password] && password.length < 11)
    {
        WHNotifyHUD *notify = [WHNotifyHUD notifyHUDWithImage:[UIImage imageNamed:nil] text:NSLocalizedString(@"PaymentPassword_Error5", @"")];
        notify.frame = CGRectMake(40,view.frame.size.height-216-80, 0, 0);
        [view addSubview:notify];
        [notify presentWithDuration:2.0f speed:0.5f inView:view completion:^{
            [notify removeFromSuperview];
        }];
        return NO;
    }
    
    return YES;
}
// 以下两个方法和verifyPaymentPassword实现相同，只是提示文案有些许差别
// 检查老支付密码的格式
+ (BOOL)verifyOldPaymentPassword:(NSString*)password
{
    if([WpCommonFunction isStringNull:password])
    {
        [WpCommonFunction messageBoxWithMessage:NSLocalizedString(@"OldPaymentPassword_Error0", @"")];
        return NO;
    }
    
    if (password.length < 6)
    {
        [WpCommonFunction messageBoxWithMessage:NSLocalizedString(@"OldPaymentPassword_Error1", @"")];
        return NO;
    }
    
    if (password.length > 20)
    {
        [WpCommonFunction messageBoxWithMessage:NSLocalizedString(@"OldPaymentPassword_Error2", @"")];
        return NO;
    }
    
    if (![WpCommonFunction testRegex:CPB_Regex_PayPassword WithString:password])
    {
        [WpCommonFunction messageBoxWithMessage:NSLocalizedString(@"OldPaymentPassword_Error3", @"")];
        return NO;
    }
    
    // 所有的字符不能相同
    if ([WpCommonFunction isSameWithAllChar:password]) {
        [WpCommonFunction messageBoxWithMessage:NSLocalizedString(@"OldPaymentPassword_Error4", @"")];
        return NO;
    }
    
    // 不是连续的数字[password isMatchedByRegex:@"^[0-9]+$"]
    if ([WpCommonFunction testRegex:@"^[0-9]+$" WithString:password] && password.length < 11)
    {
        if ([WpCommonFunction isContinuousNumber:password]) {
            [WpCommonFunction messageBoxWithMessage:NSLocalizedString(@"OldPaymentPassword_Error5", @"")];
            return NO;
        }
    }
    
    return YES;
}

// 检查老支付密码格式 -- 以浮层形式提示
+ (BOOL)verifyOldPaymentPassword:(NSString*)password onView:(UIView*)view{
    if([WpCommonFunction isStringNull:password])
    {
        WHNotifyHUD *notify = [WHNotifyHUD notifyHUDWithImage:[UIImage imageNamed:nil] text:NSLocalizedString(@"OldPaymentPassword_Error0", @"")];
        notify.frame = CGRectMake(40,view.frame.size.height-216-40, 0, 0);
        [view addSubview:notify];
        [notify presentWithDuration:2.0f speed:0.5f inView:view completion:^{
            [notify removeFromSuperview];
        }];
        return NO;
    }
    
    if (password.length < 6)
    {
        WHNotifyHUD *notify = [WHNotifyHUD notifyHUDWithImage:[UIImage imageNamed:nil] text:NSLocalizedString(@"OldPaymentPassword_Error1", @"")];
        notify.frame = CGRectMake(40,view.frame.size.height-216-40, 0, 0);
        [view addSubview:notify];
        [notify presentWithDuration:2.0f speed:0.5f inView:view completion:^{
            [notify removeFromSuperview];
        }];
        return NO;
    }
    
    if (password.length > 20)
    {
        WHNotifyHUD *notify = [WHNotifyHUD notifyHUDWithImage:[UIImage imageNamed:nil] text:NSLocalizedString(@"OldPaymentPassword_Error2", @"")];
        notify.frame = CGRectMake(40,view.frame.size.height-216-40, 0, 0);
        [view addSubview:notify];
        [notify presentWithDuration:2.0f speed:0.5f inView:view completion:^{
            [notify removeFromSuperview];
        }];
        return NO;
    }
    
    if (![WpCommonFunction testRegex:CPB_Regex_PayPassword WithString:password])
    {
        WHNotifyHUD *notify = [WHNotifyHUD notifyHUDWithImage:[UIImage imageNamed:nil] text:NSLocalizedString(@"OldPaymentPassword_Error3", @"")];
        notify.frame = CGRectMake(40,view.frame.size.height-216-40, 0, 0);
        [view addSubview:notify];
        [notify presentWithDuration:2.0f speed:0.5f inView:view completion:^{
            [notify removeFromSuperview];
        }];
        return NO;
    }
    
    // 所有的字符不能相同
    if ([WpCommonFunction isSameWithAllChar:password]) {
        WHNotifyHUD *notify = [WHNotifyHUD notifyHUDWithImage:[UIImage imageNamed:nil] text:NSLocalizedString(@"OldPaymentPassword_Error4", @"")];
        notify.frame = CGRectMake(40,view.frame.size.height-216-40, 0, 0);
        [view addSubview:notify];
        [notify presentWithDuration:2.0f speed:0.5f inView:view completion:^{
            [notify removeFromSuperview];
        }];
        return NO;
    }
    
    // 不是连续的数字[password isMatchedByRegex:@"^[0-9]+$"]
    if ([WpCommonFunction testRegex:@"^[0-9]+$" WithString:password] && password.length < 11)
    {
        WHNotifyHUD *notify = [WHNotifyHUD notifyHUDWithImage:[UIImage imageNamed:nil] text:NSLocalizedString(@"OldPaymentPassword_Error5", @"")];
        notify.frame = CGRectMake(40,view.frame.size.height-216-40, 0, 0);
        [view addSubview:notify];
        [notify presentWithDuration:2.0f speed:0.5f inView:view completion:^{
            [notify removeFromSuperview];
        }];
        return NO;
    }
    
    return YES;
}
// 检查新支付密码的格式
+ (BOOL)verifyNewPaymentPassword:(NSString*)password
{
    if([WpCommonFunction isStringNull:password])
    {
        [WpCommonFunction messageBoxWithMessage:NSLocalizedString(@"NewPaymentPassword_Error0", @"")];
        return NO;
    }
    
    if (password.length < 6)
    {
        [WpCommonFunction messageBoxWithMessage:NSLocalizedString(@"NewPaymentPassword_Error1", @"")];
        return NO;
    }
    
    if (password.length > 20)
    {
        [WpCommonFunction messageBoxWithMessage:NSLocalizedString(@"NewPaymentPassword_Error2", @"")];
        return NO;
    }
    
    if (![WpCommonFunction testRegex:CPB_Regex_PayPassword WithString:password])
    {
        [WpCommonFunction messageBoxWithMessage:NSLocalizedString(@"NewPaymentPassword_Error3", @"")];
        return NO;
    }
    
    // 所有的字符不能相同
    if ([WpCommonFunction isSameWithAllChar:password]) {
        [WpCommonFunction messageBoxWithMessage:NSLocalizedString(@"NewPaymentPassword_Error4", @"")];
        return NO;
    }
    
    // 不是连续的数字[password isMatchedByRegex:@"^[0-9]+$"]
    if ([WpCommonFunction testRegex:@"^[0-9]+$" WithString:password] && password.length < 11)
    {
        if ([WpCommonFunction isContinuousNumber:password]) {
            [WpCommonFunction messageBoxWithMessage:NSLocalizedString(@"NewPaymentPassword_Error5", @"")];
            return NO;
        }
    }
    
    return YES;
}

// 检查金额格式
+ (BOOL)verifyPrice:(NSString*)price
{
    if ([WpCommonFunction stringRemoveAllWhiteSpace:price].length == 0)
    {
        [WpCommonFunction messageBoxWithMessage:NSLocalizedString(@"Import_Price_Error2", @"")];
        return NO;
    }
    
    if (![WpCommonFunction testRegex:PRICE_REGEX_STRING WithString:price])
    {
        [WpCommonFunction messageBoxWithMessage:NSLocalizedString(@"Import_Price_Error1", @"")];
        return NO;
    }
    
    return YES;
}

// 检查金额格式大于0
+ (BOOL)verifyPriceUPZero:(NSString*)price
{
    if ([WpCommonFunction stringRemoveAllWhiteSpace:price].length == 0)
    {
        [WpCommonFunction messageBoxWithMessage:NSLocalizedString(@"Import_Price_Error2", @"")];
        return NO;
    }
    
    if (![WpCommonFunction testRegex:PRICE_REGEX_STRING WithString:price])
    {
        [WpCommonFunction messageBoxWithMessage:NSLocalizedString(@"Import_Price_Error1", @"")];
        return NO;
    }
    
    if ([WpCommonFunction comparePrice1:price andPrice2:@"0"] != NSOrderedDescending)
    {
        [WpCommonFunction messageBoxWithMessage:NSLocalizedString(@"Import_Price_Error3", @"")];
        return NO;
    }
    
    return YES;
}

// 金额大小比较
+ (NSComparisonResult)comparePrice1:(NSString*)price1 andPrice2:(NSString*)price2
{
    NSDecimalNumber* priceNumber1 = [NSDecimalNumber decimalNumberWithString:price1];
    NSDecimalNumber* priceNumber2 = [NSDecimalNumber decimalNumberWithString:price2];
    NSComparisonResult result = [priceNumber1 compare:priceNumber2];
    return result;
}


/** 判断数字是否连续
 *  1、全部为数字；
 *  2、不是全部相等的数字
 */
+ (BOOL) isContinuousNumber:(NSString *)numString
{
    int diffValue = 0;
    
    diffValue = [[numString substringWithRange:NSMakeRange(1, 1)] intValue] - [[numString substringWithRange:NSMakeRange(0, 1)] intValue];
    
    if (diffValue >= 0)
    {
        for (int i = 1; i < numString.length; i ++)
        {
            if ([[numString substringWithRange:NSMakeRange(i, 1)] intValue] - [[numString substringWithRange:NSMakeRange(i - 1, 1)] intValue] != 1) {
                return NO;
            }
        }
    }
    
    if (diffValue <= 0) {
        for (int i = 1; i < numString.length; i ++)
        {
            if ([[numString substringWithRange:NSMakeRange(i - 1, 1)] intValue] - [[numString substringWithRange:NSMakeRange(i, 1)] intValue] != 1) {
                return NO;
            }
        }
    }
    
    return YES;
}

// 得到WeiboPay设备唯一标识
+ (NSString*)getUniqueDeviceIdentifier
{
    return [OpenUDID value];
}

// 获得设备标识
+ (NSString*)macaddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

+ (NSString*)wpUniqueDeviceIdentifier
{
    NSString* macaddress = [WpCommonFunction macaddress];
    
    // 去掉":"
    NSString* middleTransfer = [macaddress stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    // 将数字转换为小写字母+3,大小字母+5
    const char* macAddrArray = [middleTransfer cStringUsingEncoding:NSASCIIStringEncoding];
    int length = [middleTransfer length];
    char newMacAddrArray[20] = {0};
    
    for (int i = 0; i < length; i++)
    {
        if (macAddrArray[i] >= '0' && macAddrArray[i] <= '9')
        {
            newMacAddrArray[i] = (char) ('d' - '0' + macAddrArray[i]);
        }
        else if (macAddrArray[i] >= 'A' && macAddrArray[i] <= 'F')
        {
            newMacAddrArray[i] = (char) (macAddrArray[i] + 5);
        }
    }
    
    // 移位
    if (length >= 3)
    {
        // 第一位和最后一位
        char tmp = newMacAddrArray[0];
        newMacAddrArray[0] = newMacAddrArray[length - 1];
        newMacAddrArray[length - 1] = tmp;
        // 第二位和最后第三位
        tmp = newMacAddrArray[1];
        newMacAddrArray[1] = newMacAddrArray[length - 3];
        newMacAddrArray[length - 3] = tmp;
        // 第三位和最后第二位
        tmp = newMacAddrArray[2];
        newMacAddrArray[2] = newMacAddrArray[length - 2];
        newMacAddrArray[length - 2] = tmp;
    }
    
    NSString* uniqueIdentifier = [[NSString alloc] initWithCString:newMacAddrArray encoding:NSASCIIStringEncoding];
    
    return uniqueIdentifier;
}


#pragma mark - 友盟升级
// 统计事件
+ (void)statEvent:(NSString*)eventId
{
#if TARGET_IPHONE_SIMULATOR
    {
    }
#else
    {
//        [MobClick event:eventId];
    }
#endif
}


#pragma mark - 弹出alert对话框
// 打开一个警告对话框

+ (void)messageBoxOneButtonWithMessage:(NSString*)message andTitle:(NSString*)title andButton:(NSString*)buttonTitle andTag:(NSInteger)tag andDelegate:(id)delegate
{
    if (!message || ![message length])
        return;
    
    WpAlertViewCommon* alertViewCommon = [[WpAlertViewCommon alloc] init];
    [alertViewCommon showAlertType:WPALERTCOMMON_TYPE_ONE_BUTTON andText:message andTitle:title andYesButton:buttonTitle andNoButton:nil andDelegate:delegate andTag:tag];
}

+ (void)messageBoxWithMessage:(NSString*)message
{
    [WpCommonFunction messageBoxOneButtonWithMessage:message andTitle:nil andButton:nil andTag:0 andDelegate:nil];
}

+ (void)messageBoxOneButtonWithMessage:(NSString*)message andTag:(NSInteger)tag andDelegate:(id)delegate
{
    [WpCommonFunction messageBoxOneButtonWithMessage:message andTitle:nil andButton:nil andTag:tag andDelegate:delegate];
}

+ (void)messageBoxOneButtonWithMessage:(NSString*)message andTitle:(NSString*)title andTag:(NSInteger)tag andDelegate:(id)delegate
{
    [WpCommonFunction messageBoxOneButtonWithMessage:message andTitle:title andButton:nil andTag:tag andDelegate:delegate];
}

+ (void)messageBoxTwoButtonWithMessage:(NSString*)message andTitle:(NSString*)title andLeftButton:(NSString*)leftButtonTitle andRightButton:(NSString*)rightButtonTitle andTag:(NSInteger)tag andDelegate:(id)delegate
{
    [WpCommonFunction messageBoxTwoButtonWithMessage:message andTitle:title andLeftButton:leftButtonTitle andRightButton:rightButtonTitle andTag:tag andDelegate:delegate andPayload:nil];
}

+ (void)messageBoxTwoButtonWithMessage:(NSString*)message andTag:(NSInteger)tag andDelegate:(id)delegate
{
    [WpCommonFunction messageBoxTwoButtonWithMessage:message andTitle:nil andLeftButton:nil andRightButton:nil andTag:tag andDelegate:delegate];
}

+ (void)messageBoxTwoButtonWithMessage:(NSString*)message andTitle:(NSString*)title andTag:(NSInteger)tag andDelegate:(id)delegate
{
    [WpCommonFunction messageBoxTwoButtonWithMessage:message andTitle:title andLeftButton:nil andRightButton:nil andTag:tag andDelegate:delegate];
}

+ (void)messageBoxTwoButtonWithMessage:(NSString*)message andTag:(NSInteger)tag andDelegate:(id)delegate andPayload:(id)payload{
    [WpCommonFunction messageBoxTwoButtonWithMessage:message andTitle:nil andLeftButton:nil andRightButton:nil andTag:tag andDelegate:delegate andPayload:payload];
}

+ (void)messageBoxTwoButtonWithMessage:(NSString*)message andTitle:(NSString*)title andLeftButton:(NSString*)leftButtonTitle andRightButton:(NSString*)rightButtonTitle andTag:(NSInteger)tag andDelegate:(id)delegate andPayload:(id)payload{
    if (!message || ![message length])
        return;
    
    if(!leftButtonTitle)
        leftButtonTitle=@"取消";
    
    if(!rightButtonTitle)
        rightButtonTitle=@"确定";
    
    WpAlertViewCommon* alertViewCommon = [[WpAlertViewCommon alloc] init];
    alertViewCommon.payload = payload;
    [alertViewCommon showAlertType:WPALERTCOMMON_TYPE_TWO_BUTTON andText:message andTitle:title andYesButton:rightButtonTitle andNoButton:leftButtonTitle andDelegate:delegate andTag:tag];
}

+ (BOOL)isShowMessageBox
{
    return [WpAlertViewCommon isShowAlertView];
}

// 设置圆角
+ (void)setView:(UIView*)view cornerRadius:(CGFloat)radius
{
    CALayer* layer = view.layer;
    
    layer.masksToBounds = YES;
    layer.cornerRadius = radius;
}

#pragma mark - 将数据保存在本地
// 将最新的服务器时间保存在本地
+ (void) saveServiceTime:(NSString *)serviceTime
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setDouble:[serviceTime doubleValue] forKey:@"NewestServiceTimeSavedLocl"];
    
    [userDefaults synchronize];
}

// 获取保存在本地的服务器时间
+ (double) getLocalServiceTime
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults doubleForKey:@"NewestServiceTimeSavedLocl"];
}

// 读取本地文件中的数据
+ (NSArray *)getLocalAccountMobile
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *mobileDataArray = [userDefaults arrayForKey:kCAOPANBAO_ACCOUNT_MOBILE];
    
    return mobileDataArray;
}

// mobileNO 和 memberID都要做判断，判断为空的情况

// 根据手机号得到（mobileNo + avatarImage）数据
+ (NSArray *)getLocalDataWithMobileNo:(NSString *)mobileNo
{
    NSString *mobileNoStr = [WpCommonFunction stringRemoveAllWhiteSpace:mobileNo];
    
    if (!mobileNo || mobileNo.length < 1)
    {
        return nil;
    }
    
    NSArray *dataArray = [WpCommonFunction getLocalAccountMobile];
    
    for (NSArray *item in dataArray)
    {
        if ([[item objectAtIndex:0] isEqualToString:mobileNoStr])
        {
            // 如果有手机号对应的数据，返回，没有则返回nil
            return item;
        }
    }
    
    return nil;
}

// 根据memberID得到（mobileNo + avatarImage）数据
+ (NSArray *)getLocalDataWithMemberId:(NSString *)memberId
{
    // 如果为空，则返回空值
    if (!memberId || memberId.length < 1)
    {
        return nil;
    }
    
    NSArray *dataArray = [WpCommonFunction getLocalAccountMobile];
    
    NSString *mIdStr = [NSString stringWithFormat:NSLocalizedString(@"User_Avatar_Naming_Conventions", @""), memberId];
    
    for (NSArray *item in dataArray)
    {
        if ([[item objectAtIndex:1] isEqualToString:mIdStr])
        {
            // 如果有手机号对应的数据，返回，没有则返回nil
            return item;
        }
    }
    return nil;
}

// 获取保存在第一个的手机号
+ (NSArray *)getLocalDataWithFirst
{
    NSArray *dataArray = [WpCommonFunction getLocalAccountMobile];
    
    if (dataArray.count > 0)
    {
        return [dataArray firstObject];
    }
    
    return nil;
}

// 将数据保存在本地（string）
+ (void) saveAccountMobileToLocalData:(NSString *)mobileString :(NSString *)avatarString
{
    NSString *mobileStr = [WpCommonFunction stringRemoveAllWhiteSpace:mobileString];
    
    // 保存的数据保证非空
    if (!mobileStr || mobileStr.length < 1 || !avatarString || avatarString.length < 1) return;
    
    NSString *userAvatarString = [NSString stringWithFormat:NSLocalizedString(@"User_Avatar_Naming_Conventions", @""), avatarString];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:[userDefaults arrayForKey:kCAOPANBAO_ACCOUNT_MOBILE]];
    
    BOOL hasData = NO;
    
    NSArray *newDataArray = [NSArray arrayWithObjects:mobileStr, userAvatarString, nil];
    
    // dataString已存在，移至第一位
    for (NSArray *item in dataArray)
    {
        if ([[item objectAtIndex:0] isEqualToString:mobileStr] || [[item objectAtIndex:1] isEqualToString:userAvatarString])
        {
            hasData = YES;
            
            //if ([dataArray indexOfObject:item] != 0)
            
            [dataArray removeObject:item];
            
            [dataArray insertObject:newDataArray atIndex:0];
            
            break;
        }
    }
    
    // dataString不存在，放在第一位，并删除编号大于5的数据
    if (!hasData)
    {
        [dataArray insertObject:newDataArray atIndex:0];
        
        if (dataArray.count > 2)
        {
            [dataArray removeLastObject];
        }
    }
    
    [userDefaults setObject:dataArray forKey:kCAOPANBAO_ACCOUNT_MOBILE];
    
    [userDefaults synchronize];
}

// 删除数据(string)
+ (void) deleteAccountMobileFromLocalData:(NSString *)mobileString
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:[userDefaults arrayForKey:kCAOPANBAO_ACCOUNT_MOBILE]];
    
    for (NSArray *item in dataArray)
    {
        if ([[item objectAtIndex:0] isEqualToString:mobileString])
        {
            [dataArray removeObject:item];
            
            break;
        }
    }
    
    [userDefaults setObject:dataArray forKey:kCAOPANBAO_ACCOUNT_MOBILE];
    
    [userDefaults synchronize];
}

// 保存memberID和Cookies值
+ (NSArray *)getCookiesAndMemberIDFromLocal
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *mIDAndCookesArray = [userDefaults arrayForKey:kCAOPANBAO_MEMBERID_COOKIES];
    
    // 将data数据转为string
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    
    if (mIDAndCookesArray.count > 1)
    {
        [newArray addObject:[mIDAndCookesArray objectAtIndex:0]];
        
        NSMutableArray *newCookieArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *cookieDic in [mIDAndCookesArray objectAtIndex:1])
        {
            // NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieDic];
            
            [newCookieArray addObject:cookie];
        }
        
        [newArray addObject:newCookieArray];
        
        return newArray;
    }
    
    return mIDAndCookesArray;
}
// 将数据保存在本地（string）
+ (void) saveCookiesAndMemberIDToLocal
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *oldDataArray = [userDefaults arrayForKey:kCAOPANBAO_MEMBERID_COOKIES];
    
    WCFUser *wcfuser = [WCFUser sharedUser];
    
    NSString *memberIDStr = wcfuser.memberId;
    
    if (!memberIDStr || memberIDStr.length < 1)
    {
        memberIDStr = @"";
        
        if (oldDataArray.count > 1)
        {
            memberIDStr = [oldDataArray objectAtIndex:0];
        }
        else
            return;
    }
    
    // 将cookie值转为Data数据保存
    NSMutableArray *dataCookieArray = [[NSMutableArray alloc] init];
    
    for (NSHTTPCookie *cookie in wcfuser.requestCookies)
    {
        NSDictionary *dic = [cookie properties];
        
        [dataCookieArray addObject:dic];
    }
    
    
    NSArray *dataArray = [[NSArray alloc] initWithObjects:memberIDStr, dataCookieArray, nil];
    
    [userDefaults setObject:dataArray forKey:kCAOPANBAO_MEMBERID_COOKIES];
    
    [userDefaults synchronize];
}

// 删除memberID和Cookies值(退出登录是)
+ (void) delegateCookiesAndMemberIDFromLocal
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults removeObjectForKey:kCAOPANBAO_MEMBERID_COOKIES];
}

#pragma mark - 判断用户是否查看了引导页
+ (BOOL)getDeviceDoesLookoverGuidePageFromLocal
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults boolForKey:kCAOPANBAO_LOOKOVER_GUIDEPAGE];
}

+ (void) saveDeviceLookoverGuidePageToLocal
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setBool:YES forKey:kCAOPANBAO_LOOKOVER_GUIDEPAGE];
    
    [userDefaults synchronize];
}


// 隐藏键盘
+ (void)hideKeyboardWithScrollView:(UIScrollView*)scrollView
{
    [scrollView endEditing:YES];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.30f];
    
    scrollView.contentOffset = CGPointMake(0, 0);
    
    [UIView commitAnimations];
}

// 显示下拉列表
+ (void)showPickerViewWithTag:(NSInteger)tag andDefaultSelIndex:(NSInteger)selIndex andDelegate:(id)delegate
{
    WpPickerView* wpPickerView = [[WpPickerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 260.0, 320.0, 260.0)];
    wpPickerView.myPickerView.tag = tag;
    [wpPickerView setMyPickerViewDelegate:delegate andDefaultSelect:selIndex];
    [wpPickerView show];
}

+ (void)showPickerViewWithTag:(NSInteger)tag andDefaultSelIndexList:(NSArray*)selIndexList andDelegate:(id)delegate
{
    WpPickerView* wpPickerView = [[WpPickerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 260.0, 320.0, 260.0)];
    wpPickerView.myPickerView.tag = tag;
    [wpPickerView setMyPickerViewDelegate:delegate andDefaultSelectList:selIndexList];
    [wpPickerView show];
}

// 获取微操盘H5 Url
+(NSString*)getH5Url:(NSString*)urlAction{
    if([urlAction hasPrefix:@"http"])
        return urlAction;
    return nil;
//    return [NSString stringWithFormat:@"%@/%@",kH5Domin,urlAction];
}

// 跳转h5页面
+(void)turnToH5PageWithUrl:(NSString*)urlAction withTitleName:(NSString*)title onController:(UIViewController*)controller{
    MyWebViewController* webController=[[MyWebViewController alloc] initWithNibName:@"MyWebViewController" bundle:nil];
    [webController setNavigationBarTitle:title];
    if([urlAction hasPrefix:@"http"])
        webController.url=urlAction;
    else
        webController.url=[WpCommonFunction getH5Url:urlAction];
    [controller.navigationController pushViewController:webController animated:YES];
}

//自定义alert弹出动画*
+(void)animationForAlertShow:(UIView *)view{
    CABasicAnimation *basic = [CABasicAnimation animation];
    basic.toValue = [NSNumber numberWithDouble:1.2]; //设置动画结束时的值
    basic.duration = 0.1;     //设置动画时长
    basic.autoreverses = YES;//设置自动翻转
    [view.layer addAnimation:basic forKey:@"transform.scale"];
}

// 使手机号码中间四位变成星号
+(NSString *)makePhoneNumSecurity:(NSString *)phone{
    NSMutableString *phoneStr;
    if (phone.length > 4) {
        phoneStr = [NSMutableString stringWithString:phone];
        [phoneStr replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    return phoneStr;
}

//拨打客服电话
+(void)telPhoneToCustomerService{
    NSString *phoneStr = NSLocalizedString(@"WCF_Service_PhoneNumber", @"");
    NSString *serviceNum = [NSString stringWithFormat:@"tel://%@",phoneStr];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:serviceNum]];
}

// 将图片Data转为Base64字符串（头像上传）
+(NSString *)transformImageDataToBase64String:(NSData *)imagedata
{
    NSString *base64ImageStr;
    
    if ([NSData instancesRespondToSelector:@selector(base64EncodedStringWithOptions:)])
    {
        base64ImageStr = [imagedata base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    else
    {
        base64ImageStr = [imagedata base64Encoding];
    }
    
    return base64ImageStr;
}

// 将Base64字符串转成图片（图片下载）
+(NSData *)transformBase64StringToImageData:(NSString *)base64Str
{
    // Base64字符串转UIImage图片：
    NSData *imageData;
    
    if ([NSData instancesRespondToSelector:@selector(initWithBase64EncodedString:options:)])
    {
        imageData = [[NSData alloc] initWithBase64EncodedString:base64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }
    else
    {
        imageData = [[NSData alloc] initWithBase64Encoding:base64Str];
    }
    
    return imageData;
}


//校验输入金额格式是否正确并改变按钮是否可按
+(BOOL)textMoneyTextAndButtonStatusContainRadixPoint:(UIButton*)button withAgree:(BOOL)isAgree andTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField.text isEqualToString:@"0"] && ![string isEqualToString:@"."] && ![string isEqualToString:@""]) {
        return NO;
    }
    
    NSRange charRange = [textField.text rangeOfString:@"."];
    
    if (charRange.location !=NSNotFound){
        NSMutableString *tempStr = [NSMutableString stringWithString:textField.text];
        [tempStr deleteCharactersInRange:NSMakeRange(charRange.location, textField.text.length - charRange.location)];
        if (tempStr.length == 5 && ![string isEqualToString:@"."] && range.location <= charRange.location && ![string isEqualToString:@""]) {
            return NO;
        }
    }
    else{
        if (textField.text.length == 5 && ![string isEqualToString:@"."] && ![string isEqualToString:@""]) {
            return NO;
        }
    }
    
    //当第一次输入内容为.时---最后一位为.
    if (charRange.location == NSNotFound && [string isEqualToString:@"."]) {
        button.enabled = NO;
        return YES;
    }
    
    if (charRange.location !=NSNotFound && [string isEqualToString:@"."]) {
        return NO;
    }
    if (charRange.location !=NSNotFound && (textField.text.length - charRange.location)>2 && ![string isEqualToString:@""] && range.location > charRange.location){
        return NO;
    }
    
    NSString *textStr;
    if ([string isEqualToString:@""] && textField.text.length > 0) {
        NSMutableString *tempStr = [NSMutableString stringWithString:textField.text];
        [tempStr deleteCharactersInRange:NSMakeRange(range.location, 1)];
        textStr = tempStr;
    }
    else if (![string isEqualToString:@""]) {
        textStr = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    if ([textStr isEqualToString:@"0"] || [textStr isEqualToString:@"0."]
        ||[textStr isEqualToString:@"0.0"] || [textStr isEqualToString:@"0.00"] || [textStr isEqualToString:@""]) {
        button.enabled = NO;
    }
    else if(isAgree){
        button.enabled = YES;
    }
    //删除数字后最后一位为.
    if ([textStr hasSuffix:@"."]) {
        button.enabled = NO;
    }
    if ([textStr hasPrefix:@"."]) {
        button.enabled = NO;
    }
    
    return YES;
}

//校验输入金额格式是否正确并改变按钮是否可按 -- 不可以输入小数点
+(BOOL)textMoneyTextAndButtonStatusWithOutRadixPoint:(UIButton*)button withAgree:(BOOL)isAgree andTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *textStr;
    if ([string isEqualToString:@""] && textField.text.length > 0) {
        NSMutableString *tempStr = [NSMutableString stringWithString:textField.text];
        [tempStr deleteCharactersInRange:NSMakeRange(range.location, 1)];
        textStr = tempStr;
    }
    else if (![string isEqualToString:@""]) {
        textStr = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    
    if ([textStr isEqualToString:@"0"] || [textStr isEqualToString:@""]) {
        button.enabled = NO;
    }
    
    else if(isAgree){
        button.enabled = YES;
    }
    
    if (textField.text.length > 4 && ![string isEqualToString:@""]) {
        return NO;
    }
    if ([string isEqualToString:@"."]) {
        return NO;
    }
    return YES;
}

//百分比转换成浮点型  如:75% --> 0.75
+(float)changePercentToFloat:(NSString*)percentStr{
    NSMutableString *str = [NSMutableString stringWithString:percentStr];
    if ([percentStr hasSuffix:@"%"]) {
        [str deleteCharactersInRange:NSMakeRange(str.length - 1, 1)];
    }
    float returnVaule = [str floatValue]/100;
    return returnVaule;
}

//在视图中间显示浮层
+(void)showNotifyHUDAtViewCenter:(UIView*)view withErrorMessage:(NSString *)errorMessage withTextFiled:(UITextField*)textField{
    for (UIView *notifyView in view.subviews) {
        if ([notifyView isMemberOfClass:[WHNotifyHUD class]]) {
            return;
        }
    }
    
    WHNotifyHUD *notify = [WHNotifyHUD notifyHUDWithImage:[UIImage imageNamed:nil] text:errorMessage];
    if (errorMessage.length > 16) {
        if (textField) {
            
            if (textField.keyboardType == UIKeyboardTypeDefault) {
                notify.frame = CGRectMake(40,view.frame.size.height-216-95, 0, 0);
            }
            else{
                notify.frame = CGRectMake(40,view.frame.size.height-216-60, 0, 0);
            }
        }
        else{
            if (textField.keyboardType == UIKeyboardTypeDefault) {
                notify.frame = CGRectMake(40,view.frame.size.height-216-75, 0, 0);
            }
            else{
                notify.frame = CGRectMake(40,view.frame.size.height-216-40, 0, 0);
            }
            
        }
        
    }
    [view addSubview:notify];
    [notify presentWithDuration:2.0f speed:0.5f inView:view completion:^{
        [notify removeFromSuperview];
    }];
}

//在视图底部显示浮层
+(void)showNotifyHUDAtViewBottom:(UIView*)view  withErrorMessage:(NSString *)errorMessage{
    
    if (!errorMessage || [errorMessage isEqualToString:@""]) return;
    
    for (UIView *notifyView in view.subviews) {
        if ([notifyView isMemberOfClass:[WHNotifyHUD class]]) {
            return;
        }
    }
    
    WHNotifyHUD *notify = [WHNotifyHUD notifyHUDWithImage:[UIImage imageNamed:nil] text:errorMessage];
    notify.frame = CGRectMake(40,view.frame.size.height - 40, 0, 0);
    if (errorMessage.length > 16) {
        notify.frame = CGRectMake((kCurrentDeviceWidth - kBDKNotifyHUDDefaultWidth)/2,view.frame.size.height-60, 0, 0);
    }
    else{
        notify.frame = CGRectMake((kCurrentDeviceWidth - kBDKNotifyHUDDefaultWidth)/2,view.frame.size.height-40, 0, 0);
    }
    [view addSubview:notify];
    [notify presentWithDuration:2.0f speed:0.5f inView:view completion:^{
        [notify removeFromSuperview];
    }];
}


// 生成规格化的手机号
+ (NSString*)generateMobileNoCode:(NSString*)str
{
    if (!str || str.length < 1) return nil;
    
    NSMutableString* mobileNoStr = [[NSMutableString alloc] initWithString:@""];
    
    for (int index = 0; index < [str length]; ++index)
    {
        // 生成规格化的手机号
        if (index == 3 || (index - 3 != 0 && (index - 3) % 4 == 0))
        {
            [mobileNoStr appendString:@" "];
        }
        
        [mobileNoStr appendString:[str substringWithRange:NSMakeRange(index, 1)]];
    }
    
    return mobileNoStr;
}

//uicolor 转 uiimage
+ (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

// 将手机号码字符串转成3-4-4格式
+ (NSString*)makePhoneNumStrFormat: (NSString*) phoneStr{
    NSMutableString *str = [NSMutableString stringWithString:phoneStr];
    if (phoneStr.length == 11) {
        [str insertString:@" " atIndex:3];
        [str insertString:@" " atIndex:8];
        [str insertString:@" " atIndex:13];
        return str;
    }
    return phoneStr;
}

// 根据服务器的时间做对应的操作
// 将最新的服务器时间保存在本地，同时计算2次请求时间的差距
#pragma mark - 比较保存在本地的时间和服务器的时间
+ (int) compareTimeInterval:(NSString *)serversTime :(NSString *)operationTypeString
{
    if (!serversTime)
    {
        return 0;
    }
    
    double localServerTime = [WpCommonFunction getLocalServiceTime];
    
    // 取完值后保存新值
    /**
     这里存在问题
     1、若加如下判断，则会导致出现多次手势密码；
     2、若无如下判断，则在home键时导致跳过手势密码页。
     */
    if ([WCFGestureTimer sharedTimer].isInvalidateTimerMark)
        [WpCommonFunction saveServiceTime:serversTime];
    
    // 服务器时间的请求，需要做时间的比较，决定是否弹出手势密码，其他请求不做比较
    if ([operationTypeString isEqualToString:@"getServerTime"])
    {
        // 服务器时间为毫秒，将时间转化为分
        double intervalTime = ([serversTime doubleValue] - localServerTime) / 1000 / 60;
        
        if (localServerTime == 0)
        {
            return 0;
        }
        else if (intervalTime < kShowGesturesViewIntervalTime + 1)
        {
            // 10分钟以内，return 0
            return 0;
        }
        else if (intervalTime < 48 * 60)
        {
            // 大于10 min，return 1
            return 1;
        }
        else
        {
            // 大于48 hour，return 2
            return 2;
        }
    }
    else
    {
        return 0;
    }
}



+(NSString*)changeDateFomat:(NSString*)date DateMark:(NSString*)mark{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[date doubleValue]];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if([mark isEqualToString:@"1"])
    {
        [formatter setDateFormat:@"MM-dd HH:mm:ss"];
    }
    else if([mark isEqualToString:@"2"])
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    else if ([mark isEqualToString:@"3"])
        [formatter setDateFormat:@"MM-dd HH:mm"];
    else if([mark isEqualToString:@"4"])
        [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}



#pragma mark - 获取微操盘H5 Url
+(NSString*)getWCPH5Url:(NSString*)urlAction
{
    if([urlAction hasPrefix:@"http"])
        return urlAction;
    return nil;
//    return [NSString stringWithFormat:@"%@/%@",kH5Domin,urlAction];
}

#pragma mark - 根据URL获取图片
+(void)getImageByUrl:(NSString*)imgUrl Img:(UIImage*)image{
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
    image = [UIImage imageWithData:data];
}

#pragma mark - 删除用户信息
+(void)deleteUserInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:USER_INFO];
    [userDefaults synchronize];
}



+(NSString*)MoneyFormat:(NSString*)money{
    NSMutableString* str = [NSMutableString stringWithString:money];
    NSInteger limit = 0;
    NSInteger length = [str length];
//    if (!(([money floatValue] - [money intValue]) == 0)) {
//        limit = 6;
//    }
//    else{
//        limit = 3;
//    }
    limit = 6;
    if ([money hasPrefix:@"-"]||[money hasPrefix:@"+"]) {
      //  limit+=1;
    }
    
    
    if (length>limit) {
        if (length == 7 && ([money hasPrefix:@"-"] || [money hasPrefix:@"+"])) {
            
        }
        else{
        [str insertString:@"," atIndex:length - limit];
        }
    }
    if(length>limit+4)
    {
        [str insertString:@"," atIndex:length-limit-4];
    }
    money = [NSString stringWithFormat:@"%@",str];
    return money;
}

+(NSString*)DateFormat:(NSString*)date{
    NSMutableString* str = [NSMutableString stringWithString:date];
    [str insertString:@"." atIndex:4];
    [str insertString:@"." atIndex:7];
    date = [NSString stringWithFormat:@"%@",str];
    return str;
}

+(BOOL)userHasLogined{
    NSString* tokenId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_TOKENID];
    if (tokenId) {
        return true;
    }
    return false;
}

+(id)toArrayOrNSDictionary:(NSData *)jsonData{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
    
}


@end
