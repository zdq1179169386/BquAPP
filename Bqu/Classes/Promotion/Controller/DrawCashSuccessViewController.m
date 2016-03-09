//
//  DrawCashSuccessViewController.m
//  Bqu
//
//  Created by yb on 15/12/11.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "DrawCashSuccessViewController.h"

@interface DrawCashSuccessViewController ()

@property(nonatomic,strong)UILabel * account;

@property(nonatomic,strong)UILabel * AccountNumber;

@property(nonatomic,strong)UILabel * name;

@property(nonatomic,strong)UILabel * price;

@property(nonatomic,strong)UILabel * handle;

@property(nonatomic,strong)UILabel * handleTime;
//
@property(nonatomic,strong)UIImageView * image3;
//
@property(nonatomic,strong)UIImageView * cound2;

@property(nonatomic,strong)UILabel * success;

@property(nonatomic,strong)UILabel * successTime;

@end
@implementation DrawCashSuccessViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initNav];
    [self initView];
    [self requestForData];
}
-(void)initView
{
    UIScrollView * scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:scrollview];
    
    UILabel * account = [[UILabel alloc] initWithFrame:CGRectMake(10, 18, 100, 11)];
    account.textColor = [UIColor colorWithHexString:@"#333333"];
    account.font = [UIFont systemFontOfSize:14];
    account.text = @"支付宝";
    [scrollview addSubview:account];
    self.account = account;
    
    UILabel * line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 46, ScreenWidth, 1)];
    line1.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [scrollview addSubview:line1];
    
    UILabel * AccountNumber = [[UILabel alloc] initWithFrame:CGRectMake(10, 18, 100, 11)];
    AccountNumber.textColor = [UIColor colorWithHexString:@"#999999"];
    AccountNumber.font = [UIFont systemFontOfSize:12];
    [scrollview addSubview:AccountNumber];
    self.AccountNumber = AccountNumber;
    
    UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(10, 18, 100, 11)];
    name.textColor = [UIColor colorWithHexString:@"#999999"];
    name.font = [UIFont systemFontOfSize:12];
    [scrollview addSubview:name];
    self.name = name;
    CGFloat cash_Y = CGRectGetMaxY(line1.frame) + 18;
    
    UILabel * cash = [[UILabel alloc] initWithFrame:CGRectMake(10, cash_Y, 100, 11)];
    cash.font = [UIFont systemFontOfSize:14];
    cash.textColor = [UIColor colorWithHexString:@"#333333"];
    cash.text = @"提现金额";
    [scrollview addSubview:cash];
    [cash sizeToFit];
    
    CGFloat line2_Y = CGRectGetMaxY(cash.frame) + 66;

    UILabel * line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, line2_Y, ScreenWidth, 1)];
    line2.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [scrollview addSubview:line2];
    
    UILabel * price = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 100, CGRectGetMaxY(line1.frame) + 40, 100, 50)];
    price.font = [UIFont systemFontOfSize:25];
    price.textColor = [UIColor colorWithHexString:@"#333333"];
    price.text = @"提现金额";
    [scrollview addSubview:price];
    self.price = price;
    
    CGFloat thirdY = CGRectGetMaxY(line2.frame) + 22;
  
    UIImageView * image1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    image1.image = [UIImage imageNamed:@"进度圈"];
    [scrollview addSubview:image1];
    image1.center = CGPointMake(ScreenWidth/2.0, thirdY);
    
    UILabel * handle = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2.0 + 20, thirdY -5, 100, 20)];
    handle.text = @"处理中";
    handle.font = [UIFont systemFontOfSize:15];
    handle.textColor = [UIColor colorWithHexString:@"#f62648"];
    [scrollview addSubview:handle];
    self.handle = handle;
    
    UILabel * handleTime = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2.0 - 20-100, thirdY-5, 100, 40)];
    handleTime.numberOfLines = 0;
