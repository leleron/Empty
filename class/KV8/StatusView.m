//
//  StatusView.m
//  KV8
//
//  Created by MasKSJ on 14-8-16.
//  Copyright (c) 2014年 MasKSJ. All rights reserved.
//

#import "StatusView.h"

@implementation StatusView
{
    UIImageView *_head;
    UIImageView *_middle1;
    UIImageView *_middle2;
    UIImageView *_middle3;
    UIImageView *_middle4;
    UIImageView *_middle5;
    UIImageView *_middle6;
    UIImageView *_end;
    NSTimer *_timer;
    NSInteger _number;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _end = [[UIImageView alloc]initWithImage:IMAGE(@"head")];
        _end.frame = CGRectMake(0, 0, 9.75, 15.6);
        [self addSubview:_end];
        
        _middle6 = [[UIImageView alloc]initWithImage:IMAGE(@"middle")];
        _middle6.frame = CGRectMake(9.75+2, 0, 9.75, 15.6);
        [self addSubview:_middle6];
        
        _middle5 = [[UIImageView alloc]initWithImage:IMAGE(@"middle")];
        _middle5.frame = CGRectMake(9.75*2+4, 0, 9.75, 15.6);
        [self addSubview:_middle5];
        
        _middle4 = [[UIImageView alloc]initWithImage:IMAGE(@"middle")];
        _middle4.frame = CGRectMake(9.75*3+6, 0, 9.75, 15.6);
        [self addSubview:_middle4];
        
        _middle3 = [[UIImageView alloc]initWithImage:IMAGE(@"middle")];
        _middle3.frame = CGRectMake(9.75*4+8, 0, 9.75, 15.6);
        [self addSubview:_middle3];
        
        _middle2 = [[UIImageView alloc]initWithImage:IMAGE(@"middle")];
        _middle2.frame = CGRectMake(9.75*5+10, 0, 9.75, 15.6);
        [self addSubview:_middle2];
        
        _middle1 = [[UIImageView alloc]initWithImage:IMAGE(@"middle")];
        _middle1.frame = CGRectMake(9.75*6+12, 0, 9.75, 15.6);
        [self addSubview:_middle1];
        
        _head = [[UIImageView alloc]initWithImage:IMAGE(@"end")];
        _head.frame = CGRectMake(9.75*7+14, 0, 9.75, 15.6);
        [self addSubview:_head];
        
        _head.hidden = YES;
        _middle1.hidden = YES;
        _middle2.hidden = YES;
        _middle3.hidden = YES;
        _middle4.hidden = YES;
        _middle5.hidden = YES;
        _middle6.hidden = YES;
        _end.hidden = YES;
    }
    return self;
}
- (void)setStatusType:(STATUS_TYPE)statusType
{
        _statusType = statusType;
        
        if ([_timer isValid])
        {
            [_timer invalidate];
            _timer = nil;
        }
        _number = 0;
        
        _head.image = IMAGE(@"end");
        _middle1.image = IMAGE(@"middle");
        _middle2.image = IMAGE(@"middle");
        _middle3.image = IMAGE(@"middle");
        _middle4.image = IMAGE(@"middle");
        _middle5.image = IMAGE(@"middle");
        _middle6.image = IMAGE(@"middle");
        _end.image = IMAGE(@"head");
        
        _head.hidden = YES;
        _middle1.hidden = YES;
        _middle2.hidden = YES;
        _middle3.hidden = YES;
        _middle4.hidden = YES;
        _middle5.hidden = YES;
        _middle6.hidden = YES;
        _end.hidden = YES;
        
        switch (_statusType) {
            case STATUS_TYPE_CHARGE:
            {
                _timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(charge) userInfo:nil repeats:YES];
            }
                break;
            case STATUS_TYPE_STANDBY:
            {
                _head.hidden = NO;
                _middle1.hidden = NO;
                _middle2.hidden = NO;
                _middle3.hidden = NO;
                _middle4.hidden = NO;
                _middle5.hidden = NO;
                _middle6.hidden = NO;
                _end.hidden = NO;
            }
                break;
            case STATUS_TYPE_WORK:
            {
                _timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(work) userInfo:nil repeats:YES];
            }
                break;
            case STATUS_TYPE_SLEEP:
            {
                _head.hidden = YES;
                _middle1.hidden = YES;
                _middle2.hidden = YES;
                _middle3.hidden = YES;
                _middle4.hidden = YES;
                _middle5.hidden = YES;
                _middle6.hidden = YES;
                _end.hidden = YES;
            }
                break;
            case STATUS_TYPE_BACK_CHARGE:
            {
                _timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(backCharge) userInfo:nil repeats:YES];
            }
                break;
            case STATUS_TYPE_ERROR:
            {
                _timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(myError) userInfo:nil repeats:YES];
            }
            default:
                break;
        }
}

