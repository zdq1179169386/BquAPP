#import "MyOrderViewController.h"
#import "MyOrderCell.h"
#import "OrderDetailViewController.h"
#import "DeliveryViewController.h"
#import "ApplyForRefundController.h"
#import "EvaluateViewController.h"
#import "SelsctPayWayViewController.h"
#import "RefundOrderDetailController.h"
#import "MyOrderHeader.h"
#import "MyOrderFooter.h"

@interface MyOrderViewController ()
{
    int _type;//下来不转圈

}
@property (strong, nonatomic) UIView * lineViewNew; // button下方点击时移动的红色线条
@property (nonatomic,strong)NSMutableArray * titleArray;

@end

@implementation MyOrderViewController


- (void)viewWillAppear:(BOOL)animated
{
    [self createBackBar];

    /**评价过后自动刷新**/
      if ([self.isEvaluate isEqualToString:@"0"])
      {
          _type =0;
          [self requestData];
          self.isEvaluate= @"1";
      }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的订单";
    self.view.backgroundColor = RGB_A(240, 238, 238);
    
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.titleArray = [NSMutableArray array];
    // 初始化选项卡
    [self initScrollView];
    // 初始化空位置
    [self blankView];
    
    /**未登录状态下,显示空视图**/
    if ([self.isLogin isEqualToString:@"1"])
    {
        self.viewBlank.hidden = NO;
    }
    else
    {
        self.viewBlank.hidden = YES;
        // 初始化表格
        [self initTableView];
        //初始化订单状态为默认 0
        self.orderStatus = @"0";
        [self requestData];
    }

    /**初始化订单个数页数**/
    _pageNum = 1;
    _pageSize = 8;
    _maxPage = 8;
    
    /**记录当前标签栏的按钮,第二次点击按钮时候,不会在请求一遍**/
    lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
#warning 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TimerOutForReloadData:) name:@"TimerOutForRequestDate" object:nil];


}
#warning 取消通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)TimerOutForReloadData:(NSNotification *)notification
{
    NSLog(@"%s",__func__);
    [self requestData];
}
#pragma mark  ->   请求数据
- (void)requestData
{
    if (_type == 0)
    {
        [self showLoadingView];
    }
    /**初始化订单个数页数**/
    _pageNum = 1;
    _maxPage = 8;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,getMyOrderUrl];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"MemberID"] = [UserManager getMyObjectForKey:userIDKey];
    dict[@"token"] = [UserManager getMyObjectForKey:accessTokenKey];
    dict[@"PageNo"] = @"1";
    dict[@"PageSize"] = @"8";
    dict[@"OrderStatus"] = self.orderStatus;
    NSString *realSign = [HttpTool returnForSign:dict];
    dict[@"sign"] = realSign;
    [HttpTool post:urlStr params:dict success:^(id json)
     {
         [self hideLoadingView];
//         NSLog(@"定单列表  = %@",json);
         [ProgressHud hideProgressHudWithView:self.view];
         [self.tableView_Base.header endRefreshing];
         NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
         if ([resultStr isEqualToString:@"0"])
         {
             [self removeNewView];
             NSArray *dataArray = [NSArray array];
             dataArray = json[@"data"];
             if (dataArray)
             {
                 if (dataArray.count == 0)
                 {
                     self.viewBlank.hidden = NO;
                     self.tableView_Base.hidden = YES;
                 }
                 else
                 {
                     self.tableView_Base.hidden = NO;
                     self.viewBlank.hidden = YES;
                     self.dataArray = [[NSMutableArray alloc] initWithCapacity:0];
                     for (NSDictionary *dict in dataArray)
                     {
                         MyOrder_Model *myOrder_Model = [MyOrder_Model parseAllDataWithDictionary:dict];
                         [self.dataArray addObject:myOrder_Model];
                     }
                     NSMutableArray * boolArray = [NSMutableArray array];
                     for (int i = 0; i<self.dataArray.count; i++)
                     {
                         BOOL isOpen = NO;
                         NSString * openStr = [NSString stringWithFormat:@"%d",isOpen];
                         [boolArray addObject:openStr];
                     }
                     self.boolArray = boolArray;
                     [self.tableView_Base reloadData];
                 }
             }
         }
         else
         {
             [self addAlertView];

         }
     } failure:^(NSError *error)
     {
         [self hideLoadingView];
         [self.tableView_Base.header endRefreshing];
         [self addNetView];
     }];
}

