//
//  ProductWebController.m
//  Bqu
//
//  Created by yb on 15/11/13.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "ProductWebController.h"

@interface ProductWebController ()<UIWebViewDelegate>

/**<#property#>*/
@property (nonatomic,strong)UIWebView * web;


@end

@implementation ProductWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IOS7_OR_LATER)
    {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
   self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f1f1"];
    
    NSString * str = [NSString stringWithFormat:@"%@/m-wap/app/ProductDetail?id=%@",WX_URL,self.productId];
    NSURL * url = [NSURL URLWithString:str];
    UIWebView * view = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight-20)];
//    view.backgroundColor = [UIColor grayColor];
    view.scalesPageToFit = YES;
    view.delegate = self;
    [view loadRequest:[NSURLRequest requestWithURL:url]];

   
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(GoBackForward)];
    
    // 设置文字
    [header setTitle:@"下拉返回商品详情" forState:MJRefreshStateIdle];
    [header setTitle:@"加载中" forState:MJRefreshStatePulling];
    [header setTitle:@"松开即可返回" forState:MJRefreshStateRefreshing];
    header.backgroundColor = [UIColor colorWithHexString:@"#f2f1f1"];
     __weak UIScrollView * scrollView = view.scrollView;
    scrollView.header = header;
    // 马上进入刷新状态


    [self.view addSubview:view];
    self.web = view;
    
    
}
-(void)GoBackForward
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.web.scrollView.header endRefreshing];
    }];
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [ProgressHud addProgressHudWithView:self.view andWithTitle:@"加载中"];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [ProgressHud hideProgressHudWithView:self.view];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [ProgressHud hideProgressHudWithView:self.view];

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
