//
//  PayFailViewViewController.m
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "PayFailViewViewController.h"
#import "OrderInfoMudel.h"
#import "OrderSumitTableViewCell.h"
#import "PayMoneyTableViewCell.h"
#import "SubmitOrdersTableViewCell.h"
#import "GoodsInfoNOBtnTabTableViewCell.h"
#import "SelsctPayWayViewController.h"
#import "OrderDetailViewController.h"
#import "GoodsDetailViewController.h"
#import "HomeViewController.h"
#import "ShoppingCarTool.h"

@interface PayFailViewViewController ()<SubmitOrderDelegate,UITableViewDataSource,UITableViewDelegate>
{
    OrderInfoMudel * _orderInfo;
}
@property (nonatomic)UITableView *table;
@end

@implementation PayFailViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_table];
    _orderInfo = [[OrderInfoMudel alloc] init];
    _table.delegate =self;
    _table.dataSource = self;
    [self addBtns];
    [self createBackBar];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self requestData];
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}



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
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)addBtns
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-50, ScreenWidth, 50)];
    view.backgroundColor = [UIColor whiteColor];
    CGFloat  width = ScreenWidth / 100.0;
    
    //添加查看订单按钮
    UIButton * lookOrderBtn = [self buildButton:CGRectMake(width*10, 10, width*30, 30) title:@"查看订单" tag:200];
    [view addSubview:lookOrderBtn];
    
    UIButton * backHomeBtn = [self buildButton:CGRectMake(ScreenWidth-width*40, 10, width*30, 30) title:@"返回首页" tag:201];
    [view addSubview:backHomeBtn];
//    UIButton * lookOrderBtn = [[UIButton alloc] initWithFrame:CGRectMake(width*10, 10, width*30, 30)];
//    [lookOrderBtn setTitle: @"查看订单" forState:UIControlStateNormal];
//    lookOrderBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [lookOrderBtn setTitleColor: [UIColor colorWithHexString:@"E8103C"] forState:UIControlStateNormal];
//    lookOrderBtn.backgroundColor = [UIColor whiteColor];
//    [lookOrderBtn addTarget:self action:@selector(submitOrder:) forControlEvents:UIControlEventTouchDown];
//    lookOrderBtn.tag = 200;
//    lookOrderBtn.layer.cornerRadius = 3;
//    [view addSubview:lookOrderBtn];
//    [lookOrderBtn.layer setBorderWidth:1.0];   //边框宽度
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
//    [lookOrderBtn.layer setBorderColor:colorref];//边框颜色
//    
//    
//    //添加返回首页按钮
//    UIButton * backHomeBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-width*40, 10, width*30, 30)];
//    [backHomeBtn setTitle: @"返回首页" forState:UIControlStateNormal];
//    backHomeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [backHomeBtn setTitleColor: [UIColor colorWithHexString:@"E8103C"] forState:UIControlStateNormal];
//    [backHomeBtn.layer setBorderColor:(__bridge CGColorRef)([UIColor colorWithHexString:@"E8103C"])];
//    backHomeBtn.backgroundColor = [UIColor whiteColor];
//    [backHomeBtn addTarget:self action:@selector(submitOrder:) forControlEvents:UIControlEventTouchDown];
//    backHomeBtn.tag = 201;
//    backHomeBtn.layer.cornerRadius = 3;
//    [backHomeBtn.layer setBorderWidth:1.0];   //边框宽度
//    [backHomeBtn.layer setBorderColor:colorref];//边框颜色
//    [view addSubview:backHomeBtn];
    
    
    [self.view addSubview:view];
    
}

-(UIButton*)buildButton:(CGRect)frame title:(NSString *)title tag:(NSInteger)tag
{
    UIButton * Btn = [[UIButton alloc] initWithFrame:frame];
    [Btn setTitle: title forState:UIControlStateNormal];
    Btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [Btn setTitleColor: [UIColor colorWithHexString:@"E8103C"] forState:UIControlStateNormal];
    [Btn.layer setBorderColor:(__bridge CGColorRef)([UIColor colorWithHexString:@"E8103C"])];
    Btn.backgroundColor = [UIColor whiteColor];
    [Btn addTarget:self action:@selector(submitOrder:) forControlEvents:UIControlEventTouchDown];
    Btn.tag = tag;
    Btn.layer.cornerRadius = 3;
    [Btn.layer setBorderWidth:1.0];   //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
    [Btn.layer setBorderColor:colorref];//边框颜色
    return Btn;
}