- (void)morerequestData
{
    _pageNum = _pageNum + 1;
    if (_maxPage<_pageSize)
    {
        [self.tableView_Base.footer endRefreshing];
        [self.tableView_Base.footer noticeNoMoreData];
        return;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,getMyOrderUrl];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"MemberID"] = [UserManager getMyObjectForKey:userIDKey];
    dict[@"token"] = [UserManager getMyObjectForKey:accessTokenKey];
    dict[@"PageNo"] = [NSString stringWithFormat:@"%d",_pageNum];
    dict[@"PageSize"] = [NSString stringWithFormat:@"%d",_pageSize];
    dict[@"OrderStatus"] = self.orderStatus;
    
    NSString *realSign = [HttpTool returnForSign:dict];
    dict[@"sign"] = realSign;
    [HttpTool post:urlStr params:dict success:^(id json)
     {
         NSArray *dataArray = [NSArray array];
         dataArray = json[@"data"];
         if (dataArray)
         {
             _maxPage = (int)dataArray.count;
             for (NSDictionary *dict in dataArray)
             {
                 MyOrder_Model *myOrder_Model = [MyOrder_Model parseAllDataWithDictionary:dict];
                 [self.dataArray addObject:myOrder_Model];
                 
             }
             
             NSMutableArray * boolArray = [NSMutableArray array];
             for (int i = 0; i<self.dataArray.count; i++) {
                 BOOL isOpen = NO;
                 NSString * openStr = [NSString stringWithFormat:@"%d",isOpen];
                 [boolArray addObject:openStr];
             }
             self.boolArray = boolArray;
             [self.tableView_Base reloadData];
             [self.tableView_Base.footer endRefreshing];
         }
         
     } failure:^(NSError *error)
     {
         [self.tableView_Base.footer endRefreshing];
     }];
}


#pragma mark    ->   初始化会移动的scrollVIew
- (void)initScrollView
{
    
    self.array_button = [[NSMutableArray alloc] initWithCapacity:0];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    NSArray * buttonTitleArray = [NSArray arrayWithObjects:@"全部",@"待付款",@"待发货",@"待收货",@"待评价",@"回收站",  nil];
    NSArray * buttonTagArray = [NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"8",@"6", nil];
    
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < buttonTitleArray.count; i ++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(ScreenWidth/6.0 * i, 0, ScreenWidth/6.0, 42);
        [button setTitle:buttonTitleArray[i] forState:UIControlStateNormal];
        button.tag = [buttonTagArray[i] integerValue] +10000;
        button.titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:14];
        [button setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick_float:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.scrollView addSubview:button];
        [self.array_button addObject:button];
        if (i == 0)
        {
            self.lineView = [[UIView alloc] init];
            self.lineView.bounds = CGRectMake(0, 0, ScreenWidth/6, 2);
            self.lineView.center = CGPointMake(button.center.x, 43);
            self.lineView.backgroundColor = [UIColor colorWithHexString:@"#e8103c"];
            self.lineView.layer.cornerRadius = 3;
            self.lineView.clipsToBounds = YES;
            [self.scrollView addSubview:self.lineView];
            [button setTitleColor:[UIColor colorWithHexString:@"#e8103c"] forState:UIControlStateNormal];
        }
    }
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 43, ScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.scrollView addSubview:line];
    [self.scrollView bringSubviewToFront:self.lineView];
    [self.view addSubview:self.scrollView];
    
    
}

