//
//  SKDropDown.m
//  DropDownExample
//
//  Created by Sukru on 01.10.2013.
//  Copyright (c) 2013 Sukru. All rights reserved.
//

#import "SKDropDown.h"
#import <QuartzCore/QuartzCore.h>
#import "DeviceViewController.h"
#import "EditInfoController.h"
#import "EditParameterController.h"
#import "WToast.h"
#import "EditModeController.h"
#import "AppDelegate.h"
#import "AboutDeviceController.h"
@implementation SKDropDown

- (id)showDropDown:(UIButton *)b withHeight:(CGFloat *)height withData:(NSArray *)arr animationDirection:(NSString *)direction withFrameHeight:(CGFloat*)frameHeight withFrameWidth:(CGFloat*)frameWidth{
    _btnSender = b;
    animationDirection = direction;
    self.table = (UITableView *)[super init];
    
   
    
    
    if (self) {
        // Initialization code
        self.height = *frameHeight;
        self.width = *frameWidth;
        CGRect btn = b.frame;
        self.list = [NSArray arrayWithArray:arr];
        
        if ([direction isEqualToString:@"up"])
        {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, -5);
        }
        else if ([direction isEqualToString:@"down"])
        {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height+13, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, 5);
        }
        
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8;
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        
        _table = [[UITableView alloc] initWithFrame:CGRectMake(btn.origin.x-40, btn.origin.y+*height, self.width, self.height)];
        _table.delegate = self;
        _table.dataSource = self;
        _table.layer.cornerRadius = 5;
        _table.backgroundColor = [UIColor colorWithRed:0.239 green:0.239 blue:0.239 alpha:1];
        _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _table.separatorColor = [UIColor clearColor];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        
        if ([direction isEqualToString:@"up"])
        {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y-*height, btn.size.width, *height);
        }
        else if([direction isEqualToString:@"down"])
        {
            self.frame = CGRectMake(btn.origin.x-32, btn.origin.y+btn.size.height+13, self.width, self.height);
        }
        
        _table.frame = CGRectMake(btn.origin.x-40, btn.origin.y+*height-10, self.width, self.height);
        [UIView commitAnimations];
        [b.superview addSubview:self];
        [self.window addSubview:_table];
    }
    return self;
}

-(void)hideDropDown:(UIButton *)b
{
    CGRect btn = b.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    if ([animationDirection isEqualToString:@"up"])
    {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
    }else if ([animationDirection isEqualToString:@"down"])
    {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, self.width, 0);
    }
    _table.frame = CGRectMake(btn.origin.x-40, btn.origin.y+64-10, self.width,0);
    [UIView commitAnimations];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 32;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    
    DeviceViewController *home = [[DeviceViewController alloc] init];
    
    if ([DeviceViewController share].navigationController == nil)
    {
        UINavigationController *nav = [[UINavigationController   alloc] initWithRootViewController:home];
        self.window.rootViewController = nav;
    }
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:11];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    }
    
    cell.textLabel.text =[_list objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    
//    UIView * v = [[UIView alloc] init];
//    v.backgroundColor = [UIColor grayColor];
//    cell.selectedBackgroundView = v;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //  NSInteger a = indexPath.row;
    NSString* title = [self.list objectAtIndex:indexPath.row];
    if (_add == nil)
    {
        _add = [[addController alloc] init];
    }
    if (_set == nil)
    {
        _set = [[SetViewController alloc] init];
    }
    if ([title isEqualToString:SEARCH_DEVICE])
    {
        NSLog(@"0");
        [[DeviceViewController share].navigationController pushViewController:_add animated:YES];
        NSLog(@"140:%@",[DeviceViewController share].navigationController);
    }
    if([title isEqualToString:CONFIG_DEVICE])
    {
        NSLog(@"1");

        [[DeviceViewController share].navigationController pushViewController:_set animated:YES];
    }
    if ([title isEqualToString:OPEN_PICTURE]) {
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        ipc.delegate = self;
        ipc.allowsEditing = YES;
        [self.nav presentViewController:ipc animated:YES completion:nil];
    }
    if ([title isEqualToString:FIX_DEVICE_INFO]) {
        EditInfoController *info = [[EditInfoController alloc]init];
        info.cam = _cam;
        [self.nav pushViewController:info animated:YES];
    }
    if ([title isEqualToString:FIX_DEVICE_PARAM]) {
        EditParameterController *Para = [[EditParameterController alloc]init];
        Para.cam = _cam;
        if(_cam.mCamState == CONN_INFO_CONNECTED)
        {
            [self.nav pushViewController:Para animated:YES];
        }
        else
        {
            NSString *messtr = [NSString stringWithFormat:@"%@%@",LOCAL(@"devices"),LOCAL(@"operation")];
            [WToast showWithText:messtr];
        }

    }
    if ([title isEqualToString:FIX_NETWORK_MODE]) {
        AppDelegate *_delegate = [UIApplication sharedApplication].delegate;
        EditModeController *mode = [[EditModeController alloc]init];
        mode.cam = _cam;
        _delegate.WIFISSID = @"";
        if(_cam.mCamState == CONN_INFO_CONNECTED)
        {
            [_cam Rjone_SetEtc2];
            [self.nav pushViewController:mode animated:YES];
        }else
        {
            NSString *messtr = [NSString stringWithFormat:@"%@%@",LOCAL(@"devices"),LOCAL(@"operation")];
            [WToast showWithText:messtr];
        }
    }
    if ([title isEqualToString:ABOUT_DEVICE]) {
        AboutDeviceController *about = [[AboutDeviceController alloc]init];
        about.cam = _cam;
        if(_cam.mCamState == CONN_INFO_CONNECTED)
        {
            [self.nav pushViewController:about animated:YES];
        }else
        {
            NSString *messtr = [NSString stringWithFormat:@"%@%@",LOCAL(@"devices"),LOCAL(@"operation")];
            [WToast showWithText:messtr];
        }

    }
    [self hideDropDown:_btnSender];

    [self myDelegate];
}

- (void) myDelegate {
    [self.delegate skDropDownDelegateMethod:self];
}


@end
