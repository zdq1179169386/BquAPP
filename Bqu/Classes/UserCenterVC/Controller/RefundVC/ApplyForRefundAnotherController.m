//
//  ApplyForRefundAnotherController.m
//  Bqu
//
//  Created by yb on 15/10/27.
//  Copyright (c) 2015年 yb. All rights reserved.
//申请售后

#import "ApplyForRefundAnotherController.h"
#import "ApplyForRefundCell.h"
#import "ApplyForRefundAlertView.h"
#import "RefundOrderDetailController.h"
@interface ApplyForRefundAnotherController ()<UITableViewDataSource,UITableViewDelegate>

{
    int  _row0;
    int  _row1;
    int  _row2;
    NSArray * array1;
    NSArray * array2;
    NSArray * array3;
    NSArray * array4;
    NSArray * array0;

    NSTimer *timer;
    
    
}
@property (nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong) UIView * buttomView;
/**yes是支付宝，no是银行卡*/
@property(nonatomic,assign) BOOL  arefundType;
/**yes是退款，no退货*/
@property(nonatomic,assign)BOOL refunfOrGoods;

/**最大可退金额*/
@property(nonatomic,copy) NSString * MaxRefundAmount;

/**最大可退数量(订单退款返回0,退货退款返回商品数量)*/
@property(nonatomic,copy) NSString * MaxRGDNumber;
/**退款成功后，返回的退款单号*/
@property(nonatomic,copy) NSString * OrderRefundId;
@end

@implementation ApplyForRefundAnotherController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (IOS7_OR_LATER)
    {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    [self initTable];
    double money = self.itemCount.intValue * self.itemPrice.doubleValue;
    self.money = [NSString stringWithFormat:@"%.2lf",money];

    NSLog(@"申请售后%@,%@,%@",self.ParentRefundId,self.orderId,self.OrderItemId);
    
//      self.isTwiceApplyForRefund = NO;
    
     [self requestForRefundAmount];
}
#pragma mark -- 获取最大可退金额
-(void)requestForRefundAmount
{
    NSString * urlStr1 = [NSString stringWithFormat:@"%@/API/Order/Refund/GetAllow",TEST_URL];
    NSString * memberID = [UserManager getMyObjectForKey:userIDKey];
    NSString * token = [UserManager getMyObjectForKey:accessTokenKey];
    
    NSMutableDictionary * dict1 = [NSMutableDictionary dictionary];
    
    if (memberID && token && self.orderId) {
        dict1[@"orderId"] = self.orderId;
        dict1[@"orderItemId"] = self.OrderItemId;
        if (self.isTwiceApplyForRefund) {
            //父售后单编号（二次申请传父售后单编号，否则传0
             dict1[@"parentRefundId"] = self.ParentRefundId;

        }else
        {
            dict1[@"parentRefundId"] = @"0";

        }
        dict1[@"MemberID"] = memberID;
        dict1[@"token"] = token;
        
        NSString * sign1 = [HttpTool returnForSign:dict1];
        
        NSMutableDictionary * dict2 = [[NSMutableDictionary alloc] initWithDictionary:dict1];
        dict2[@"sign"] = sign1;
        NSLog(@"%@,%@",dict1,dict2);
        [HttpTool post:urlStr1 params:dict2 success:^(id json) {
            
            if (!json[@"error"]) {
                
                NSDictionary * dic = json[@"data"];
                if (![dic isKindOfClass:[NSNull class]]) {
                    NSString * maxAmount = [dic objectForKey:@"MaxRefundAmount"];
                    self.MaxRGDNumber = [dic objectForKey:@"MaxRGDNumber"];
                    self.MaxRefundAmount = [NSString stringWithFormat:@"%.2f",maxAmount.doubleValue];
                    NSLog(@"最大退款金额%@,%@",maxAmount,self.MaxRGDNumber);
                    [self.tableView reloadData];
                }
               

            }else{
                
                
            }
           
        } failure:^(NSError *error) {
            
        }];
    }
    
}
-(void)initSrollerView
{
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    scrollView.contentSize = CGSizeMake(0, ScreenHeight);
    scrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:scrollView];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initTable
{
    self.title = @"退货退款";
    
    UIButton * backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-40)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [[UIView alloc] init];
        [self.tableView registerClass:[ApplyForRefundCell class] forCellReuseIdentifier:@"cell"];
        //        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.view addSubview:self.tableView];
        UIButton * promt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        [promt setTitle:@"温馨提示：已使用的优惠券和积分不予返还" forState:UIControlStateNormal];
        [promt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        promt.titleLabel.font = [UIFont systemFontOfSize:13];
        promt.backgroundColor = RGB_A(251, 245, 213);
        promt.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 70);
        self.tableView.tableHeaderView = promt;
        
    }
    _row0 = 0;
    _row1 = 0;
    _row2 = 0;

    array0 = [[NSArray alloc] initWithObjects:@"请选择退款类型",@"仅退款", @"退货退款",nil];
    array1 = [[NSArray alloc] initWithObjects:@"请选择退款原因",@"7天无理由退换货",@"效果不好/不喜欢",@"假冒品牌",@"功能故障",@"颜色/款式/型号等描述不符",@"商品少件/破损/污渍等",@"其他",nil];
    _row2=0;
    array2 = [[NSArray alloc] initWithObjects:@"请选择退款方式",@"退到支付宝",@"退到银行卡",nil];
    
    array3 = [[NSArray alloc] initWithObjects:@" ＊ 服务类型",@" ＊ 退款原因",@" ＊ 服务金额",@" ＊ 联系电话", nil];
    
    array4 = [[NSArray alloc] initWithObjects:@" ＊ 服务类型",@" ＊ 退款原因",@" ＊ 服务金额",@" ＊ 联系电话",@" ＊ 退款方式",@" ＊ 银行卡号",@" ＊ 开户人",@" ＊ 开户银行",@" ＊ 退款说明", nil];
