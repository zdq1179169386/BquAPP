//
//  AgreeMentViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/10.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "AgreeMentViewController.h"

@interface AgreeMentViewController ()<UIWebViewDelegate>

@end

@implementation AgreeMentViewController
- (void)viewWillAppear:(BOOL)animated
{
    [self createBackBar];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    [super viewDidLoad];
    self.navigationItem.title = @"注册协议";

    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/app/Agreement",WX_URL]]];
    
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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
