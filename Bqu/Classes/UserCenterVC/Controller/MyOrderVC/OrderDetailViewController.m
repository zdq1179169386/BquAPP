//
//  OrderDetailViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/21.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "ApplyForRefundController.h"
#import "EvaluateViewController.h"
#import "SelsctPayWayViewController.h"
#import "DeliveryViewController.h"
#import "ApplyForRefundAnotherController.h"
#import "RefundOrderDetailController.h"
#import "MyOrderViewController.h"

#import "MyTool.h"

#import "AddressCell.h"
#import "MessageCell.h"
#import "OrderDetailStatusCell.h"
#import "OrderDetailLogisticCell.h"

@interface OrderDetailViewController ()
{
}
@end

@implementation OrderDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self createBackBar];
    [self requestData];
}

#pragma mark    ------------>  请求数据
- (void)requestData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,getOrderDetailUrl];
    NSLog(@"订单详情 %@",urlStr);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"MemberID"] = [UserManager getMyObjectForKey:userIDKey];
    dict[@"token"] = [UserManager getMyObjectForKey:accessTokenKey];
    dict[@"OrderId"] = self.OrderID;
    NSString *realSign = [HttpTool returnForSign:dict];
    dict[@"sign"] = realSign;
    [HttpTool post:urlStr params:dict success:^(id json)
     {
         [self.tableView.header endRefreshing];
         NSLog(@"订单详情的数据: %@",json[@"data"]);
         
         self.dataDict = [NSDictionary dictionary];
         self.dataArray = [NSMutableArray array];
         self.expressDict = [NSDictionary dictionary];
         self.expressArr = [NSArray array];
         self.OrderAuditDic = [NSDictionary dictionary];
         if ((NSNull*)json[@"data"] != [NSNull null])
         {
             self.dataDict = json[@"data"];
             NSArray *array = json[@"data"][@"itemInfo"];
             for (NSDictionary *dataDic in array)
             {
                 OrderDetailItem *orderDetailItem = [OrderDetailItem parseOrderDetailItemWithDictionary:dataDic];
                 [self.dataArray addObject:orderDetailItem];
             }
             self.expressDict = json[@"data"][@"Express"];
             self.expressArr = self.expressDict[@"ExpressDataItems"];
             self.OrderAuditDic = json[@"data"][@"OrderAudit"];
             
             [self.tableView reloadData];
             
         }
     } failure:^(NSError *error)
     {
     }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGB_A(240, 238, 238);
    self.navigationItem.title = @"订单详情";
    //初始化表
    [self initTableView];

}


#pragma mark    ------------>   初始化表

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[AddressCell class] forCellReuseIdentifier:@"address"];
    [self.tableView registerClass:[MessageCell class] forCellReuseIdentifier:@"message"];
    [self.tableView registerClass:[OrderItemCell class] forCellReuseIdentifier:@"orderItem"];
    [self.tableView registerClass:[OrderDetailStatusCell class] forCellReuseIdentifier:@"DetailStatus"];
    [self.tableView registerClass:[OrderDetailLogisticCell class] forCellReuseIdentifier:@"Detaillogisstic"];
    [self.tableView registerClass:[OrderDetailFooter class] forHeaderFooterViewReuseIdentifier:@"footer"];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    //下拉刷新
    self.tableView.header.backgroundColor = [UIColor colorWithHexString:@"#f2f1f1"];
    self.tableView.header = [DIYHeader headerWithRefreshingBlock:^{
        [self requestData];
    }];

}

#pragma mark    ---->  表的代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            AddressCell *cell = (AddressCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.frame.size.height ;
        }
        else
        {
            if (![self.dataDict[@"remark"] isEqualToString:@""])
            {
                MessageCell *cell = (MessageCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
                return cell.frame.size.height ;
            }
            else
            {
                return 0;
            }
        }
    }
    else if(indexPath.section == 1)
    {
        if (indexPath.row < 3)
        {
            return 40;
        }
        else
        {
            return 75;
        }
    }
    else if(indexPath.section == 2)
    {
        if (([self.dataDict[@"orderStatus"] integerValue] == 3 || [self.dataDict[@"orderStatus"] integerValue] == 4))
        {
            return 88;
        }
        return 78;
    }
    
    return 0;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 0.01;
            break;
        case 1:
            return 10;
            break;
        case 2:
            return 35;
            break;
        default:
            break;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 0.01;
            break;
        case 1:
            return 10;
            break;
        case 2:
            if ([self.order.RecycleBin isEqualToString:@"1"])
            {
                return 199;
            }
            return 244;
            break;
        default:
            break;
    }
    return 0;

}


