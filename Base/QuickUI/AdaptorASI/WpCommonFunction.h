//
//  WpCommonFunction.h
//  WeiboPaySdkLib
//
//  Created by Mark on 13-3-18.
//  Copyright (c) 2013年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define VERSIONFILE_UPDATE              @"update"

#pragma mark - WpCommonFunction

@interface WpCommonFunction : NSObject

#pragma mark - 版本升级
// 打开强制更新页
+ (void)appUpdateViewWithType:(NSInteger)type andUrl:(NSString*)url andDelegate:(id)delegate;

+ (NSString*)JsonStringFromDict:(NSDictionary*)dict andKey:(const NSString*)key;
// 得到目录在Document目录下的路径（修改为将文件保存到Cache目录）
+ (NSString*)getFolderPathInDocument:(NSString*)folderPath;
// 得到文件在Document目录下的路径
+ (NSString*)getFilePathInDocument:(NSString*)folderPath withFileName:(NSString*)fileName andFileType:(NSString*)fileType;
// 记录系统版本号
+ (void)saveUserAppVersion;
// 判断版本是否更新
+ (BOOL)isAppUpdate;

// 将数字转化为带有2位小数的标准浮点型字符串
+ (NSString *) transformStringTo2PointFloatString:(NSString *)floatString;

//获取当前时间的13位时间戳
+ (NSString *)getNowData;
// 将豪秒转化为标准时间
+ (NSString *)dateFromMilliscondServer:(NSString*)dateServer;
// 按豪秒返回当前的时间 年-月
+ (NSString *) monthFromMilliSecondServer:(NSString *)dateServer;
// 将秒转化为标准时间
+ (NSString *)dateFromScondServer:(NSString*)dateServer;
// 按秒返回当前的月份
+ (int) monthFromSecondServer:(NSString *)dateServer;

// 移除字符串中所有的空格
+ (NSString*)stringRemoveAllWhiteSpace:(NSString*)str;
// 判断字符串是否为空
+ (BOOL)isStringNull:(NSString*)str;
// 使用正则表达式校验字符串
+ (BOOL)testRegex:(NSString*)regex WithString:(NSString*)str;
// 判断字符是否全部相同
+ (BOOL) isSameWithAllChar:(NSString *)targetString;
// 判断字符串是否为连续的数字
+ (BOOL) isContinuousNumber:(NSString *)numString;
// 检查支付密码格式 -- 以浮层形式提示
+ (BOOL)verifyPaymentPassword:(NSString*)password onView:(UIView*)view;
// 以下两个方法和verifyPaymentPassword实现相同，只是提示文案有些许差别
// 检查老支付密码的格式
+ (BOOL)verifyOldPaymentPassword:(NSString*)password;
// 检查老支付密码格式 -- 以浮层形式提示
+ (BOOL)verifyOldPaymentPassword:(NSString*)password onView:(UIView*)view;
// 检查新支付密码的格式
+ (BOOL)verifyNewPaymentPassword:(NSString*)password;
// 检查金额格式
+ (BOOL)verifyPrice:(NSString*)price;
// 检查金额格式大于0
+ (BOOL)verifyPriceUPZero:(NSString*)price;
// 金额大小比较
+ (NSComparisonResult)comparePrice1:(NSString*)price1 andPrice2:(NSString*)price2;

// 得到WeiboPay设备唯一标识
+ (NSString*)getUniqueDeviceIdentifier;

// 获得设备标识
+ (NSString*)macaddress;
+ (NSString*)wpUniqueDeviceIdentifier;

// 统计事件
+ (void)statEvent:(NSString*)eventId;


// alert message
// 打开一个警告对话框
+ (void)messageBoxOneButtonWithMessage:(NSString*)message andTitle:(NSString*)title andButton:(NSString*)buttonTitle andTag:(NSInteger)tag andDelegate:(id)delegate;
+ (void)messageBoxWithMessage:(NSString*)message;
+ (void)messageBoxOneButtonWithMessage:(NSString*)message andTag:(NSInteger)tag andDelegate:(id)delegate;
+ (void)messageBoxOneButtonWithMessage:(NSString*)message andTitle:(NSString*)title andTag:(NSInteger)tag andDelegate:(id)delegate;
+ (void)messageBoxTwoButtonWithMessage:(NSString*)message andTitle:(NSString*)title andLeftButton:(NSString*)leftButtonTitle andRightButton:(NSString*)rightButtonTitle andTag:(NSInteger)tag andDelegate:(id)delegate;
+ (void)messageBoxTwoButtonWithMessage:(NSString*)message andTag:(NSInteger)tag andDelegate:(id)delegate;
+ (void)messageBoxTwoButtonWithMessage:(NSString*)message andTitle:(NSString*)title andTag:(NSInteger)tag andDelegate:(id)delegate;
+ (void)messageBoxTwoButtonWithMessage:(NSString*)message andTag:(NSInteger)tag andDelegate:(id)delegate andPayload:(id)payload;
+ (void)messageBoxTwoButtonWithMessage:(NSString*)message andTitle:(NSString*)title andLeftButton:(NSString*)leftButtonTitle andRightButton:(NSString*)rightButtonTitle andTag:(NSInteger)tag andDelegate:(id)delegate andPayload:(id)payload;
+ (BOOL)isShowMessageBox;

// 设置圆角
+ (void)setView:(UIView*)view cornerRadius:(CGFloat)radius;

