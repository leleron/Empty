//
//  cleanerCell.m
//  KV8
//
//  Created by MasKSJ on 14-8-13.
//  Copyright (c) 2014年 MasKSJ. All rights reserved.
//

#import "cleanerCell.h"
#import "miscClasses/SQLSingle.h"
#import "FMDatabaseAdditions.h"
@implementation cleanerCell
{
    UILabel *_nameLabel;
    UILabel *_statusLabel;
    UIButton *_favorite;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 120.66, 91)];
        _imgView.userInteractionEnabled = YES;
        _imgView.layer.cornerRadius = 12;
        _imgView.layer.masksToBounds  = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imgView];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 25, 160, 20)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = TOPBARCOLOR;
        [self.contentView addSubview:_nameLabel];
        
        _statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 55, 170, 20)];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.font = [UIFont systemFontOfSize:14];
        _statusLabel.textColor = [UIColor colorWithRed:98/255.0 green:98/255.0 blue:98/255.0 alpha:1];
        [self.contentView addSubview:_statusLabel];
        
        //箭头图标
        _b = [UIButton buttonWithType:UIButtonTypeCustom];
        _b.frame = CGRectMake(0, 0, 10.2, 17.4);
        [_b setImage:IMAGE(@"arrow") forState:UIControlStateNormal];
        _b.center = CGPointMake(300, 50);
        _b.userInteractionEnabled = NO;
        [self.contentView addSubview:_b];
        
        _favorite = [UIButton buttonWithType:UIButtonTypeCustom];
        _favorite.frame= CGRectMake(250, 53, 25.2, 23.8);
        _favorite.userInteractionEnabled = NO;
        [_favorite setImage:IMAGE(@"star") forState:UIControlStateNormal];
        _favorite.hidden = YES;
        [self.contentView addSubview:_favorite];
        self.contentView.backgroundColor = BLUECOLOR;
    }
    return self;
}
- (void)setNsName:(NSString *)nsName
{
    if (_nsName != nsName)
    {
        _nsName = nsName;
        _nameLabel.text = _nsName;
    }
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [arr objectAtIndex:0];
    NSString *path1= [path stringByAppendingPathComponent:self.nsDID];
    UIImage *image = [UIImage imageWithContentsOfFile:path1];
    if (image)
    {
        _imgView.image = image;
    }
    else
    {
        _imgView.image = [UIImage imageWithContentsOfFile:PATH(@"snapshot_bg")];
    }
    SQLSingle *sql = [SQLSingle shareSQLSingle];
    NSString *did = [sql.dataBase stringForQuery:@"select DEV_ID from favorite"];
    if ([did isEqualToString:_nsDID])
    {
        _favorite.hidden = NO;
    }
    else
    {
        _favorite.hidden = YES;
    }
}
- (void)setMCamState:(E_CAM_STATE)mCamState
{
    _mCamState = mCamState;
    switch (_mCamState)
    {
        case CONN_INFO_CONNECTING:
            _statusLabel.text = LOCAL(@"connecting");
            break;
        case CONN_INFO_CONNECTED:
        {
            NSString * label ;
            label = [NSString stringWithFormat:@"%@",LOCAL(@"connected")];
            _statusLabel.text = label;
        }
            break;
        case CONN_INFO__OVER_MAX:
            
            _statusLabel.text = @"OVER_MAX";
            break;
        default:
            _statusLabel.text = LOCAL(@"disconnected");
            break;
    }
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
