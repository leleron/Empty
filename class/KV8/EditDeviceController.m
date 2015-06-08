//
//  EditDeviceController.m
//  KV8
//
//  Created by MasKSJ on 14-8-14.
//  Copyright (c) 2014年 MasKSJ. All rights reserved.
//

#import "EditDeviceController.h"
#import "EditInfoController.h"
#import "EditParameterController.h"
#import "EditModeController.h"
#import "AboutDeviceController.h"
#import "HelpDeviceController.h"
#import "miscClasses/SQLSingle.h"
#import "FMDatabaseAdditions.h"
#import "AppDelegate.h"
#import "WToast.h"
@interface EditDeviceController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    BOOL _isFavorite;
}
@end

@implementation EditDeviceController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //根据语言做相应布局
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    self.title = [NSString stringWithFormat:LOCAL(@"editDevice"),_cam.nsCamName];
    self.view.backgroundColor = BLUECOLOR;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 25, 26.43);
    [backButton setImage:[UIImage imageWithContentsOfFile:PATH(@"back_no")] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(myBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    CGRect rect = CGRectMake(10, 10, SCREEN_WIDTH-20, 40);
    
    //收藏
    UIView *collectView = [[UIView alloc]initWithFrame:rect];
    collectView.backgroundColor = UIColorFromRGB(0x009AD3);
    collectView.layer.cornerRadius = 8;
    [self.view addSubview:collectView];
    
    UILabel *collect = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
    collect.backgroundColor = [UIColor clearColor];
    collect.text = LOCAL(@"favorite");
    collect.textColor = [UIColor whiteColor];
    collect.center = CGPointMake(65, collectView.frame.size.height/2);
    collect.font = [UIFont systemFontOfSize:15];
    if (iOSVERSION >=7.0 && [currentLanguage isEqualToString:@"en"])
    {
        collect.frame =CGRectMake(23, 5, 120, 20);
        //collect.center = CGPointMake(77, collectView.frame.size.height/2);
    }//enenenenne
    [collectView addSubview:collect];
    
    UISwitch *mySwitch = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    mySwitch.center = CGPointMake(260, collectView.frame.size.height/2);
    [mySwitch addTarget:self action:@selector(myCollect:) forControlEvents:UIControlEventValueChanged];
    
    if (iOSVERSION <7.0)
    {
        mySwitch.center = CGPointMake(250, collectView.frame.size.height/2);
    }
    [collectView addSubview:mySwitch];
    
    SQLSingle *sql = [SQLSingle shareSQLSingle];
    NSString *did = [sql.dataBase stringForQuery:@"select DEV_ID from favorite"];
    if ([did isEqualToString:_cam.nsDID])
    {
        [mySwitch setOn:YES animated:YES];
        _isFavorite = YES;
    }
    //    UIButton *aboutDevice = [UIButton buttonWithType:UIButtonTypeCustom];
    //    aboutDevice.frame = rect;
    //    aboutDevice.backgroundColor = UIColorFromRGB(0x009AD3);
    //    aboutDevice.layer.cornerRadius = 8;
    //    aboutDevice.showsTouchWhenHighlighted = YES;
    //    [aboutDevice setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [aboutDevice setTitle:LOCAL(@"aboutDevice") forState:UIControlStateNormal];
    //    [aboutDevice setImage:IMAGE(@"arrow") forState:UIControlStateNormal];
    //    aboutDevice.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 210);
    //    aboutDevice.imageEdgeInsets = UIEdgeInsetsMake(15, 265, 8, 20);
    //    aboutDevice.titleLabel.font = [UIFont systemFontOfSize:15];
    //    [aboutDevice addTarget:self action:@selector(aboutDevice) forControlEvents:UIControlEventTouchUpInside];
    //    if ([currentLanguage isEqualToString:@"en"])
    //    {
    //        aboutDevice.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 180);
    //    }
    //    [self.view addSubview:aboutDevice];
    //照片
    rect.origin.y = rect.origin.y + 50;
    UIButton *Photo = [UIButton buttonWithType:UIButtonTypeCustom];
    Photo.frame = rect;
    Photo.backgroundColor = UIColorFromRGB(0x009AD3);
    Photo.layer.cornerRadius = 8;
    Photo.showsTouchWhenHighlighted = YES;
    [Photo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [Photo setTitle:LOCAL(@"openpicture") forState:UIControlStateNormal];
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(23, 5, 120, 20)];
    la.text = LOCAL(@"openpicture");
    la.textColor = [UIColor whiteColor];
    la.font = [UIFont systemFontOfSize:15];
    [Photo addSubview:la];
    [Photo setImage:IMAGE(@"arrow") forState:UIControlStateNormal];
    Photo.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 210);
    Photo.imageEdgeInsets = UIEdgeInsetsMake(15, 265, 8, 20);
    Photo.titleLabel.font = [UIFont systemFontOfSize:15];
    [Photo addTarget:self action:@selector(Openphoto) forControlEvents:UIControlEventTouchUpInside];
    
    if ([currentLanguage isEqualToString:@"en"])
    {
        Photo.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 180);
    }
    
    if (iOSVERSION >=7.0 && [currentLanguage isEqualToString:@"en"])
    {
        Photo.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 90);
        //Photo.frame = CGRectMake(30, 5, 120, 20);
        
    }
    [self.view addSubview:Photo];
    
    
    
    
    //修改设备信息
    rect.origin.y = rect.origin.y + 50;
    UIButton *editInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    editInfo.frame = rect;
    editInfo.backgroundColor = UIColorFromRGB(0x009AD3);
    editInfo.layer.cornerRadius = 8;
    editInfo.showsTouchWhenHighlighted = YES;
    [editInfo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editInfo setTitle:LOCAL(@"change_info") forState:UIControlStateNormal];
    [editInfo setImage:IMAGE(@"arrow") forState:UIControlStateNormal];
    editInfo.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 180);
    editInfo.imageEdgeInsets = UIEdgeInsetsMake(15, 265, 8, 20);
    editInfo.titleLabel.font = [UIFont systemFontOfSize:15];
    [editInfo addTarget:self action:@selector(editInfo) forControlEvents:UIControlEventTouchUpInside];
    
    if ([currentLanguage isEqualToString:@"en"])
    {
        editInfo.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 100);
    }
    
    if (iOSVERSION >=7.0 && [currentLanguage isEqualToString:@"en"])
    {
        editInfo.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 90);
    }
    [self.view addSubview:editInfo];
    
    //修改设备参数
    rect.origin.y = rect.origin.y + 50;
    UIButton *editParameter = [UIButton buttonWithType:UIButtonTypeCustom];
    editParameter.frame = rect;
    editParameter.backgroundColor = UIColorFromRGB(0x009AD3);
    editParameter.layer.cornerRadius = 8;
    editParameter.showsTouchWhenHighlighted = YES;
    [editParameter setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editParameter setTitle:LOCAL(@"change_para") forState:UIControlStateNormal];
    [editParameter setImage:IMAGE(@"arrow") forState:UIControlStateNormal];
    editParameter.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 180);
    editParameter.imageEdgeInsets = UIEdgeInsetsMake(15, 265, 8, 20);
    editParameter.titleLabel.font = [UIFont systemFontOfSize:15];
    [editParameter addTarget:self action:@selector(editParameter) forControlEvents:UIControlEventTouchUpInside];
    if ([currentLanguage isEqualToString:@"en"])
    {
        editParameter.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 100);
    }
    [self.view addSubview:editParameter];
    rect.origin.y = rect.origin.y + 40;
    
    UILabel *parameterDescribeLable = [[UILabel alloc]initWithFrame:rect];
    parameterDescribeLable.backgroundColor = [UIColor clearColor];
    parameterDescribeLable.textColor =UIColorFromRGB(0x009AD8);
    parameterDescribeLable.text = LOCAL(@"need");
    parameterDescribeLable.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:parameterDescribeLable];
    
    //修改设备网络模式
    rect.origin.y = rect.origin.y + 10 + 20;
    UIButton *editMode = [UIButton buttonWithType:UIButtonTypeCustom];
    editMode.frame = rect;
    editMode.backgroundColor = UIColorFromRGB(0x009AD3);
    editMode.layer.cornerRadius = 8;
    editMode.showsTouchWhenHighlighted = YES;
    [editMode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editMode setTitle:LOCAL(@"change_network") forState:UIControlStateNormal];
    [editMode setImage:IMAGE(@"arrow") forState:UIControlStateNormal];
    editMode.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 150);
    editMode.imageEdgeInsets = UIEdgeInsetsMake(15, 265, 8, 20);
    editMode.titleLabel.font = [UIFont systemFontOfSize:15];
    if ([currentLanguage isEqualToString:@"en"])
    {
        editMode.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 80);
    }
    if (iOSVERSION >=7.0 && [currentLanguage isEqualToString:@"en"])
    {
        editMode.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 70);
    }
    [editMode addTarget:self action:@selector(editMode) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:editMode];
    
    rect.origin.y = rect.origin.y + 40;
    
    UILabel *ModeDescribeLable = [[UILabel alloc]initWithFrame:rect];
    ModeDescribeLable.backgroundColor = [UIColor clearColor];
    ModeDescribeLable.textColor =UIColorFromRGB(0x009AD8);
    ModeDescribeLable.text = LOCAL(@"need");
    ModeDescribeLable.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:ModeDescribeLable];
    
    //关于设备
    rect.origin.y = rect.origin.y + 10 + 20;
    UIButton *aboutDevice = [UIButton buttonWithType:UIButtonTypeCustom];
    aboutDevice.frame = rect;
    aboutDevice.backgroundColor = UIColorFromRGB(0x009AD3);
    aboutDevice.layer.cornerRadius = 8;
    aboutDevice.showsTouchWhenHighlighted = YES;
    [aboutDevice setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [aboutDevice setTitle:LOCAL(@"aboutDevice") forState:UIControlStateNormal];
    [aboutDevice setImage:IMAGE(@"arrow") forState:UIControlStateNormal];
    aboutDevice.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 210);
    aboutDevice.imageEdgeInsets = UIEdgeInsetsMake(15, 265, 8, 20);
    aboutDevice.titleLabel.font = [UIFont systemFontOfSize:15];
    [aboutDevice addTarget:self action:@selector(aboutDevice) forControlEvents:UIControlEventTouchUpInside];
    if ([currentLanguage isEqualToString:@"en"])
    {
        aboutDevice.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 180);
    }
    [self.view addSubview:aboutDevice];
    
    
    //Help
    rect.origin.y = rect.origin.y + 50;
    UIButton *HelpDevice = [UIButton buttonWithType:UIButtonTypeCustom];
    HelpDevice.frame = rect;
    HelpDevice.backgroundColor = UIColorFromRGB(0x009AD3);
    HelpDevice.layer.cornerRadius = 8;
    HelpDevice.showsTouchWhenHighlighted = YES;
    [HelpDevice setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[HelpDevice setTitle:LOCAL(@"helpfile") forState:UIControlStateNormal];
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(23, 5, 120, 20)];
    l.text = LOCAL(@"helpfile");
    l.textColor = [UIColor whiteColor];
    l.font = [UIFont systemFontOfSize:15];
    [HelpDevice addSubview:l];
    [HelpDevice setImage:IMAGE(@"arrow") forState:UIControlStateNormal];
    HelpDevice.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 210);
    HelpDevice.imageEdgeInsets = UIEdgeInsetsMake(15, 265, 8, 20);
    HelpDevice.titleLabel.font = [UIFont systemFontOfSize:15];
    [HelpDevice addTarget:self action:@selector(HelpDevice) forControlEvents:UIControlEventTouchUpInside];
    if ([currentLanguage isEqualToString:@"en"])
    {
        HelpDevice.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 180);
    }
    [self.view addSubview:HelpDevice];
    
    
    if (iOSVERSION >=7.0)
    {
        collectView.frame = CGRectMake(collectView.frame.origin.x,collectView.frame.origin.y+ADJSTHEIGHT,collectView.frame.size.width,collectView.frame.size.height);
        
        Photo.frame = CGRectMake(Photo.frame.origin.x,Photo.frame.origin.y+ADJSTHEIGHT,Photo.frame.size.width,Photo.frame.size.height);
        
        editInfo.frame = CGRectMake(editInfo.frame.origin.x,editInfo.frame.origin.y+ADJSTHEIGHT,editInfo.frame.size.width,editInfo.frame.size.height);
        
        editParameter.frame = CGRectMake(editParameter.frame.origin.x,editParameter.frame.origin.y+ADJSTHEIGHT,editParameter.frame.size.width,editParameter.frame.size.height);
        
        parameterDescribeLable.frame = CGRectMake(parameterDescribeLable.frame.origin.x,parameterDescribeLable.frame.origin.y+ADJSTHEIGHT,parameterDescribeLable.frame.size.width,parameterDescribeLable.frame.size.height);
        
        editMode.frame = CGRectMake(editMode.frame.origin.x,editMode.frame.origin.y+ADJSTHEIGHT,editMode.frame.size.width,editMode.frame.size.height);
        
        ModeDescribeLable.frame = CGRectMake(ModeDescribeLable.frame.origin.x,ModeDescribeLable.frame.origin.y+ADJSTHEIGHT,ModeDescribeLable.frame.size.width,ModeDescribeLable.frame.size.height);
        
        aboutDevice.frame = CGRectMake(aboutDevice.frame.origin.x,aboutDevice.frame.origin.y+ADJSTHEIGHT,aboutDevice.frame.size.width,aboutDevice.frame.size.height);
        
        HelpDevice.frame = CGRectMake(HelpDevice.frame.origin.x,HelpDevice.frame.origin.y+ADJSTHEIGHT,HelpDevice.frame.size.width,HelpDevice.frame.size.height);
    }
}
- (void)myBack
{
    SQLSingle *sql = [SQLSingle shareSQLSingle];
    if (_isFavorite)
    {
        [sql.dataBase executeUpdate:@"update favorite set DEV_ID=?",_cam.nsDID];
    }
    
    NSString *did = [sql.dataBase stringForQuery:@"select DEV_ID from favorite"];
    if ([did isEqualToString:_cam.nsDID] && !_isFavorite)
    {
         [sql.dataBase executeUpdate:@"update favorite set DEV_ID=?",@""];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)myCollect:(UISwitch *)mySwitch
{
    _isFavorite = mySwitch.isOn;
    
    SQLSingle *sql = [SQLSingle shareSQLSingle];
    if (_isFavorite)
    {
        [sql.dataBase executeUpdate:@"update favorite set DEV_ID=?",_cam.nsDID];
    }
    
    NSString *did = [sql.dataBase stringForQuery:@"select DEV_ID from favorite"];
    if ([did isEqualToString:_cam.nsDID] && !_isFavorite)
    {
        [sql.dataBase executeUpdate:@"update favorite set DEV_ID=?",@""];
    }
}
-(void)Openphoto
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [self presentViewController:ipc animated:YES completion:nil];
}
- (void)editInfo
{
    EditInfoController *info = [[EditInfoController alloc]init];
    info.cam = _cam;
    [self.navigationController pushViewController:info animated:YES];
}
- (void)editParameter
{
    EditParameterController *Para = [[EditParameterController alloc]init];
    Para.cam = _cam;
    if(_cam.mCamState == CONN_INFO_CONNECTED)
    {
        [self.navigationController pushViewController:Para animated:YES];
    }
   else
   {
       NSString *messtr = [NSString stringWithFormat:@"%@%@",LOCAL(@"devices"),LOCAL(@"operation")];
       [WToast showWithText:messtr];
   }
}
- (void)editMode
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    EditModeController *mode = [[EditModeController alloc]init];
    mode.cam = _cam;
    delegate.WIFISSID = @"";
    if(_cam.mCamState == CONN_INFO_CONNECTED)
    {
        [_cam Rjone_SetEtc2];
        [self.navigationController pushViewController:mode animated:YES];
    }else
    {
        NSString *messtr = [NSString stringWithFormat:@"%@%@",LOCAL(@"devices"),LOCAL(@"operation")];
        [WToast showWithText:messtr];
    }
}
- (void)aboutDevice
{
    AboutDeviceController *about = [[AboutDeviceController alloc]init];
    about.cam = _cam;
     if(_cam.mCamState == CONN_INFO_CONNECTED)
     {
    [self.navigationController pushViewController:about animated:YES];
     }else
     {
          NSString *messtr = [NSString stringWithFormat:@"%@%@",LOCAL(@"devices"),LOCAL(@"operation")];
         [WToast showWithText:messtr];
     }
}
-(void)HelpDevice
{
    HelpDeviceController *help = [[HelpDeviceController alloc]init];
    help.cam = _cam;

    [self.navigationController pushViewController:help animated:YES];

}

#pragma mark ---UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
//    [self.navigationController popViewControllerAnimated:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