//获取订单详情
-(void)requestData
{
    [ShoppingCarTool getOrderDetail:_orderID success:^(id success) {
        
        NSString *resultCode = success[@"resultCode"];
        //请求成功
        if (!resultCode.intValue)
        {
            //先把无网络状态View 去除
            [self removeNewView];
            NSDictionary *dictionary = success[@"data"];
            
            _orderInfo.orderTime = dictionary[@"orderDate"];
            _orderInfo.orderNum = dictionary[@"id"];
            _orderInfo.orderPrice = dictionary[@"orderTotalAmount"];
            _orderInfo.orderStatus = dictionary[@"orderStatus"];
            NSMutableArray * data = [[NSMutableArray alloc] init];
            
            NSArray *array =dictionary[@"itemInfo"];
            if (array)
            {
                NSLog(@"订单失败%@array",array);
                for (NSDictionary * dicPro in  array)
                {
                    GoodsInfomodel *goods = [[GoodsInfomodel alloc] init];
                    goods.Id = dicPro[@"productId"];
                    goods.name = dicPro[@"productName"];
                    goods.imgUrl = dicPro[@"image"];
                    goods.count = dicPro[@"count"];
                    goods.price = dicPro[@"price"];
                    goods.taxRate = dicPro[@"taxrate"];
                    [data addObject:goods];
                }
                _orderInfo.goodsArr = data;
                [self.table reloadData];
            }
        }
        else
        {
            [self addAlertView];
        }

    } failure:^(NSError *error) {
        [self addNetView];
    }];

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
    [self requestData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma  mark -tableView 代理于数据

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            return 82;
        }
        return 40;
    }
    else
    {
        if (indexPath.row == 0 ||indexPath.row == _orderInfo.goodsArr.count+1 )
        {
            return 38;
        }
        if (indexPath.row == _orderInfo.goodsArr.count+2)
        {
            return 47;
        }
        return 80;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 2;
    return 3+_orderInfo.goodsArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * strFail;
    NSString * strPay;
    if(_orderInfo.orderStatus.integerValue == 1)
    {
        strFail = @"订单支付失败，请重新支付";
        strPay =@"(请尽快完成支付)";
    }
    else if (_orderInfo.orderStatus.integerValue == 5)
    {
        strFail = @"订单已取消，无法支付";
        strPay =@"(查看订单，请去详情)";
    }
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            OrderSumitTableViewCell *cell = [[OrderSumitTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            [cell setValue:strFail str:strPay];
            cell.image.image = [UIImage imageNamed:@"fail"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            PayMoneyTableViewCell *cell = [[PayMoneyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
            [cell setValue:_orderInfo.orderPrice];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
            cell.textLabel.text = [NSString stringWithFormat:@"交易号：%@",_orderInfo.orderNum];
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.row ==_orderInfo.goodsArr.count+1)
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell4"];
            cell.textLabel.text = @"温馨提示：如果您已经付款，请稍候前往我的订单查看支付情况";
            cell.textLabel.textAlignment = 0;
            cell.textLabel.font = [UIFont systemFontOfSize:11];
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#999999"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.row ==_orderInfo.goodsArr.count+2 )
        {
            SubmitOrdersTableViewCell *cell = [[SubmitOrdersTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell5"];
            [cell setValue:_orderInfo.orderPrice];
            [cell.subitBtn setTitle:@"重新支付" forState:UIControlStateNormal];
            if (_orderInfo.orderStatus.integerValue == 5) {
                cell.subitBtn.backgroundColor = [UIColor grayColor];
            }
            cell.moneyLab.textColor = [UIColor colorWithHexString:@"#333333"];
            cell.delegate =self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        GoodsInfoNOBtnTabTableViewCell *cell = [[GoodsInfoNOBtnTabTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell6"];
        GoodsInfomodel*goods = _orderInfo.goodsArr[indexPath.row-1];
        [cell setValue:goods];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
}


//按钮响应事件
//也是submitOrder 的代理

-(void)submitOrder:(UIButton *)sender
{
    if (sender.tag == 200)
    {
            OrderDetailViewController *view = [[OrderDetailViewController alloc] init];
            view.OrderID = _orderID;
            view.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:view animated:NO];
    }
    else if (sender.tag == 201)
    {
        
        [self.navigationController.tabBarController setSelectedIndex:0];
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"gotohomeVC" object:self];
    }
    else
    {
        if (_orderInfo.orderStatus.integerValue == 1)
        {
            SelsctPayWayViewController *view= [[SelsctPayWayViewController alloc] init];
            view.orderID = _orderInfo.orderNum;
            view.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:view animated:YES];
        }
        else if(_orderInfo.orderStatus.integerValue == 5)
        {
            UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"" message:@"订单已经取消，无法再次支付" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [view show];
        }
    }
}
@end
