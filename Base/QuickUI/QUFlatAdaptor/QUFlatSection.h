//
//  QUFlatSection.h
//  IWithYou
//
//  Created by zhuojian on 14-8-30.
//
//

#import "QUSection.h"

#import "QUFlatSectionDelegate.h"

#define sssFlatTitle(x)  ((QUFlatTitleSection*)x)
#define sssFlatIcon(x)   ((QUFlatIconSection*)x)
#define sssFlatIconText(x)   ((QUFlatIconTextSection*)x)
#define sssFlatIconLabel(x)   ((QUFlatIconLabelSection*)x)
#define sssFlatSubmit(x)   ((QUFlatSubmitSection*)x)

#define sssFlatTitleTag(x) ((QUFlatTitleSection*)([self.pAdaptor.pSources sectionWithTag:x]))
#define sssFlatIconTag(x)   ((QUFlatIconSection*)([self.pAdaptor.pSources sectionWithTag:x]))
#define sssFlatIconTextTag(x)   ((QUFlatIconTextSection*)([self.pAdaptor.pSources sectionWithTag:x]))
#define sssFlatIconLabelTag(x)   ((QUFlatIconLabelSection*)([self.pAdaptor.pSources sectionWithTag:x]))
#define sssFlatSubmitTag(x)   ((QUFlatSubmitSection*)([self.pAdaptor.pSources sectionWithTag:x]))
#define sssFlatTipTag(x) ((QUFlatTipSection*)([self.pAdaptor.pSources sectionWithTag:x]))


@class QUFlatSubmitSection;
@class QUBackgroundButton;

@interface QUFlatSection : QUSection

@end

@interface QUFlatTitleSection : QUFlatSection
@property(nonatomic,weak)IBOutlet UILabel* lblTitle;
@end

@interface QUFlatBigTitleSection : QUFlatTitleSection
@end

@interface QUFlatIconSection : QUFlatSection
@property(nonatomic,weak)IBOutlet UIImageView* viewIcon;
@end

@interface QUFlatIconTextSection : QUFlatIconSection
@property(nonatomic,weak)IBOutlet UITextField* txtInput;

-(void)becomeFirstResponder;
@end

@interface QUFlatIconLabelSection : QUFlatIconSection
@property(nonatomic,weak)IBOutlet UILabel* lblTitle;
@end



@interface QUFlatTipSection : QUFlatTitleSection
@end



@interface QUFlatSubmitSection : QUFlatSection
@property(nonatomic,weak)IBOutlet QUBackgroundButton* btnSubmit;
@property(nonatomic,weak)id<QUFlatSubmitSectionDelegate> pDelegate;
@end

/** 验证码 */
@interface QUFlatValidCodeSection : QUFlatIconTextSection
@property(nonatomic,weak)IBOutlet QUBackgroundButton* btnValidCode;
@property(nonatomic,weak)id<QUFlatSubmitSectionDelegate> pDelegate;
@end

