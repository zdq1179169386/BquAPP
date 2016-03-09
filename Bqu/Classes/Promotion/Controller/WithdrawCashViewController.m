//
//  WithdrawCashViewController.m
//  Bqu
//
//  Created by wyy on 15/12/9.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "WithdrawCashViewController.h"
#import "ApplyForRefundAlertView.h"
#import "PromotionAccountModel.h"
#import "DrawCashAlertView.h"
#import "DrawCashSuccessViewController.h"
@interface WithdrawCashViewController ()
{
    PromotionAccountModel * _model;
}
@property (weak, nonatomic) IBOutlet UILabel *myPropertyLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectAccountButton;
@property (weak, nonatomic) IBOutlet UIButton *selectMoneyButton;
@property (weak, nonatomic) IBOutlet UITextField *securityPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
/**账户*/
@property (nonatomic,strong)NSArray * accountArray;

@end

@implementation WithdrawCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self reuqestForAccount];
    self.securityPasswordTextField.secureTextEntry = YES;
    self.selectAccountButton.titleLabel.numberOfLines = 2;
    self.myPropertyLabel.text = [NSString stringWithFormat:@"%.2f元",self.usableMoney.floatValue];
    self.navigationItem.title = @"提现";
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (IOS7_OR_LATER)
    {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    self.commitButton.layer.masksToBounds = YES;
    self.commitButton.layer.cornerRadius = 2.0;
    [self.selectAccountButton setTitle:@"" forState:UIControlStateNormal];
    self.selectAccountButton.titleLabel.text = @"";
    [self.selectMoneyButton setTitle:@"" forState:UIControlStateNormal];
    [self initLeftBarButton];
}
#pragma mark -- 获取提现账户
-(void)reuqestForAccount
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",TEST_URL,GetAccountBanks];
    NSString * memberID = [UserManager getMyObjectForKey:userIDKey];
    NSString * token = [UserManager getMyObjectForKey:accessTokenKey];
    if (self.accountID && memberID && token) {
        //创建，安字段创建
        NSDictionary * dict = @{@"MemberID":memberID,@"token":token,@"AccountID":self.accountID};
        NSMutableDictionary * mutableDic = [HttpTool getDicToRequest:dict];
        self.accountArray = [[NSArray alloc] init];
        [HttpTool post:urlStr params:mutableDic success:^(id json) {
            NSString * resultCode = json[@"resultCode"];
            NSLog(@"%@",json[@"data"]);

            if (resultCode.intValue == 0) {
                NSArray * array = [PromotionAccountModel objectArrayWithKeyValuesArray:json[@"data"]];
//                NSLog(@"data=%@",array);
                self.accountArray = array;
                
            }else
            {
                UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器数据出错" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [view show];
            }
            [ProgressHud hideProgressHudWithView:self.view];
            
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
- (void)initLeftBarButton
{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 选择账户
- (IBAction)selectAccountBtnClicked:(id)sender
{
    if (self.accountArray.count>0) {
        UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        DrawCashAlertView * alert = [[DrawCashAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) withDelegate:self withTitle:@"提现账户" withArray: self.accountArray withIndexPath:indexPath];
        [window addSubview:alert];
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有提现账户,请去添加" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
   
}

- (IBAction)selectMoneyBtnClicked:(id)sender
{
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    NSArray * array = [[NSArray alloc] initWithObjects:@"10元", @"20元",@"50元",@"100元",nil];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    ApplyForRefundAlertView * alert = [[ApplyForRefundAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) withDelegate:self withTitle:@"提现金额" withArray:array withIndexPath:indexPath];
    [window addSubview:alert];
}
#pragma mark -- 提现
- (IBAction)commitBtnClicked:(id)sender
{
   
    if (self.selectAccountButton.titleLabel.text.length>0 && self.selectMoneyButton.titleLabel.text.length>0 && self.securityPasswordTextField.text.length>0) {
        
        [self GetWithdrawalFunc];
        
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请完善信息" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
-(void)GetWithdrawalFunc
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",TEST_URL,GetWithdrawal];
    NSString * memberID = [UserManager getMyObjectForKey:userIDKey];
    NSString * token = [UserManager getMyObjectForKey:accessTokenKey];
    NSLog(@"%@",_model.BankId);
    if (memberID && token) {
        //创建，安字段创建
        NSString * securityPassword = [self.securityPasswordTextField.text MD5];
        NSMutableString *price = [NSMutableString stringWithString:self.selectMoneyButton.titleLabel.text];
        [price deleteCharactersInRange:NSMakeRange(price.length - 1, 1)];
        NSDictionary * dict = @{@"MemberID":memberID,@"token":token,@"BankID":_model.BankId,@"Price":price,@"PassWord":securityPassword};
        NSMutableDictionary * mutableDic = [HttpTool getDicToRequest:dict];
        
        [HttpTool post:urlStr params:mutableDic success:^(id json) {
            NSString * resultCode = json[@"resultCode"];
            NSString * message = json[@"message"];
            NSLog(@"%@",json[@"message"]);
            if (resultCode.intValue == 0) {
                NSDictionary * dic = json[@"data"];
                //跳到提现成功页面
                DrawCashSuccessViewController * vc = [[DrawCashSuccessViewController alloc] init];
                vc.accountID = self.accountID;
                vc.money = self.selectMoneyButton.titleLabel.text;
                vc.RecordID = dic[@"RecordID"];
                [self.navigationController pushViewController:vc animated:YES];
             
            }else
            {
                UIAlertView * view = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [view show];
            }
            [ProgressHud hideProgressHudWithView:self.view];
            for (UIView * view in self.view.subviews) {
                if (view == self.netView) {
                    [self.netView removeFromSuperview];
                    break;
                }
            }
            
        } failure:^(NSError *error) {
            [ProgressHud hideProgressHudWithView:self.view];
//            if (error.code == NetWorkingErrorCode) {
//                [self.view addSubview:self.netView];
//            }
        }];
        
    }


}
-(void)ApplyForRefundAlertViewBtnClick:(ApplyForRefundAlertView*)view withStr:(NSString *)title withIndexPath:(NSIndexPath*)index withRow:(int)row
{
    if (index.section == 0 && index.row == 2) {
        
        [self.selectMoneyButton setTitle:title forState:UIControlStateNormal];
    }
}
-(void)DrawCashAlertViewDelegateBtnClick:(DrawCashAlertView*)view withStr:(NSString *)title withIndexPath:(NSIndexPath*)index withRow:(int)row
{
    NSLog(@"%@",title);
    if (index.section == 0 && index.row == 1) {
        _model = self.accountArray[row];
        [self.selectAccountButton setTitle:title forState:UIControlStateNormal];
    }
}
@end
