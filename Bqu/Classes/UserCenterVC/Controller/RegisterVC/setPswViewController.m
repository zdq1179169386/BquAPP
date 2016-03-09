//
//  setPswViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/10.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "setPswViewController.h"
#import "CompleteRegisterViewController.h"

@interface setPswViewController ()

@end

@implementation setPswViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self createBackBar];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = RGB_A(240, 238, 238);
    
    self.navigationItem.title = @"用户注册";
     self.complete_Button.titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:17];

    self.setPsw_TextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.setPsw_TextField.secureTextEntry = YES;

}
- (IBAction)completeButtonClick:(id)sender
{
    
    
    if (![self.setPsw_TextField.text isEqualToString:@""] )
    {
        if ([[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[^\\s]{6,20}$"] evaluateWithObject:self.setPsw_TextField.text])
        {
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,userRegisterUrl];
            //    NSLog(@"用户注册的数据%@",urlStr);
            
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:self.phoneNumber forKey:@"mobile"];
            
            NSString *password = [self.setPsw_TextField.text MD5];
            NSString *realPasswprd = password.lowercaseString;
            [dic setValue:realPasswprd forKey:@"pass"];
            
            //    [dic setObject:self.setPsw_TextField.text forKey:@"pass"];
            [dic setObject:@"3" forKey:@"platfrom"];
            [dic setObject:self.checkCode forKey:@"code"];
            [dic setObject:@"0" forKey:@"Key"];
            NSString *realSign = [HttpTool returnForSign:dic];
            dic[@"sign"] = realSign;
            
            
            [HttpTool post:urlStr params:dic success:^(id json)
             {
                 NSLog(@"传入的字典%@",dic);
                 NSLog(@"注册数据 = %@",json);
                 NSLog(@"message %@",json[@"message"]);
                 
                 NSString *resultCode = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
                 if ([resultCode isEqualToString:@"0"])
                     
                 {
                     CompleteRegisterViewController *completeVC = [[CompleteRegisterViewController alloc] init];
                     completeVC.number = self.phoneNumber;
                     completeVC.psw = self.setPsw_TextField.text;
                     completeVC.hidesBottomBarWhenPushed = YES;
                     [self.navigationController pushViewController:completeVC animated:NO];
                     
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
           [TipView remindAnimationWithTitle:@"密码格式不正确哦~"];
        }
        
       
    }
    else
    {
        [TipView remindAnimationWithTitle:@"输入不可以为空哦~"];
    }
    
    
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
