//
//  SAMenuTable.m
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/19/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import "SIMenuTable.h"
#import "SIMenuCell.h"
#import "SIMenuConfiguration.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+Extension.h"

@interface SIMenuTable () {
    CGRect endFrame;
    CGRect startFrame;
    NSIndexPath *currentIndexPath;
    
    UIImageView *_arrowImage;
}
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *items;
@end

@implementation SIMenuTable

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self) {
        self.items = [NSArray arrayWithArray:items];
        
        endFrame = self.bounds;
        startFrame = endFrame;
        startFrame.origin.y -= self.items.count*[SIMenuConfiguration itemCellHeight];
        
        self.table = [[UITableView alloc] initWithFrame:startFrame style:UITableViewStylePlain];
        self.table.delegate = self;
        self.table.dataSource = self;
        self.table.backgroundColor = [UIColor clearColor];
        self.table.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.table.bounds.size.height, [SIMenuConfiguration menuWidth], self.table.bounds.size.height)];
        header.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.table addSubview:header];
        
        self.table.scrollEnabled = NO;

    }
    return self;
}

- (void)chooseTitleItem:(NSInteger)index {
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    
    [self tableView:self.table didSelectRowAtIndexPath:path];
    

}

- (void)show
{
    [self addSubview:self.table];
    if (!self.table.tableFooterView) {
        [self addFooter];
    }
    [UIView animateWithDuration:[SIMenuConfiguration animationDuration] animations:^{
        self.layer.backgroundColor = [UIColor color:[SIMenuConfiguration mainColor] withAlpha:[SIMenuConfiguration backgroundAlpha]].CGColor;
        self.table.frame = endFrame;
        self.table.contentOffset = CGPointMake(0, [SIMenuConfiguration bounceOffset]);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:[self bounceAnimationDuration] animations:^{
            self.table.contentOffset = CGPointMake(0, 0);
        }];
    }];
}

- (void)hide
{
    [UIView animateWithDuration:[self bounceAnimationDuration] animations:^{
        self.table.contentOffset = CGPointMake(0, [SIMenuConfiguration bounceOffset]);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:[SIMenuConfiguration animationDuration] animations:^{
            self.layer.backgroundColor = [UIColor color:[SIMenuConfiguration mainColor] withAlpha:0.0].CGColor;
            self.table.frame = startFrame;
        } completion:^(BOOL finished) {
            [self.table deselectRowAtIndexPath:currentIndexPath animated:NO];
            SIMenuCell *cell = (SIMenuCell *)[self.table cellForRowAtIndexPath:currentIndexPath];
            [cell setSelected:NO withCompletionBlock:^{

            }];
            currentIndexPath = nil;
            [self removeFooter];
            [self.table removeFromSuperview];
            [self removeFromSuperview];
        }];
    }];
}

- (float)bounceAnimationDuration
{
    float percentage = 28.57;
    return [SIMenuConfiguration animationDuration]*percentage/100.0;
}

- (void)addFooter
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [SIMenuConfiguration menuWidth], self.table.bounds.size.height - (self.items.count * [SIMenuConfiguration itemCellHeight]))];
    self.table.tableFooterView = footer;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackgroundTap:)];
    [footer addGestureRecognizer:tap];
}

- (void)removeFooter
{
    self.table.tableFooterView = nil;
}

- (void)onBackgroundTap:(id)sender
{
    [self.menuDelegate didBackgroundTap];
}

- (void)dealloc
{
    self.items = nil;
    self.table = nil;
    self.menuDelegate = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SIMenuConfiguration itemCellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    SIMenuCell *cell = (SIMenuCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[SIMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    
    }
    if (indexPath.row == 0) {
        if (!_arrowImage) {
            _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selecte_arrow"]];
        }
        cell.accessoryView = _arrowImage;
        cell.textLabel.textColor = Color_Bg_007aff;

    }
    cell.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    cell.textLabel.text = [self.items objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentIndexPath = indexPath;
    
    for (UITableViewCell *cell in tableView.visibleCells) {
        cell.accessoryView = nil;
        cell.textLabel.textColor = [UIColor blackColor];

    }
    SIMenuCell *cell = (SIMenuCell *)[tableView cellForRowAtIndexPath:indexPath];
    __block NSString *title = cell.textLabel.text;
    cell.textLabel.textColor = Color_Bg_007aff;
    cell.accessoryView = _arrowImage;
    [cell setSelected:YES withCompletionBlock:^{
        [self.menuDelegate didSelectItemAtIndex:indexPath.row title:title];
    }];
    
}

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    SIMenuCell *cell = (SIMenuCell *)[tableView cellForRowAtIndexPath:indexPath];
//    cell.accessoryType = UITableViewCellAccessoryNone;
//    [cell setSelected:NO withCompletionBlock:^{
//
//    }];
//}


@end