#pragma mark    ---->区头区尾 视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2)
    {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
        headView.backgroundColor = [UIColor whiteColor];
        
        UILabel *address_Lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 15)];
        address_Lab.font = [UIFont boldSystemFontOfSize:11];
        address_Lab.textColor = [UIColor colorWithHexString:@"#555555"];
        address_Lab.text = self.dataDict[@"shopname"];
        [headView addSubview:address_Lab];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0 , 0, ScreenWidth, 1)];
        line1.backgroundColor = [UIColor colorWithHexString:@"#cccccc" alpha:0.5];
        [headView addSubview:line1];

        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 34, ScreenWidth, 1)];
        line2.backgroundColor = [UIColor colorWithHexString:@"#cccccc" alpha:0.5];
        [headView addSubview:line2];

        return headView;
    }
    
   
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2)
    {
        OrderDetailFooter *footer = [[OrderDetailFooter alloc] initWithReuseIdentifier:@"footer" withSection:section];
        [footer setValue:self.dataDict withOrder:self.order];
        footer.delegate = self;
        return footer;
    }
    
    return nil;

}

#pragma mark    ---->  表的数据源


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            if (![self.dataDict[@"remark"] isEqualToString:@""])
            {
                return 2;
            }
            else
            {
                return 1;
            }
        }
            break;
        case 1:
            if ([self.dataDict[@"orderStatus"] integerValue] == 5)
            {
                  return 3;
            }
            return 4;
            break;
        case 2:
        {
            
            return self.dataArray.count;
        }
            break;
        default:
            break;
    }
    return 0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"address"];
            [cell setValue:self.dataDict];

            NSString *str = [NSString stringWithFormat:@"收货地址: %@",self.dataDict[@"address"]];
            CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12] maxW:ScreenWidth- 36 - 28];
            [cell setFrame:CGRectMake(0, 0, ScreenWidth, size.height+76)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            MessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"message"];
            [cell setValue:self.dataDict[@"remark"] ];
            CGSize size = [[NSString stringWithFormat:@"买家留言:%@",self.dataDict[@"remark"]] sizeWithFont:[UIFont systemFontOfSize:12] maxW:ScreenWidth-29-15];
            [cell setFrame:CGRectMake(0, 0, ScreenWidth, size.height+20)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row <3)
        {
            OrderDetailStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailStatus"];

            if (indexPath.row == 0)
            {
                cell.orderStatusLab.text = @"订单状态：";
                cell.orderInfoLab.text = self.dataDict[@"status"];
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
                line.backgroundColor = [UIColor colorWithHexString:@"#cccccc" alpha:0.3];
                [cell.contentView addSubview:line];
            }
            else if (indexPath.row == 1)
            {
                cell.orderStatusLab.text = @"订单金额：";
                cell.orderInfoLab.text = [NSString stringWithFormat:@"￥%0.2f",[self.dataDict[@"orderTotalAmount"] floatValue]];
                cell.orderInfoLab.font = [UIFont boldSystemFontOfSize:12];
                cell.orderInfoLab.textColor = [UIColor colorWithHexString:@"#e8103c"];
                
            }
            else if (indexPath.row == 2)
            {
                cell.orderStatusLab.text = @"订单编号：";
                cell.orderInfoLab.text = [NSString stringWithFormat:@"%@", self.dataDict[@"id"]];
                cell.line.hidden = YES;
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39, ScreenWidth, 1)];
                line.backgroundColor = [UIColor colorWithHexString:@"#cccccc" alpha:0.3];
                [cell.contentView addSubview:line];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
          OrderDetailLogisticCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Detaillogisstic"];
            [cell setValue:self.dataDict];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
          return cell;
        }
        
    }
    else
    {
        OrderItemCell * cell = [tableView dequeueReusableCellWithIdentifier:@"orderItem"];
        OrderDetailItem *item = self.dataArray[indexPath.row];
        [cell setValue:item withRecycle:self.order];
        cell.delegate = self;
        if (indexPath.row == self.dataArray.count-1)
        {
            cell.line.hidden = YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}


#pragma mark
#pragma mark    ----> 申请售后按钮点击事件
- (void)applyRefundButtonClick:(UIButton *)button
{
    OrderItemCell *cell = (OrderItemCell *)[[button superview] superview];
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    OrderDetailItem *item = self.dataArray[path.row];
    
    /**判断是否过了退款时间**/
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    NSString *dieDate = [dateFormatter stringForObjectValue:item.allowRefundDate];
    
    NSComparisonResult  reslt = [strDate compare:dieDate];
   
        if ([item.refundId isKindOfClass:[NSNull class]])
        {
            /**申旭表示还没有过期   **/
            if (reslt == NSOrderedDescending)
            {
                //订单售后按钮
                ApplyForRefundAnotherController * vc = [[ApplyForRefundAnotherController alloc] init];
                vc.orderId = self.dataDict[@"id"];
                vc.RefundType = @"1";
                vc.OrderItemId = item.Id;
                vc.itemCount = item.count;
                vc.itemPrice  = item.price;
                vc.isTwiceApplyForRefund = NO;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [TipView remindAnimationWithTitle:@"已经过了售后时间哦"];
            }
        }
        else
        {
            //查看售后
            RefundOrderDetailController *refundVC = [[RefundOrderDetailController alloc] init];
            refundVC.refundId = item.refundId;
            refundVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:refundVC animated:YES];
        }

}
#pragma mark
#pragma mark  --------> 区尾上的两个按钮
- (void)detailfooter:(NSInteger)section withBtn:(UIButton *)button
{
    
    switch (button.tag)
    {
        case 1000:
        {
            switch ([self.dataDict[@"orderStatus"] integerValue])
            {
                case 1:
                    
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"取消订单？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                    alertView.tag = 2235;
                    [alertView show];
                    
                    NSLog(@"取消订单按钮");
                }
                    break;
                case 3:
                    
                {
                    DeliveryViewController *deliveryVC = [[DeliveryViewController alloc] init];
                    deliveryVC.hidesBottomBarWhenPushed = YES;
                    deliveryVC.orderID = self.dataDict[@"id"];
                    [self.navigationController pushViewController:deliveryVC animated:NO];                    NSLog(@"物流跟踪按钮");
                }
                    break;
                case 4:
                    
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"删除订单？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                    alertView.tag = 2236;
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
            
            switch ([self.dataDict[@"orderStatus"] integerValue])
            {
                case 1:
                    
                {
                    
                    SelsctPayWayViewController *paylVC = [[SelsctPayWayViewController alloc] init];
                    paylVC.orderID = self.dataDict[@"id"];
                    paylVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:paylVC animated:NO];
                    NSLog(@"立即支付按钮");
                }
                    break;
                case 2:
                    
                {
                    
                    NSDictionary *dd = [NSDictionary dictionary];
                    dd = self.dataDict[@"OrderRefund"];
                    NSString *idStr = [NSString stringWithFormat:@"%@",dd[@"Id"]];
                    if ([idStr isEqualToString:@"0"])
                    {
                        //订单退款按钮
                        ApplyForRefundController * vc = [[ApplyForRefundController alloc] init];
                        vc.orderId = self.dataDict[@"id"];
                        vc.RefundType = @"1";
                        vc.totalAcount = [NSString stringWithFormat:@"%lu",(unsigned long)self.dataArray.count ];
                        vc.model = self.order;
                        [self.navigationController pushViewController:vc animated:NO];
                    }
                    else
                    {
                        //查看售后
                        RefundOrderDetailController *refundVC = [[RefundOrderDetailController alloc] init];
                        refundVC.refundId = idStr;
                        refundVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:refundVC animated:YES];
                        
                    }
                    
                    NSLog(@"订单退款按钮");
                }
                    break;
                case 3:
                    
                {
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认付款" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                    alertView.tag = 2234;
                    [alertView show];
                    
                    NSLog(@"确认收货按钮");
                }
                    break;
                case 4:
                    
                {
                    NSString *commentCount = [NSString stringWithFormat:@"%@",self.dataDict[@"commentCount"]];
                    if ([commentCount isEqualToString:@"0"])
                    {
                        EvaluateViewController *evaluVC = [[EvaluateViewController alloc] init];
                        evaluVC.hidesBottomBarWhenPushed = YES;
                        evaluVC.orderID = self.dataDict[@"id"];
                        evaluVC.order = self.order;
                        
                        [self.navigationController pushViewController:evaluVC animated:NO];
                        NSLog(@"立即评价按钮");
                        
                    }
                    else{
                        [HttpEngine deleteOrderWithorderId:self.dataDict[@"id"] success:^(id json)
                         {
                             [self hideLoadingView];
                             NSLog(@"删除订单 = %@",json);
                             NSLog(@"message = %@",json[@"message"]);
                             [TipView remindAnimationWithTitle:json[@"message"]];
                             [self requestData];
                             
                             
                         } failure:^(NSError *error) {
                             [self hideLoadingView];
                         }];

                    }
                }
                    break;
                    
                case 5:
                    
                {
                    [HttpEngine deleteOrderWithorderId:self.dataDict[@"id"] success:^(id json)
                     {
                         [self hideLoadingView];
                         NSLog(@"删除订单 = %@",json);
                         NSLog(@"message = %@",json[@"message"]);
                         [TipView remindAnimationWithTitle:json[@"message"]];
                         [self requestData];
                         
                     } failure:^(NSError *error) {
                         [self hideLoadingView];
                     }];
                }
                default:
                    break;
            }
        }
    }
 
}
- (void)footButtonClick:(UIButton *)button
{
    switch (button.tag)
    {
        case 1000:
        {
            switch ([self.dataDict[@"orderStatus"] integerValue])
            {
                case 1:
                    
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"取消订单？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                    alertView.tag = 2235;
                    [alertView show];
                    
                    NSLog(@"取消订单按钮");
                }
                    break;
                case 3:
                    
                {
                    DeliveryViewController *deliveryVC = [[DeliveryViewController alloc] init];
                    deliveryVC.hidesBottomBarWhenPushed = YES;
                    deliveryVC.orderID = self.dataDict[@"id"];
                    [self.navigationController pushViewController:deliveryVC animated:NO];                    NSLog(@"物流跟踪按钮");
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1001:
        {
            
            switch ([self.dataDict[@"orderStatus"] integerValue])
            {
                case 1:
                    
                {
                    SelsctPayWayViewController *paylVC = [[SelsctPayWayViewController alloc] init];
                    paylVC.orderID = self.dataDict[@"id"];
                    paylVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:paylVC animated:NO];
                    NSLog(@"立即支付按钮");
                }
                    break;
                case 2:
                    
                {
                    
                    NSDictionary *dd = [NSDictionary dictionary];
                    dd = self.dataDict[@"OrderRefund"];
                    NSString *idStr = [NSString stringWithFormat:@"%@",dd[@"Id"]];
                    if ([idStr isEqualToString:@"0"])
                    {
                        //订单退款按钮
                        ApplyForRefundController * vc = [[ApplyForRefundController alloc] init];
                        NSLog(@"订单退款按钮==%@",self.dataDict[@"id"]);
                        vc.orderId = self.dataDict[@"id"];
                        vc.RefundType = @"1";
                        vc.totalAcount = [NSString stringWithFormat:@"%lu",(unsigned long)self.dataArray.count ];
                        vc.model = self.order;
                        [self.navigationController pushViewController:vc animated:NO];
                    }
                    else
                    {
                        //查看售后
                        RefundOrderDetailController *refundVC = [[RefundOrderDetailController alloc] init];
                        refundVC.refundId = idStr;
                        refundVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:refundVC animated:YES];

                    }

                    NSLog(@"订单退款按钮");
                }
                    break;
                case 3:
                    
                {
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认付款" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                    alertView.tag = 2234;
                    [alertView show];
                    
                    NSLog(@"确认收货按钮");
                }
                    break;
                case 4:
                    
                {
                    NSString *commentCount = [NSString stringWithFormat:@"%@",self.dataDict[@"commentCount"]];
                    if ([commentCount isEqualToString:@"0"])
                    {
                        EvaluateViewController *evaluVC = [[EvaluateViewController alloc] init];
                        evaluVC.hidesBottomBarWhenPushed = YES;
                        evaluVC.orderID = self.dataDict[@"id"];
                        evaluVC.order = self.order;
                        
                        [self.navigationController pushViewController:evaluVC animated:NO];
                        NSLog(@"立即评价按钮");

                    }
              }
                    break;
                    
                default:
                    break;
            }
        }
    }

}
#pragma mark
#pragma mark    ---->确认收货
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (alertView.tag == 2234)
    {
        if (buttonIndex == 1)
        {
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,surePayUrl];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"MemberID"] = [UserManager getMyObjectForKey:userIDKey];
            dict[@"token"] = [UserManager getMyObjectForKey:accessTokenKey];
            dict[@"OrderId"] =  self.dataDict[@"id"];
            dict[@"MemberName"] = [UserManager getMyObjectForKey:userNameKey];
            
            NSString *realSign = [HttpTool returnForSign:dict];
            dict[@"sign"] = realSign;
            [self showLoadingView];
            
            [HttpTool post:urlStr params:dict success:^(id json)
             {
                 [self hideLoadingView];
                 NSLog(@"data的数据: %@",json[@"data"]);
                 NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
                 if ([resultStr isEqualToString:@"0"])
                 {
                     EvaluateViewController *evaluVC = [[EvaluateViewController alloc] init];
                     evaluVC.hidesBottomBarWhenPushed = YES;
                     evaluVC.orderID = self.dataDict[@"id"];
                     evaluVC.order = self.order;
                     [self.navigationController pushViewController:evaluVC animated:NO];
                     
                     NSLog(@"立即评价按钮");
                 }
                 
             } failure:^(NSError *error)
             {
                 
             }];
        }

    }
    else if (alertView.tag == 2235)
    {
        
        /** zxd 修改了 判断是否点击确定*/
        if(buttonIndex == 1)
        {
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,cancelPayUrl];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"MemberID"] = [UserManager getMyObjectForKey:userIDKey];
            dict[@"token"] = [UserManager getMyObjectForKey:accessTokenKey];
            dict[@"OrderId"] = self.dataDict[@"id"];
            dict[@"MemberName"] = [UserManager getMyObjectForKey:userNameKey];
            
            NSString *realSign = [HttpTool returnForSign:dict];
            dict[@"sign"] = realSign;
            [self showLoadingView];
            
            [HttpTool post:urlStr params:dict success:^(id json)
             {
                 [self hideLoadingView];
                 
                 NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
                 if ([resultStr isEqualToString:@"0"])
                 {
                     [self requestData];
                 }
                 
             } failure:^(NSError *error)
             {
                 
             }];
        }
    }
    else if (alertView.tag == 2236 )
    {
        if (buttonIndex == 1)
        {
            [HttpEngine deleteOrderWithorderId:self.order.Id success:^(id json)
             {
                 [self hideLoadingView];
                 NSLog(@"删除订单 = %@",json);
                 NSLog(@"message = %@",json[@"message"]);
                 [TipView remindAnimationWithTitle:json[@"message"]];
                 [TipView doSomething:^{
                     [self.navigationController popViewControllerAnimated:NO];
                 } afterDelayTime:1];
                 
                 
             } failure:^(NSError *error) {
                 [self hideLoadingView];
             }];
        }
    }


}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        if (indexPath.row == 3)
        {
            NSString *sss = [NSString stringWithFormat:@"%@",self.dataDict[@"orderStatus"]];
            NSLog(@"sss%@",sss);
            if ([sss isEqualToString:@"1"] || [sss isEqualToString:@"2"])
            {
                /**海关状态没有快递,所以就不让跳转到快递页面**/
            }
            else
            {
                DeliveryViewController *deliveryVC = [[DeliveryViewController alloc] init];
                self.hidesBottomBarWhenPushed = YES;
                deliveryVC.orderID = self.dataDict[@"id"];
                [self.navigationController pushViewController:deliveryVC animated:NO];
            }


        }
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

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
