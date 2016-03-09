//
//  ConectUsViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "ConectUsViewController.h"

@interface ConectUsViewController ()<UIWebViewDelegate>

@end

@implementation ConectUsViewController

- (void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:animated];
    [self createBackBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGB_A(240, 238, 238);
    self.navigationItem.title = @"联系我们";

    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/app/Comproblem?id=108",WX_URL]]];
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
