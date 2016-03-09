//
//  HSViewController.h
//  BquAPP
//
//  Created by yb on 15/10/14.
//  Copyright © 2015年 yb. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "StaticJumpToAppViewController.h"

@interface HSViewController : StaticJumpToAppViewController<UISearchBarDelegate>
{
    MBProgressHUD       *_loadingView;
    UILabel             *_tipLabel;
    UIImageView         *_emptyImageView;
    UISearchBar         *_searchBar;
}

@property (nonatomic, assign) BOOL  shouldHideTabbar;

// 返回按钮
- (void)createBackBar;
// 取消按钮
- (void)createCancelBar;



// 载入窗体
- (void)hideLoadingView;
- (void)showLoadingView;
- (void)removeLoadingView;

- (void)showEmptyView;
- (void)removeEmptyView;

// 成功和失败的处理
- (void)successfulOrFailWithWebView:(UIWebView *)aWebView isSuccess:(BOOL)isSuccess;

// 跳转网页
-(void)jumpWebView:(NSDictionary *)dict;


@end
