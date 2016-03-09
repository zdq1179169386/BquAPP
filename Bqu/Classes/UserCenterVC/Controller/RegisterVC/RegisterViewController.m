//
//  RegisterViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/10.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "RegisterViewController.h"
#import "ImportIdentityCodeViewController.h"
#import "AgreeMentViewController.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController


- (void)viewWillAppear:(BOOL)animated
{
    [self createBackBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGB_A(240, 238, 238);
    self.navigationItem.title = @"用户注册";
    self.getIdentityCode_Button.titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:17];
    self.number_TextField.delegate = self;

    self.getIdentityCode_Button.backgroundColor = [UIColor lightGrayColor];
    self.getIdentityCode_Button.userInteractionEnabled = NO;
    [self.agree_button setBackgroundImage:[UIImage imageNamed:@"noture"] forState:UIControlStateNormal];

    isSelected = YES;
    [self.agree_button setBackgroundImage:[UIImage imageNamed:@"ture"] forState:UIControlStateNormal];
    self.getIdentityCode_Button.userInteractionEnabled = YES;
    self.getIdentityCode_Button.backgroundColor = [UIColor colorWithHexString:@"#e8103c"];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 11)
       return NO; // return NO to not change text
    
    return YES;
}

- (IBAction)registerButtonClick:(id)sender
{
    if (![self.number_TextField.text isEqualToString:@""] )
    {
        if (self.number_TextField.text.length != 11 || ![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1(3[0-9]|5[0-35-9]|8[0-9])\\d{8}$"] evaluateWithObject:self.number_TextField.text])
        {
            [self hideLoadingView];
            
            [TipView remindAnimationWithTitle:@"手机号格式不正确"];
        }
        else
        {
            //检验手机号码是否存在
            NSString * urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,existMobileUrl];
            //    NSLog(@"检验手机号码是否存在接口地址 %@",urlStr);
            
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            [dic setObject:self.number_TextField.text forKey:@"mobile"];
            NSString * realSign = [HttpTool returnForSign:dic];
            dic[@"mobile"] = self.number_TextField.text;
            dic[@"sign"] = realSign;
            [HttpTool post:urlStr params:dic success:^(id json)
             {
                 [self hideLoadingView];
                 //        NSLog(@"传入的字典 = %@",dic);
                 //        NSLog(@"这是验证手机号是否存在%@",json);
                 NSString *isExist = json[@"resultCode"];
                 
                 if (isExist.boolValue == 0)
                 {
                     
                     //发送验证码
                     NSString * urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,registrSendCodeUrl];
                     NSLog(@"接口地址 %@",urlStr);
                     NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                     [dic setObject:self.number_TextField.text forKey:@"Mobile"];
                     [dic setObject:@"0" forKey:@"Key"];
                     NSString * realSign = [HttpTool returnForSign:dic];
                     dic[@"sign"] = realSign;
                     
                     [HttpTool post:urlStr params:dic success:^(id json)
                      {
                          //                 NSLog(@"传入的字典 = %@",dic);
                          NSLog(@"这是发送注册验证码的数据%@",json);
                          NSLog(@"message%@",json[@"message"]);
                          
                          NSString *resultCode = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
                          if ([resultCode isEqualToString:@"0"])
                          {
                              ImportIdentityCodeViewController *importVC = [[ImportIdentityCodeViewController alloc] init];
                              importVC.hidesBottomBarWhenPushed = YES;
                              importVC.phoneNumber = self.number_TextField.text;
                              
                              [self.navigationController pushViewController:importVC animated:NO];
                              self.getIdentityCode_Button.titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:17];
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
                      [TipView remindAnimationWithTitle:@"手机号已经注册过了"];
                 }
             } failure:^(NSError *error)
             {
                 {
                     
                 }
             }];
        }
    }
    else
    {
        [TipView remindAnimationWithTitle:@"输入不可以为空哦~"];
     }
    
}
- (IBAction)agreementButtonClick:(id)sender
{
    
    AgreeMentViewController *agreeVC = [[AgreeMentViewController alloc] init];
    agreeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:agreeVC animated:NO];
}
- (IBAction)selectBtnClick:(id)sender
{
    isSelected = !isSelected;
    if (isSelected)
    {
        [self.agree_button setBackgroundImage:[UIImage imageNamed:@"ture"] forState:UIControlStateNormal];
        self.getIdentityCode_Button.userInteractionEnabled = YES;
        self.getIdentityCode_Button.backgroundColor = [UIColor colorWithHexString:@"#e8103c"];
    }
    else
    {
        self.getIdentityCode_Button.userInteractionEnabled = NO;
        [self.agree_button setBackgroundImage:[UIImage imageNamed:@"noture"] forState:UIControlStateNormal];
        self.getIdentityCode_Button.backgroundColor = [UIColor lightGrayColor];
    }

}

- (IBAction)selectedClick:(id)sender
{
/**按钮太小哦，弃用了**/
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