#pragma mark
#pragma mark -->空的收藏视图
- (void)blankView
{
    self.viewBlank = [[UIView alloc] initWithFrame:CGRectMake(0,self.scrollView.frame.size.height , ScreenWidth, ScreenHeight  - self.scrollView.frame.size.height)];
    self.viewBlank.backgroundColor = RGB_A(240, 238, 238);
    [self.view addSubview:self.viewBlank];
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.bounds = CGRectMake(0, 0, 80,80);
    imageView.center = CGPointMake(ScreenWidth / 2.0, ScreenHeight / 2.0 - 104);
    imageView.image = [UIImage imageNamed:@"empty"];
    [self.viewBlank addSubview:imageView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth / 2.0 - 100, imageView.frame.size.height + imageView.frame.origin.y + 20, 200, 44)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.text = @"抱歉，您还没有相关订单~";
    [self.viewBlank addSubview:label];
}

#pragma mark -> scrollVIew按钮点击事件
- (void)buttonClick_float:(UIButton *)button
{
    _type = 0;
    if (button.tag == lastBtn.tag)
    {
        return;
    }
    lastBtn = button;
    for (UIButton * button in self.array_button)
    {
        [button setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    }
    [button setTitleColor:[UIColor colorWithHexString:@"#e8103c"] forState:UIControlStateNormal];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.lineView.center = CGPointMake(button.center.x, 43);
    [UIView commitAnimations];
    self.buttonTag = button.tag;
    
    self.orderStatus = [NSString stringWithFormat:@"%ld",button.tag-10000];
    NSLog(@"订单状态 = %@",self.orderStatus);

    if ([self.isLogin isEqualToString:@"0"])
    {
        [self requestData];
    }
    
    [self.tableView_Base reloadData];
    
}

#pragma mark -- > 表

- (void)initTableView
{
    if (self.tableView_Base != nil)
    {
        return;
    }
    else
    {
        self.tableView_Base = [[UITableView alloc] initWithFrame:CGRectMake(0,self.scrollView.frame.size.height, ScreenWidth, ScreenHeight  - self.scrollView.frame.size.height-60) style:UITableViewStyleGrouped];
        self.tableView_Base.delegate = self;
        self.tableView_Base.dataSource = self;
        self.tableView_Base.backgroundColor = RGB_A(236, 236, 236);
        self.tableView_Base.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView_Base registerNib:[UINib nibWithNibName:@"MyOrderCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
        [self.tableView_Base registerClass:[MyOrderHeader class] forHeaderFooterViewReuseIdentifier:@"header"];
        [self.tableView_Base registerClass:[MyOrderFooter class] forHeaderFooterViewReuseIdentifier:@"footer"];
        
        [self.view addSubview:self.tableView_Base];
        
        //下拉刷新
        self.tableView_Base.header.backgroundColor = [UIColor colorWithHexString:@"#f2f1f1"];
        self.tableView_Base.header = [DIYHeader headerWithRefreshingBlock:^{
            _type = 1;
            [self requestData];
        }];
        
        //上拉加载
        self.tableView_Base.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self morerequestData];
        }];
        
    }
    
    
}


#pragma mark -- > TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MyOrder_Model *order = self.dataArray[section];
    NSArray *array = order.itemInfoArray;
    if (array.count<=2)
    {
        return array.count;
    }
    else
    {
        NSString * boolStr = self.boolArray[section];
        if (boolStr.boolValue==1) {
            //展开
            return array.count;
        }else
        {
            //收起
            return 2;
        }
    }
    
    return 0;
}


