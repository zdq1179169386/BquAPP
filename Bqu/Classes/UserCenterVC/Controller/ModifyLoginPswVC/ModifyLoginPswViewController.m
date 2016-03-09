//
//  ModifyLoginPswViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "ModifyLoginPswViewController.h"

@interface ModifyLoginPswViewController ()

@end

@implementation ModifyLoginPswViewController


- (void)viewWillAppear:(BOOL)animated
{

    [self createBackBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGB_A(240, 238, 238);
    self.navigationItem.title = @"修改登录密码";
    
    [self.commit_Button onlyCornerRadius];
    self.commit_Button.titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:17];
    self.oldPsw_TextF.secureTextEntry = YES;
    self.pswNew_TextF.secureTextEntry = YES;
    
    NSLog(@"==========%@",self.isLogin);

}

- (IBAction)commitButoonClick:(id)sender
{
    [self.view endEditing:YES];
    if ([self.isLogin isEqualToString:@"0"])
    {
        if ([self.pswNew_TextF.text isEqualToString:@""] || [self.oldPsw_TextF.text isEqualToString:@""])
        {
           [TipView remindAnimationWithTitle:@"输入不可以为空哦"];
        }
        else
        {
            if ([[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[^\\s]{6,20}$"] evaluateWithObject:self.pswNew_TextF.text])
            {
                if ([self.oldPsw_TextF.text isEqualToString:self.pswNew_TextF.text])
                {
                   [TipView remindAnimationWithTitle:@"新旧密码不能一样哦"];
                }
                else
                {
                     NSString * urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,UpdateUserPasswordUrl];
                     NSLog(@"修改用户密码地址 %@",urlStr);
                     
                     NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                     [dic setObject:[UserManager getMyObjectForKey:userIDKey] forKey:@"MemberID"];
                     [dic setObject:[UserManager getMyObjectForKey:accessTokenKey] forKey:@"token"];
                     NSString *password = [self.pswNew_TextF.text MD5];
                     NSString *realPasswprd = password.lowercaseString;
                     [dic setValue:realPasswprd forKey:@"PassWord"];
                     NSString *oldpassword = [self.oldPsw_TextF.text MD5];
                     NSString *realOldPasswprd = oldpassword.lowercaseString;
                     [dic setValue:realOldPasswprd forKey:@"OldPassWord"];
                     [dic setObject:@"1" forKey:@"Type"];
                        
                     NSString * realSign = [HttpTool returnForSign:dic];
                     dic[@"sign"] = realSign;
                     
                     [HttpTool post:urlStr params:dic success:^(id json)
                      {
                          NSLog(@"传入的字典 = %@",dic);
                          NSLog(@"这是修改用户密码数据%@",json);
                          NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
                          if ([resultStr isEqualToString:@"0"])
                          {
                              NSLog(@"message%@",json[@"message"]);
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
            }
            else
            {
                [TipView remindAnimationWithTitle:@"密码格式不正确"];
            }
        }
    }
    else
    {
        [TipView remindAnimationWithTitle:@"请先登录哦~"];
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
