//
//  ModifySafetyPswViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "ModifySafetyPswViewController.h"
#import "ForgetSafePasswordViewController.h"

@interface ModifySafetyPswViewController ()

@end

@implementation ModifySafetyPswViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self createBackBar];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGB_A(240, 238, 238);
    self.navigationItem.title = @"修改安全密码";
    
    [self.commit_Button onlyCornerRadius];
     self.commit_Button.titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:17];
    

    self.oldSafePsw_TextF.secureTextEntry = YES;
    self.newlySafePsw_TextF.secureTextEntry = YES;
    self.againMewPsw_TextF.secureTextEntry = YES;

}
- (IBAction)commitButtonClick:(id)sender
{
    [self.view endEditing:YES];

    if ([self.isLogin isEqualToString:@"0"])
    {
        if ([self.oldSafePsw_TextF.text isEqualToString:@""] || [self.newlySafePsw_TextF.text isEqualToString:@""] || [self.againMewPsw_TextF.text isEqualToString:@""])
        {
            [TipView remindAnimationWithTitle:@"输入不能为空"];
            [self hideLoadingView];
        }
        else
        {
             if ([[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,18}$"] evaluateWithObject:self.newlySafePsw_TextF.text] &&[[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,18}$"] evaluateWithObject:self.againMewPsw_TextF.text])
             {
                 if ([self.newlySafePsw_TextF.text isEqualToString:self.oldSafePsw_TextF.text])
                 {
                    [TipView remindAnimationWithTitle:@"新旧密码不能一致哦~"];
                 }
                 else
                 {
                     if ([self.newlySafePsw_TextF.text isEqualToString:self.againMewPsw_TextF.text])
                     {
                         
                         NSString * urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,UpdateUserPasswordUrl];
                         NSLog(@"修改安全密码地址 %@",urlStr);
                         
                         NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                         [dic setObject:[UserManager getMyObjectForKey:userIDKey] forKey:@"MemberID"];
                         [dic setObject:[UserManager getMyObjectForKey:accessTokenKey] forKey:@"token"];
                         
                         NSString *password = [self.newlySafePsw_TextF.text MD5];
                         NSString *realPasswprd = password.lowercaseString;
                         [dic setValue:realPasswprd forKey:@"PassWord"];
                         
                         NSString *oldpassword = [self.oldSafePsw_TextF.text MD5];
                         NSString *realOldPasswprd = oldpassword.lowercaseString;
                         [dic setValue:realOldPasswprd forKey:@"OldPassWord"];
                         [dic setObject:@"2" forKey:@"Type"];
                         
                         NSString * realSign = [HttpTool returnForSign:dic];
                         dic[@"sign"] = realSign;
                         
                         
                         
                         [HttpTool post:urlStr params:dic success:^(id json)
                          {
                              [self hideLoadingView];
                              NSLog(@"传入的字典 = %@",dic);
                              NSLog(@"这是修改安全密码数据%@",json);
                              NSLog(@"message%@",json[@"message"]);
                              
                              NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
                              if ([resultStr isEqualToString:@"0"])
                              {
                                  [TipView doSomething:^
                                   {
                                       [self.navigationController popViewControllerAnimated:NO];
                                   } afterDelayTime:1.9];
                                  
                                  [TipView ShadeWithTitle:@"密码修改成功" withImage:[UIImage imageNamed:@"susse"]];
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
                        [TipView remindAnimationWithTitle:@"两次输入密码不一致"];
                     }

                 }
                 
             }
            else
            {
                [TipView remindAnimationWithTitle:@"密码格式不正确哦！建议密码采用字母和数字混合"];
            }
        }
        }else
        {
             [TipView remindAnimationWithTitle:@"请先登录哦"];
        }

}
- (IBAction)forgetSafePswButtonClick:(id)sender
{
    
    //发送验证码
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,registrSendCodeUrl];
    NSLog(@"接口地址 %@",urlStr);
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:self.phoneNumber forKey:@"Mobile"];
    [dic setObject:@"1" forKey:@"Key"];
    NSString * realSign = [HttpTool returnForSign:dic];
    dic[@"sign"] = realSign;
    
    [HttpTool post:urlStr params:dic success:^(id json)
     {
         NSLog(@"传入的字典 = %@",dic);
         NSLog(@"这是发送注册验证码的数据%@",json);
         NSLog(@"message%@",json[@"message"]);
         
         NSString *resultCode = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
         if ([resultCode isEqualToString:@"0"])
         {
             ForgetSafePasswordViewController *forgetSafeVC = [[ForgetSafePasswordViewController alloc] init];
             forgetSafeVC.hidesBottomBarWhenPushed = YES;
             forgetSafeVC.phoneNumber = self.phoneNumber;
             [self.navigationController pushViewController:forgetSafeVC animated:NO];
             
         }
         else
         {
            [TipView remindAnimationWithTitle:json[@"message"]];
         }
         
         
     } failure:^(NSError *error)
     {
         
     }];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

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