#pragma mark    ------------> 设置区头区尾视图
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MyOrderHeader *header = [[MyOrderHeader alloc] initWithReuseIdentifier:@"header" withSection:section];
    
    if (![self.dataArray isKindOfClass:[NSNull class]])
    {
        MyOrder_Model *order = self.dataArray[section];
        [header setValue:order];
        
        if (section == 0)
        {
            header.line1.hidden = YES;
        }
    }
    
    return header;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    MyOrder_Model *order = self.dataArray[section];

    /**过了海关**/
    if ([order.orderStatus isEqualToString:@"2"])
     {
         if (![order.CustomsStatus isEqualToString:@"0"] || ![order.CustomsDisStatus isEqualToString:@"0"])
         {
             return 40;
         }
     }
    
    
    if ([self.orderStatus isEqualToString:@"6"])
    {
        return 40;
    }

    return 90;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    MyOrderFooter *footer =[[MyOrderFooter alloc] initWithReuseIdentifier:@"footer" withSection:section];
    
    MyOrder_Model *order = self.dataArray[section];
    [footer setValue:order];
    footer.delegate = self;

    NSString * str = self.boolArray[section];
    if ([str isEqualToString:@"1"])
    {
        footer.restCount.text = @"收起";
        CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI);
        footer.arrowBtn.transform = transform;
        
    }
    
    // 计算文字的宽度 红色箭头随着动
    CGRect rect = [footer.restCount.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil];
    float width =  ceilf(rect.size.width);
    footer.restCount.frame = CGRectMake(10, 2, width + 5, 26);
    footer.arrowBtn.frame = CGRectMake(footer.restCount.frame.origin.x + width + 5 , 8, 14, 14);

    return footer;
}



#pragma mark    ------------>单元格
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cellID";
    MyOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    /**找到数组中的model**/
    MyOrder_Model *order = self.dataArray[indexPath.section];
    NSArray *array = order.itemInfoArray;
    MyOrderItems_Model *orderItem = array[indexPath.row];
    /**给cell赋值**/
    [cell setValue:orderItem];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyOrder_Model *order = self.dataArray[indexPath.section];
    OrderDetailViewController *orderDetailVC = [[OrderDetailViewController alloc] init];
    orderDetailVC.OrderID = order.Id;
    if ([order.orderStatus isEqualToString:@"4"])
    {
        if ([order.commentCount isEqualToString:@"0"])
        {
            orderDetailVC.orderStatus =  [order.orderStatus intValue];
        }
        else
        {
            orderDetailVC.orderStatus = 6;
        }
    }
    orderDetailVC.hidesBottomBarWhenPushed = YES;
    orderDetailVC.order = self.dataArray[indexPath.section];
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

