//
//  SearchController.m
//  KV8
//
//  Created by MasKSJ on 14-8-13.
//  Copyright (c) 2014年 MasKSJ. All rights reserved.
//

#import "SearchController.h"
#import "CamObj.h"
#import "GSetting.h"
#import "WToast.h"
#import "SQLSingle.h"
#import "RJONE_LibCallBack.h"
#import "AppDelegate.h"


typedef struct _IPC_SEARCH_RESP //save as little endian, * required items
{
    unsigned char cmd_id[4];
    unsigned char result;
    unsigned char reserve[3];
    
    unsigned char core_ver[4];	//kernel version e.g.:2.6.26.0  core_ver[0,1,2,3]=0,26,6,2
    unsigned char sys_ver[4];	//* firmware version, if int, little endian. Refer to above
    unsigned char p2papi_ver[4];//* P2P api version(if int, little endian). Refer to above
    unsigned char web_ver[4];	//web service version. Refer to above
    
    unsigned char  dev_id[20];	//* device ID
    unsigned short dev_web_port;//web service port
    unsigned short dev_p2p_port;//p2p port
    unsigned char  dev_mac[6];  //e.g.: 00:0C:29:84:46:1F  dev_mac[0,1,2,3,4,5]=00,0C,29,84,46,1F
    unsigned char  dev_isStaticIP;	 //0: no static ip(DHCP); 1: yes
    unsigned char  dev_network_mode; //* 1: AP WiFi mode;  2: Network card mode
    
    unsigned char  dev_ip[4];			//device ip   //e.g.:192.168.1.100  dev_ip[0,1,2,3]=100,1,168,192
    unsigned char  dev_subnet_mask[4];	//device subnet mask
    unsigned char  dev_gateway[4];		//device gateway. Refer to device ip
    unsigned char  dev_dns1[4];
    unsigned char  dev_dns2[4];
    unsigned char  reserv2[4];
    
    unsigned char  dev_ssid[64];//* added 2013-01-20
    unsigned char  dev_sn[20];  //* added 2012-06-28
    unsigned char  dev_type;	//* refer to ENUM_DEV_TYPE 1: single sensor; 2:dual sensor
    unsigned char  product_type;//* refer to ENUM_PRODUCT_TYPE //modified 2013-12-06
    unsigned char  reserve3[2]; //2013-01-20
}SEARCH_RESP;


@interface SearchController ()
{
    MBProgressHUD *HUD;
    UITableView *_deviceTable;
    NSMutableArray *_searchResultArray;
}
@end

