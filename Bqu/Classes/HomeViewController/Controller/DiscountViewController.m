//
//  DiscountViewController.m
//  Bqu
//
//  Created by yingbo on 15/9/28.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "DiscountViewController.h"

@interface DiscountViewController ()<UIWebViewDelegate>
/**<#property#>*/
@property (nonatomic,strong)UIWebView * web;


/**<#property#>*/
@property (nonatomic,strong)UIScrollView * scrollview;



@end

@implementation DiscountViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"web=%@",self.goodsUrl);
    self.web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
   
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.goodsUrl]];
    // 添加Web
    [self.web loadRequest:request];
    self.web.scalesPageToFit = YES;
    self.web.delegate = self;
    __weak UIScrollView * scrollView = self.web.scrollView;
    scrollView.header = [DIYHeader headerWithRefreshingBlock:^{
        [self.web reload];
    }];
    [self.view addSubview:self.web];
    self.scrollview = scrollView;
    self.view.backgroundColor = [UIColor orangeColor];
    [self createBackBar];

}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.scrollview.header endRefreshing];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
//    if (error) {
//        [ProgressHud addProgressHudWithView:self.view andWithTitle:@"网页加载出错" withTime:1 withType:MBProgressHUDModeText];
//        }
    [self.scrollview.header endRefreshing];

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
