//
//  AllPeakController.m
//  Bqu
//
//  Created by WONG on 15/10/10.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "AllPeakController.h"

@interface AllPeakController ()

@end

@implementation AllPeakController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor cyanColor];
    self.navigationItem.title = @"B区保障";
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/app/GenuineEnsure",WX_URL]]];
    [web loadRequest:request];
    web.scalesPageToFit = YES;
    
    [self.view addSubview:web];
    [self createBackBar];
}
- (void)createBackBar {
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


@end
