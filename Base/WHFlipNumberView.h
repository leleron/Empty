//
//  FlipNumberView.h
//
//  Created by Markus Emrich on 26.02.11.
//  Copyright 2011 Markus Emrich. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef enum
{
	eFlipStateFirstHalf,
	eFlipStateSecondHalf
} eFlipState;

@protocol WHFlipNumberViewDelegate;

#pragma mark -

@interface WHFlipNumberView : UIImageView

@property (nonatomic, weak) id<WHFlipNumberViewDelegate> delegate;
@property (nonatomic, readonly) CGFloat currentAnimationDuration;
@property (nonatomic, assign) NSUInteger nowNum;
@property (nonatomic, assign) NSUInteger mMaxValue;
@property (nonatomic, assign) NSUInteger mCurrentValue;
@property (nonatomic, assign) eFlipState mCurrentState;
@property (nonatomic, strong) NSArray* mTopImages;
@property (nonatomic, strong) NSArray* mBottomImages;
@property (nonatomic, strong) UIImageView* mImageViewTop;
@property (nonatomic, strong) UIImageView* mImageViewBottom;
@property (nonatomic, strong) UIImageView* mImageViewFlip;
@property(nonatomic,assign)   BOOL beLoadedAnmation; // 是否首次载入
- (id) initWithIntValue: (NSUInteger) startNumber;
- (void)changeNumber:(NSInteger )number;
-(void)layoutNumberView:(NSUInteger)startNumber;

- (void)pauseAnimation;
- (void)resumeAnimation:(int)number;
@end


#pragma mark -
#pragma mark delegate
@protocol WHFlipNumberViewDelegate <NSObject>
@optional
- (void) flipNumberView: (WHFlipNumberView*) flipNumberView willChangeToValue: (NSUInteger) newValue;
- (void) flipNumberView: (WHFlipNumberView*) flipNumberView didChangeValue: (NSUInteger) newValue animated: (BOOL) animated;
@end;