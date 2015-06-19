//
//  DeviceViewController.m
//  Empty
//
//  Created by 李荣 on 15/5/12.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "DeviceViewController.h"
//#import "HomeController.h"
#import "GSetting.h"
#import "CamObj.h"
#import "FMDatabaseAdditions.h"
#import "SplashViewController.h"
#import "SQLSingle.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "VideoController.h"
#import "WToast.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
DeviceViewController* instance;

@interface DeviceViewController ()
@property(strong,nonatomic) NSArray* imgArray;
@property(strong,nonatomic) NSArray* nameArray;
@property(strong,nonatomic)NSTimer* timer;
@end

@implementation DeviceViewController
{
    UITableView *_cleanerTable;
    GSetting *_gSetting;
    BOOL _isTableEdit;
    
    UIButton *addButton;
    BOOL ifAdd; //判断下拉菜单是否收回
    SKDropDown *drop;

}

+(DeviceViewController *)share
{
    return instance;
}


- (void)viewDidLoad {
    self.navigationBarTitle = @"设备";
    [super viewDidLoad];
    
    instance = self;
    addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 25, 21.96);
    [addButton setImage:[UIImage imageWithContentsOfFile:PATH(@"add_no")] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(myAdd) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:addButton];

    
    UICollectionViewFlowLayout* flowlayout = [[UICollectionViewFlowLayout alloc]init];
    self.myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 320, 548) collectionViewLayout:flowlayout];
    self.myCollectionView.backgroundColor = [UIColor whiteColor];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    [self.myCollectionView registerClass:[deviceCell class] forCellWithReuseIdentifier:@"deviceCell"];
    [self.view addSubview:self.myCollectionView];
    self.imgArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"device1"],[UIImage imageNamed:@"device2"],[UIImage imageNamed:@"device3"],[UIImage imageNamed:@"device4"],[UIImage imageNamed:@"device5"],[UIImage imageNamed:@"device6"],[UIImage imageNamed:@"device7"], nil];
//    self.nameArray = [NSArray arrayWithObjects:@"电熨斗",@"洗衣机",@"吹风机",@"电冰箱",@"缝纫机",@"机器人",@"空气净化器", nil];
    // Do any additional setup after loading the view from its nib.
    [self performSelector:@selector(getConnected) withObject:nil afterDelay:3.0];
    
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(getConnected) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
    }

    
    [self connectDataBase];
    [self loadCam];

}
-(void)viewDidAppear:(BOOL)animated{
    [self.myCollectionView reloadData];
}
- (void)connectDataBase
{
    SQLSingle *sql = [SQLSingle shareSQLSingle];
    [sql.dataBase executeUpdate:@"CREATE TABLE if not exists camre_info (RID INTEGER PRIMARY KEY,CAMERA_NAME VARCHAR(30),DEV_ID VARCHAR(30),DEV_PWD VARCHAR(30),DEV_AP_SSID VARCHAR(30),DEV_AP_PWD VARCHAR(30),WIFI_SSID VARCHAR(30),WIFI_PWD VARCHAR(30),DEV_TYPE INTEGER DEFAULT 0,PRODUCT_TYPE INTEGER DEFAULT -1,IS_ENCRYPT boolean DEFAULT false,ENCRYPT_PWD VARCHAR(10),SNAPSHOT1 BLOB,SNAPSHOT2 BLOB,RESERV1 VARCHAR(30),RESERV2 VARCHAR(50),RESERV3 NUMERIC DEFAULT 0,RESERV4 NUMERIC DEFAULT 0)"];
    [sql.dataBase executeUpdate:@"CREATE TABLE if not exists favorite (RID INTEGER PRIMARY KEY,DEV_ID VARCHAR(30))"];
    NSInteger count=[sql.dataBase intForQuery:@"select count(*) from favorite"];
    if (!count)
    {
        [sql.dataBase executeUpdate:@"insert into favorite(DEV_ID) values(?)",@""];
    }
    
}
- (void)loadCam
{
    //从数据库中读取设备
    SQLSingle *sql = [SQLSingle shareSQLSingle];
    GSetting *gSetting=[GSetting instance];
    FMResultSet *rs = [sql.dataBase executeQuery:@"select DEV_ID,CAMERA_NAME,DEV_PWD from camre_info order by CAMERA_NAME"];
    while ([rs next])
    {
        CamObj *cam = [[CamObj alloc]init];
        cam.nsDID = [rs stringForColumn:@"DEV_ID"];
        cam.nsCamName = [rs stringForColumn:@"CAMERA_NAME"];
        cam.nsViewPwd = [rs stringForColumn:@"DEV_PWD"];
        [gSetting.arrCam addObject:cam];
        
        
        NSLog(@"%@  %@  %@",cam.nsDID,cam.nsCamName,cam.nsViewPwd);
    }
    [rs close];
}
- (void)getConnected
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        GSetting *gSetting=[GSetting instance];
        NSArray *array = [NSArray arrayWithArray:gSetting.arrCam];
        for (CamObj   *cam in array)
        {
            if ([cam getLastError] <0)
            {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [cam startConnect:10];
                });
            }
        }
    });
}

