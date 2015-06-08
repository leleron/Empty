//
//  HomeController.m
//  KV8
//
//  Created by MasKSJ on 14-8-12.
//  Copyright (c) 2014年 MasKSJ. All rights reserved.
//

#import "HomeController.h"
#import "addController.h"
#import "VideoController.h"
#import "cleanerCell.h"
#import "miscClasses/GSetting.h"
#import "EditDeviceController.h"
#import "miscClasses/SQLSingle.h"
#import "FMDatabaseAdditions.h"
#import "WToast.h"
#import "RJONE_LibCallBack.h"
#import "AppDelegate.h"
BOOL AP_WIFI;
@interface HomeController ()
{
    UITableView *_cleanerTable;
    GSetting *_gSetting;
    BOOL _isTableEdit;
    
    UIButton *addButton;
    BOOL ifAdd; //判断下拉菜单是否收回
    SKDropDown *drop;
}
@end
HomeController *instance;
@implementation HomeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _gSetting=[GSetting instance];
          [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RefreshStatus) name:@"RefreshStatus" object:nil];
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [_cleanerTable reloadData];
    self.ifPush = YES;

}

+(HomeController *)share
{
    return instance;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    instance = self;
    self.view.backgroundColor = BLUECOLOR;
    //    self.title = @"KV8";
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:30];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"KV8";
    self.navigationItem.titleView = titleLabel;
    self.navigationController.navigationBar.tintColor = TOPBARCOLOR;
    if (iOSVERSION>=7.0)
    {
        [self.navigationController.navigationBar setBarTintColor:TOPBARCOLOR];
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], UITextAttributeTextColor,
      [UIFont fontWithName:@"Enter Sansman" size:17],UITextAttributeFont,
      nil]];
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = CGRectMake(0, 0, 25, 24.34);
    [editButton setImage:[UIImage imageWithContentsOfFile:PATH(@"edit_no")] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(myEdit) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:editButton];
    
    addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 25, 21.96);
    [addButton setImage:[UIImage imageWithContentsOfFile:PATH(@"add_no")] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(myAdd) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:addButton];
    
    _cleanerTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT)];
    if (iOSVERSION <7.0)
    {
        _cleanerTable.frame =CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT-64);
    }
    _cleanerTable.delegate = self;
    _cleanerTable.dataSource = self;
    _cleanerTable.backgroundColor = BLUECOLOR;
    _cleanerTable.separatorColor = [UIColor whiteColor];
    if (iOSVERSION>=7.0)
    {
        _cleanerTable.separatorInset = UIEdgeInsetsZero;
    }
    [self setExtraCellLineHidden:_cleanerTable];
    [self.view addSubview:_cleanerTable];
    
    SQLSingle *sql = [SQLSingle shareSQLSingle];
    NSString *did = [sql.dataBase stringForQuery:@"select DEV_ID from favorite"];
    for (CamObj *cam in _gSetting.arrCam)
    {
        if ([cam.nsDID isEqualToString:did])
        {
            VideoController *video = [[VideoController alloc]init];
            video.cam = cam;
            [self.navigationController pushViewController:video animated:YES];
        }
    }
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)myEdit
{
    if (_gSetting.arrCam.count == 0)
    {
        [WToast showWithText:LOCAL(@"noDeviceEdit")];
        return;
    }
    _isTableEdit = !_cleanerTable.isEditing;
    [_cleanerTable setEditing:_isTableEdit animated:YES];
}
- (void)myAdd
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.camDID = @"";

    ifAdd = !ifAdd;
    NSArray *titleArray = [[NSArray alloc] initWithObjects:SEARCH_DEVICE,CONFIG_DEVICE, nil];
    if(drop == nil)
    {
        CGFloat dropDownListHeight = 64; //Set height of drop down list
        NSString *direction = @"down"; //Set drop down direction animation
        CGFloat height = 60;
        CGFloat width = 80;
        drop = [[SKDropDown alloc]showDropDown:addButton withHeight:&dropDownListHeight withData:titleArray animationDirection:direction withFrameHeight:&height withFrameWidth:&width];
        drop.delegate = self;
    }
    else
    {
        [drop hideDropDown:addButton];
        drop = nil;
    }
}


- (void) skDropDownDelegateMethod: (SKDropDown *) sender
{
    [self closeDropDown];
}

-(void)closeDropDown{
    drop = nil;
}



//隐藏分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

#pragma mark -UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_gSetting.arrCam.count == 0) {
        tableView.editing = NO;
    }
    return _gSetting.arrCam.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    cleanerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[cleanerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        //点击imgView,跳转页面
        cell.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mySkipVideo:)];
        [cell.imgView addGestureRecognizer:cell.tap];
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = TOPBARCOLOR;
    CamObj *cam = [_gSetting.arrCam objectAtIndex:indexPath.row];
     cell.DevConnectSSID  =  AP_WIFI;
    cell.nsDID = cam.nsDID;
    cell.nsName = cam.nsCamName;
    cell.mCamState = cam.mCamState;
    cell.imgView.tag = 100+indexPath.row;
    cell.b.hidden = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 101;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CamObj *cam = [_gSetting.arrCam objectAtIndex:indexPath.row];
    EditDeviceController *edit = [[EditDeviceController alloc]init];
    edit.cam = cam;
//    [cam setHandle];
//    NSLog(@"handle:%d",[cam setHandle]);
 //   [self.navigationController pushViewController:edit animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    cleanerCell *cell = (cleanerCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = BLUECOLOR;
    cell.b.hidden = _isTableEdit;
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CamObj *cam=[_gSetting.arrCam objectAtIndex:indexPath.row];
    //Disconnect device
    [cam stopAll];
    
    //delete from DB
    SQLSingle *sql = [SQLSingle shareSQLSingle];
    [sql.dataBase executeUpdate:@"delete from camre_info where DEV_ID=?",cam.nsDID];
    
    //删除图片
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [arr objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:cam.nsDID];
    BOOL isExist = [fileManager fileExistsAtPath:filePath];
    if (isExist) {
        NSError *error;
        [fileManager removeItemAtPath:filePath error:&error];
    }
    
    //Delete from UI
    [_gSetting.arrCam removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView reloadData];
}
#pragma mark - tap
- (void)mySkipVideo:(UITapGestureRecognizer *)tap
{
    
    VideoController *video = [[VideoController alloc]init];
    video.cam = [_gSetting.arrCam objectAtIndex:tap.view.tag -100];
    if(video.cam.mCamState == CONN_INFO_CONNECTED)
    {
    [self.navigationController pushViewController:video animated:YES];
    }
    else
    {
         NSString *messtr = [NSString stringWithFormat:@"%@%@",LOCAL(@"devices"),LOCAL(@"operation")];
         [WToast showWithText:messtr];
    }
    
}
- (void)RefreshStatus
{
    if (!_cleanerTable.isEditing)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_cleanerTable reloadData];
        });
    }
}
@end
