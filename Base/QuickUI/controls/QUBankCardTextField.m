//
//  QUBankCardTextField.m
//  CaoPanBao
//
//  Created by 陈宏伟 on 14-8-8.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "QUBankCardTextField.h"
@interface QUBankCardTextFieldHelper()<UITextFieldDelegate>
{
    NSString    *previousTextFieldContent;
    UITextRange *previousSelection;
}
@property(nonatomic,strong)NSString    *previousTextFieldContent;
@property(nonatomic,strong)UITextRange *previousSelection;
@property(nonatomic,weak)QUBankCardTextField* textField;
@end

@implementation QUBankCardTextFieldHelper
-(instancetype)initWithPhoneTextField:(QUBankCardTextField*)textField{
    self=[super init];
    
    self.textField=textField;
    
    self.textField.delegate=self;
    
    return self;
}

#pragma mark - mark UITextField Delegate
- (BOOL)textField                       :(UITextField *)textField
        shouldChangeCharactersInRange   :(NSRange)range
        replacementString               :(NSString *)string
{
    // Note textField's current state before performing the change, in case
    // reformatTextField wants to revert it
    self.previousTextFieldContent = textField.text;
    self.previousSelection = textField.selectedTextRange;
    
    /** 如果实现了自定义的，则走自定义方式 */
    if([self.textField.pDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)])
        return [self.textField.pDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    
    
    NSString* changedString=[textField.text substringWithRange:range];
    
    if([changedString isEqualToString:@" "]) // 如果删除为空格字符
    {
        self.textField.bCurrentDelededBlank=YES;
    }
    else
        self.textField.bCurrentDelededBlank=NO;
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if([self.textField.pDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)])
        return [self.textField.pDelegate textFieldShouldBeginEditing:textField];
    
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    if([self.textField.pDelegate respondsToSelector:@selector(textFieldShouldClear:)])
        return [self.textField.pDelegate textFieldShouldClear:textField];
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if([self.textField.pDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)])
        return [self.textField.pDelegate textFieldShouldEndEditing:textField];
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([self.textField.pDelegate respondsToSelector:@selector(textFieldShouldReturn:)])
        return [self.textField.pDelegate textFieldShouldReturn:textField];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if([self.textField.pDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)])
        [self.textField.pDelegate textFieldDidBeginEditing:textField];
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if([self.textField.pDelegate respondsToSelector:@selector(textFieldDidEndEditing:)])
        [self.textField.pDelegate textFieldDidEndEditing:textField];
}

@end

@interface QUBankCardTextField () <UITextFieldDelegate>
{
    NSString    *previousTextFieldContent;
    UITextRange *previousSelection;
}

@property(nonatomic,strong)QUBankCardTextFieldHelper* helper;
@end

@implementation QUBankCardTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        ////        self.delegate = self;
        //        [self addTarget:self
        //        action          :@selector(reformatAsCardNumber:)
        //        forControlEvents:UIControlEventEditingChanged];
        
        [self setupFormat];
    }
    
    return self;
}

/** 设置格式化输出 */
-(void)setupFormat
{
    self.helper=[[QUBankCardTextFieldHelper alloc] initWithPhoneTextField:self];
    
    [self addTarget:self
   action          :@selector(reformatAsCardNumber:)
   forControlEvents:UIControlEventEditingChanged];
    
    self.returnKeyType=UIReturnKeyDone;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self setupFormat];
}



// Version 1.2
// Source and explanation: http://stackoverflow.com/a/19161529/1709587
- (void)reformatAsCardNumber:(UITextField *)textField
{
    if([[QUBankCardTextField removeFormat:textField.text] length]<=25)
    {
        previousTextFieldContent = textField.text;
        previousSelection = textField.selectedTextRange;
    }
    // In order to make the cursor end up positioned correctly, we need to
    // explicitly reposition it after we inject spaces into the text.
    // targetCursorPosition keeps track of where the cursor needs to end up as
    // we modify the string, and at the end we set the cursor position to it.
    NSUInteger targetCursorPosition =
    [textField offsetFromPosition:textField.beginningOfDocument
                       toPosition:textField.selectedTextRange.start];
    
    NSString *cardNumberWithoutSpaces =
    [self removeNonDigits:textField.text
andPreserveCursorPosition:&targetCursorPosition];
    
    if ([cardNumberWithoutSpaces length] > 25) {
        // If the user is trying to enter more than 19 digits, we prevent
        // their change, leaving the text field in  its previous state.
        // While 16 digits is usual, credit card numbers have a hard
        // maximum of 19 digits defined by ISO standard 7812-1 in section
        // 3.8 and elsewhere. Applying this hard maximum here rather than
        // a maximum of 16 ensures that users with unusual card numbers
        // will still be able to enter their card number even if the
        // resultant formatting is odd.
        [textField setText:self.helper.previousTextFieldContent];
        textField.selectedTextRange = self.helper.previousSelection;
        return;
    }
    
    NSString *cardNumberWithSpaces =
    [self insertSpacesEveryFourDigitsIntoString:cardNumberWithoutSpaces
                      andPreserveCursorPosition:&targetCursorPosition];
    // 如果删除了空格，则按照默认输入框删除字符处理
    if(self.bCurrentDelededBlank)
    {
        
    }

    // 否则，常规删除内容，则对删除后内容，重新格式化文本
    else
    {
        textField.text = cardNumberWithSpaces;
        UITextPosition *targetPosition =
        [textField positionFromPosition:[textField beginningOfDocument]
                                 offset:targetCursorPosition];
        
        [textField setSelectedTextRange:
         [textField textRangeFromPosition:targetPosition
         toPosition                      :targetPosition]
         
         ];
    }
}



