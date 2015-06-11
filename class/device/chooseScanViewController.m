//
//  chooseScanViewController.m
//  Empty
//
//  Created by leron on 15/6/11.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "chooseScanViewController.h"
#import "SYQRCodeViewController.h"
#import "ZBarImage.h"
#import "zbar.h"
#import "ZBarReaderView.h"
#import "ZBarCameraSimulator.h"
#import "ZBarReaderController.h"
@interface chooseScanViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZBarReaderDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnScanCode;
@property (weak, nonatomic) IBOutlet UIButton *btnChooseCode;

@end

@implementation chooseScanViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"扫一扫";
    [super viewDidLoad];
    [self.btnScanCode addTarget:self action:@selector(gotoScan) forControlEvents:UIControlEventTouchUpInside];
    [self.btnChooseCode addTarget:self action:@selector(gotoChoose) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}

-(void)gotoScan{
    SYQRCodeViewController* controller = [[SYQRCodeViewController alloc]init];
    [self.navigationController presentViewController:controller animated:YES completion:nil];
}

-(void)gotoChoose{
//    UIImagePickerController* controller = [[UIImagePickerController alloc]init];
//    controller.delegate = self;
//    [self.navigationController presentViewController:controller animated:YES completion:nil];
    ZBarReaderController* controller = [[ZBarReaderController alloc]init];
    controller.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self.navigationController presentViewController:controller animated:YES completion:nil];
    
}

#pragma mark imagePickerControllerDelegate
//-(void)imagePickerController:(nonnull UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *id> *)info{
//    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    
//    
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
