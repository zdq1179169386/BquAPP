//
//  CompleteRegisterViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/10.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "CompleteRegisterViewController.h"
#import "LoginViewController.h"

@interface CompleteRegisterViewController ()

@end

@implementation CompleteRegisterViewController
- (void)viewWillAppear:(BOOL)animated
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 21);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"用户注册";
    self.view.backgroundColor = RGB_A(240, 238, 238);
    
    
    self.complete_Button.titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:17];
    self.tip_Label.font =[UIFont fontWithName:@"Helvetica-Bold" size:17];
    self.number_Label.text = self.number;
}
- (IBAction)backLogin_Button:(id)sender
{
//    NSArray *ctrlArray = self.navigationController.viewControllers;
//    [self.navigationController popToViewController:[ctrlArray objectAtIndex:0] animated:YES];
//    
    
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,userLoginUrl];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    [dic setValue:@" " forKey:@"checkCode"];
    [dic setValue:@"1" forKey:@"autoLogin"];
    NSString *password = [self.psw MD5];
    NSString *realPasswprd = password.lowercaseString;
    [dic setValue:realPasswprd forKey:@"Password"];
    [dic setValue:self.number forKey:@"UserName"];
    NSString *realSign =  [HttpTool returnForSign:dic];
    [dic setValue:realSign forKey:@"sign"];
    
      [HttpTool post:urlStr params:dic success:^(id json)
      {
           if ((NSNull *)json[@"data"] != [NSNull null])
           {

            NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
            if ([resultStr isEqualToString:@"0"])
            {
                     
                [UserManager saveToken:json[@"data"][@"Token"]];
                [UserManager saveUserID:json[@"data"][@"MemberID"]];
                [UserManager saveUserName:json[@"data"][@"MemberName"]];
                [UserManager saveIsPromoter:json[@"dta"][@"IsReferrer"]];
                
                [self.navigationController popToRootViewControllerAnimated:NO];
                self.tabBarController.selectedIndex = 0;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"gotohomeVC" object:self];
            }
   
     }
         
     } failure:^(NSError *error)
     {
         self.tabBarController.selectedIndex = 0;
         [[NSNotificationCenter defaultCenter] postNotificationName:@"gotohomeVC" object:self];
     }];

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