/*
 *   Removes non-digits from the string, decrementing `cursorPosition` as
 *   appropriate so that, for instance, if we pass in `@"1111 1123 1111"`
 *   and a cursor position of `8`, the cursor position will be changed to
 *   `7` (keeping it between the '2' and the '3' after the spaces are removed).
 */
- (NSString *)  removeNonDigits             :(NSString *)string
                andPreserveCursorPosition   :(NSUInteger *)cursorPosition
{
    NSUInteger      originalCursorPosition = *cursorPosition;
    NSMutableString *digitsOnlyString = [NSMutableString new];
    
    for (NSUInteger i = 0; i < [string length]; i++) {
        unichar characterToAdd = [string characterAtIndex:i];
        
        if (isdigit(characterToAdd)) {
            NSString *stringToAdd =
            [NSString stringWithCharacters:&characterToAdd
                                    length:1];
            
            [digitsOnlyString appendString:stringToAdd];
        } else {
            if (i < originalCursorPosition) {
                (*cursorPosition)--;
            }
        }
    }
    
    return digitsOnlyString;
}


/*
 *   Inserts spaces into the string to format it as a credit card number,
 *   incrementing `cursorPosition` as appropriate so that, for instance, if we
 *   pass in `@"111111231111"` and a cursor position of `7`, the cursor position
 *   will be changed to `8` (keeping it between the '2' and the '3' after the
 *   spaces are added).
 */
- (NSString *)  insertSpacesEveryFourDigitsIntoString   :(NSString *)string
                andPreserveCursorPosition               :(NSUInteger *)cursorPosition
{
    NSMutableString *stringWithAddedSpaces = [NSMutableString new];
    NSUInteger      cursorPositionInSpacelessString = *cursorPosition;
    
    for (NSUInteger i = 0; i < [string length]; i++) {
        if(i<=4)
        {
            if ((i > 0) && ((i % 4) == 0)) {
                [stringWithAddedSpaces appendString:@" "];
                
                if (i < cursorPositionInSpacelessString) {
                    (*cursorPosition)++;
                }
            }
        }
        else{
            int index=i-4;
            if ((index > 0) && ((index % 4) == 0)) {
                [stringWithAddedSpaces appendString:@" "];
                
                if (i < cursorPositionInSpacelessString) {
                    (*cursorPosition)++;
                }
            }
        }
        
        unichar     characterToAdd = [string characterAtIndex:i];
        NSString    *stringToAdd =
        [NSString stringWithCharacters:&characterToAdd length:1];
        
        [stringWithAddedSpaces appendString:stringToAdd];
    }
    
    return stringWithAddedSpaces;
}


/**  格式化手机号 */
+ (NSString *)formatMobile:(NSString *)string
{
    NSMutableString *stringWithAddedSpaces = [NSMutableString new];
    
    for (NSUInteger i = 0; i < [string length]; i++) {
        
        if(i<=4)
        {
            if ((i > 0) && ((i % 4) == 0)) {
                [stringWithAddedSpaces appendString:@" "];
                
                
            }
        }
        else{
            int index=i-4;
            if ((index > 0) && ((index % 4) == 0)) {
                [stringWithAddedSpaces appendString:@" "];
                
                
            }
        }
        
        unichar     characterToAdd = [string characterAtIndex:i];
        NSString    *stringToAdd =
        [NSString stringWithCharacters:&characterToAdd length:1];
        
        [stringWithAddedSpaces appendString:stringToAdd];
    }
    
    return stringWithAddedSpaces;
}

+(NSString*)removeFormat:(NSString*)string{
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}

#pragma mark - textField Delegate
- (BOOL)textField                       :(UITextField *)textField
        shouldChangeCharactersInRange   :(NSRange)range
        replacementString               :(NSString *)string
{
    // Note textField's current state before performing the change, in case
    // reformatTextField wants to revert it
//    previousTextFieldContent = textField.text;
//    previousSelection = textField.selectedTextRange;
    
    /** 如果实现了自定义的，则走自定义方式 */
    if([self.pDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)])
        return [self.pDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    
    
    NSString* changedString=[textField.text substringWithRange:range];
    
    if([changedString isEqualToString:@" "]) // 如果删除为空格字符
    {
        self.bCurrentDelededBlank=YES;
    }
    else
        self.bCurrentDelededBlank=NO;
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if([self.pDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)])
        return [self.pDelegate textFieldShouldBeginEditing:textField];
    
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    if([self.pDelegate respondsToSelector:@selector(textFieldShouldClear:)])
        return [self.pDelegate textFieldShouldClear:textField];
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if([self.pDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)])
        return [self.pDelegate textFieldShouldEndEditing:textField];
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([self.pDelegate respondsToSelector:@selector(textFieldShouldReturn:)])
        return [self.pDelegate textFieldShouldReturn:textField];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if([self.pDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)])
        [self.pDelegate textFieldDidBeginEditing:textField];
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if([self.pDelegate respondsToSelector:@selector(textFieldDidEndEditing:)])
        [self.pDelegate textFieldDidEndEditing:textField];
}



@end