@implementation SearchController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _searchResultArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = LOCAL(@"devices_searched");
    self.view.backgroundColor = BLUECOLOR;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 25, 26.43);
    [backButton setImage:[UIImage imageWithContentsOfFile:PATH(@"back_no")] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(myBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    UIButton *allSaveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    allSaveButton.frame = CGRectMake(0, 0, 25, 22.57);
    [allSaveButton setImage:[UIImage imageWithContentsOfFile:PATH(@"addall_no")] forState:UIControlStateNormal];
    [allSaveButton addTarget:self action:@selector(myAllSave) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:allSaveButton];
    
    _deviceTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (iOSVERSION <7.0)
    {
        _deviceTable.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    }
    _deviceTable.backgroundColor = BLUECOLOR;
    _deviceTable.separatorColor = [UIColor whiteColor];
    if (iOSVERSION>=7.0)
    {
        _deviceTable.separatorInset = UIEdgeInsetsZero;
    }
    _deviceTable.dataSource =self;
    _deviceTable.delegate = self;
    [self setExtraCellLineHidden:_deviceTable];
    [self.view addSubview:_deviceTable];
    
    HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = LOCAL(@"searching");
    
    [HUD showWhileExecuting:@selector(mySearch) onTarget:self withObject:nil animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)myBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)myAllSave
{
    NSInteger addNum = 0;
    GSetting *gSetting = [GSetting instance];
    for (CamObj *cam in _searchResultArray)
    {
        if (!cam.isExist)
        {
            addNum++;
            [gSetting.arrCam addObject:cam];
            cam.isExist = YES;
            cam.addedName=[NSString stringWithFormat:@"%@%@", cam.nsDID,LOCAL(@"added")];
            
            SQLSingle *sql = [SQLSingle shareSQLSingle];
            [sql.dataBase executeUpdate:@"insert into camre_info(CAMERA_NAME,DEV_ID,DEV_PWD) values(?,?,?)",cam.nsCamName,cam.nsDID,cam.nsViewPwd];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                long connectResult = [cam startConnect:10];
                NSLog(@"%@->connect result ==%ld",cam.nsDID,connectResult);
            });
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [_deviceTable reloadData];
        [WToast showWithText:[NSString stringWithFormat:LOCAL(@"added_devices"),addNum]];
    });
    
}
- (void)mySearch
{
    
    SEARCH_CALL_RESP * pSearch;
    INT32 nNum=0, i=0;
    pSearch = RJONE_LibSearch(30, 5, &nNum);
    
    
    NSString *nsDID;
    CHAR prefix[64], number[64], checkCode[64], Result[64];
    
    for(i=0; i<nNum; i++)
    {
        nsDID=[NSString stringWithFormat:@"%s", pSearch[i].dev_id];
        
        memset(prefix, 0, sizeof(prefix));
        memset(number, 0, sizeof(number));
        memset(checkCode, 0, sizeof(checkCode));
        memset(Result, 0, sizeof(Result));
        formatDID((CHAR *)pSearch[i].dev_id, prefix, number, checkCode, Result);
        
        CamObj *camObj=[[CamObj alloc] init];
        camObj.nsDID    = nsDID;
        camObj.nsViewPwd  = @"88888888";
        camObj.nsCamName=nsDID;
        camObj.addedName = nsDID;

        
        GSetting *gSetting = [GSetting instance];
        for(CamObj *cam in gSetting.arrCam)
        {
            if([cam.nsDID caseInsensitiveCompare:nsDID]==NSOrderedSame)
            {
                camObj.isExist = YES;
                break;
            }
        }
        if (camObj.isExist)
        {
            camObj.addedName=[NSString stringWithFormat:@"%@%@", nsDID,LOCAL(@"added")];
        }
        [_searchResultArray addObject:camObj];

    }
    [NSThread sleepForTimeInterval:0.1];
    for (int i = 0; i<_searchResultArray.count; i++)
    {
        CamObj *cam = [_searchResultArray objectAtIndex:i];
        if (cam.isExist)
        {
            [_searchResultArray addObject:cam];
            [_searchResultArray removeObjectAtIndex:i];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_deviceTable reloadData];
        [WToast showWithText:[NSString stringWithFormat:LOCAL(@"found_devices"),_searchResultArray.count]];
    });
    
    //    DCAM_SearchInLAN_release(&pSearch);

}
int formatDID(const CHAR* DID, CHAR *prefix, CHAR *number, CHAR *checkCode, CHAR* Result)
{
    INT32 i=0, j=0, posCheckCode=0, posNumber=0;
    CHAR bIsCharacter;
    const CHAR *p = DID;
    if(p == NULL) return -1;
    
    j = 0;
    bIsCharacter = 1;
    for(i = 0 ; i < 64; i++)
    {
        if((DID[i] >= '0') && (DID[i] <= '9'))
        {
            if(bIsCharacter == 1)
            {
                strcpy(prefix, Result);
                
                bIsCharacter = 0;
                Result[j] = '-';
                j++;
                posNumber=j;
            }
            Result[j] = DID[i];
            j++;
            
        }else if((DID[i] >= 'a') && (DID[i] <= 'z')){
            if(bIsCharacter == 0)
            {
                bIsCharacter = 1;
                Result[j] = '-';
                j++;
                posCheckCode=j;
            }
            Result[j] = DID[i] - ('a' - 'A');
            j++;
            
        }else if((DID[i] >= 'A') && (DID[i] <= 'Z')){
            if(bIsCharacter == 0){
                bIsCharacter = 1;
                Result[j] = '-';
                j++;
                posCheckCode=j;
            }
            Result[j] = DID[i];
            j++;
        }else if(DID[i] == '-'){
            // Do nothing
        }else break;
    }
    
    if(posNumber>0) {
        strcpy(number, Result);
        *(number+posCheckCode-1)='\0';
        //strcpy(number, (char *)&number[posNumber]);
        int kk=0, kkLen=(int)strlen(number);
        for(kk=0;kk<kkLen; kk++) number[kk]=number[posNumber+kk];
        number[kk]='\0';
    }
    if(posCheckCode>0) strcpy(checkCode, (Result+posCheckCode));
    return 0;
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
#pragma mark -UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchResultArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.contentView.backgroundColor = BLUECOLOR;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = TOPBARCOLOR;
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.frame = CGRectMake(0, 0, 10.2, 17.4);
    [b setImage:IMAGE(@"arrow") forState:UIControlStateNormal];
    b.center = CGPointMake(300, 30);
    b.userInteractionEnabled = NO;
    [cell.contentView addSubview:b];
    CamObj *cam = [_searchResultArray objectAtIndex:indexPath.row];
    cell.textLabel.text =cam.addedName;
    cell.textLabel.textColor = TOPBARCOLOR;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.1f];
    CamObj *cam = [_searchResultArray objectAtIndex:indexPath.row];
    if (cam.isExist)
    {
        [WToast showWithText:[NSString stringWithFormat:LOCAL(@"have_added"),_searchResultArray.count]];
        return;
    }
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.camDID = cam.nsDID;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)deselect
{
    [_deviceTable deselectRowAtIndexPath:[_deviceTable indexPathForSelectedRow] animated:NO];
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
