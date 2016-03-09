//
//  HSViewController.m
//  BquAPP
//
//  Created by yb on 15/10/14.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "HSViewController.h"
#import "Header.h"
#import <AudioToolbox/AudioToolbox.h>
#import "AppDelegate.h"

@interface HSViewController ()

@end

@implementation HSViewController

#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setNavBar
{
    if (IOS7_OR_LATER)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        //barTintColor背景色; tintColor是barButtonItem颜色; titleTextAttributes是标题颜色
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#F2F0F1"];
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.tintColor = NAVI_TintColor;
        self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:NAVI_TitleTextColor forKey:NSForegroundColorAttributeName];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    else
    {
        self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"#F2F0F1"];
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_shouldHideTabbar)
    {
        self.hidesBottomBarWhenPushed = YES;
        self.tabBarController.tabBar.hidden = YES;
    }
    else
    {
        self.hidesBottomBarWhenPushed = NO;
        self.tabBarController.tabBar.hidden = NO;
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Funcs

- (void)createBackBar
{
    [self hideLoadingView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(backBarClicked) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 30, 21);
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)createCancelBar
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(cancelBarClicked) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0 , 0, 12, 21);
    [btn setImage:[UIImage imageNamed:@"icon_back_n"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon_back_p"] forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}



#pragma mark - Actions

- (void)backBarClicked
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)cancelBarClicked
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)popviewController:(BOOL)animated
{
    [self.navigationController popToRootViewControllerAnimated:animated];
}

#pragma mark - Loading

- (void)showLoadingView
{
    if (!_loadingView)
    {
        // 基于哪个view?
        UIView *baseView = self.navigationController.view ? self.navigationController.view : self.view;
        _loadingView = [[MBProgressHUD alloc] initWithView:baseView];
        _loadingView.labelText = @"载入中";
        _loadingView.color = [UIColor blackColor];//这儿表示无背景
        [baseView addSubview:_loadingView];
        
    }
    
    [_loadingView show:YES];
}

- (void)hideLoadingView
{
    [_loadingView hide:YES];
}

- (void)removeLoadingView
{
    if (_loadingView)
    {
        [_loadingView removeFromSuperview];
        _loadingView = nil;
    }
}


- (void)showEmptyView
{
    if (_emptyImageView)
    {
        [_emptyImageView removeFromSuperview];
        _emptyImageView = nil;
    }
    
    _emptyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 568)];
    _emptyImageView.image = [UIImage imageNamed:@"empty_tip"];
    [self.view addSubview:_emptyImageView];
}

- (void)removeEmptyView
{
    if (_emptyImageView)
    {
        [_emptyImageView removeFromSuperview];
        _emptyImageView = nil;
    }
}




//用如下方式，可以使得用户结束通话后自动返回到应用：
-(void)callURL:(NSString *)phone
{
    UIWebView *callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phone]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    //记得添加到view上
    [self.view addSubview:callWebview];
}

#pragma mark - 临时


#pragma mark - 成功或失败的处理

- (void)successfulOrFailWithWebView:(UIWebView *)aWebView isSuccess:(BOOL)isSuccess
{
    NSString *callBack = [[NSUserDefaults standardUserDefaults] objectForKey:@"callback"];
    NSString *jsStr = [NSString stringWithFormat:@"%@('%@')", callBack, isSuccess ? @"1": @"0"];
    
    //    [aWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@('1')",callBack]];
    [aWebView stringByEvaluatingJavaScriptFromString:jsStr];
}

#pragma mark - 跳转网页
-(void)jumpWebView:(NSDictionary *)dict
{
    //分析url地址，http为网页,tel为电话
    NSString *str =[NSString stringWithFormat:@"%@",[dict objectForKey:@"url"]];
    if(![str isEqual: @"javascript:;"])
    {
        if ([str rangeOfString:@"tel://" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            //            UIAlertView *aView = [[UIAlertView alloc] initWithTitle:nil
            //                                                            message:@"确认拨打电话:"
            //                                                  cancelButtonTitle:@"取消"
            //                                                  otherButtonTitles:@"拨打", nil];
            //            [aView show];
            //            [aView setHandler:^(UIAlertView *alert, NSInteger buttonIndex)
            //             {
            //                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            //             }
            //             forButtonAtIndex:1];
        }
        else
        {
            // 点击网页
            
            //            ShopDetailViewController *ctl = [[ShopDetailViewController alloc] init];
            //            ctl.shopDetailUrl = [dict objectForKey:@"url"];
            //            ctl.shouldHideTabbar = YES;
            //            ctl.hidesBottomBarWhenPushed = YES;
            //            
            //            [self.navigationController pushViewController:ctl animated:YES];
        }
    }
}

@end