#pragma mark - 将数据保存在本地
+ (void) saveServiceTime:(NSString *)serviceTime;
+ (double) getLocalServiceTime;

#pragma mark - 获取mobile + avatar数据
+ (NSArray *)getLocalAccountMobile;
// 根据手机号得到（mobileNo + avatarImage）数据
+ (NSArray *)getLocalDataWithMobileNo:(NSString *)mobileNo;
// 根据memberID得到（mobileNo + avatarImage）数据
+ (NSArray *)getLocalDataWithMemberId:(NSString *)memberId;
// 获取保存在第一个的手机号
+ (NSArray *)getLocalDataWithFirst;
// 将数据保存在本地（string）
+ (void) saveAccountMobileToLocalData:(NSString *)mobileString :(NSString *)avatarString;
// 删除数据(string)
+ (void) deleteAccountMobileFromLocalData:(NSString *)mobileString;


// 保存memberID和Cookies值
+ (NSArray *)getCookiesAndMemberIDFromLocal;
// 将数据保存在本地（string）
+ (void) saveCookiesAndMemberIDToLocal;
// 删除memberID和Cookies值(退出登录是)
+ (void) delegateCookiesAndMemberIDFromLocal;

#pragma mark - 判断用户是否查看了引导页
+ (BOOL)getDeviceDoesLookoverGuidePageFromLocal;

+ (void) saveDeviceLookoverGuidePageToLocal;


// 隐藏键盘
+ (void)hideKeyboardWithScrollView:(UIScrollView*)scrollView;

// 显示下拉列表
+ (void)showPickerViewWithTag:(NSInteger)tag andDefaultSelIndex:(NSInteger)selIndex andDelegate:(id)delegate;
+ (void)showPickerViewWithTag:(NSInteger)tag andDefaultSelIndexList:(NSArray*)selIndexList andDelegate:(id)delegate;

// 获取微操盘H5 Url
+(NSString*)getH5Url:(NSString*)urlAction;
// 跳转h5页面
+(void)turnToH5PageWithUrl:(NSString*)urlAction withTitleName:(NSString*)title onController:(UIViewController*)controller;

/** 自定义alert弹出动画*/
+(void)animationForAlertShow:(UIView *)view;

/** 使手机号码中间四位变成星号*/
+(NSString *)makePhoneNumSecurity:(NSString *)phone;

/** 拨打客服电话*/
+(void)telPhoneToCustomerService;

/** 将图片转为Base64字符串（头像上传） */
+(NSString *)transformImageDataToBase64String:(NSData *)imagedata;

/** 将Base64字符串转成图片（图片下载） */
+(NSData *)transformBase64StringToImageData:(NSString *)base64Str;


/** 校验输入金额格式是否正确并改变按钮是否可按 -- 可输入小数点及小数点后两位*/
+(BOOL)textMoneyTextAndButtonStatusContainRadixPoint:(UIButton*)button withAgree:(BOOL)isAgree andTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

/** 校验输入金额格式是否正确并改变按钮是否可按 -- 不可以输入小数点*/
+(BOOL)textMoneyTextAndButtonStatusWithOutRadixPoint:(UIButton*)button withAgree:(BOOL)isAgree andTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

/** 百分比转换成浮点型  如:75% --> 0.75 */
+(float)changePercentToFloat:(NSString*)percentStr;

/** 在视图中间显示浮层 */
+(void)showNotifyHUDAtViewCenter:(UIView*)view withErrorMessage:(NSString *)errorMessage withTextFiled:(UITextField*)textField;

/** 在视图底部显示浮层 */
+(void)showNotifyHUDAtViewBottom:(UIView*)view  withErrorMessage:(NSString *)errorMessage;

// 生成规格化的手机号
+ (NSString*)generateMobileNoCode:(NSString*)str;

/** uicolor 转 uiimage*/
+ (UIImage*)createImageWithColor: (UIColor*) color;

/** 将手机号码字符串转成3-4-4格式 */
+ (NSString*)makePhoneNumStrFormat: (NSString*) phoneStr;

#pragma mark - 10分钟后和48小时候后的相关操作
// 10分钟后：验证手势密码
// 48小时候，验证手势密码，若处在登录页，需要跳转登录
+ (BOOL) operationWithLeaveUnused:(NSString *)serversTime :(NSString *)operationTypeString;

// 根据服务器的时间做对应的操作
// 将最新的服务器时间保存在本地，同时计算2次请求时间的差距
#pragma mark - 比较保存在本地的时间和服务器的时间
+ (int) compareTimeInterval:(NSString *)serversTime :(NSString *)operationTypeString;

// 登录成功后缓存数据，并跳转页面
+ (void) loginSuccessedOperation:(UIViewController *)viewController;

// 检查是否设置了手势密码
//+ (void) checkoutGesturePassword:(id<WHGesturePswDrawedResultDelegate>)parentViewController;

#pragma mark - 获取微操盘H5 Url
+(NSString*)getWCPH5Url:(NSString*)urlAction;

+(NSString*)changeDateFomat:(NSString*)date DateMark:(NSString*)mark;
#pragma mark - 根据URL获取图片
+(void)getImageByUrl:(NSString*)imgUrl Img:(UIImage*)image;

#pragma mark - 删除用户信息
+(void)deleteUserInfo;

#pragma mark - 数字增加逗号
+(NSString*)MoneyFormat:(NSString*)money;

#pragma mark - 日期加小数点
+(NSString*)DateFormat:(NSString*)date;


@end
