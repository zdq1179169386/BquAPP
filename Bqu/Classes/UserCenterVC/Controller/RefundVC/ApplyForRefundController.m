//
//  ApplyForRefundController.m
//  Bqu
//
//  Created by yb on 15/10/26.
//  Copyright (c) 2015年 yb. All rights reserved.
//订单退款页面

#import "ApplyForRefundController.h"
#import "ApplyForRefundCell.h"
#import "ApplyForRefundAlertView.h"
#import "RefundOrderDetailController.h"
//#import "IQKeyboardManager.h"
@interface ApplyForRefundController ()<UITableViewDataSource,UITableViewDelegate,ApplyForRefundCellDelegate,UITextFieldDelegate>
{
    int  _row;
     int  _row2;
    NSArray * array1;
    NSArray * array2;
    NSArray * array3;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
    NSArray * array4;
    
    NSTimer *timer;

}
@property (nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong) UIView * buttomView;
/**yes是支付宝，no是银行卡*/
@property(nonatomic,assign) BOOL  arefundType;

/**最大可退金额*/
@property(nonatomic,copy) NSString * MaxRefundAmount;

/**<#property#>*/
//@property (nonatomic,strong)IQKeyboardManager * returnKeyHandler;


@end

@implementation ApplyForRefundController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
#pragma mark --
-(void)keyboardWillChangeFrame:(NSNotification *)notify
{
    CGRect keyboardF = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"%@",NSStringFromCGRect(keyboardF));
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

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

    [self requestForRefundAmount];
}
#pragma mark -- 获取最大可退金额
-(void)requestForRefundAmount
{
    NSString * urlStr1 = [NSString stringWithFormat:@"%@/API/Order/Refund/GetAllow",TEST_URL];
    NSString * memberID = [UserManager getMyObjectForKey:userIDKey];
    NSString * token = [UserManager getMyObjectForKey:accessTokenKey];

    NSMutableDictionary * dict1 = [NSMutableDictionary dictionary];
    
    if (memberID && token &&self.orderId) {
      
        dict1[@"orderId"] = self.orderId;
        dict1[@"orderItemId"] = @"0";
        dict1[@"parentRefundId"] = @"0";
        dict1[@"MemberID"] = memberID;
        dict1[@"token"] = token;
        
        NSString * sign1 = [HttpTool returnForSign:dict1];
        
        NSMutableDictionary * dict2 = [[NSMutableDictionary alloc] initWithDictionary:dict1];
        dict2[@"sign"] = sign1;
        NSLog(@"%@,%@",dict1,dict2);
        [HttpTool post:urlStr1 params:dict2 success:^(id json) {
            NSLog(@"最大退款金额%@",json[@"data"]);
            if (!json[@"error"]) {
                NSDictionary * dic = json[@"data"];
               NSString * maxAmount = [dic objectForKey:@"MaxRefundAmount"];
                self.MaxRefundAmount = [NSString stringWithFormat:@"%.2f",maxAmount.doubleValue];
                NSLog(@"%@",self.MaxRefundAmount);
                
            }else{
                
                
            }
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            
        }];
    }

}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initTable
{
    self.title = @"订单退款";
    UIButton * backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50)];
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
    _row = 0;
    array1 = [[NSArray alloc] initWithObjects:@"请选择退款原因",@"7天无理由退换货",@"效果不好/不喜欢",@"假冒品牌",@"功能故障",@"颜色/款式/型号等描述不符",@"商品少件/破损/污渍等",@"其他",nil];
    _row2 = 0;
    array2 = [[NSArray alloc] initWithObjects:@"请选择退款方式",@"退到支付宝",@"退到银行卡",nil];
 
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    
   
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-64-50, ScreenWidth, 50)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, ScreenWidth-10, 40)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"提交申请" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 5;
    btn.clipsToBounds = YES;
    [view addSubview:btn];
    
    UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    [view addSubview:line];
    
    self.arefundType = YES;
}
#pragma mark -- 提交退款申请
-(void)btnClick:(UIButton *)btn
{
    //跳到售后单详情页,要将售后单号传过去
//    RefundOrderDetailController * vc = [[RefundOrderDetailController alloc] init];
//      [self.navigationController pushViewController:vc animated:YES];
//   return;
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

    
    if ([cell1.btn.text isEqualToString:@"请选择退款原因"]) {
        [ProgressHud addProgressHudWithView:self.view andWithTitle:@"请选择退款原因" withTime:1.5 withType:MBProgressHUDModeText];

        return;
    }
    if ([cell1_0.btn.text isEqualToString:@"请选择退款方式"]) {
         [ProgressHud addProgressHudWithView:self.view andWithTitle:@"请选择退款方式" withTime:1.5 withType:MBProgressHUDModeText];
        return;
    }


        NSLog(@"======%@",cell1_4.textView.text);
        //仅退款，这个页面只有仅退款
        NSString * urlStr1 = [NSString stringWithFormat:@"%@/api/order/Refund/Add",TEST_URL];
        NSString * memberID = [UserManager getMyObjectForKey:userIDKey];
        NSString * token = [UserManager getMyObjectForKey:accessTokenKey];
        NSString * userName = [UserManager getMyObjectForKey:userNameKey];
//        NSLog(@"%@",userName);
        if (self.arefundType) {//退到支付宝
            
            if (cell2.textField.text.length==0 || cell3.textField.text.length==0 || cell1_1.textField.text.length==0||cell1_2.textField.text.length==0 || cell1_3.textView.text.length==0)
            {
                
                [ProgressHud addProgressHudWithView:self.view andWithTitle:@"请补全信息" withTime:1.5 withType:MBProgressHUDModeText];

                return;
            }
            
            NSMutableDictionary * dict1 = [NSMutableDictionary dictionary];
            
                 if (memberID && token) {
                    dict1[@"OrderId"] = self.orderId;
                    dict1[@"RefundType"] = @"1";
                    dict1[@"Reason"] = cell1.btn.text;
                    dict1[@"Amount"] = cell2.textField.text;
                    dict1[@"ReturnQuantity"] = @"0";
                    dict1[@"Payee"] = cell1_2.textField.text;
                    dict1[@"ContactCellPhone"] = cell3.textField.text;
                    dict1[@"PayeeAccount"] = cell1_1.textField.text;
                    dict1[@"RefundAccount"] = cell1_0.btn.text;
                    dict1[@"OrderItemId"] = @"0";
                    dict1[@"ParentRefundId"] = @"0";
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
                        
                        NSLog(@"退到支付宝__%@",json);
                       
                        if (!json[@"error"]) {
                           
                            NSString * str = json[@"message"];
                            
                            if ([str isEqualToString:@"操作成功"]) {
                                NSDictionary * dic = json[@"data"];
                                
                                [ProgressHud addProgressHudWithView:self.view andWithTitle:str withTime:1 withType:MBProgressHUDModeText];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)),
                                               dispatch_get_main_queue(), ^{
                                                [ProgressHud hideProgressHudWithView:self.view];
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
                            
                           
                        }
                     } failure:^(NSError *error) {
                        
                     }];
                }
         
            }else
            {//退到银行卡
                

                if (cell2.textField.text.length==0 || cell3.textField.text.length==0 || cell1_1.textField.text.length==0||cell1_2.textField.text.length==0 || cell1_3.textField.text.length==0 ||cell1_4.textView.text.length==0)
                {
                    
                    [ProgressHud addProgressHudWithView:self.view andWithTitle:@"请补全信息" withTime:1.5 withType:MBProgressHUDModeText];
                    
                    return;
                }
                
                if (memberID && token) {
                    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                    
//                    NSLog(@"%@,%@,%@",self.model.Id,self.model.orderTotalAmount);
//                    NSLog(@"%@,%@,%@,%@,%@,%@",cell2.textField.text,cell3.textField.text,cell5.textField.text,cell6.textField.text,cell7.textField.text,cell8.textView.text);

                    dic[@"OrderId"] = self.orderId;
                    dic[@"RefundType"] = @"1";
                    dic[@"Reason"] = cell1.btn.text;
                    dic[@"Amount"] = cell2.textField.text;
                    dic[@"ReturnQuantity"] = @"0";
                    dic[@"Payee"] = cell1_2.textField.text;
                    dic[@"ContactCellPhone"] = cell3.textField.text;
                    dic[@"PayeeAccount"] = cell1_1.textField.text;
                    dic[@"RefundAccount"] = cell1_0.btn.text;
                    dic[@"OrderItemId"] = @"0";
                    dic[@"ParentRefundId"] = @"0";
                    dic[@"MemberID"] = memberID;
                    dic[@"UserName"] = userName;
                    dic[@"GoodsReturnRemark"] = cell1_4.textView.text;
                    dic[@"token"] = token;
                    dic[@"BankName"] = cell1_3.textField.text;
                    NSString * sign1 = [HttpTool returnForSign:dic];
                    
                    NSMutableDictionary * dict2 = [[NSMutableDictionary alloc] initWithDictionary:dic];
                    dict2[@"sign"] = sign1;
//                    dict2[@"BankName"] = cell6.textField.text;
                    dict2[@"RefundMoneyReMark"] = @"";
                    NSLog(@"%@,%@",dic,dict2);
                    [HttpTool post:urlStr1 params:dict2 success:^(id json) {
                        
                        NSLog(@"退到银行卡__%@,__%@",json[@"message"],json);
                        if (!json[@"error"]) {
                            
                            NSString * str = json[@"message"];
                            
                            if ([str isEqualToString:@"操作成功"]) {
                                NSDictionary * dic = json[@"data"];
                                [ProgressHud addProgressHudWithView:self.view andWithTitle:str withTime:1 withType:MBProgressHUDModeText];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)),
                                               dispatch_get_main_queue(), ^{
                                                   [ProgressHud hideProgressHudWithView:self.view];
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
                            
                        }else
                        {
                           
                        }
                    } failure:^(NSError *error) {
                        
                    }];
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 4;
    }else
    {
        if (self.arefundType) {
            //支付宝
            return 4;
            
        }else
        {
            //银行卡
            return 5;
        }

    }
    return 0;
  
}

    
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ApplyForRefundCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate = self;
//    cell.textField.text = nil;
//    cell.textView.text = nil;
    cell.textField.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.label.text = [array4 objectAtIndex:indexPath.row];
    if (indexPath.section==0) {
        
        if (indexPath.row==0) {
            NSString * str = [NSString stringWithFormat:@"  * 服务类型"];
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:@"*"]];
            [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:@"*"]];
            cell.label.attributedText = attr;
            cell.btn.text = @"仅退款";
            cell.btn.textColor = [UIColor redColor];
            return cell;
        }else if(indexPath.row ==1)
        {
            
            NSString * str = [NSString stringWithFormat:@"  * 退款原因"];
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:@"*"]];
            [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:@"*"]];
            cell.label.attributedText = attr;
            NSLog(@"%d",_row);
            cell.textView.hidden = YES;
            cell.textField.hidden = YES;
            cell.btn.hidden = NO;
            cell.btn.text = [array1 objectAtIndex:_row];
            
            return cell;
        }else if (indexPath.row==2)
        {
            NSString * str = [NSString stringWithFormat:@"  * 退款金额"];
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:@"*"]];
            [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:@"*"]];
            cell.label.attributedText = attr;
            cell.rightImage.hidden = YES;
            cell.btn.hidden = YES;
            cell.textField.hidden = NO;
            cell.textField.placeholder = [NSString stringWithFormat:@"最多%@元",self.MaxRefundAmount];
            
            
        }else if (indexPath.row==3)
        {
            NSString * str = [NSString stringWithFormat:@"  * 联系电话"];
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:@"*"]];
            [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:@"*"]];
            cell.label.attributedText = attr;
            cell.rightImage.hidden = YES;
            cell.btn.hidden = YES;
            cell.textField.hidden = NO;
            cell.textField.placeholder = @"请输入联系电话";
        }
    
    }else
    {
            if (indexPath.row==0)
            {
                NSString * str = [NSString stringWithFormat:@"  * 退款方式"];
                NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
                [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:@"*"]];
                [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:@"*"]];
                cell.label.attributedText = attr;
                cell.textField.hidden = YES;
                cell.textView.hidden = YES;
                cell.btn.hidden = NO;
                cell.btn.text = [array2 objectAtIndex:_row2];
                
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
    NSLog(@"1111%s",__func__);
    
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    if (indexPath.section==0 && indexPath.row==0) {
        NSArray * array = [[NSArray alloc] initWithObjects:@"仅退款", nil];
        ApplyForRefundAlertView * alertView = [[ApplyForRefundAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) withDelegate:self withTitle:@"请选择退款类型" withArray:array withIndexPath:indexPath];
        [window addSubview:alertView];
        NSLog(@"%s",__func__);
    }else if (indexPath.section==0 &&indexPath.row ==1)
    {
        NSArray * array = [[NSArray alloc] initWithObjects:@"7天无理由退换货",@"效果不好/不喜欢",@"假冒品牌",@"功能故障",@"颜色/款式/型号等描述不符",@"商品少件/破损/污渍等",@"其他",nil];
        ApplyForRefundAlertView * alertView = [[ApplyForRefundAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) withDelegate:self withTitle:@"退款原因" withArray:array withIndexPath:indexPath];
        [window addSubview:alertView];
        
    }else if (indexPath.section==1 && indexPath.row ==0)
    {
        NSArray * array = [[NSArray alloc] initWithObjects:@"退款到支付宝",@"退款到银行卡", nil];
        ApplyForRefundAlertView * alertView = [[ApplyForRefundAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) withDelegate:self withTitle:@"请选择退款方式" withArray:array withIndexPath:indexPath];
        [window addSubview:alertView];

    }else
    {
        return;
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
-(void)ApplyForRefundAlertViewBtnClick:(ApplyForRefundAlertView*)view withStr:(NSString *)title withIndexPath:(NSIndexPath*)index withRow:(int)row

{
//    NSLog(@"%d,%d,%d",row,index.section,index.row);
    if (index.section==0 && index.row ==0){
        
    }else if (index.section==0 && index.row ==1)
    {
        _row = row+1;
        
        NSIndexPath * index = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationNone];
        
    }else if (index.section==1 && index.row==0) {
        
        _row2 = row +1;
        NSString * str = [array2 objectAtIndex:_row2];
        if ([str isEqualToString:@"退到支付宝"]) {
            self.arefundType =YES;
        }else
        {
            self.arefundType = NO;
        }
        NSIndexSet * index = [[NSIndexSet alloc] initWithIndex:1];
        [self.tableView reloadSections:index withRowAnimation:UITableViewRowAnimationNone];
    }
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<0) {
            [self.view endEditing:YES];

    }
}
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
//{
//    //NSLog(@"%s",__func__ );
//    ApplyForRefundCell * cell = (ApplyForRefundCell *)textField.superview.superview;
//    NSIndexPath * index = [self.tableView indexPathForCell:cell];
//     NSLog(@"---%ld,%ld",index.row,index.section);
//    if (index.section==1) {
//            [self.tableView setContentOffset:CGPointMake(0, 120) animated:YES];
//
//    }
//    return YES;
//}

@end
