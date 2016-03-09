//
//  PhoneIdentityViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/10.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "PhoneIdentityViewController.h"
#import "Header.h"
#import "ResetPasswordViewController.h"

@interface PhoneIdentityViewController ()

@end

@implementation PhoneIdentityViewController

- (void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:animated];
    [self createBackBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = RGB_A(240, 238, 238);
    self.navigationItem.title = @"手机短信校验";
    
    [_getIdentityCode_Button redStyle];
     self.Next_Button.titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:17];
    NSString *string = [self.number substringToIndex:3];
    NSString *string1 = [self.number substringFromIndex:7];
    self.number_Label.text = [NSString stringWithFormat:@"%@****%@",string,string1];
    
    //300秒验证
    self.getIdentityCode_Button.hidden = YES;
    _seconds = 60;
    self.time_Lab.text = [NSString stringWithFormat:@"%d",_seconds];
    self.tip_Lab.text = @"秒后重新发送";
    _timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethodLogin2) userInfo:nil repeats:YES];

    self.Next_Button.backgroundColor = [UIColor colorWithHexString:@"#e8103c"];
    self.Next_Button.layer.cornerRadius = 8;
    self.Next_Button.layer.borderWidth = 1;
    self.Next_Button.layer.borderColor = [UIColor colorWithHexString:@"#ee1c3f"].CGColor;
    self.Next_Button.clipsToBounds = YES;
}
- (IBAction)nextButtonClick:(id)sender
{
    [self.view endEditing:YES];

    if (![self.identityCode_TextField.text isEqualToString:@""] )
    {
        NSString * urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,registrCheckCodeUrl];
        NSLog(@"验证码是否正确地址 = %@",urlStr);
        
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:self.number forKey:@"Mobile"];
        [dic setObject:self.identityCode_TextField.text forKey:@"Content"];
        [dic setObject:@"2" forKey:@"Key"];
        NSString * realSign = [HttpTool returnForSign:dic];
        dic[@"sign"] = realSign;
        
        
        [HttpTool post:urlStr params:dic success:^(id json)
         {
             
             NSLog(@"dic %@",dic);
             
             NSLog(@"检验验证码是否正确  %@",json);
             NSLog(@"message %@",json[@"message"]);
             
             NSString *resultCode = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
             if ([resultCode isEqualToString:@"0"])
             {
                 [self releaseTImer];

                 ResetPasswordViewController *resetPswVC = [[ResetPasswordViewController alloc] init];
                 resetPswVC.checkCode = self.identityCode_TextField.text;
                 resetPswVC.number = self.number;
                 resetPswVC.hidesBottomBarWhenPushed = YES;
                 [self.navigationController pushViewController:resetPswVC animated:NO];
                 
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
        [TipView remindAnimationWithTitle:@"输入不可以为空哦~"];
    }


}

//倒计时方法验证码实现倒计时300秒，300秒后按钮变换开始的样子
-(void)timerFireMethodLogin2
{
    if (_seconds == 0)
    {
        _seconds = 60;
        [self releaseTImer];
    }
    else
    {
        _seconds--;
        self.getIdentityCode_Button.hidden = YES;
        self.time_Lab.hidden = NO;
        self.tip_Lab.hidden = NO;
        self.time_Lab.text = [NSString stringWithFormat:@"%d",_seconds];
    }
}

//如果登陆成功或者时间到了，停止验证码的倒数，
- (void)releaseTImer
{
    [_timer1 invalidate];
    _timer1 = nil;
    self.getIdentityCode_Button.hidden = NO;
    self.getIdentityCode_Button.userInteractionEnabled = YES;
    [self.getIdentityCode_Button redStyle];
    self.time_Lab.hidden = YES;
    self.tip_Lab.hidden = YES;
    [self.getIdentityCode_Button setTitle:@"获取验证码" forState: UIControlStateNormal];

}

- (IBAction)sendCheckCodeButtonClick:(id)sender
{
    
    self.getIdentityCode_Button.hidden = YES;
    _seconds = 60;
    self.time_Lab.hidden = NO;
    self.tip_Lab.hidden = NO;
    self.time_Lab.text = [NSString stringWithFormat:@"%d",_seconds];
    _timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethodLogin2) userInfo:nil repeats:YES];

    
    //发送验证码
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,registrSendCodeUrl];
    NSLog(@"发送验证码 %@",urlStr);
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:self.number forKey:@"Mobile"];
    [dic setObject:@"2" forKey:@"Key"];
    NSString * realSign = [HttpTool returnForSign:dic];
    dic[@"sign"] = realSign;
    
    [HttpTool post:urlStr params:dic success:^(id json)
     {
        NSLog(@"传入的字典 = %@",dic);
        NSLog(@"发送注册验证码的数据%@",json);
         
         NSString *resultCode = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
         if ([resultCode isEqualToString:@"0"])
         {
             NSLog(@"message%@",json[@"message"]);
         }
         else
         {
            [TipView remindAnimationWithTitle:json[@"message"]];
         }
         
         
     } failure:^(NSError *error)
     {
         [TipView remindAnimationWithTitle:@"发送信息失败"];
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