#pragma mark  -> 区尾上的两个按钮代理方法
- (void)footer:(NSInteger)section withBtn:(UIButton *)button
{
    /**根据区对应订单**/
    if (self.dataArray)
    {
        MyOrder_Model *order  = self.dataArray[section];
        int state = [order.orderStatus intValue];
        switch (button.tag)/**区分左右按钮**/
        {
            case 1000:
            {
                switch (state)/**区分订单状态**/
                {
                    case 1:/**待付款 取消订单**/
                    {
                        self.order = order;
                        self.titleArray = [NSMutableArray array];
                        [HttpEngine deleteTheOrderReasonsuccess:^(id json)
                        {
                            NSString *resultCode = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
                            if ([resultCode isEqualToString:@"0"])
                            {
                                NSArray *dataArray = [NSArray array];
                                dataArray = json[@"data"];
                                for (NSDictionary *dic in dataArray)
                                {
                                    deleteTheOrderReason *reason = [deleteTheOrderReason parseDataWithDictionary:dic];
                                    [self.titleArray addObject:reason.Name];
                                }
                                [self.titleArray addObject:@"不想取消"];
                                // alter弹框选择Ω
                                UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
                                ApplyForRefundAlertView *alertView = [[ApplyForRefundAlertView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth, ScreenHeight)withDelegate:self withTitle:@"请选择取消订单的原因" withArray:self.titleArray withIndexPath:0];
                                alertView.tag = 1230;
                                [window addSubview:alertView];
                            }
                        } failure:^(NSError *error)
                        {
                            
                        }];

                     }
                        break;
                    case 3:/**待收货,看看物流 **/
                    {
                        DeliveryViewController *deliveryVC = [[DeliveryViewController alloc] init];
                        deliveryVC.hidesBottomBarWhenPushed = YES;
                        deliveryVC.orderID = order.Id;
                        [self.navigationController pushViewController:deliveryVC animated:NO];
                        NSLog(@"物流跟踪按钮");
                    }
                        break;
                    case 4:/****/
                    {
                        self.order = order;
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"删除订单？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        alertView.tag = 1234;
                        [alertView show];

                    }
                        break;
     
                    default:
                        break;
                }
            }
                break;
            case 1001:
            {
                
                switch (state)
                {
                    case 1:/**代付款  立即付款**/
                    {
                        SelsctPayWayViewController *orderDetailVC = [[SelsctPayWayViewController alloc] init];
                        orderDetailVC.orderID = order.Id;
                        orderDetailVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:orderDetailVC animated:YES];
                        NSLog(@"立即支付按钮");
                    }
                        break;
                    case 2:/**待发货 退款售后**/
                    {
                        //退款信息的字典 ID=0 表示尚未退款 status表示退款状态
                        NSDictionary *dd = [NSDictionary dictionary];
                        dd = order.OrderRefund;
                        NSString *idStr = [NSString stringWithFormat:@"%@", dd[@"Id"]];
                        
                        /**假如已经退款,查看售后,否则就可以申请退款**/
                        if ([idStr isEqualToString:@"0"])
                        {
                            //订单退款按钮
                            ApplyForRefundController * vc = [[ApplyForRefundController alloc] init];
                            vc.orderId = order.Id;
                            vc.RefundType = @"1";
                            vc.model = order;
                            vc.totalAcount = [NSString stringWithFormat:@"%@",self.order.itemInfoArray];
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                        else
                        {
                            //查看售后
                            RefundOrderDetailController *refundVC = [[RefundOrderDetailController alloc] init];
                            refundVC.refundId = idStr;
                            refundVC.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:refundVC animated:NO];
                            
                        }
                        
                        NSLog(@"订单退款按钮");
                    }
                        break;
                    case 3:/**待收货 确认收货**/
                    {
                        self.order = order;
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认收货？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        alertView.tag = 1231;
                        [alertView show];
                        NSLog(@"确认收货");
                    }
                        break;
                    case 4:/**待评价 立即评价**/
                    {
                        NSLog(@"comment == %@",order.commentCount);
                        if ([order.commentCount isEqualToString:@"0"])
                        {
                            EvaluateViewController *evaluVC = [[EvaluateViewController alloc] init];
                            evaluVC.hidesBottomBarWhenPushed = YES;
                            evaluVC.orderID = order.Id;
                            
                            evaluVC.order = order;
                            [self.navigationController pushViewController:evaluVC animated:YES];
                        }
                        else
                        {
                            self.order = order;
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认删除？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                            alertView.tag = 1233;
                            [alertView show];

                        }

                    }
                        break;
                    case 5:/**已关闭 删除订单**/
                    {
                        NSLog(@"删除订单");
                        self.order = order;
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认删除？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        alertView.tag = 1232;
                        [alertView show];
                    }
                        break;

                    default:
                        break;
                }
            }
        }
        
    }
    
}


