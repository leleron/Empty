//
//  SplashViewController.m
//  fishPhone
//
//  Created by SUNFLOWER on 8/7/13.
//  Copyright (c) 2013 com.awe.ifish. All rights reserved.
//

#import "SplashViewController.h"
#import <CoreGraphics/CGAffineTransform.h>

@interface SplashViewController ()

@end

@implementation SplashViewController

- (id)initWithViewController:(UIViewController *)controller animation:(UIModalTransitionStyle)transition {
    
	return [self initWithViewController:controller animation:transition delay:1.0];
}

- (id)initWithViewController:(UIViewController *)controller animation:(UIModalTransitionStyle)transition delay:(NSTimeInterval)seconds {
	self = [super init];
	
	if (self) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
		NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
		NSString *launchImageFile = [infoDictionary objectForKey:@"UILaunchImageFile"];
		NSString *launchImageFileiPhone = [infoDictionary objectForKey:@"UILaunchImageFile~iphone"];
		
        imagetitle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        imagetitle.backgroundColor = [UIColor blackColor];
        imagetitle.hidden = YES;
         image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];

        
        [self.view addSubview:imagetitle];
        [self.view addSubview:image ];

		
		[controller setModalTransitionStyle:transition];
		
		[NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(timerFireMethod:) userInfo:controller repeats:NO];
	}
	
	return self;
}
# if 1
-(BOOL)shouldAutorotate
{
    NSLog(@"shouldAutorotate");
    
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    NSLog(@" SPLASH   supportedInterfaceOrientations   %ld ",(long)[[UIDevice currentDevice] orientation]  );
    [[UIDevice currentDevice]  orientation];
//    return UIInterfaceOrientationMaskLandscape;
    imagetitle.frame = CGRectMake(0, 0, 320, 20);
    image.frame = CGRectMake(0, 0, 320, 480);
    image.image = [UIImage imageNamed:@"960.png"];
    
     return UIInterfaceOrientationMaskPortrait;
}
#endif
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSLog(@" %ld ",(long)[[UIDevice currentDevice] orientation]);

    return NO;
}
- (void)timerFireMethod:(NSTimer *)theTimer {
	[self presentModalViewController:[theTimer userInfo] animated:YES];
}

@end