//    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-64-50, ScreenWidth, 50)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, ScreenWidth-10, 40)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"提交订单" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 5;
    btn.clipsToBounds = YES;
    [view addSubview:btn];
    
    UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    [view addSubview:line];
    
    self.arefundType = YES;
    self.refunfOrGoods = YES;// 仅退款
}
#pragma mark -- 提交退款申请
-(void)btnClick:(UIButton *)btn
{
    NSIndexPath * index0_0 = [NSIndexPath indexPathForRow:0 inSection:0];
    ApplyForRefundCell * cell0_0 = (ApplyForRefundCell*)[self.tableView cellForRowAtIndexPath:index0_0];
    
    NSIndexPath * index2 = [NSIndexPath indexPathForRow:2 inSection:0];
    ApplyForRefundCell * cell2 = (ApplyForRefundCell*)[self.tableView cellForRowAtIndexPath:index2];
    
    NSIndexPath * index1 = [NSIndexPath indexPathForRow:1 inSection:0];
    ApplyForRefundCell * cell1 = (ApplyForRefundCell*)[self.tableView cellForRowAtIndexPath:index1];
    
    NSIndexPath * index3 = [NSIndexPath indexPathForRow:3 inSection:0];
    ApplyForRefundCell * cell3 = (ApplyForRefundCell*)[self.tableView cellForRowAtIndexPath:index3];
    
    NSIndexPath * index1_0 = [NSIndexPath indexPathForRow:0 inSection:1];
    ApplyForRefundCell * cell1_0 = (ApplyForRefundCell*)[self.tableView cellForRowAtIndexPath:index1_0];
    
    NSIndexPath * index1_1 = [NSIndexPath indexPathForRow:1 inSection:1];
    ApplyForRefundCell * cell1_1 = (ApplyForRefundCell*)[self.tableView cellForRowAtIndexPath:index1_1];
    
    NSIndexPath * index1_2 = [NSIndexPath indexPathForRow:2 inSection:1];
    ApplyForRefundCell * cell1_2 = (ApplyForRefundCell*)[self.tableView cellForRowAtIndexPath:index1_2];
    
    NSIndexPath * index1_3 = [NSIndexPath indexPathForRow:3 inSection:1];
    ApplyForRefundCell * cell1_3 = (ApplyForRefundCell*)[self.tableView cellForRowAtIndexPath:index1_3];
    
    NSIndexPath * index1_4 = [NSIndexPath indexPathForRow:4 inSection:1];
    ApplyForRefundCell * cell1_4 = (ApplyForRefundCell*)[self.tableView cellForRowAtIndexPath:index1_4];
    
  
    
    if ([cell0_0.btn.text isEqualToString:@"请选择退款类型"]) {
        [ProgressHud addProgressHudWithView:self.view andWithTitle:@"请选择退款类型" withTime:1.5 withType:MBProgressHUDModeText];
        
        return;
    }
    if ([cell1.btn.text isEqualToString:@"请选择退款原因"]) {
         [ProgressHud addProgressHudWithView:self.view andWithTitle:@"请选择退款原因" withTime:1.5 withType:MBProgressHUDModeText];
        return;
    }
    if ([cell1_0.btn.text isEqualToString:@"请选择退款方式"]) {
         [ProgressHud addProgressHudWithView:self.view andWithTitle:@"请选择退款方式" withTime:1.5 withType:MBProgressHUDModeText];
        return;
    }

    
      NSString * urlStr1 = [NSString stringWithFormat:@"%@/api/order/Refund/Add",TEST_URL];
        NSString * memberID = [UserManager getMyObjectForKey:userIDKey];
        NSString * token = [UserManager getMyObjectForKey:accessTokenKey];
        NSString * userName = [UserManager getMyObjectForKey:userNameKey];
                NSLog(@"orderId=%@",self.orderId);
    //先判断是退货类型，在判断退货方式
        if (self.refunfOrGoods) {  //仅退款
            NSMutableDictionary * dict1 = [NSMutableDictionary dictionary];
            
            if (self.arefundType) {
               //退到支付宝 可以了
                if (cell2.textField.text.length==0 || cell3.textField.text.length==0||cell1_1.textField.text.length==0 || cell1_3.textView.text.length==0||cell1_2.textField.text.length==0) {
                    
                    NSLog(@"%@,%@,%@,%@,%@",cell2.textField.text,cell3.textField.text,cell1_1.textField.text,cell1_3.textView.text,cell1_2.textField.text);
                    [ProgressHud addProgressHudWithView:self.view andWithTitle:@"请补全信息" withTime:1.5 withType:MBProgressHUDModeText];
                    

                    return;
                }
                NSLog(@"%@,%@,%@,%@,%@",cell2.textField.text,cell3.textField.text,cell1_1.textField.text,cell1_3.textView.text,cell1_2.textField.text);

                if (memberID && token &&userName) {
                    dict1[@"OrderId"] = self.orderId;
                    dict1[@"RefundType"] = @"1";
                    dict1[@"Reason"] = cell1.btn.text;
                    dict1[@"Amount"] = cell2.textField.text;
                    dict1[@"ReturnQuantity"] = @"0";
                    dict1[@"Payee"] = cell1_2.textField.text;
                    dict1[@"ContactCellPhone"] = cell3.textField.text;
                    dict1[@"PayeeAccount"] = cell1_1.textField.text;
                    dict1[@"RefundAccount"] = cell1_0.btn.text;
//                   订单商品编号(订单退款:0;售后传主键ID)
                    dict1[@"OrderItemId"] = self.OrderItemId;
                    if (self.isTwiceApplyForRefund) {
                        //父售后单编号（二次申请传父售后单编号，否则传0
                        dict1[@"ParentRefundId"] = self.ParentRefundId;
                        
                    }else
                    {
                        dict1[@"ParentRefundId"] = @"0";
                        
                        
                    }

                    dict1[@"MemberID"] = memberID;
                    dict1[@"UserName"] = userName;
                    dict1[@"GoodsReturnRemark"] = cell1_3.textView.text;
                    dict1[@"token"] = token;
                    
                    
                    NSString * sign1 = [HttpTool returnForSign:dict1];
                    
                    NSMutableDictionary * dict2 = [[NSMutableDictionary alloc] initWithDictionary:dict1];
                    dict2[@"sign"] = sign1;
                    dict2[@"BankName"] = @"";
                    dict2[@"RefundMoneyReMark"] = @"";
                    NSLog(@"%@,%@",dict1,dict2);
                    [HttpTool post:urlStr1 params:dict2 success:^(id json) {
                        
                        NSLog(@"__%@, ___%@",json[@"message"],json[@"data"]);
                        if (!json[@"error"]) {
                            NSString * str = json[@"message"];
                            
                            if ([str isEqualToString:@"操作成功"]) {
                                NSDictionary * dic = json[@"data"];
                                
                              [ProgressHud addProgressHudWithView:self.view andWithTitle:str withTime:1 withType:MBProgressHUDModeText];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)),
                                               dispatch_get_main_queue(), ^{
                                                
                                                   //跳到售后单详情页,要将售后单号传过去
                                            RefundOrderDetailController * vc = [[RefundOrderDetailController alloc] init];
                                            vc.refundId = dic[@"OrderRefundId"];
                                                   NSLog(@"申请成功，返回的售后单号=%@", dic[@"OrderRefundId"]);
                                            [self.navigationController pushViewController:vc animated:YES];
                                                   
                                               });
                            }else
                            {
                                str = [str substringWithRange:NSMakeRange(3, str.length-3)];
                               [ProgressHud addProgressHudWithView:self.view andWithTitle:str withTime:1 withType:MBProgressHUDModeText];
                            }
                            
                            
                        }else{
                            
                            
                        }
                    } failure:^(NSError *error) {
                        
                    }];
                    
                }
                
            }else
            {  //退到银行卡 可以了
                if (cell2.textField.text.length==0 || cell3.textField.text.length==0||cell1_1.textField.text.length==0 || cell1_3.textField.text.length==0||cell1_2.textField.text.length==0 || cell1_4.textView.text.length==0) {
                    
                    NSLog(@"%@,%@,%@,%@,%@",cell2.textField.text,cell3.textField.text,cell1_1.textField.text,cell1_3.textField.text,cell1_2.textView.text);
                    [ProgressHud addProgressHudWithView:self.view andWithTitle:@"请补全信息" withTime:1.5 withType:MBProgressHUDModeText];
                    return;
                }
//                NSIndexPath * index4 = [NSIndexPath indexPathForRow:4 inSection:0];
//                ApplyForRefundCell * cell4 = (ApplyForRefundCell*)[self.tableView cellForRowAtIndexPath:index4];
                if (memberID && token &&userName) {
                    dict1[@"OrderId"] = self.orderId;
                    dict1[@"RefundType"] = @"1";
                    dict1[@"Reason"] = cell1.btn.text;
                    dict1[@"Amount"] = cell2.textField.text;
                    dict1[@"ReturnQuantity"] = @"0";
                    dict1[@"Payee"] = cell1_2.textField.text;
                    dict1[@"ContactCellPhone"] = cell3.textField.text;
                    dict1[@"PayeeAccount"] = cell1_1.textField.text;
                    dict1[@"RefundAccount"] = cell1_0.btn.text;
//                  订单商品编号(订单退款:0;售后传订单商品编号)
                    dict1[@"OrderItemId"] = self.OrderItemId;
                    if (self.isTwiceApplyForRefund) {
                        //父售后单编号（二次申请传父售后单编号，否则传0
                        dict1[@"ParentRefundId"] = self.ParentRefundId;
                        
                    }else
                    {
                        dict1[@"ParentRefundId"] = @"0";
                        
                    }

                    dict1[@"MemberID"] = memberID;
                    dict1[@"UserName"] = userName;
                    dict1[@"GoodsReturnRemark"] = cell1_4.textView.text;
                    dict1[@"BankName"] = cell1_3.textField.text;
                    dict1[@"token"] = token;
                    
                    NSString * sign1 = [HttpTool returnForSign:dict1];
                    
                    NSMutableDictionary * dict2 = [[NSMutableDictionary alloc] initWithDictionary:dict1];
                    dict2[@"sign"] = sign1;
                    dict2[@"RefundMoneyReMark"] = @"";
                    NSLog(@"%@,%@",dict1,dict2);
                    [HttpTool post:urlStr1 params:dict2 success:^(id json) {
                        
                        NSLog(@"__%@, ___%@",json[@"message"],json[@"data"]);
                        if (!json[@"error"]) {
                            NSString * str = json[@"message"];
                            
                            if ([str isEqualToString:@"操作成功"]) {
                                NSDictionary * dic = json[@"data"];
                                //跳到售后单详情页,要将售后单号传过去
                                
                              [ProgressHud addProgressHudWithView:self.view andWithTitle:str withTime:1 withType:MBProgressHUDModeText];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)),
                                               dispatch_get_main_queue(), ^{
                                                   
                                                   //跳到售后单详情页,要将售后单号传过去
                                                   RefundOrderDetailController * vc = [[RefundOrderDetailController alloc] init];
                                                   vc.refundId = dic[@"OrderRefundId"];
                                                   NSLog(@"退款成功，返回的售后单号=%@", dic[@"OrderRefundId"]);
                                                   [self.navigationController pushViewController:vc animated:YES];
                                                   
                                               });
                            }else
                            {
                                str = [str substringWithRange:NSMakeRange(3, str.length-3)];
                               [ProgressHud addProgressHudWithView:self.view andWithTitle:str withTime:1 withType:MBProgressHUDModeText];
                            }

                            
                        }else{
                            
                           [ProgressHud addProgressHudWithView:self.view andWithTitle:json[@"error"] withTime:1 withType:MBProgressHUDModeText];
                        }
                    } failure:^(NSError *error) {
                        
                    }];
                    
                }

                    
                    
            }
                
    }else
    {
        
        //退货退款
        NSIndexPath * index4 = [NSIndexPath indexPathForRow:4 inSection:0];
        ApplyForRefundCell * cell4 = (ApplyForRefundCell*)[self.tableView cellForRowAtIndexPath:index4];
        
         NSMutableDictionary * dict1 = [NSMutableDictionary dictionary];
        if (self.arefundType) {
            //退到支付宝
            if (cell2.textField.text.length==0 || cell3.textField.text.length==0||cell4.textField.text.length==0||cell1_1.textField.text.length==0 ||cell1_2.textField.text.length==0 ||cell1_3.textView.text.length==0) {
                
                NSLog(@"%@,%@,%@,%@,%@,%@",cell2.textField.text,cell3.textField.text,cell4.textField.text,cell1_1.textField.text,cell1_2.textField.text,cell1_3.textView.text);
                [ProgressHud addProgressHudWithView:self.view andWithTitle:@"不能为空"];
                timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerOver) userInfo:nil repeats:NO];
                return;
            }
            if (memberID && token &&userName) {
                NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                
                dic[@"OrderId"] = self.orderId;
                dic[@"RefundType"] = @"2";
                dic[@"Reason"] = cell1.btn.text;
                dic[@"Amount"] = cell3.textField.text;
                dic[@"ReturnQuantity"] = cell2.textField.text;
                dic[@"Payee"] = cell1_2.textField.text;
                dic[@"ContactCellPhone"] = cell4.textField.text;
                dic[@"PayeeAccount"] = cell1_1.textField.text;
                dic[@"RefundAccount"] = @"退到支付宝";
                //       订单商品编号(订单退款:0;售后传订单商品编号)
                dic[@"OrderItemId"] = self.OrderItemId;
                if (self.isTwiceApplyForRefund) {
                    //父售后单编号（二次申请传父售后单编号，否则传0
                    dic[@"ParentRefundId"] = self.ParentRefundId;
                    
                }else
                {
                    dic[@"ParentRefundId"] = @"0";
                    
                }
                dic[@"MemberID"] = memberID;
                dic[@"UserName"] = userName;
                dic[@"GoodsReturnRemark"] = cell1_3.textView.text;
                dic[@"token"] = token;
                
                NSString * sign1 = [HttpTool returnForSign:dic];
                
                NSMutableDictionary * dict2 = [[NSMutableDictionary alloc] initWithDictionary:dic];
                dict2[@"BankName"] = @"";
                dict2[@"RefundMoneyReMark"] = @"";
                dict2[@"sign"] = sign1;
                NSLog(@"%@,%@",dic,dict2);
                [HttpTool post:urlStr1 params:dict2 success:^(id json) {
                    
                    NSLog(@"__%@, ___%@",json[@"message"],json[@"data"]);
                    if (!json[@"error"]) {
                        NSString * str = json[@"message"];
                        
                        if ([str isEqualToString:@"操作成功"]) {
                            NSDictionary * dic = json[@"data"];
                            //跳到售后单详情页,要将售后单号传过去
                            
                           [ProgressHud addProgressHudWithView:self.view andWithTitle:str withTime:1 withType:MBProgressHUDModeText];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)),
                                           dispatch_get_main_queue(), ^{
                                               
                                             
                                               //跳到售后单详情页,要将售后单号传过去
                                               RefundOrderDetailController * vc = [[RefundOrderDetailController alloc] init];
                                               vc.refundId = dic[@"OrderRefundId"];
                                               NSLog(@"退款成功，返回的售后单号=%@", dic[@"OrderRefundId"]);
                                               [self.navigationController pushViewController:vc animated:YES];
                                               
                                           });                        }else
                        {
                            str = [str substringWithRange:NSMakeRange(3, str.length-3)];
                            [ProgressHud addProgressHudWithView:self.view andWithTitle:str withTime:1 withType:MBProgressHUDModeText];
                        }
                    }else{
                        
                        [ProgressHud addProgressHudWithView:self.view andWithTitle:json[@"error"] withTime:1 withType:MBProgressHUDModeText];
                    }
                } failure:^(NSError *error) {
                    
                }];
                
            }
            
        
        }else
        {
            //退到银行卡
            if (cell2.textField.text.length==0 || cell3.textField.text.length==0||cell4.textField.text.length==0||cell1_1.textField.text.length==0 || cell1_3.textField.text.length==0||cell1_2.textField.text.length==0 ||cell1_4.textView.text.length ==0) {
                
                NSLog(@"%@,%@,%@,%@,%@,%@",cell2.textField.text,cell3.textField.text,cell1_1.textField.text,cell1_3.textField.text,cell1_2.textView.text,cell1_4.textView.text);
                [ProgressHud addProgressHudWithView:self.view andWithTitle:@"补全信息" withTime:1 withType:MBProgressHUDModeText];
                return;
            }
            
            if (memberID && token &&userName) {
                dict1[@"OrderId"] = self.orderId;
                dict1[@"RefundType"] = @"2";
                dict1[@"Reason"] = cell1.btn.text;
                dict1[@"Amount"] = cell3.textField.text;
                dict1[@"ReturnQuantity"] = cell2.textField.text;
                dict1[@"Payee"] = cell1_2.textField.text;
                dict1[@"ContactCellPhone"] = cell4.textField.text;
                dict1[@"PayeeAccount"] = cell1_1.textField.text;
                dict1[@"RefundAccount"] = @"退到银行卡";
                //     订单商品编号(订单退款:0;售后传订单商品编号)
                dict1[@"OrderItemId"] = self.OrderItemId;
                if (self.isTwiceApplyForRefund) {
                    //父售后单编号（二次申请传父售后单编号，否则传0
                    dict1[@"ParentRefundId"] = self.ParentRefundId;
                    
                }else
                {
                    dict1[@"ParentRefundId"] = @"0";
                    
                }
                dict1[@"MemberID"] = memberID;
                dict1[@"UserName"] = userName;
                dict1[@"GoodsReturnRemark"] = cell1_4.textView.text;
                dict1[@"BankName"] = cell1_3.textField.text;
                dict1[@"token"] = token;
                
                NSString * sign1 = [HttpTool returnForSign:dict1];
                
                NSMutableDictionary * dict2 = [[NSMutableDictionary alloc] initWithDictionary:dict1];
                dict2[@"sign"] = sign1;
                dict2[@"RefundMoneyReMark"] = @"";
                NSLog(@"%@,%@",dict1,dict2);
                [HttpTool post:urlStr1 params:dict2 success:^(id json) {
                    
                    NSLog(@"__%@, ___%@",json[@"message"],json[@"data"]);
                    if (!json[@"error"]) {
                        NSString * str = json[@"message"];
                        
                        if ([str isEqualToString:@"操作成功"]) {
                            NSDictionary * dic = json[@"data"];
                            //跳到售后单详情页,要将售后单号传过去
                            
                            [ProgressHud addProgressHudWithView:self.view andWithTitle:str withTime:1 withType:MBProgressHUDModeText];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)),
                                           dispatch_get_main_queue(), ^{
                                               
                                               //跳到售后单详情页,要将售后单号传过去
                                               RefundOrderDetailController * vc = [[RefundOrderDetailController alloc] init];
                                               vc.refundId = dic[@"OrderRefundId"];
                                               NSLog(@"退款成功，返回的售后单号=%@", dic[@"OrderRefundId"]);
                                               [self.navigationController pushViewController:vc animated:YES];
                                               
                                           });                        }else
                        {
                            str = [str substringWithRange:NSMakeRange(3, str.length-3)];
                            [ProgressHud addProgressHudWithView:self.view andWithTitle:str withTime:1 withType:MBProgressHUDModeText];
                        }
                    }else{
                        
                       [ProgressHud addProgressHudWithView:self.view andWithTitle:json[@"error"] withTime:1 withType:MBProgressHUDModeText];
                    }
                } failure:^(NSError *error) {
                    
                }];
                
            }
            
        }
        
    }
    
}
-(void)timerOver
{
    [ProgressHud hideProgressHudWithView:self.view];
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
}
#pragma mark - tableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        
        if (self.refunfOrGoods) {//仅退款
            return 4;
            
        }else
        {//退货退款
            return 5;
            
        }

    }else
    {
        if (self.arefundType) {
            //退到支付宝
            return 4;
        }else
        {
            //退到银行卡
            return 5;
        }
        
    }
           return 0;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * Id =@"cell";
     ApplyForRefundCell * cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (!cell) {
        cell = [[ApplyForRefundCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textField.hidden = YES;
    cell.textView.hidden = YES;
    cell.rightImage.hidden = NO;
    cell.textField.placeholder = @"";
    if (indexPath.section==0) {
        //第一个区
        
        if (indexPath.row==0) {
            NSString * str = [NSString stringWithFormat:@"  * 服务类型"];
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:@"*"]];
            [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:@"*"]];
            cell.label.attributedText = attr;
            cell.btn.text = [array0 objectAtIndex:_row0];
            cell.btn.textColor = [UIColor redColor];
            cell.btn.hidden = NO;
            return cell;

        }else if (indexPath.row==1)
        {
            NSString * str = [NSString stringWithFormat:@"  * 退款原因"];
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:@"*"]];
            [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:@"*"]];
            cell.label.attributedText = attr;
