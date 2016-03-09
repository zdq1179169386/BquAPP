//
//  SelsctPayWayViewController.m
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "SelsctPayWayViewController.h"
#import "OrderSumitTableViewCell.h"
#import "PayMoneyTableViewCell.h"
#import "PayWayTableViewCell.h"
#import "PaySuccessViewController.h"
#import "PayFailViewViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "payAli.h"
#import "OrderProductMudel.h"
#import "MyOrderViewController.h"

@interface SelsctPayWayViewController ()<UITableViewDelegate,UITableViewDataSource,PayResultDelegate,UIAlertViewDelegate>
{
    BOOL  _aliWay;
    //BOOL  _unionWay;
    OrderProductMudel *_orderDetail;
    NSTimer * timer;
    NSInteger isback;
}
@property (nonatomic)UITableView *table;
@property (nonatomic)UIButton *yesPayBtn;
@end

@implementation SelsctPayWayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"选择支付方式";
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    _table.delegate =self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    _aliWay = 0;
    //_unionWay = 0;
    [self addButn];
    [self loadOrderDetails];
    [self createBackBar];
    isback = 0;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(cellTimerRun) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

//-(void)viewWillAppear:(BOOL)animated
//{
//     [self.navigationController setNavigationBarHidden:YES];
//}
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [self.navigationController setNavigationBarHidden:NO];
//}



- (void)createBackBar
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(backBarClicked) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 30, 21);
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}


- (void)backBarClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if (isback) {
//        [self.navigationController popToRootViewControllerAnimated:NO];
//    }
}
-(void)loadOrderDetails
{
    NSString * urlStr =[NSString stringWithFormat:@"%@%@",TEST_URL,@"/API/Order/GetOrderDetail"];
    NSString * memberID = [UserManager getMyObjectForKey:userIDKey];
    NSString * token = [UserManager getMyObjectForKey:accessTokenKey];
    
    if (memberID && token && _orderID)
    {
        NSMutableDictionary * signDict = [NSMutableDictionary dictionary];
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        
        NSString * sign = nil;
        [signDict setObject:memberID forKey:@"MemberID"];
        [signDict setObject:token forKey:@"token"];
        [signDict setObject:_orderID forKey:@"OrderId"];
        
        
        sign  = [HttpTool returnForSign:signDict];
        dict[@"MemberID"] = memberID;
        dict[@"token"] = token;
        dict[@"sign"] = sign;
        dict[@"OrderId"] = _orderID;
        
        
        [HttpTool post:urlStr params:dict success:^(id json) {
            
            NSString *resultCode = json[@"resultCode"];
            //请求成功
            if (!resultCode.intValue)
            {
                //先把无网络状态View 去除
                [self removeNewView];
                NSDictionary *dictionary = json[@"data"];
                if (dictionary )
                {
                    _orderDetail =[OrderProductMudel productMudelWithDic:dictionary];
                }
                [self.table reloadData];
            }
            else
            {
                [self addAlertView];
            }
            
        } failure:^(NSError *error) {
            [self addNetView];
        }];
    }
}


//添加netView
-(void)addNetView
{
    [self.view addSubview:self.netView];
    self.netView.delegate = self;
}

-(void)removeNewView
{
    for (UIView * view  in self.view.subviews)
    {
        if (view == self.netView)
        {
            [self.netView removeFromSuperview];
            break;
        }
    }
}

-(void)addAlertView
{
    UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器请求数据失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [view show];
}

-(void)NetWorkViewDelegate:(NetWorkView *)view withBtn:(UIButton *)btn
{
    [self loadOrderDetails];
}


