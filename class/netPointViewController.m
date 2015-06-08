//
//  netPointViewController.m
//  Empty
//
//  Created by 李荣 on 15/5/15.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "netPointViewController.h"
#import <MapKit/MapKit.h>
#import<CoreLocation/CoreLocation.h>

@interface netPointViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *locationView;
@property(strong,nonatomic)CLLocationManager* locationManager;
@property(strong,nonatomic)CLLocation* previousPoint;
@property(assign,nonatomic)CLLocationDistance totalMovementDistance;

@end

@implementation netPointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationView.delegate = self;
    self.locationManager.delegate = self;

    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
    self.locationView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationView.showsUserLocation = YES;
    if ([[UIDevice currentDevice].systemVersion doubleValue]>=8.0) {
        [self.locationManager requestWhenInUseAuthorization];
    }  //  }

    [self.locationManager startUpdatingLocation];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -CCLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
//    CLLocation *newLocation
//    MKAnnotationView
//    self.locationView adda
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
