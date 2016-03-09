//
//  PaySuccessViewController.m
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "PayMoneyTableViewCell.h"
#import "OrderSumitTableViewCell.h"
#import "OrderDetailViewController.h"
#import "ShoppingCarTool.h"

@interface PaySuccessViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic)UIButton * lookOrder;

@property (nonatomic)UIButton * backHome;

@property(nonatomic)UITableView *table;

@property(nonatomic)PaySuccessMessage * payState;

@end

@implementation PaySuccessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    _table.delegate =self;
    _table.dataSource = self;
    _payState = [[PaySuccessMessage alloc] init];
    [self.view addSubview:_table];
    [self addBtns];
    [self loadOrderDetail];
    [self createBackBar];
    self.automaticallyAdjustsScrollViewInsets = NO;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
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


-(void)loadOrderDetail
{
    [ShoppingCarTool getOrderDetail:_orderID success:^(id success) {
        NSString *resultCode = success[@"resultCode"];
        //请求成功
        if (!resultCode.intValue)
        {
            //先把无网络状态View 去除
            [self removeNewView];
            NSDictionary *dictionary = success[@"data"];
            if (dictionary)
            {
                _payState = [PaySuccessMessage PaySuccessMessageWithDicFromPaySuccess:dictionary];
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
    [self loadOrderDetail];
}


-(void)addBtns
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-50, ScreenWidth, 50)];
    view.backgroundColor = [UIColor whiteColor];
    CGFloat  width = ScreenWidth / 100.0;
    
    //添加查看订单按钮
    UIButton *lookOrderBtn = [self buildButton:CGRectMake(width*10, 10, width*30, 30) title:@"查看订单" tag:100];
    [view addSubview:lookOrderBtn];
    
    UIButton *backHomeBtn =[self buildButton:CGRectMake(ScreenWidth-width*40, 10, width*30, 30) title:@"返回首页"tag:101];
    [view addSubview:backHomeBtn];
    
    [self.view addSubview:view];
//    UIButton * lookOrderBtn = [[UIButton alloc] initWithFrame:CGRectMake(width*10, 10, width*30, 30)];
//    [lookOrderBtn setTitle: @"查看订单" forState:UIControlStateNormal];
//    lookOrderBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [lookOrderBtn setTitleColor: [UIColor colorWithHexString:@"E8103C"] forState:UIControlStateNormal];
//    lookOrderBtn.backgroundColor = [UIColor whiteColor];
//    [lookOrderBtn addTarget:self action:@selector(touch2:) forControlEvents:UIControlEventTouchDown];
//    lookOrderBtn.tag = 100;
//    lookOrderBtn.layer.cornerRadius = 3;
//    [lookOrderBtn.layer setBorderWidth:1.0];   //边框宽度
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
//    [lookOrderBtn.layer setBorderColor:colorref];//边框颜色
//    [view addSubview:lookOrderBtn];
//    
//    //添加返回首页按钮
//    UIButton * backHomeBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-width*40, 10, width*30, 30)];
//    [backHomeBtn setTitle: @"返回首页" forState:UIControlStateNormal];
//    backHomeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [backHomeBtn setTitleColor: [UIColor colorWithHexString:@"E8103C"] forState:UIControlStateNormal];
//    [backHomeBtn.layer setBorderColor:(__bridge CGColorRef)([UIColor colorWithHexString:@"E8103C"])];
//    backHomeBtn.backgroundColor = [UIColor whiteColor];
//    [backHomeBtn addTarget:self action:@selector(touch2:) forControlEvents:UIControlEventTouchDown];
//    backHomeBtn.tag = 101;
//    backHomeBtn.layer.cornerRadius = 3;
//    [backHomeBtn.layer setBorderWidth:1.0];   //边框宽度
//    [backHomeBtn.layer setBorderColor:colorref];//边框颜色
//    [view addSubview:backHomeBtn];
    
}

-(UIButton*)buildButton:(CGRect)frame title:(NSString *)title tag:(NSInteger)tag
{
    UIButton * Btn = [[UIButton alloc] initWithFrame:frame];
    [Btn setTitle: title forState:UIControlStateNormal];
    Btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [Btn setTitleColor: [UIColor colorWithHexString:@"E8103C"] forState:UIControlStateNormal];
    [Btn.layer setBorderColor:(__bridge CGColorRef)([UIColor colorWithHexString:@"E8103C"])];
    Btn.backgroundColor = [UIColor whiteColor];
    [Btn addTarget:self action:@selector(touch2:) forControlEvents:UIControlEventTouchDown];
    Btn.tag = tag;
    Btn.layer.cornerRadius = 3;
    [Btn.layer setBorderWidth:1.0];   //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
    [Btn.layer setBorderColor:colorref];//边框颜色
    return Btn;
}

-(void)touch2:(UIButton*)sender
{
    if (sender.tag == 100)
    {//订单详情
        OrderDetailViewController *view = [[OrderDetailViewController alloc] init];
        view.OrderID = _orderID;
        view.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:view animated:YES];
    }
    else if(sender.tag == 101)
    {//返回主页面
        
        [self.tabBarController setSelectedIndex:0];
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"gotohomeVC" object:self];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
            return 70;
        return 43;
    }
    else return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    return 4;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            OrderSumitTableViewCell *cell = [[OrderSumitTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            [cell setValue:@"订单支付成功" str:@" "];
            cell.image.image = [UIImage imageNamed:@"payment_mode.png"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            PayMoneyTableViewCell *cell = [[PayMoneyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            [cell setValue:_payState.price];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else
    {
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"交易订单";
                cell.detailTextLabel.text =[NSString stringWithFormat:@"%@",self.payState.orderId];
                
                break;
            case 1:
                cell.textLabel.text = @"交易时间";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.payState.orderTime];
                break;
                
            case 2:
                cell.textLabel.text = @"当前状态";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.payState.orderState];
                break;
                
            case 3:
                cell.textLabel.text = @"支付方式";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.payState.payWay];
                break;
            default:
                break;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        return cell;
    }
    return nil;
}

@end