//            NSLog(@"%d",_row);
            cell.textField.hidden = YES;
            cell.textView.hidden = YES;
            cell.btn.text = [array1 objectAtIndex:_row1];
            cell.btn.textColor = [UIColor blackColor];
            cell.btn.hidden = NO;


        }else if (indexPath.row==2)
        {
            if (self.refunfOrGoods) {
                //仅退款
                NSString * str = [NSString stringWithFormat:@"  * 退款金额"];
                NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
                [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:@"*"]];
                [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:@"*"]];
                cell.label.attributedText = attr;
                cell.rightImage.hidden = YES;
                cell.btn.hidden = YES;
                cell.textField.hidden = NO;
              cell.textField.placeholder = [NSString stringWithFormat:@"最大金额不得超过%@元",self.MaxRefundAmount];
                

            }else
            {
                //退款退货
                NSString * str = [NSString stringWithFormat:@"  * 退货数量"];
                NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
                [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:@"*"]];
                [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:@"*"]];
                cell.label.attributedText = attr;
                cell.rightImage.hidden = YES;
                cell.btn.hidden = YES;
                cell.textField.hidden = NO;
                cell.textField.placeholder = [NSString stringWithFormat:@"最大数量不能超过%@",self.MaxRGDNumber];
                
            }
        }else if (indexPath.row==3)
        {
            if (self.refunfOrGoods) {
                   //仅退款
                NSString * str = [NSString stringWithFormat:@"  * 联系电话"];
                NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
                [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:@"*"]];
                [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:@"*"]];
                cell.label.attributedText = attr;
                cell.rightImage.hidden = YES;
                cell.btn.hidden = YES;
                cell.textField.hidden = NO;
                cell.textField.placeholder =  @"请输入电话号码";
                
            }else
            {
                //退款退货
                NSString * str = [NSString stringWithFormat:@"  * 退款金额"];
                NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
                [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:@"*"]];
                [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:@"*"]];
                cell.label.attributedText = attr;
                cell.rightImage.hidden = YES;
                cell.btn.hidden = YES;
                cell.textField.hidden = NO;
                cell.textField.placeholder = [NSString stringWithFormat:@"最多%@元",self.MaxRefundAmount];
            }
            
        }else if (indexPath.row==4)
        {
            if (self.refunfOrGoods) {
                 //仅退款
                return nil;
                
            }else
            {
                 //退款退货
                NSString * str = [NSString stringWithFormat:@"  * 联系电话"];
                NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
                [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:@"*"]];
                [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:@"*"]];
                cell.label.attributedText = attr;
                cell.rightImage.hidden = YES;
                cell.btn.hidden = YES;
                cell.textField.hidden = NO;
                
            }
        }
        
        
    }else
    {
        //第二区
        if (indexPath.row==0) {
            NSString * str = [NSString stringWithFormat:@"  * 退款方式"];
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:@"*"]];
            [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:@"*"]];
            cell.label.attributedText = attr;
            cell.btn.text = [array2 objectAtIndex:_row2];
            cell.btn.hidden = NO;
            cell.btn.textColor  = [UIColor blackColor];
        }else if (indexPath.row==1)
        {
            if (self.arefundType) {
                //支付宝
                NSString * str = [NSString stringWithFormat:@"  * 收款账号"];
                NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
                [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:@"*"]];
                [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:@"*"]];
                cell.label.attributedText = attr;
                cell.rightImage.hidden = YES;
                cell.btn.hidden = YES;
                cell.textField.hidden = NO;
                cell.textField.placeholder = @"请输入收款账号";
            }else
            {
                NSString * str = [NSString stringWithFormat:@"  * 银行卡号"];
                NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
                [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:@"*"]];
                [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:@"*"]];
                cell.label.attributedText = attr;
                cell.rightImage.hidden = YES;
                cell.btn.hidden = YES;
                cell.textField.hidden = NO;
                cell.textField.placeholder = @"请输入收款账号";
            }

        }else if (indexPath.row==2)
        {
            
            if (self.arefundType) {
                NSString * str = [NSString stringWithFormat:@"  * 收款人"];
                NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
                [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:@"*"]];
                [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:@"*"]];
                cell.label.attributedText = attr;
                cell.rightImage.hidden = YES;
                cell.btn.hidden = YES;
                cell.textField.hidden = NO;
                cell.textField.placeholder = @"请输入收款人";
            }else
            {
                NSString * str = [NSString stringWithFormat:@"  * 开户人"];
                NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
                [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:@"*"]];
                [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:@"*"]];
                cell.label.attributedText = attr;
                cell.rightImage.hidden = YES;
                cell.btn.hidden = YES;
                cell.textField.hidden = NO;
                cell.textField.placeholder = @"请输入开户人";

            }

            
        }else if (indexPath.row==3)
        {
            if (self.arefundType) {
                NSString * str = [NSString stringWithFormat:@"  * 退款说明"];
                NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
                [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:@"*"]];
                [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:@"*"]];
                cell.label.attributedText = attr;
                cell.rightImage.hidden = YES;
                cell.btn.hidden = YES;
                cell.textField.hidden = YES;
                cell.textView.hidden = NO;
                
            }else{
                NSString * str = [NSString stringWithFormat:@"  * 开户银行"];
                NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
                [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:@"*"]];
                [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:@"*"]];
                cell.label.attributedText = attr;
                cell.rightImage.hidden = YES;
                cell.textField.hidden = NO;
                cell.btn.hidden = YES;
                cell.textField.placeholder = @"请输入开户银行全程";
            }

        }else
        {
            if (self.arefundType) {
                return nil;
            }else
            {
                NSString * str = [NSString stringWithFormat:@"  * 退款说明"];
                NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
                [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:@"*"]];
                [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:@"*"]];
                cell.label.attributedText = attr;
                cell.rightImage.hidden = YES;
                cell.btn.hidden = YES;
                cell.textField.hidden = YES;
                cell.textView.hidden = NO;
            }

        }
    }
    
        return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    if (indexPath.section==0 &&indexPath.row==0) {
        NSArray * array = [[NSArray alloc] initWithObjects:@"仅退款", @"退货退款",nil];
        ApplyForRefundAlertView * alertView = [[ApplyForRefundAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) withDelegate:self withTitle:@"请选择退款类型" withArray:array withIndexPath:indexPath];
        [window addSubview:alertView];
//        NSLog(@"%s",__func__);
    }else if (indexPath.section==0 &&indexPath.row ==1)
    {
        NSArray * array = [[NSArray alloc] initWithObjects:@"7天无理由退换货",@"效果不好/不喜欢",@"假冒品牌",@"功能故障",@"颜色/款式/型号等描述不符",@"商品少件/破损/污渍等",@"其他",nil];
        ApplyForRefundAlertView * alertView = [[ApplyForRefundAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) withDelegate:self withTitle:@"退款原因" withArray:array withIndexPath:indexPath];
        [window addSubview:alertView];
        
    }else if (indexPath.section==1 &&indexPath.row ==0)
    {
        NSArray * array = [[NSArray alloc] initWithObjects:@"退款到支付宝",@"退款到银行卡", nil];
        ApplyForRefundAlertView * alertView = [[ApplyForRefundAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) withDelegate:self withTitle:@"请选择退款方式" withArray:array withIndexPath:indexPath];
        [window addSubview:alertView];
        
    }else
    {
        return;
        //        [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:indexPath];
        //[self.tableView setContentOffset:CGPointMake(0, 120) animated:YES];
    }
    
}
-(void)ApplyForRefundAlertViewBtnClick:(ApplyForRefundAlertView*)view withStr:(NSString *)title withIndexPath:(NSIndexPath*)index withRow:(int)row
{
    if (index.section ==0&&index.row==0){
        
        _row0 = row +1;
        NSString * str = [array0 objectAtIndex:_row0];
        if ([str isEqualToString:@"仅退款"]) {
            self.refunfOrGoods =YES;
        }else
        {
            self.refunfOrGoods = NO;
        }
//        _row2=0;
        NSIndexSet * indexSet = [[NSIndexSet alloc] initWithIndex:0];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        
    }else if (index.section ==0&&index.row==1)
    {
        _row1 = row+1;
        
        NSIndexPath * indexP = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexP] withRowAnimation:UITableViewRowAnimationNone];
    }else if (index.section==1&&index.row==0) {
        
        _row2 = row +1;
        NSString * str = [array2 objectAtIndex:_row2];
        if ([str isEqualToString:@"退到支付宝"]) {
            self.arefundType =YES;
        }else
        {
            self.arefundType = NO;
        }
        NSIndexSet * indexSet = [[NSIndexSet alloc] initWithIndex:1];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 44;
        
    }else
    {
        if (self.arefundType) {
            // 支付宝
            if (indexPath.row==3) {
                return 100;
            }else
            {
                return 44;
            }
        }else
        {
            //银行卡
            if (indexPath.row==4) {
                return 100;
            }else
            {
                return 44;
            }
        }
    }
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y<0) {
        [self.view endEditing:YES];
        
    }
}
#pragma mark --


@end
