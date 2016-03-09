//
//  ImportIdentityCodeViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/10.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "ImportIdentityCodeViewController.h"
#import "setPswViewController.h"

@interface ImportIdentityCodeViewController ()

@end

@implementation ImportIdentityCodeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self createBackBar];
   
  }


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGB_A(240, 238, 238);
    
    self.navigationItem.title = @"用户注册";
    self.commitCode_Button.titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:17];
    
    self.againSend_Button.titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:12];
    
    //300秒验证
    self.againSend_Button.hidden = YES;
    _seconds = 60;
    self.time_Label.text = [NSString stringWithFormat:@"%d",_seconds];
    _timer2 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethodRegister) userInfo:nil repeats:YES];
    
    NSString *string = [self.phoneNumber substringToIndex:3];
    NSString *string11 = [self.phoneNumber substringFromIndex:3];
    NSString *string3 = [string11 substringToIndex:4];
    NSString *string4 = [string11 substringFromIndex:4];
        self.number_Label.text = [NSString stringWithFormat:@"%@-%@-%@",string,string3,string4];

   
}
- (IBAction)commitCodeButtonClick:(id)sender
{

    if (![self.identityCode_TextField.text isEqualToString:@""] )
    {
        
        NSString * urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,registrCheckCodeUrl];
        NSLog(@"验证码是否正确地址 = %@",urlStr);
        
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:self.phoneNumber forKey:@"Mobile"];
        [dic setObject:self.identityCode_TextField.text forKey:@"Content"];
        [dic setObject:@"0" forKey:@"Key"];
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
                 
                 setPswViewController *setPswVC = [[setPswViewController alloc] init];
                 setPswVC.hidesBottomBarWhenPushed = YES;
                 setPswVC.phoneNumber = self.phoneNumber;
                 setPswVC.checkCode = self.identityCode_TextField.text;
                 [self.navigationController pushViewController:setPswVC animated:NO];
                 self.identityCode_TextField.text = @"";
             }
             else
             {
                 [TipView remindAnimationWithTitle:@"验证码输入不正确"];
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
-(void)timerFireMethodRegister
{
    if (_seconds == 0)
    {
        _seconds = 60;
        [self releaseTImer];
        [self.againSend_Button setEnabled:YES];
    }
    else
    {
        _seconds--;
        self.againSend_Button.hidden = YES;
        self.time_Label.text = [NSString stringWithFormat:@"%d",_seconds];
        [self.againSend_Button setEnabled:NO];
    }
}


//如果登陆成功或者时间到了，停止验证码的倒数，
- (void)releaseTImer
{
    [_timer2 invalidate];
    _timer2 = nil;

    self.againSend_Button.hidden = NO;
    self.againSend_Button.userInteractionEnabled = YES;
    [self.againSend_Button redStyle];
    self.time_Label.hidden = YES;
    self.tip_Label.hidden = YES;
    [self.againSend_Button setTitle:@"获取验证码" forState: UIControlStateNormal];

}
- (IBAction)sendCodeButtonClick:(id)sender
{
    self.againSend_Button.hidden = YES;
    _seconds = 60;
    self.time_Label.hidden = NO;
    self.tip_Label.hidden = NO;
    self.time_Label.text = [NSString stringWithFormat:@"%d",_seconds];
    _timer2 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethodRegister) userInfo:nil repeats:YES];


    NSString * urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,registrSendCodeUrl];
    NSLog(@"手动发送验证码 %@",urlStr);
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:self.phoneNumber forKey:@"Mobile"];
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
