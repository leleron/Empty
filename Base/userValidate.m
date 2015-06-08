//
//  userValidate.m
//  IWithYou
//
//  Created by lifeng on 12-11-6.
//
//

#import "userValidate.h"


@implementation validateObject
@synthesize value;
@synthesize  value2;
@synthesize error;
@synthesize tag;
+(id)object{
    return [[validateObject alloc] init];
}
@end

@implementation validateItem
@synthesize m_object;
-(BOOL)validate{
    return YES;
}
-(id)initWithObject:(validateObject *)object{
    self=[super init];
    self.m_object=object;
    return self;
}

+(id)validateWithObject:(validateObject*)object{
    return [[validateItem alloc] initWithObject:object];
}

@end

@implementation validateNotEmpty
-(BOOL)validate{
    BOOL isMatch=NO;
    if(!self.m_object.value) //判断二进制数据，如图片类，直接看地址是否为空
        return NO;
    
    if([self.m_object.value isKindOfClass:[UIImage class]]) // 如果是UIIMAGE则不往下验证
        return YES;
    
    NSString * string = (NSString*)self.m_object.value;
    NSString * trimed =[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(trimed.length>0)
        isMatch=YES;
    return isMatch;
}

+(id)validateWithObject:(validateObject*)object{
    return [[validateNotEmpty alloc] initWithObject:object];
}

@end

@implementation validateEmail
-(BOOL)validate{
    NSString * regex = @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self.m_object.value];
    //NSLog(@"isMatch:%d",isMatch);
    return isMatch;
}
+(id)validateWithObject:(validateObject*)object{
    return [[validateEmail alloc] initWithObject:object];
}
@end

@implementation validateNickName;
-(BOOL)validate{
    BOOL isMatch=YES;
    NSString* nickName=(NSString*)self.m_object.value;
    if(nickName.length<2)
    {
        isMatch=NO;
    }
    return isMatch;
}
+(id)validateWithObject:(validateObject*)object{
    return [[validateNickName alloc] initWithObject:object];
}
@end

@implementation validateCompareTwo
-(BOOL)validate{
    BOOL isMatch=YES;
    NSString* text1=(NSString*)self.m_object.value;
    NSString* text2=(NSString*)self.m_object.value2;
    if(![text1 isEqualToString:text2])
    {
        //NSLog(@"validate error:%@",self.m_object.error);
        isMatch=NO;
    }
    return isMatch;
}
+(id)validateWithObject:(validateObject*)object{
    return [[validateCompareTwo alloc] initWithObject:object];
}
@end

@implementation validateNotCompareTwo
-(BOOL)validate{
    BOOL isMatch=YES;
    NSString* text1=(NSString*)self.m_object.value;
    NSString* text2=(NSString*)self.m_object.value2;
    if([text1 isEqualToString:text2])
        {
        //NSLog(@"validate error:%@",self.m_object.error);
        isMatch=NO;
        }
    return isMatch;
}
+(id)validateWithObject:(validateObject*)object{
    return [[validateNotCompareTwo alloc] initWithObject:object];
}
@end

@implementation validateLengthMin

-(BOOL)validate{
    BOOL isMatch=YES;
    NSString* text=(NSString*)self.m_object.value;
    NSNumber* min=(NSNumber*)self.m_object.value2;
    if(text.length<[min integerValue])
    {
        isMatch=NO;
    }
    return isMatch;
}
+(id)validateWithObject:(validateObject*)object{
    return [[validateLengthMin alloc] initWithObject:object];
}


@end
@implementation validateLengthMax
-(BOOL)validate{
    BOOL isMatch=YES;
    NSString* text=(NSString*)self.m_object.value;
    NSNumber* max=(NSNumber*)self.m_object.value2;
    if(text.length>[max integerValue])
    {
        isMatch=NO;
    }
    return isMatch;
}
+(id)validateWithObject:(validateObject*)object{
    return [[validateLengthMax alloc] initWithObject:object];
}
@end

@implementation validatePhone
-(BOOL)validate{
    BOOL isMatch=NO;
    NSString *Regex = @"^([1])([0-9]{10})$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    
    isMatch= [phoneTest evaluateWithObject:self.m_object.value];
    return isMatch;
}

+(id)validateWithObject:(validateObject*)object{
    return [[validatePhone alloc] initWithObject:object];
}

@end

@implementation validateNumber
-(BOOL)validate{
    BOOL isMatch=NO;
    NSString *Regex = @"^\\d+$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    
    isMatch= [phoneTest evaluateWithObject:self.m_object.value];
    return isMatch;
}

+(id)validateWithObject:(validateObject*)object{
    return [[validateNumber alloc] initWithObject:object];
}

@end

@implementation validateMoney

