//
//  SataicViewController.m
//  Bqu
//
//  Created by yb on 15/12/1.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "SataicViewController.h"
#import "BquTool.h"
#import "SearchController.h"
#import "GoodsDetailViewController.h"

@interface SataicViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView* web;

@end

@implementation SataicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _web = [[UIWebView alloc] initWithFrame:self.view.frame];
    [_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    //测试用[_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.bqu.com/Activitywap/HydratingMois_selection.html"]]];
    
    _web.scalesPageToFit = YES;
    _web.delegate = self;
    [self.view addSubview:_web];
    [self createBackBar];
    
    UIColor * color = [UIColor colorWithHexString:@"ededed"];
    self.navigationController.navigationBar.barTintColor = color;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createBackBar
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(backBarClicked) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 30, 21);
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}


- (void)backBarClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSLog(@"UIWebView console: %@", requestString);
    if ([requestString isEqualToString:self.url])
    {
        return  YES;
    }
    else
    {//调用父累 的解析url  并跳转
        NSLog(@"______%@",requestString);
        [self url:requestString];
        return NO;
    }

}
@end
