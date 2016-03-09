//
//  ForgetSafePasswordViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "ForgetSafePasswordViewController.h"
#import "ReSetSafePasswordViewController.h"

@interface ForgetSafePasswordViewController ()

@end

@implementation ForgetSafePasswordViewController
- (void)viewWillAppear:(BOOL)animated
{
    [self createBackBar];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGB_A(240, 238, 238);
    self.navigationItem.title = @"手机验证";
    
    [self.getCode_Button redStyle];
    [self.next_Button onlyCornerRadius];
    self.next_Button.titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:17];
    
    //300秒验证
    self.getCode_Button.hidden = YES;
    _seconds = 60;
    self.secondLab.text = [NSString stringWithFormat:@"%d",_seconds];
    _timer3 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod3:) userInfo:nil repeats:YES];

    NSString *string = [self.phoneNumber substringToIndex:3];
    NSString *string1 = [self.phoneNumber substringFromIndex:7];
        self.number_Lab.text = [NSString stringWithFormat:@"%@****%@",string,string1];
  }


//倒计时方法验证码实现倒计时300秒，300秒后按钮变换开始的样子
-(void)timerFireMethod3:(NSTimer *)theTimer
{
    if (_seconds == 0)
    {
        _seconds = 60;
        [self releaseTImer];
    }
    else
    {
        _seconds--;
        self.getCode_Button.hidden = YES;
        self.secondLab.text = [NSString stringWithFormat:@"%d",_seconds];
    }
}


//如果登陆成功或者时间到了，停止验证码的倒数，
- (void)releaseTImer
{
    [_timer3 invalidate];
    _timer3 = nil;
    self.getCode_Button.hidden = NO;
    self.getCode_Button.userInteractionEnabled = YES;
    [self.getCode_Button redStyle];
    self.secondLab.hidden = YES;
    self.secondtip_Lab.hidden = YES;
    [self.getCode_Button setTitle:@"获取验证码" forState: UIControlStateNormal];
    
}

- (IBAction)getCodeButtonClick:(id)sender
{
    self.getCode_Button.hidden = YES;
    _seconds = 60;
    self.secondtip_Lab.hidden = NO;
    self.secondLab.hidden = NO;
    self.secondLab.text = [NSString stringWithFormat:@"%d",_seconds];
    _timer3 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod3:) userInfo:nil repeats:YES];


//    {"Mobile":"18858278109","Key":"0","sign":"A9B27A71EC0FB25C7B919295485FF378"}
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
//         NSLog(@"传入的字典 = %@",dic);
//         NSLog(@"这是发送注册验证码的数据%@",json);
//         NSLog(@"message%@",json[@"message"]);
         
         NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
         if ([resultStr isEqualToString:@"0"])
         {
             NSLog(@"message%@",json[@"message"]);
         }
         else
         {
               [TipView remindAnimationWithTitle:json[@"message"]];
         }

     } failure:^(NSError *error)
     {
           [TipView remindAnimationWithTitle:@"出错哦，数据data为空"];
     }];
    

}
- (IBAction)nextButtonClick:(id)sender
{
    [self.view endEditing:YES];

      NSString * urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,registrCheckCodeUrl];
    NSLog(@"验证码是否正确地址 = %@",urlStr);
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:self.phoneNumber forKey:@"Mobile"];
    [dic setObject:self.identityCode_TextF.text forKey:@"Content"];
    [dic setObject:@"1" forKey:@"Key"];
    NSString * realSign = [HttpTool returnForSign:dic];
    dic[@"sign"] = realSign;

    [HttpTool post:urlStr params:dic success:^(id json)
     {
         NSLog(@"检验验证码是否正确  %@",json);
         NSLog(@"message %@",json[@"message"]);
         
         NSString *resultCode = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
         if ([resultCode isEqualToString:@"0"])
         {
             
             [self releaseTImer];
             
             ReSetSafePasswordViewController *reSetSafeVC = [[ReSetSafePasswordViewController alloc] init];
             reSetSafeVC.hidesBottomBarWhenPushed = YES;
             reSetSafeVC.checkCode = self.identityCode_TextF.text;
             reSetSafeVC.phoneNumber = self.phoneNumber;
             [self.navigationController pushViewController:reSetSafeVC animated:NO];

             self.identityCode_TextF.text = @"";
         }
         else
         {
            [TipView remindAnimationWithTitle:@"验证码输入不正确"];
         }
         
     } failure:^(NSError *error)
     {
         
         
     }];
    
    

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
