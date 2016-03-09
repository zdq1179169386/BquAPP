//
//  AboutViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()<UIWebViewDelegate>

@end

@implementation AboutViewController
- (void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:animated];
    [self createBackBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = RGB_A(240, 238, 238);
    self.navigationItem.title = @"关于B区";
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/app/Comproblem?id=107",WX_URL]]];
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
}//
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    //字体大小
//    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '70%'"];
//    //字体颜色
//    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#55555'"];
//    //页面背景色
//    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#EFECED'"];
//}
//

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
