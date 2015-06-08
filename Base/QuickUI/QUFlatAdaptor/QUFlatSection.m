//
//  QUFlatSection.m
//  IWithYou
//
//  Created by zhuojian on 14-8-30.
//
//

#import "QUFlatSection.h"

@implementation QUFlatSection

-(void)layoutSection{
    
    QUEntity* e=(QUEntity*)self.entity;
    
    [self.line_bottom indentLineLevel:e.pIndentLevel];
    
    [super layoutSection];
    
}

@end


@implementation QUFlatTitleSection
-(void)layoutSection{
    [super layoutSection];
    
    QUFlatTitleEntity* e=(QUFlatTitleEntity*)self.entity;

    self.lblTitle.text=e.pTitle;
    
}
@end

@implementation QUFlatBigTitleSection
@end

@implementation QUFlatTipSection
@end

@implementation QUFlatIconSection
-(void)layoutSection{
    QUFlatIconTextEntity* e=(QUFlatIconTextEntity*)self.entity;
    self.viewIcon.image=[UIImage imageNamed:e.pIcon];
    
    [super layoutSection];
}
@end

@implementation QUFlatIconTextSection
-(void)layoutSection{
    QUFlatIconTextEntity* e=(QUFlatIconTextEntity*)self.entity;
    
    self.txtInput.text=e.pTitle;
    
    self.txtInput.placeholder=e.pTitlePlaceHold;
    
    [super layoutSection];
}

-(void)becomeFirstResponder{

    // 延迟显示键盘
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)); // 1
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self.txtInput becomeFirstResponder];
    });
    
}

@end

@implementation QUFlatIconLabelSection
-(void)layoutSection{
    QUFlatIconTextEntity* e=(QUFlatIconTextEntity*)self.entity;
    self.lblTitle.text=e.pTitle;
    
    [super layoutSection];
}
@end

@implementation QUFlatSubmitSection

-(void)sectionDidLoad{

    [super sectionDidLoad];
    
    self.pDelegate=(id<QUFlatSubmitSectionDelegate>)self.pAdaptor.delegate; // 与Adaptor 同一委托
    
    [self.btnSubmit addTarget:self action:@selector(clickSubmit:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)layoutSection{
    
    QUFlatTitleEntity* entity=(QUFlatTitleEntity*)self.entity;
    
    [self.btnSubmit setTitle:entity.pTitle forState:UIControlStateNormal];
    
    [super layoutSection];
    
}

-(IBAction)clickSubmit:(id)sender
{
    if([self.pDelegate respondsToSelector:@selector(flatSubmitSection:upInsideButton:)])
    {
        [self.pDelegate flatSubmitSection:self upInsideButton:self.btnSubmit];
    }
}

@end

/**验证码*/
@implementation QUFlatValidCodeSection

-(void)layoutSection{
    [super layoutSection];    
}

-(void)sectionDidLoad{
    self.pDelegate=(id<QUFlatSubmitSectionDelegate>)self.pAdaptor.delegate; // 与Adaptor 同一委托
    
    [self.btnValidCode addTarget:self action:@selector(clickSubmit:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(IBAction)clickSubmit:(id)sender
{
    if([self.pDelegate respondsToSelector:@selector(flatSubmitSection:upInsideButton:)])
    {
        [self.pDelegate flatSubmitSection:self upInsideButton:self.btnValidCode];
    }
}

@end


