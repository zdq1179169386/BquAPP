//
//  SetSafetyPswViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "SetSafetyPswViewController.h"

@interface SetSafetyPswViewController ()

@end

@implementation SetSafetyPswViewController


- (void)viewWillAppear:(BOOL)animated
{
    [self createBackBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGB_A(240, 238, 238);
    self.navigationItem.title = @"安全密码设置";
    
    [self.commit_Button onlyCornerRadius];
    self.commit_Button.titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:17];
    self.safetyPsw_TextF.secureTextEntry = YES;
    self.sureSafetyPsw_TextF.secureTextEntry = YES;
    NSLog(@"=====++++++=====%@",self.isLogin);

}
- (IBAction)commitButtonClick:(id)sender
{
    [self.view endEditing:YES];
    
    if ([self.isLogin isEqualToString:@"0"])
    {
        if ([self.safetyPsw_TextF.text isEqualToString:@""] || [self.sureSafetyPsw_TextF.text isEqualToString:@""])
        {
               [TipView remindAnimationWithTitle:@"输入不可以为空哦"];
            

        }
        else
        {
            if ([[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,18}$"] evaluateWithObject:self.safetyPsw_TextF.text] &&[[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,18}$"] evaluateWithObject:self.sureSafetyPsw_TextF.text])
            {
                NSString * urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,setSafePasswordUrl];
                NSLog(@"安全密码地址 %@",urlStr);
                
                NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                [dic setObject:[UserManager getMyObjectForKey:userIDKey] forKey:@"MemberID"];
                [dic setObject:[UserManager getMyObjectForKey:accessTokenKey] forKey:@"token"];
                
                NSString *password = [self.safetyPsw_TextF.text MD5];
                NSString *realPasswprd = password.lowercaseString;
                [dic setValue:realPasswprd forKey:@"PassWord"];
                NSString * realSign = [HttpTool returnForSign:dic];
                dic[@"sign"] = realSign;
                
                [HttpTool post:urlStr params:dic success:^(id json)
                 {
                     
                     NSLog(@"传入的字典 = %@",dic);
                     NSLog(@"这是修改用户密码数据%@",json[@"message"]);
                     
                     NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
                     if ([resultStr isEqualToString:@"0"])
                     {
                         
                         [UserManager setMyObject:@"yes" forKey:safatyPasswordKey];
                         
                         NSLog(@"message%@",json[@"message"]);
                         [TipView doSomething:^
                          {
                              [self.navigationController popViewControllerAnimated:NO];
                          } afterDelayTime:1.9];
                         
                         [TipView ShadeWithTitle:@"密码设置成功" withImage:[UIImage imageNamed:@"susse"]];
                     }
                     else
                     {
                            [TipView remindAnimationWithTitle:json[@"message"]];
                     }
                 } failure:^(NSError *error)
                 {
                     
                 }];
            }
            else
            {
                   //[TipView remindAnimationWithTitle:@"密码格式不正确哦！"];
                   [TipView remindAnimationWithTitle:@"密码格式不正确哦！建议密码采用字母和数字混合"];
            }
        }
    }
    else
    {
           [TipView remindAnimationWithTitle:@"请先登录哦"];
    }
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
