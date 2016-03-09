//
//  SearchPasswordViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/10.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "SearchPasswordViewController.h"
#import "Header.h"
#import "PhoneIdentityViewController.h"

@interface SearchPasswordViewController ()

@end

@implementation SearchPasswordViewController

- (void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:animated];
    [self createBackBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB_A(240, 238, 238);
    self.navigationItem.title = @"找回密码";
    self.next_Button.titleLabel.font =[UIFont systemFontOfSize:17];
    
    self.safetyCode_iamgeView.hidden = YES;
    self.next_Button.backgroundColor = [UIColor colorWithHexString:@"#e8103c"];
    self.next_Button.layer.cornerRadius = 8;
    self.next_Button.layer.borderWidth = 1;
    self.next_Button.layer.borderColor = [UIColor colorWithHexString:@"#ee1c3f"].CGColor;
    self.next_Button.clipsToBounds = YES;

    self.autoCodeView = [[ZLLAutoCode alloc] initWithFrame:CGRectMake(ScreenWidth-100, 83, 90, 30)];
    [self.view addSubview:self.autoCodeView];
}

- (IBAction)chaClick:(id)sender
{
  self.number_TextField.text = @"";
}
- (IBAction)nextButtonClick:(id)sender
{
    [self.view endEditing:YES];

    if (![self.number_TextField.text isEqualToString:@""] && ![self.safety_TextField.text isEqualToString:@""])
    {
        
        if ([self.safety_TextField.text isEqualToString:self.autoCodeView.authCodeStr])
        {
            
            //发送验证码
            NSString * urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,registrSendCodeUrl];
            NSLog(@"发送验证码 %@",urlStr);
            
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            [dic setObject:self.number_TextField.text forKey:@"Mobile"];
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
                     
                     PhoneIdentityViewController *phoneIdentityVC = [[PhoneIdentityViewController alloc] init];
                     phoneIdentityVC.hidesBottomBarWhenPushed = YES;
                     phoneIdentityVC.number = self.number_TextField.text;
                     [self.navigationController pushViewController:phoneIdentityVC animated:NO];
                     
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
        else
        {
            //验证不匹配，验证码和输入框抖动
            self.safety_TextField.text = @"";
            CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
            anim.repeatCount = 1;
            anim.values = @[@-20,@20,@-20];
            [self.safety_TextField.layer addAnimation:anim forKey:nil];
            
               [TipView remindAnimationWithTitle:@"验证码错误"];
             
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
