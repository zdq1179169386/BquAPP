//
//  ThemeJumpToVC.m
//  Bqu
//
//  Created by WONG on 15/10/20.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "ThemeJumpToVC.h"

@interface ThemeJumpToVC ()

@end

@implementation ThemeJumpToVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createBackBar];
    UILabel * titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLable.text = @"品牌专场";
    titleLable.font = [UIFont systemFontOfSize:20];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLable;
}

- (void)createBackBar
{
//    [self hideLoadingView];
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
    [self dismissViewControllerAnimated:YES completion:NULL];
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
