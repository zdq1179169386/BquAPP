//
//  ResetPasswordViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/10.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "ReSetPswSuccessedViewController.h"

@interface ResetPasswordViewController ()

@end

@implementation ResetPasswordViewController
- (void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:animated];
    [self createBackBar];
    NSLog(@"验证码 = %@",self.checkCode);
}


- (void)viewDidLoad {
    [super viewDidLoad];


    self.view.backgroundColor = RGB_A(240, 238, 238);
    self.navigationItem.title = @"重置密码";
    self.next_Button.titleLabel.font =[UIFont systemFontOfSize:17];
    [self.next_Button onlyCornerRadius];
    self.setNewPsw_TextField.secureTextEntry = YES;
    self.next_Button.backgroundColor = [UIColor colorWithHexString:@"#e8103c"];
    self.next_Button.layer.cornerRadius = 8;
    self.next_Button.layer.borderWidth = 1;
    self.next_Button.layer.borderColor = [UIColor colorWithHexString:@"#ee1c3f"].CGColor;
    self.next_Button.clipsToBounds = YES;

}
- (IBAction)nextButtonClick:(id)sender
{
    [self.view endEditing:YES];
    
    if (![self.setNewPsw_TextField.text isEqualToString:@""] )
    {
        
        if ([[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[^\\s]{6,20}$"] evaluateWithObject:self.setNewPsw_TextField.text])
        {
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,searchPasswordUrl];
            NSLog(@"用户找回密码的数据%@",urlStr);
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:self.number forKey:@"Mobile"];
            
            NSString *password = [self.setNewPsw_TextField.text MD5];
            NSString *realPasswprd = password.lowercaseString;
            [dic setValue:realPasswprd forKey:@"PassWord"];
            
            [dic setObject:self.checkCode forKey:@"Code"];
            [dic setObject:@"2" forKey:@"Key"];
            NSString *realSign = [HttpTool returnForSign:dic];
            
            dic[@"sign"] = realSign;
            
            [HttpTool post:urlStr params:dic success:^(id json)
             {
                 NSLog(@"传入的字典%@",dic);
                 NSLog(@"找回登陆密码json = %@",json);
                 NSLog(@"message = %@",json[@"message"]);
                 NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
                 if ([resultStr isEqualToString:@"0"])
                 {
                     ReSetPswSuccessedViewController *reSetVC = [[ReSetPswSuccessedViewController alloc] init];
                     reSetVC.hidesBottomBarWhenPushed = YES;
                     [self.navigationController pushViewController:reSetVC animated:NO];
                 }
                 else
                 {
                     [TipView remindAnimationWithTitle:json[@"message"]];
                 }
             } failure:^(NSError *error)
             {
                 NSLog(@"网络连接不稳定");
             }];
            
        }
        else
        {
            [TipView remindAnimationWithTitle:@"密码格式不正确~"];
        }
    }
    else
    {
       [TipView remindAnimationWithTitle:@"输入不可以为空哦~"];
    }
    
}
- (IBAction)showPswButtonClick:(id)sender
{
    self.setNewPsw_TextField.secureTextEntry = NO;
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