-(BOOL)validate{
    BOOL isMatch=NO;
    NSString *Regex = @"^[0-9]+(.[0-9]{1,2})?$|^[0-9]*$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    
    isMatch= [phoneTest evaluateWithObject:self.m_object.value];
    return isMatch;
}

+(id)validateWithObject:(validateObject*)object{
    return [[validateMoney alloc] initWithObject:object];
}

@end

@implementation validateRegular

-(BOOL)validate{
    BOOL isMatch=NO;
//    NSString *Regex = @"^[0-9]+(.[0-9]{1,2})?$|^[0-9]*$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", self.m_object.value2];
    
    isMatch= [phoneTest evaluateWithObject:self.m_object.value];
    return isMatch;
}

+(id)validateWithObject:(validateObject*)object{
    return [[validateRegular alloc] initWithObject:object];
}

@end

// 短信验证码的验证，6位数字
@implementation verifyVerifCode

-(BOOL)validate
{
    BOOL isMatch = NO;
    NSString *Regex = @"([0-9]{6})$";
    
    NSPredicate *verifyCodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    
    isMatch= [verifyCodeTest evaluateWithObject:self.m_object.value];
    return isMatch;
}

+(id)validateWithObject:(validateObject*)object{
    return [[verifyVerifCode alloc] initWithObject:object];
}
@end
// 银行卡CVV的验证，3位数字
@implementation cvv2Code

-(BOOL)validate
{
    BOOL isMatch = NO;
    NSString *Regex = @"([0-9]{3})$";
    
    NSPredicate *verifyCodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    
    isMatch= [verifyCodeTest evaluateWithObject:self.m_object.value];
    return isMatch;
}

+(id)validateWithObject:(validateObject*)object{
    return [[cvv2Code alloc] initWithObject:object];
}

@end

// 银行卡有效期的验证，4位数字
@implementation validityCode
-(BOOL)validate
{
    BOOL isMatch = NO;
    NSString *Regex = @"([0-9]{4})$";
    
    NSPredicate *verifyCodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    
    isMatch= [verifyCodeTest evaluateWithObject:self.m_object.value];
    return isMatch;
}

+(id)validateWithObject:(validateObject*)object{
    return [[validityCode alloc] initWithObject:object];
}

@end
// 操盘宝昵称，2-6位中文字
@implementation ValidateCPBNickName

-(BOOL)validate
{
    int strLength = (int)((NSString *)self.m_object.value).length;
    
    if (strLength < 2 || strLength > 6) {
        return NO;
    }
    
    for (int i = 0; i < strLength; ++ i)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [(NSString *)self.m_object.value substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (strlen(cString) != 3)
        {
            return NO;
        }
    }
    
    return YES;
}

+(id)validateWithObject:(validateObject*)object
{
    return [[ValidateCPBNickName alloc] initWithObject:object];
}
@end


// 银行卡号的验证
@implementation ValidateBankCardNo

- (BOOL) validate
{

    BOOL isMatch = NO;
    
    // 银行卡号校验规则 15~25位数字
    NSPredicate *verifyCodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CPB_Regex_BankCardNO];
    
    isMatch= [verifyCodeTest evaluateWithObject:self.m_object.value];
    
    return isMatch;
}

+(id)validateWithObject:(validateObject*)object
{
    return [[ValidateBankCardNo alloc] initWithObject:object];
}


@end

// 真实姓名的设置 2~14个字符
@implementation ValidateRealName

- (BOOL) validate
{
    int strLength = ((NSString *)self.m_object.value).length;
    
    if (strLength < 2 || strLength > 14)
    {
        return NO;
    }
    
    return YES;
}

+(id)validateWithObject:(validateObject*)object
{
    return [[ValidateRealName alloc] initWithObject:object];
}
@end

@implementation ValidateSfzID

- (BOOL) validate
{
    BOOL isMatch = NO;
    
    NSPredicate *verifyCodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CPB_Regex_SfzID];
    
    isMatch= [verifyCodeTest evaluateWithObject:self.m_object.value];
    
    return isMatch;
}

+(id)validateWithObject:(validateObject*)object
{
    return [[ValidateSfzID alloc] initWithObject:object];
}
@end


@implementation userValidate
@synthesize m_delegate;
-(id)init{
    self=[super init];
    _validateList=[[NSMutableArray alloc] initWithCapacity:10];
    return self;
}
-(void)append:(validateItem*)item{
    [_validateList addObject:item];
}
-(BOOL)validate{
    BOOL isMatch=YES;
    for (validateItem* i in _validateList) {

        isMatch=[i validate];
        //NSLog(@"match:%d  %@",isMatch,i.m_object.error);

        if(!isMatch)
        {
            [self.m_delegate userValidate_ValidateFailed:i];
            return NO;
        }
    }
    [self.m_delegate userValidate_ValidateSucc];
    return YES;
}

@end