#pragma mark    ---->   是否确认收货 删除订单 弹出框
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{

    if (alertView.tag == 1231)
    {
        if (buttonIndex == 1)
        {
            //   { "MemberID": "59","token": "555","sign": "123123"}
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,surePayUrl];
            NSLog(@"确认收货 %@",urlStr);
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"MemberID"] = [UserManager getMyObjectForKey:userIDKey];
            dict[@"token"] = [UserManager getMyObjectForKey:accessTokenKey];
            dict[@"OrderId"] = self.order.Id;
            dict[@"MemberName"] = [UserManager getMyObjectForKey:userNameKey];
            NSLog(@"确认收货 %@",[UserManager getMyObjectForKey:userNameKey]);
            
            NSString *realSign = [HttpTool returnForSign:dict];
            dict[@"sign"] = realSign;
            [self showLoadingView];
            [HttpTool post:urlStr params:dict success:^(id json)
             {
                 [self hideLoadingView];
                 if (json[@"error"] == nil)
                 {
                     [TipView remindAnimationWithTitle:@"收货成功"];
                     [TipView doSomething:^{
                         [self requestData];
                     } afterDelayTime:1];
                     /**如果数组为空,显示空视图**/
                     if (self.dataArray.count == 0)
                     {
                         self.tableView_Base.hidden = YES;
                         self.viewBlank.hidden = NO;
                     }
                 }
                 
             } failure:^(NSError *error)
             {
                 
             }];
        }

    }
    else if (alertView.tag == 1232 || alertView.tag == 1233 || alertView.tag == 1234 )
    {
        if (buttonIndex == 1)
        {
            [HttpEngine deleteOrderWithorderId:self.order.Id success:^(id json)
             {
                 [self hideLoadingView];
                 [TipView remindAnimationWithTitle:json[@"message"]];
                 [TipView doSomething:^{
                     [self requestData];
                 } afterDelayTime:1];
                 
                 /**如果数组为空,显示空视图**/
                 if (self.dataArray.count == 0)
                 {
                     self.tableView_Base.hidden = YES;
                     self.viewBlank.hidden = NO;
                 }
                 
             } failure:^(NSError *error) {
                 [self hideLoadingView];
             }];
        }
    }
}

#pragma mark
#pragma mark   取消订单 取消原因
-(void)ApplyForRefundAlertViewBtnClick:(ApplyForRefundAlertView*)view withStr:(NSString *)title withIndexPath:(NSIndexPath*)index withRow:(int)row
{
    if (row != self.titleArray.count-1)
    {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,cancelPayUrl];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"MemberID"] = [UserManager getMyObjectForKey:userIDKey];
        dict[@"token"] = [UserManager getMyObjectForKey:accessTokenKey];
        dict[@"OrderId"] = self.order.Id;
        dict[@"CloseReson"] = [NSString stringWithFormat:@"%d",row];
        dict[@"MemberName"] = [UserManager getMyObjectForKey:userNameKey];
        NSString *realSign = [HttpTool returnForSign:dict];
        dict[@"sign"] = realSign;
        [HttpTool post:urlStr params:dict success:^(id json)
         {
             NSLog(@"测试语句 取消订单传参 = %@",dict);
             NSLog(@"测试语句 取消订单数据 = %@",json);
             
             [TipView remindAnimationWithTitle:json[@"message"]];
             [TipView doSomething:^{
                 [self requestData];
             } afterDelayTime:1];
             
             /**如果数组为空,显示空视图**/
             if (self.dataArray.count == 0)
             {
                 self.tableView_Base.hidden = YES;
                 self.viewBlank.hidden = NO;
             }
             
         } failure:^(NSError *error)
         {
             //            [self hideLoadingView];
         }];

    }
}


#pragma mark
#pragma mark  剩余件数按钮点击
- (void)footer:(NSInteger)section restBtn:(UIButton *)restBtn
{
    NSString * str = self.boolArray[section];
    BOOL value = !str.boolValue;
    NSLog(@"value=%d",value);
    str = [NSString stringWithFormat:@"%d",value];
    
    [self.boolArray replaceObjectAtIndex:section withObject:str];
    NSIndexSet * index = [[NSIndexSet alloc] initWithIndex:section];
    [self.tableView_Base reloadSections:index withRowAnimation:UITableViewRowAnimationNone];
    
}


#pragma mark
#pragma mark    网络不好必加
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

