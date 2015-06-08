//
//  userValidate.h
//  IWithYou
//
//  Created by lifeng on 12-11-6.
//
//

#import <Foundation/Foundation.h>


@interface validateObject : NSObject
@property(nonatomic,retain)NSString* error;
@property(nonatomic,retain)NSObject* value;
@property(nonatomic,retain)NSObject* value2;
@property(nonatomic,assign)int tag;
+(id)object;
@end

@interface validateItem:NSObject
{
}
-(id)initWithObject:(validateObject*)object;
-(BOOL)validate;
+(id)validateWithObject:(validateObject*)object;

@property(nonatomic,retain)validateObject* m_object;
@end

@interface validateNotEmpty : validateItem 
-(BOOL)validate;
@end

@interface validateEmail : validateItem
-(BOOL)validate;
@end

@interface validateNickName : validateItem
-(BOOL)validate;
@end

@interface validateCompareTwo: validateItem
-(BOOL)validate;
@end

@interface validateNotCompareTwo: validateItem
-(BOOL)validate;
@end

@interface validateLengthMin : validateItem
-(BOOL)validate;
@end

@interface validateLengthMax : validateItem
-(BOOL)validate;
@end

@interface validatePhone : validateItem
-(BOOL)validate;
@end

@interface validateNumber : validateItem
-(BOOL)validate;
@end

@interface validateMoney : validateItem
-(BOOL)validate;
@end

@interface validateRegular : validateItem
-(BOOL)validate;
@end

// 短信验证码的验证，6位数字
@interface verifyVerifCode : validateItem
-(BOOL)validate;
@end

// 银行卡CVV2的验证，3位数字
@interface cvv2Code : validateItem
-(BOOL)validate;
@end

// 银行卡有效期的验证，4位数字
@interface validityCode : validateItem
-(BOOL)validate;
@end

// 操盘宝昵称的设置
@interface ValidateCPBNickName : validateItem
-(BOOL)validate;
@end

// 银行卡号的验证
@interface ValidateBankCardNo : validateItem
-(BOOL)validate;
@end

// 真实姓名的设置 2~14个字符
@interface ValidateRealName : validateItem
-(BOOL)validate;
@end

// 身份证的设置 CPB_Regex_SfzID
@interface ValidateSfzID : validateItem
-(BOOL)validate;
@end

@protocol userValidateOperation<NSObject>
@optional
-(void)userValidate_ValidateSucc;
-(void)userValidate_ValidateFailed:(validateItem*)item;
@end

@interface userValidate : NSObject
{
    id _delegate;
    NSMutableArray* _validateList;
}
-(void)append:(validateItem*)item;
-(BOOL)validate;
@property(nonatomic,retain)id<userValidateOperation> m_delegate;
@end