-(void)addButn
{
    _yesPayBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, ScreenHeight-52-65, ScreenWidth-20, 48)];
    [_yesPayBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [_yesPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _yesPayBtn.backgroundColor = [UIColor redColor];
    _yesPayBtn.layer.cornerRadius = 6;
    [_yesPayBtn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_yesPayBtn];
}

-(void)cellTimerRun
{
    NSInteger overSecondTime =_orderDetail.OverSecondTime.integerValue;
    overSecondTime --;
    _orderDetail.OverSecondTime = [NSString stringWithFormat:@"%ld",(long)overSecondTime];
    if (overSecondTime <=0) {
        [timer invalidate];
        timer = nil;
    }else
    {
        int minute = (int)(overSecondTime)/60;
        int second =(int)(overSecondTime - minute*60);
        //NSLog(@"cellTimerRun =_%d,_%d,_%d,_%d",day,hour,minute,second);
        NSString *strTime = [NSString stringWithFormat:@"距支付结束还有%d分%d秒",minute,second];
        dispatch_async(dispatch_get_main_queue(), ^{
             NSIndexPath * index = [NSIndexPath indexPathForItem:0 inSection:0];
            OrderSumitTableViewCell * cell = (OrderSumitTableViewCell *)[self.table cellForRowAtIndexPath:index];
            //设置界面的按钮显示 根据自己需求设置
           cell.sumitLab.text = [NSString stringWithFormat:@"%@",strTime];
            
        });
    }

}

//支付
-(void)pay
{
    //先判断是否已经支付过了
    
    NSString * urlStr =[NSString stringWithFormat:@"%@%@",TEST_URL,@"/API/Order/GetOrderStatus"];
    NSString * memberID = [UserManager getMyObjectForKey:userIDKey];
    NSString * token = [UserManager getMyObjectForKey:accessTokenKey];
    NSString *Type = @"2";
    NSString *OrderId = _orderDetail.orderID;
    
    if (memberID && token )
    {
        NSMutableDictionary * signDict = [NSMutableDictionary dictionary];
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        
        NSString * sign = nil;
        [signDict setObject:memberID forKey:@"MemberID"];
        [signDict setObject:token forKey:@"token"];
        [signDict setObject:Type forKey:@"Type"];
        [signDict setObject:OrderId forKey:@"OrderId"];
        
        
        
        sign  = [HttpTool returnForSign:signDict];
        dict[@"MemberID"] = memberID;
        dict[@"token"] = token;
        dict[@"sign"] = sign;
        dict[@"Type"] = Type;
        dict[@"OrderId"] =OrderId;
        
        
        //NSLog(@"是否支付过发功%@",dict);
        
        [HttpTool post:urlStr params:dict success:^(id json) {
            [self removeNewView];
            NSString* resultCode = json[@"resultCode"];
                   if (resultCode.boolValue == 0)//未支付 ，可以去支付
            {
                if ( _aliWay == 0)
                {
    
                    UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"提示！" message:@"请选择一种支付方式" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [view show];
                }
                
                if(_aliWay == 1)
                {
                    
                    payAli * pay = [[payAli alloc] init];
                    pay.delegate = self;
                    [pay topay: _orderDetail];
                }

            }
            else// 非0 订单已经支付，获取取消了
            {
                //已经付过款 之后跳转到 根视图
                UIAlertView * view = [[UIAlertView alloc] initWithTitle:nil message:json[@"errors"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [view show];

            }
            
            
        } failure:^(NSError *error) {
            [self addNetView];
            
        }];
    }
}



//已经付过款 之后跳转到 根视图
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    [self.navigationController popToRootViewControllerAnimated:NO];
//    isback = 1;
//    MyOrderViewController * orderView = [[MyOrderViewController alloc] init];
//    
//    [self.navigationController pushViewController:orderView animated:YES];
    
}



-(void)payResult:(BOOL)result
{
    //在调用支付宝的时候，无法唤醒网页版，增加了这段代码 ，在支付的payAli 里面也写了这段代码
    NSArray *array = [[UIApplication sharedApplication] windows];
    UIWindow* win=[array objectAtIndex:0];
    [win setHidden:YES];
    
    
    if (result)
    {
        PaySuccessViewController *paySuccess = [[PaySuccessViewController alloc] init];
        paySuccess.orderID = _orderID;
        [self.navigationController pushViewController:paySuccess animated:YES];
    }
    else
    {
        PayFailViewViewController *payFail = [[PayFailViewViewController alloc] init];
        payFail.orderID = _orderID;
        [self.navigationController pushViewController:payFail animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

//tablepView 代理实现
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        if (indexPath.row == 1)
        {
            _aliWay =!_aliWay; //获得选的的支付方式
            //_unionWay = 0;
            [self.table reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:NO ];
        }
        else if(indexPath.row == 2)
        {
            //_unionWay =!_unionWay; //获得选的的支付方式
            _aliWay = 0;
            [self.table reloadData ];
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    else return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            return 80;
        }
        return 40;
    }
    else
    {
        if (indexPath.row == 0)
        {
            return 35;
        }
        else return 55;
    }
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            OrderSumitTableViewCell * cell = [[OrderSumitTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderSumitCell"];
            [cell setValue:@"订单已提交" str:@" "];
            cell.image.image = [UIImage imageNamed:@"payment_mode"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            PayMoneyTableViewCell *cell = [[PayMoneyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PayMoneyCell"];
            [cell setValue:_orderDetail.amount];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
            view.backgroundColor = [UIColor whiteColor];
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 11, ScreenWidth/2, 12)];
            lable.text = @"选择支付方式";
            lable.font = [UIFont systemFontOfSize:11];
            lable.textColor= [UIColor colorWithHexString:@"#333333"];
            [view addSubview:lable];
            
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            [cell addSubview:view];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            PayWayTableViewCell *cell = [[PayWayTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PayMoneyCell"];
            if (indexPath.row == 1)
            {
                cell.imageView.image = [UIImage imageNamed:@"payment.png"];
                cell.textLabel.text = @"支付宝支付";
                cell.detailTextLabel.text = @"推荐有支付宝账户账户使用";
                [cell setValue2:_aliWay];
            }
            //        else{
            //            cell.imageView.image = [UIImage imageNamed:@"unionpay.png"];
            //            cell.textLabel.text = @"银联支付";
            //            cell.detailTextLabel.text = @"方便快捷，开通网银的银行卡使用";
            //            [cell setValue2:_unionWay];
            //        }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font =[UIFont systemFontOfSize:11];
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            cell.detailTextLabel.font =[UIFont systemFontOfSize:10];
            cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#999999"];
            return cell;
        }
    }
}

@end