- (id)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) { break; }
    }
    return info;
}

- (void)myAdd
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.camDID = @"";
    UserInfo* myUserInfo = [[WHGlobalHelper shareGlobalHelper]get:USER_INFO];
    //判断用户是否已经登陆
    if (!myUserInfo) {
        LoginViewController* controller = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        self.tabBarController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        
    }else{
    
    ifAdd = !ifAdd;
    NSArray *titleArray = [[NSArray alloc] initWithObjects:SAO_YI_SAO,ADD_DEVICE, nil];
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
}


- (void) skDropDownDelegateMethod: (SKDropDown *) sender
{
    [self closeDropDown];
}

-(void)closeDropDown{
    drop = nil;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UICollectionView delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;  {
    GSetting* gset = [GSetting instance];
    
    return [gset.arrCam count];
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    deviceCell *cell = (deviceCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"deviceCell" forIndexPath:indexPath];
    GSetting* gset = [GSetting instance];
    CamObj* cam = [gset.arrCam objectAtIndex:indexPath.row];
    cell.imgDevice.image = [self.imgArray objectAtIndex:0];
    cell.lblName.text = cam.nsCamName;
    
    UILongPressGestureRecognizer* longPressRecongnizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [cell addGestureRecognizer:longPressRecongnizer];
    longPressRecongnizer.minimumPressDuration = 1.0;
    longPressRecongnizer.delegate = self;
    longPressRecongnizer.view.tag = (int)indexPath.row;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(95, 116);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    GSetting* get = [GSetting instance];
    VideoController *video = [[VideoController alloc]init];
    video.cam = [get.arrCam objectAtIndex:indexPath.row];
    if(video.cam.mCamState == CONN_INFO_CONNECTED)
    {
        video.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:video animated:YES];
    }
    else
    {
//        NSString *messtr = [NSString stringWithFormat:@"%@%@",LOCAL(@"devices"),LOCAL(@"operation")];
        [WToast showWithText:@"连接失败"];
    }

}

#pragma mark 长按操作
-(void)longPress:(UILongPressGestureRecognizer*) recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        GSetting* gset = [GSetting instance];
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:recognizer.view.tag inSection:0];
        NSArray* deleteItems = @[indexPath];
    //    [self.myCollectionView deleteItemsAtIndexPaths:deleteItems];
        CamObj *cam=[gset.arrCam objectAtIndex:(int)indexPath.row];
        [gset.arrCam removeObjectAtIndex:[indexPath row]];
        //Disconnect device
        [self.myCollectionView deleteItemsAtIndexPaths:deleteItems];
        for(int i =(int)[indexPath row]+1;i<[self.myCollectionView.subviews count];i++){
           UICollectionViewCell* cell= (deviceCell*)[self.myCollectionView.subviews objectAtIndex:i];
            if ([cell isKindOfClass:[deviceCell class]]) {
                cell.tag = cell.tag -1;
            }
        }
        [cam stopAll];
        
        //delete from DB
        SQLSingle *sql = [SQLSingle shareSQLSingle];
        [sql.dataBase executeUpdate:@"delete from camre_info where DEV_ID=?",cam.nsDID];
        [self.myCollectionView reloadData];

    }else if (recognizer.state == UIGestureRecognizerStateEnded){
        NSLog(@"已删除");
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
