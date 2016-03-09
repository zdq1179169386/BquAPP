//
//  ReSetSafePasswordViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "ReSetSafePasswordViewController.h"
#import "ResetSafeSuccessViewController.h"

@interface ReSetSafePasswordViewController ()

@end

@implementation ReSetSafePasswordViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self createBackBar];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGB_A(240, 238, 238);
    self.navigationItem.title = @"设置安全密码";
    
    [self.commit_Button onlyCornerRadius];
    self.commit_Button.titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:17];
    self.setNewPSw_TextF.secureTextEntry = YES;
}

- (IBAction)commitButtonClick:(id)sender
{
    [self.view endEditing:YES];

    if ([self.setNewPSw_TextF.text isEqualToString:@""])
    {
         [TipView remindAnimationWithTitle:@"输入不可以为空哦"];
    }
    else
    {
        if ([[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,18}$"] evaluateWithObject:self.setNewPSw_TextF.text])
        {
            NSString * urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,searchPasswordUrl];
            NSLog(@"找回密码地址 %@",urlStr);
            
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            
            [dic setObject:@"1" forKey:@"Key"];
            [dic setObject:self.checkCode forKey:@"Code"];
            dic[@"Mobile"] = self.phoneNumber;
            NSString *password = [self.setNewPSw_TextF.text MD5];
            NSString *realPasswprd = password.lowercaseString;
            [dic setValue:realPasswprd forKey:@"PassWord"];
            
            NSString * realSign = [HttpTool returnForSign:dic];
            dic[@"sign"] = realSign;
            
            [HttpTool post:urlStr params:dic success:^(id json)
             {
                 NSLog(@"传入的字典 = %@",dic);
                 NSLog(@"这是找回安全密码数据%@",json);
                 
                 NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
                 if ([resultStr isEqualToString:@"0"])
                 {
                     
                     ResetSafeSuccessViewController *reSetSuccessVC = [[ResetSafeSuccessViewController alloc] init];
                     reSetSuccessVC.hidesBottomBarWhenPushed = YES;
                     [self.navigationController pushViewController:reSetSuccessVC animated:NO];
                     
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
            [TipView remindAnimationWithTitle:@"密码格式不正确哦"];
        }
        

    }
    
    
    
}
- (IBAction)showPswButtonClik:(id)sender
{
    self.setNewPSw_TextF.secureTextEntry = NO;

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
