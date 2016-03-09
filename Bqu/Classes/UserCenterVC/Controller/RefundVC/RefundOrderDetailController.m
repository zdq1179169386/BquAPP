//
//  RefundOrderDetailController.m
//  Bqu
//
//  Created by yb on 15/10/28.
//  Copyright (c) 2015年 yb. All rights reserved.
// 售后单详情页

#import "RefundOrderDetailController.h"
#import "RefundMessage.h"
#import "RefundDetailCell.h"
#import "ReturnGoodsController.h"
#import "ApplyForRefundAnotherController.h"
#import "RefundViewController.h"
@interface RefundOrderDetailController ()<UITableViewDataSource,UITableViewDelegate,RefundDetailCellDelegate>
{
    NSTimer * timer;
}
@property (nonatomic,strong) UITableView * tableView;

/**数据源*/
@property (nonatomic,strong) NSMutableArray * dataArray;

/**订单id*/
@property (nonatomic,copy)NSString * orderId;

/**商品的主键id*/
@property (nonatomic,copy)NSString * orderRefuntId;

/**父售后单号*/
@property (nonatomic,copy)NSString * ParentRefundId;


@end

@implementation RefundOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (IOS7_OR_LATER)
    {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    [self initNav];
    [self requestForData];
}
-(void)initNav
{
    self.title = @"售后单详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIButton * backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];

}
-(void)backBtnBack
{
    RefundViewController * vc = [[RefundViewController alloc] init];
    vc.isLogin = @"0";
    [self.navigationController pushViewController:vc animated:NO];
}
#pragma mark -- init 
-(UITableView*)tableView
{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.backgroundColor = RGB_A(239, 239, 239);
        [self.tableView registerClass:[RefundDetailCell class] forCellReuseIdentifier:@"cell"];
        self.tableView.header = [DIYHeader headerWithRefreshingBlock:^{
            [self requestForData];
        }];
        UILabel * footer = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
        footer.text = @"若对本次退款有疑问，请拨打电话 4008-575766";
        footer.textAlignment = NSTextAlignmentCenter;
        footer.font = [UIFont systemFontOfSize:11];
        footer.textColor = [UIColor colorWithHexString:@"#888888"];
        self.tableView.tableFooterView = footer;
        [self.view addSubview:self.tableView];
    }
    return _tableView;
}
-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
       _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
#pragma mark -- 请求数据
-(void)requestForData
{
   
    
    NSString * urlStr1 = [NSString stringWithFormat:@"%@/api/order/Refund/Detail",TEST_URL];
    NSString * memberID = [UserManager getMyObjectForKey:userIDKey];
    NSString * token = [UserManager getMyObjectForKey:accessTokenKey];
    
    NSMutableDictionary * dict1 = [NSMutableDictionary dictionary];
    
    if (memberID && token &&self.refundId) {
        NSLog(@"%@",self.refundId);
        dict1[@"refundId"] = self.refundId;
        dict1[@"MemberID"] = memberID;
        dict1[@"token"] = token;
        
        NSString * sign1 = [HttpTool returnForSign:dict1];
        
        NSMutableDictionary * dict2 = [[NSMutableDictionary alloc] initWithDictionary:dict1];
        dict2[@"sign"] = sign1;
        [self.dataArray removeAllObjects];
        [HttpTool post:urlStr1 params:dict2 success:^(id json) {
            
            NSLog(@"售后单详情=%@",json[@"data"]);
            NSString * resultCode = json[@"resultCode"];
            if (resultCode.intValue == 0) {
                NSDictionary * dataDic = json[@"data"];
                if (![dataDic isKindOfClass:[NSNull class]]) {
                    if (dataDic.count>0) {
                        
                        NSArray * array = [dataDic objectForKey:@"RefundSchedule"];
                        NSMutableArray * dataArray = [NSMutableArray array];
                        
                        for (int i=0; i<array.count; i++) {
                            RefundMessage * message = [RefundMessage objectWithKeyValues:array[i]];
                            //订单id，和主键id.父售后单id
                            self.orderId = message.OrderId;
                            self.orderRefuntId = message.OrderItemId;
                            self.ParentRefundId = message.ParentRefundId;
                            
                            [dataArray addObject:message];
                        }
                        RefundMessage * message = [dataArray lastObject];
                        if (message.SellerAudit.intValue>2) {
                            for (RefundMessage * mesg in dataArray) {
                                mesg.SellerAudit = message.SellerAudit;
                            }
                        }
                        self.dataArray = [self refundMessageFrameWithMessage:dataArray];
                        [self.tableView.header endRefreshing];
                        [self.tableView reloadData];
                    }
                    
                }
   
            }
        } failure:^(NSError *error) {
            
            [self.tableView.header endRefreshing];
        }];
    }
}
#pragma mark -- 转化
-(NSMutableArray *)refundMessageFrameWithMessage:(NSMutableArray*)array
{
    NSMutableArray * frames = [NSMutableArray array];
    for (RefundMessage * message in array) {
        RefundMessageFrame * f = [[RefundMessageFrame alloc] init];
        f.message = message;
        [frames addObject:f];
    }
    return frames;
}
#pragma mark -- tableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray) {
          return self.dataArray.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RefundDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = [UIColor clearColor];
    if (self.dataArray) {
//        cell.orderStatus = self.afterMarketmodel.RefundMode;
        cell.messageF = self.dataArray[indexPath.row];

    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.delegate = self;
    return cell;
}
#pragma mark -- RefundDetailCellDelegate
-(void)returenGoodsOrTwiceToApplyRefund:(RefundDetailCell *)cell with:(UIButton *)btn
{
    NSLog(@"RefundDetailCellDelegate==%@",btn.titleLabel.text);
    if ([btn.titleLabel.text isEqualToString:@"发货"]) {
      
        ReturnGoodsController * vc = [[ReturnGoodsController alloc] init];
        vc.refundId = self.refundId;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([btn.titleLabel.text isEqualToString:@"重新申请"])
    {
        ApplyForRefundAnotherController * vc = [[ApplyForRefundAnotherController alloc] init];
        vc.isTwiceApplyForRefund = YES;
//        //二次申请，要传订单id ，售后单id；商品的主键id
        vc.orderId = self.orderId;
        vc.OrderItemId = self.orderRefuntId;
        vc.ParentRefundId = self.ParentRefundId;
        [self.navigationController pushViewController:vc animated:YES];
        NSLog(@"orderId=%@,orderRefuntId=%@,ParentRefundId=%@",self.orderId,self.orderRefuntId,self.ParentRefundId);
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RefundMessageFrame * frame = self.dataArray[indexPath.row];
    return frame.cellHeight;
//    return 300;
}
-(void)timerOver
{
    [ProgressHud hideProgressHudWithView:self.view];
    if (timer) {
        [timer invalidate];
        timer = nil;
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
