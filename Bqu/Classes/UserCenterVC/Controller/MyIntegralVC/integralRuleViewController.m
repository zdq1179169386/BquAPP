//
//  integralRuleViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/30.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "integralRuleViewController.h"

@interface integralRuleViewController ()<UIWebViewDelegate>

@end

@implementation integralRuleViewController

- (void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:animated];
    [self createBackBar];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB_A(240, 238, 238);
    self.navigationItem.title = @"积分规则";
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/app/IntegralRule",WX_URL]]];

    [self.view addSubview: webView];
    [webView loadRequest:request];

}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showLoadingView];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideLoadingView];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideLoadingView];
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