//    handleTime.backgroundColor = [UIColor redColor];
    handleTime.textAlignment = NSTextAlignmentRight;
    handleTime.font = [UIFont systemFontOfSize:14];
    handleTime.textColor = [UIColor colorWithHexString:@"#777777"];
    [scrollview addSubview:handleTime];
    self.handleTime = handleTime;
    
    UIImageView * image2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1, 48)];
    image2.image = [UIImage imageNamed:@"进度条 红"];
    [scrollview addSubview:image2];
    image2.center = CGPointMake(ScreenWidth/2.0, thirdY + 28);
    
    CGFloat image3_Y = CGRectGetMaxY(image2.frame);
    UIImageView * image3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1, 48)];
    image3.image = [UIImage imageNamed:@"进度条 灰"];
    [scrollview addSubview:image3];
    self.image3 = image3;
    image3.center = CGPointMake(ScreenWidth/2.0, image3_Y + 24);
    
     CGFloat cound2_Y = CGRectGetMaxY(image3.frame);
    UIImageView * cound2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    cound2.image = [UIImage imageNamed:@"进度圈 灰"];
    [scrollview addSubview:cound2];
    self.cound2 = cound2;
    cound2.center = CGPointMake(ScreenWidth/2.0, cound2_Y + 4);
    
    CGFloat success_Y = CGRectGetMaxY(cound2.frame);
    UILabel * success = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2.0+20, success_Y-20, 100, 20)];
    success.text = @"提现成功";
    success.font = [UIFont systemFontOfSize:15];
    success.textColor = [UIColor colorWithHexString:@"#333333"];
    [scrollview addSubview:success];
    self.success = success;
    
    UILabel * successTime = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2.0 - 20-100, success_Y-20, 100, 20)];
    successTime.hidden = YES;
    successTime.font = [UIFont systemFontOfSize:15];
    successTime.textAlignment = NSTextAlignmentRight;
    successTime.textColor = [UIColor colorWithHexString:@"#777777"];
    [scrollview addSubview:successTime];
    self.successTime = successTime;

}
-(void)initNav
{
    self.navigationItem.title = @"提现详情";
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}
- (void)back:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)requestForData
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",TEST_URL,WithdrawalSuccess];
    NSString * memberID = [UserManager getMyObjectForKey:userIDKey];
    NSString * token = [UserManager getMyObjectForKey:accessTokenKey];
    NSLog(@"accountID=%@",self.RecordID);
    if (memberID && token) {
        //创建，安字段创建
        NSDictionary * dict = @{@"MemberID":memberID,@"token":token,@"AccountID": self.accountID,@"RecordID":self.RecordID};
        NSMutableDictionary * mutableDic = [HttpTool getDicToRequest:dict];
        
        [HttpTool post:urlStr params:mutableDic success:^(id json) {
            NSString * resultCode = json[@"resultCode"];
            NSLog(@"--%@,%@",json[@"message"],json[@"data"]);
            if (resultCode.intValue == 0) {
                NSDictionary * dict = json[@"data"];
                [self restView:dict];
            }else
            {
                UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器出错" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [view show];
            }
            [ProgressHud hideProgressHudWithView:self.view]      ;
  for (UIView * view in self.view.subviews) {
                if (view == self.netView) {
                    [self.netView removeFromSuperview];
                    break;
                }
            }
            
        } failure:^(NSError *error) {
            [ProgressHud hideProgressHudWithView:self.view];
            if (error.code == NetWorkingErrorCode) {
                [self.view addSubview:self.netView];
            }
        }];
        
    }

}

-(void)restView:(NSDictionary *)dict
{
    NSString * AccountType = dict[@"AccountType"];
    NSString * UserName = dict[@"UserName"];
    self.name.text = UserName;
    [self.name sizeToFit];
    self.handleTime.text = dict[@"Date"];
    self.price.text = [NSString stringWithFormat:@"-%@",self.money];
    if (AccountType.intValue==1) {
        //支付宝
        self.account.text = @"支付宝";
        self.AccountNumber.text = dict[@"AccountNumber"];
        CGSize size = [self.AccountNumber.text sizeWithFont:[UIFont systemFontOfSize:13]];
        self.AccountNumber.frame = CGRectMake(ScreenWidth-10-size.width, 18, size.width, 11);
        
        CGFloat miniX = CGRectGetMinX(self.AccountNumber.frame);
        self.name.frame = CGRectMake(miniX-8-self.name.frame.size.width, 18, self.name.frame.size.width, 11);
        [self.account sizeToFit];
        [self.AccountNumber sizeToFit];
        
    }else
    {
        self.account.text = @"银行卡";
        self.AccountNumber.text = dict[@"BankCardNumber"];
        CGSize size = [self.AccountNumber.text sizeWithFont:[UIFont systemFontOfSize:13]];
        self.AccountNumber.frame = CGRectMake(ScreenWidth-10-size.width, 18, size.width, 11);
        CGFloat miniX = CGRectGetMinX(self.AccountNumber.frame);
        self.name.frame = CGRectMake(miniX-8-self.name.frame.size.width, 18, self.name.frame.size.width, 11);
        [self.account sizeToFit];
        [self.AccountNumber sizeToFit];
    }
    NSString * status = dict[@"Status"];
    if (status.intValue == 0) {
        //待审核
        
    }else
    {
        //付款成功
        self.image3.image = [UIImage imageNamed:@"进度条 红"];
        self.cound2.image = [UIImage imageNamed:@"进度圈 红"];
        self.success.textColor = [UIColor colorWithHexString:@"#f62648"];
        self.successTime.hidden = NO;
        self.successTime.text = dict[@"Date"];
    }
    
}
@end
