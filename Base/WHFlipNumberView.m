//
//  FlipNumberView.m
//
//  Created by Markus Emrich on 26.02.11.
//  Copyright 2011 Markus Emrich. All rights reserved.
//
//
//  based on
//  www.voyce.com/index.php/2010/04/10/creating-an-ipad-flip-clock-with-core-animation/
//

#import "WHFlipNumberView.h"

static NSString* kFlipAnimationKey = @"kFlipAnimationKey";

@interface WHFlipNumberView()
{
    BOOL alreadyLayout;
    BOOL isPause;
}
@end

@implementation WHFlipNumberView

@synthesize delegate;
@synthesize currentAnimationDuration,nowNum,mTopImages,
mImageViewFlip,mCurrentValue,mBottomImages,mCurrentState,
mImageViewBottom,mImageViewTop,mMaxValue;

- (id) init
{
	return [self initWithIntValue: 0];
}

-(void)initNumberData{
    self.nowNum=0;
}

-(void)awakeFromNib{
    [self initNumberData];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)changeNumber:(NSInteger )number{
    self.beLoadedAnmation=YES;
    self.nowNum = number;
    [self animateToPreviousNumber];
}

- (id) initWithIntValue: (NSUInteger) startNumber
{
    self = [super initWithFrame: CGRectZero];
    if (self)
	{
        [self layoutNumberView:startNumber];
    }
    return self;
}

-(void)layoutNumberView:(NSUInteger)startNumber{
    if(alreadyLayout)
        return;
    
    alreadyLayout=YES;
    
    self.backgroundColor = [UIColor clearColor];
    self.autoresizesSubviews = NO;
//    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    
    mCurrentValue = startNumber;
    [self initImages];
    UIImage* image = [mTopImages objectAtIndex: mCurrentValue];
    super.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, image.size.width, image.size.height*2);
}

// needed to release view properly
- (void) removeFromSuperview
{
	[self stopAnimation];
	[super removeFromSuperview];
}

- (void) stopAnimation
{
	[mImageViewFlip.layer removeAllAnimations];
	mImageViewFlip.hidden = YES;
}

- (void) initImages
{
	NSMutableArray* filenames = [NSMutableArray arrayWithCapacity: 10];
	for (int i = 0; i < 10; i++) {
		[filenames addObject: [NSString stringWithFormat: @"%d.png", i]];
	}
	
	NSMutableArray* images = [NSMutableArray arrayWithCapacity: [filenames count]*2];
	
	// create bottom and top images
	for (int i = 0; i < 2; i++)
	{
		for (NSString* filename in filenames)
		{
			UIImage* image	= [UIImage imageNamed: [NSString stringWithFormat: @"%@", filename]];
			CGSize size		= CGSizeMake(image.size.width, image.size.height/2);
			CGFloat yPoint	= (i==0) ? 0.0 : -size.height;
			UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
			[image drawAtPoint:CGPointMake(0.0,yPoint)];
			UIImage *top = UIGraphicsGetImageFromCurrentImageContext();
			[images addObject: top];
			UIGraphicsEndImageContext();
		}
	}
	
	mTopImages	  = [images subarrayWithRange: NSMakeRange(0, [filenames count])];
	mBottomImages = [images subarrayWithRange: NSMakeRange([filenames count], [filenames count])];
	
	// setup image views
	mImageViewTop	 = [[UIImageView alloc] initWithImage: [mTopImages    objectAtIndex: mCurrentValue]];
	mImageViewBottom = [[UIImageView alloc] initWithImage: [mBottomImages objectAtIndex: mCurrentValue]];
	mImageViewFlip	 = [[UIImageView alloc] initWithImage: [mTopImages    objectAtIndex: mCurrentValue]];
    mImageViewFlip.hidden = YES;
	
	mImageViewBottom.frame = CGRectMake(0, mImageViewTop.image.size.height, mImageViewTop.image.size.width, mImageViewTop.image.size.height);
	
	// add image views
	[self addSubview: mImageViewTop];
	[self addSubview: mImageViewBottom];
	[self addSubview: mImageViewFlip];
	
	// setup default 3d transform
	[self setZDistance: (mImageViewTop.image.size.height*2)*3];
}

- (CGSize) sizeThatFits: (CGSize) aSize
{
    if (!mTopImages || [mTopImages count] <= 0) {
        return [super sizeThatFits: aSize];
    }
    
    UIImage* image = (UIImage*)[mTopImages objectAtIndex: 0];
    CGFloat ratioW     = aSize.width/aSize.height;
    CGFloat origRatioW = image.size.width/(image.size.height*2);
    CGFloat origRatioH = (image.size.height*2)/image.size.width;
    
    if (ratioW>origRatioW)
    {
        aSize.width = aSize.height*origRatioW;
    }
    else
    {
        aSize.height = aSize.width*origRatioH;
    }
    
    return aSize;
}


#pragma mark -
#pragma mark external access

- (void) setFrame: (CGRect)rect
{
    [self setFrame:rect allowUpscaling:NO];
}

- (void) setFrame: (CGRect)rect allowUpscaling:(BOOL)upscalingAllowed
{
    if (!upscalingAllowed) {
        rect.size.width  = MIN(rect.size.width, mImageViewTop.image.size.width);
        rect.size.height = MIN(rect.size.height, mImageViewTop.image.size.height*2);
    }
    
    rect.size = [self sizeThatFits: rect.size];
	[super setFrame: rect];
    
    rect.origin = CGPointMake(0, 0);
    rect.size.height /= 2.0;
    mImageViewTop.frame = rect;
    rect.origin.y += rect.size.height;
    mImageViewBottom.frame = rect;
    
	if (mCurrentState == eFlipStateFirstHalf) {
        mImageViewFlip.frame = mImageViewTop.frame;
    } else {
        mImageViewFlip.frame = mImageViewBottom.frame;
    }
	
	[self setZDistance: self.frame.size.height*3];
}

