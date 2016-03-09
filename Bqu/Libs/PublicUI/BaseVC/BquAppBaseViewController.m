//
//  BquAppBaseViewController.m
//  Bqu
//
//  Created by yb on 15/11/27.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "BquAppBaseViewController.h"



@implementation BquAppBaseViewController

-(instancetype)init
{
    self = [super init];
    if (self) {
       
    }
    return self;
}
-(NetWorkView *)netView
{
    if (!_netView) {
        _netView = [[NetWorkView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _netView.delegate = self;
    }
    return _netView;
}
-(void)creatBackBtn
{
    UIButton * backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    [self hideNetWorkingView];
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    
//     [self creatBackBtn];
//    NSLog(@"self.navigationController.view==%@",self.navigationController.view);

//   self.navigationController.view.backgroundColor = [UIColor redColor];
//    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
//    //开始检测
//    [mgr startMonitoring];
//    // 2.设置网络状态改变后的处理
//    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        // 当网络状态改变了, 就会调用这个block
//        switch (status) {
//            case AFNetworkReachabilityStatusUnknown: // 未知网络
//                NSLog(@"未知网络");
//                self.IsHasNetwork = NO;
//                break;
//            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
//            {
//                self.IsHasNetwork = NO;
////                NSLog(@"没有网络(断网),self.navigationController.view==%@",self.navigationController.view);
////                [self.navigationController pushViewController:<#(nonnull UIViewController *)#> animated:<#(BOOL)#>];
////                self.IsHasNetwork = NO;
//                if (!_netView) {
//                    _netView = [[NetWorkView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
//                    _netView.delegate = self;
//                }
////                UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
//                UIView * baseView = self.navigationController.view ? self.navigationController.view : self.view;
//                [self.view addSubview:_netView];
//            }
//                break;
//                
//            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
//                NSLog(@"手机自带网络");
//                self.IsHasNetwork = YES;
//                break;
//                
//            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
//                NSLog(@"WIFI");
//                self.IsHasNetwork = YES;
//                break;
//        }
//    }];
//    //结束检测
//    [mgr stopMonitoring];
}
-(void)hideNetWorkingView
{
    if (_netView) {
        [_netView removeFromSuperview];
        _netView = nil;
    }
 
}

@end
