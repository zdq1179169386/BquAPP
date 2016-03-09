//
//  ReSetPswSuccessedViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "ReSetPswSuccessedViewController.h"
#import "LoginViewController.h"

@interface ReSetPswSuccessedViewController ()

@end

@implementation ReSetPswSuccessedViewController

- (void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:animated];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 21);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"重置密码成功";
    
    self.backLogin_Button.titleLabel.font =[UIFont systemFontOfSize:17];
    self.successed_Label.font =[UIFont systemFontOfSize:12];
    self.successed_Label.textColor = [UIColor colorWithHexString:@"#333333"];
    self.remian_Label.textColor = [UIColor colorWithHexString:@"#999999"];
    self.back_Label.textColor = [UIColor colorWithHexString:@"#999999"];
    self.backLogin_Button.backgroundColor = [UIColor colorWithHexString:@"#e8103c"];
    self.backLogin_Button.layer.cornerRadius = 8;
    self.backLogin_Button.layer.borderWidth = 1;
    self.backLogin_Button.layer.borderColor = [UIColor colorWithHexString:@"#ee1c3f"].CGColor;
    self.backLogin_Button.clipsToBounds = YES;

}
- (IBAction)backLoginButtonClick:(id)sender
{
    
    NSArray *ctrlArray = self.navigationController.viewControllers;
    [self.navigationController popToViewController:[ctrlArray objectAtIndex:1] animated:NO];
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