- (void) setZDistance: (NSUInteger) zDistance
{
	// setup 3d transform
	CATransform3D aTransform = CATransform3DIdentity;
	aTransform.m34 = -1.0 / zDistance;
	self.layer.sublayerTransform = aTransform;
}



#pragma mark - no animation
// 无动画切换方式
-(void)previousNumber:(int)number{
	
    self.nowNum=number;
    
	// get next value
    NSUInteger nextIndex = self.nowNum;

    // setup first animation half
    mImageViewFlip.frame   = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/2.0);

    mImageViewTop.image	   = [mTopImages    objectAtIndex: nextIndex];
    
    mImageViewBottom.image = [mBottomImages objectAtIndex: nextIndex];
    
    mImageViewFlip.image = [mBottomImages objectAtIndex: nextIndex];

    mCurrentValue = self.nowNum;

	// add/start animation
    mCurrentState = eFlipStateFirstHalf;

    
	// show animated view
	mImageViewFlip.hidden = YES;

}


#pragma mark - animation

- (CGFloat) defaultAnimationDuration
{
	return 0.25;
}

- (void) animateToPreviousNumber
{
	[self animateToPreviousNumberWithDuration: [self defaultAnimationDuration]];
}

- (void) animateToPreviousNumberWithDuration: (CGFloat) duration
{
    [self animateIntoCurrentDirectionWithDuration: duration];
}

- (void) animateIntoCurrentDirectionWithDuration: (CGFloat) duration
{

	currentAnimationDuration = duration;
	
	// get next value
    NSUInteger nextIndex = self.nowNum;
	[self updateFlipViewFrame];
	
	// setup animation
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
	animation.duration	= currentAnimationDuration;
	animation.delegate	= self;
	animation.removedOnCompletion = NO;
	animation.fillMode = kCAFillModeForwards;
    
	// exchange images & setup animation
	if (mCurrentState == eFlipStateFirstHalf)
	{
		// setup first animation half
		mImageViewFlip.frame   = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/2.0);
		mImageViewFlip.image   = [mTopImages	objectAtIndex: mCurrentValue];
		mImageViewBottom.image = [mBottomImages objectAtIndex: mCurrentValue];
		mImageViewTop.image	   = [mTopImages    objectAtIndex: nextIndex];
        
		// inform delegate
		if ([delegate respondsToSelector: @selector(flipNumberView:willChangeToValue:)]) {
			[delegate flipNumberView: self willChangeToValue: nextIndex];
		}
		
		animation.fromValue	= [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.0, 1, 0, 0)];
		animation.toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-M_PI_2, 1, 0, 0)];
		animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
	}
	else
	{
		// setup second animation half
		mImageViewFlip.image = [mBottomImages objectAtIndex: nextIndex];
        
		animation.fromValue	= [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 1, 0, 0)];
		animation.toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.0, 1, 0, 0)];
		animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
	}
	
	// add/start animation
    
	[mImageViewFlip.layer addAnimation: animation forKey: kFlipAnimationKey];
    
	// show animated view
	mImageViewFlip.hidden = NO;
    
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{

	if (!flag) {
		return;
	}
	
	if (mCurrentState == eFlipStateFirstHalf)
	{
		// do second animation step
		mCurrentState = eFlipStateSecondHalf;
		[self animateIntoCurrentDirectionWithDuration: currentAnimationDuration];
	}
	else
	{
		// reset state
		mCurrentState = eFlipStateFirstHalf;
		
		// set new value
		mCurrentValue = self.nowNum;
		
		// update images
		mImageViewBottom.image = [mBottomImages objectAtIndex: mCurrentValue];
        mImageViewFlip.hidden  = YES;
		
		// remove old animation
		[mImageViewFlip.layer removeAnimationForKey: kFlipAnimationKey];
		
		// inform delegate
		if ([delegate respondsToSelector: @selector(flipNumberView:didChangeValue:animated:)]) {
			[delegate flipNumberView: self didChangeValue: mCurrentValue animated: YES];
		}
	}
        
}


#pragma mark -
#pragma mark helper


- (NSUInteger) nextValue
{
	return [self validValueFromInt: mCurrentValue+1];
}

- (NSUInteger) validValueFromInt: (NSInteger) index
{
    if (index<0) {
        index += (mMaxValue+1);
    }
    NSUInteger newIndex = index % (mMaxValue+1);
    
    return newIndex;
}

- (void) updateFlipViewFrame
{
	if (mCurrentState == eFlipStateFirstHalf)
	{
		mImageViewFlip.layer.anchorPoint = CGPointMake(0.5, 1.0);
		mImageViewFlip.frame = mImageViewTop.frame;
	}
	else
	{
		mImageViewFlip.layer.anchorPoint = CGPointMake(0.5, 0.0);
		mImageViewFlip.frame = mImageViewBottom.frame;
	}
}

#pragma mark animation start and stop

- (void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

- (void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

/**暂停layer上面的动画*/
- (void)pauseAnimation
{
//    isPause = YES;
//    
////    [self pauseLayer:self.layer];
////    [self resumeLayer:mImageViewFlip.layer];
////    [mImageViewFlip.layer removeAllAnimations];
}

/**继续layer上面的动画*/
- (void)resumeAnimation:(int)number
{
    isPause = NO;
    
    if(!self.beLoadedAnmation)  // 初次不执行，只用于动画恢复
        return;
    
    [self previousNumber:number];

//    [self resumeLayer:self.layer];
//    [self resumeLayer:mImageViewFlip.layer];
}

@end