- (void)charge
{
    if (_number >=8)
    {
        _number = 0;
        _head.hidden = YES;
        _middle1.hidden = YES;
        _middle2.hidden = YES;
        _middle3.hidden = YES;
        _middle4.hidden = YES;
        _middle5.hidden = YES;
        _middle6.hidden = YES;
        _end.hidden = YES;
    }
    _number++;
    switch (_number)
    {
        case 1:_head.hidden = NO;break;
        case 2:_middle1.hidden = NO;break;
        case 3:_middle2.hidden = NO;break;
        case 4:_middle3.hidden = NO;break;
        case 5:_middle4.hidden = NO;break;
        case 6:_middle5.hidden = NO;break;
        case 7:_middle6.hidden = NO;break;
        case 8:_end.hidden = NO;break;
        default:
            break;
    }
}
BOOL isBackChargeHidden;
- (void)backCharge
{
    isBackChargeHidden = !isBackChargeHidden;
    if (isBackChargeHidden)
    {
        _head.hidden = YES;
        _middle1.hidden = YES;
        _middle2.hidden = YES;
        _middle3.hidden = YES;
        _middle4.hidden = YES;
        _middle5.hidden = YES;
        _middle6.hidden = YES;
        _end.hidden = YES;
    }
    else
    {
        _head.hidden = NO;
        _middle1.hidden = NO;
        _middle2.hidden = YES;
        _middle3.hidden = YES;
        _middle4.hidden = YES;
        _middle5.hidden = YES;
        _middle6.hidden = YES;
        _end.hidden = YES;
    }
}
- (void)work
{
    if (_number >=15)
    {
        _number = 1;
        _head.hidden = YES;
        _middle1.hidden = YES;
        _middle2.hidden = YES;
        _middle3.hidden = YES;
        _middle4.hidden = YES;
        _middle5.hidden = YES;
        _middle6.hidden = YES;
        _end.hidden = YES;
    }
    _number++;
    switch (_number)
    {
        case 1:_head.hidden = NO;break;
        case 2:_head.hidden = YES,_middle1.hidden = NO;break;
        case 3:_middle1.hidden = YES,_middle2.hidden = NO;break;
        case 4:_middle2.hidden = YES,_middle3.hidden = NO;break;
        case 5:_middle3.hidden = YES,_middle4.hidden = NO;break;
        case 6:_middle4.hidden = YES,_middle5.hidden = NO;break;
        case 7:_middle5.hidden = YES,_middle6.hidden = NO;break;
        case 8:_middle6.hidden = YES,_end.hidden = NO;break;
        case 9:_end.hidden = YES,_middle6.hidden = NO;break;
        case 10:_middle6.hidden = YES,_middle5.hidden = NO;break;
        case 11:_middle5.hidden = YES,_middle4.hidden = NO;break;
        case 12:_middle4.hidden = YES,_middle3.hidden = NO;break;
        case 13:_middle3.hidden = YES,_middle2.hidden = NO;break;
        case 14:_middle2.hidden = YES,_middle1.hidden = NO;break;
        case 15:_middle1.hidden = YES,_head.hidden = NO;break;
        default:
            break;
    }
}
BOOL isError;
- (void)myError
{
    isError = !isError;
    if (isError)
    {
        _head.hidden = YES;
        _middle1.hidden = YES;
        _middle2.hidden = YES;
        _middle3.hidden = YES;
        _middle4.hidden = YES;
        _middle5.hidden = YES;
        _middle6.hidden = YES;
        _end.hidden = YES;
    }
    else
    {
        _head.image = IMAGE(@"red_end"),_head.hidden = NO;
        _middle1.image = IMAGE(@"red_middle"),_middle1.hidden = NO;
        _middle2.image = IMAGE(@"red_middle"),_middle2.hidden = NO;
        _middle3.image = IMAGE(@"red_middle"),_middle3.hidden = NO;
        _middle4.image = IMAGE(@"red_middle"),_middle4.hidden = NO;
        _middle5.image = IMAGE(@"red_middle"),_middle5.hidden = NO;
        _middle6.image = IMAGE(@"red_middle"),_middle6.hidden = NO;
        _end.image = IMAGE(@"red_head"),_end.hidden = NO;
    }
}
- (void)myRelease
{
    if ([_timer isValid])
    {
        [_timer invalidate];
        _timer = nil;
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
