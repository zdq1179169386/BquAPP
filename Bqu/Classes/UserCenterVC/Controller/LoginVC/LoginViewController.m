//
//  LoginViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/10.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "SearchPasswordViewController.h"


@interface LoginViewController ()

@end

@implementation LoginViewController


- (void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:animated];
    [self createBackBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGB_A(240, 238, 238);
    self.navigationItem.title = @"登录";
    
    [self setRegestButton];
    self.login_Button.titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:17];
    
    /**设置皮肤外观 初始化变量**/
    [self setAppearance];
}

- (void)setAppearance
{
    self.account_View.userInteractionEnabled = YES;
    self.passwordTextField.secureTextEntry = YES;
    self.account_TextField.tag = 123;
    self.account_TextField.delegate = self;
    self.safeCheck_View.hidden = YES;
    self.checkCode = @" ";
    self.errorCount = 0;

    self.login_Button.backgroundColor = [UIColor colorWithHexString:@"#e8103c"];
    self.login_Button.layer.cornerRadius = 8;
    self.login_Button.layer.borderWidth = 1;
    self.login_Button.layer.borderColor = [UIColor colorWithHexString:@"#ee1c3f"].CGColor;
    self.login_Button.clipsToBounds = YES;
    [self.forgetPsw_Button setTitleColor:[UIColor colorWithHexString:@"#555555"] forState:UIControlStateNormal];
}

- (void)setRegestButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(registerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"注册" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 30, 21);
   
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)registerButtonClicked
{
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    registerVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:registerVC animated:NO];
}
- (IBAction)chaButtonClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button.tag == 1221)
    {
        self.account_TextField.text = @"";
    }
    else if (button.tag == 1222)
    {
        self.passwordTextField.text = @"";
    }
}

- (IBAction)loginButtonClick:(id)sender
{
    [self.view endEditing:YES];
    
    if ([self.account_TextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""])
    {
       [TipView remindAnimationWithTitle:@"输入不可以为空哦~"];
    }
    else
    {
        if (self.errorCount < 4 )
        {
            [self requestData];
        }
        else
        {
            if ([self.safeCheck_TextF.text isEqualToString:@""])
            {
                [TipView remindAnimationWithTitle:@"输入不可以为空哦~"];
            }
            else
            {
                self.checkCode = self.safeCheck_TextF.text;
                [self requestData];
            }
        }

    }
  
}

- (IBAction)checkCodeButtonClick:(id)sender
{
    self.safeCheck_TextF.text = @"";
    [self requestData];
    
}
- (void)requestData
{
    
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,userLoginUrl];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    [dic setValue:self.checkCode forKey:@"checkCode"];
    [dic setValue:@"1" forKey:@"autoLogin"];
    NSString *password = [self.passwordTextField.text MD5];
    NSString *realPasswprd = password.lowercaseString;
    [dic setValue:realPasswprd forKey:@"Password"];
    [dic setValue:self.account_TextField.text forKey:@"UserName"];
    NSString *realSign =  [HttpTool returnForSign:dic];
    [dic setValue:realSign forKey:@"sign"];
    [self showLoadingView];
    [HttpTool post:urlStr params:dic success:^(id json)
     {
          NSLog(@"登录数据%@",json);
         [self hideLoadingView];
         if (![json[@"data"] isKindOfClass:[NSNull class]])
         {
             /**输入错误次数**/
             int ErrorTimes = [json[@"data"][@"ErrorTimes"] intValue];
             self.errorCount = ErrorTimes;
             self.checkCode_Lab.text = [NSString stringWithFormat:@"%@",json[@"data"][@"CheckCode"]];
             if (self.errorCount < 3)
             {
                 self.checkCode = [NSString stringWithFormat:@"%@",json[@"data"][@"CheckCode"]];
             }
             NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
             if ([resultStr isEqualToString:@"0"])
             {
                 NSLog(@"登陆成功后 = %@",json);
                 [self.navigationController popViewControllerAnimated:NO];
                 [UserManager saveToken:json[@"data"][@"Token"]];
                 [UserManager saveUserID:json[@"data"][@"MemberID"]];
                 [UserManager saveUserName:json[@"data"][@"MemberName"]];
                 [UserManager saveIsPromoter:json[@"data"][@"IsReferrer"]];
                 
                 [self.navigationController popToRootViewControllerAnimated:NO];
             }
             else
             {
                 if (self.errorCount >3)
                 {
                     self.login_Button.center = CGPointMake(ScreenWidth/2, 194 +22);
                     self.forgetPsw_Button.center = CGPointMake(ScreenWidth- 50, 194+44+20 );
                     self.safeCheck_View.hidden = NO;
                     self.checkCode_Lab.layer.borderColor = [UIColor lightGrayColor].CGColor;
                     self.checkCode_Lab.layer.borderWidth = 1;
                     self.checkCode_Lab.layer.cornerRadius = 4;
                     
                     self.safeCheck_TextF.text = @"";
                }
                 if (self.errorCount == 4)
                 {
                   [TipView remindAnimationWithTitle:@"30分钟内输入密码错误三次需要输入验证码"];
                     
                 }
                 else
                 {
                      [TipView remindAnimationWithTitle:json[@"message"]];
                 }
             }
         }
         
     } failure:^(NSError *error)
     {
         NSLog(@"%@",error.domain);
         [self hideLoadingView];
     }];
    
}
- (IBAction)forgetButtonClick:(id)sender
{
    SearchPasswordViewController *seachPswVC = [[SearchPasswordViewController alloc] init];
    seachPswVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:seachPswVC animated:NO];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 123)
    {
        if (range.location >= 11)
            return NO; // return NO to not change text
    }
    return YES;

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
