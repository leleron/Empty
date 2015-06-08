//
//  SearchWIFIController.m
//  KV8
//
//  Created by MasKSJ on 14-8-21.
//  Copyright (c) 2014年 MasKSJ. All rights reserved.
//
#import "AppDelegate.h"
#import "SearchWIFIController.h"
@interface SearchWIFIController ()
{
    MBProgressHUD *HUD;
    UITableView *_seachTable;
}
@end

@implementation SearchWIFIController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(SearchWIFI) name:@"SearchWIFI" object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = LOCAL(@"select_a_wifi");
    self.view.backgroundColor = BLUECOLOR;
    [_cam.WIFIarray removeAllObjects];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 25, 26.43);
    [backButton setImage:[UIImage imageWithContentsOfFile:PATH(@"back_no")] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(myBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    _seachTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (iOSVERSION <7.0)
    {
        _seachTable.frame =CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT-64);
    }
    _seachTable.delegate = self;
    _seachTable.dataSource = self;
    _seachTable.backgroundColor = BLUECOLOR;
    _seachTable.separatorColor = [UIColor whiteColor];
    if (iOSVERSION>=7.0)
    {
        _seachTable.separatorInset = UIEdgeInsetsZero;
    }
    [self setExtraCellLineHidden:_seachTable];
    [self.view addSubview:_seachTable];
    
    HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = LOCAL(@"searching_wifi");
    [HUD show:YES];
    [HUD hide:YES afterDelay:10];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)SearchWIFI
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [HUD hide:YES];
        [_seachTable reloadData];
    });
}
- (void)myBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cam.WIFIarray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    NSDictionary *dic = [_cam.WIFIarray objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"ssid"];
    cell.detailTextLabel.text = [dic objectForKey:@"address"];
    cell.contentView.backgroundColor = BLUECOLOR;
    cell.textLabel.textColor = TOPBARCOLOR;
    cell.detailTextLabel.textColor = TOPBARCOLOR;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = TOPBARCOLOR;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.1f];
    NSDictionary *dic = [_cam.WIFIarray objectAtIndex:indexPath.row];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.WIFISSID = [dic objectForKey:@"ssid"];
   
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)deselect
{
    [_seachTable deselectRowAtIndexPath:[_seachTable indexPathForSelectedRow] animated:NO];
}
//隐藏分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
	HUD = nil;
}
@end
