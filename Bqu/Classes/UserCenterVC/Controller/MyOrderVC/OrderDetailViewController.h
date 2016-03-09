//
//  OrderDetailViewController.h
//  Bqu
//
//  Created by yingbo on 15/10/21.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "HSViewController.h"
#import "OrderItemCell.h"
#import "OrderDetailFooter.h"
typedef enum
{
    /*默认状态*/
    OrderDetailStatus_default = 0,
    /***待付款状态***/
    OrderDetailStatus_waitpay = 1,
    /***待发货状态***/
    OrderDetailStatus_waitsend = 2,
    /***待收货状态***/
    OrderDetailStatus_waitreceive = 3,
    /***订单完成状态***/
    OrderDetailStatus_complete = 4,
    /***订单关闭状态***/
    OrderDetailStatus_close = 5,
    /***订单完成中的订单评价状态***/
    OrderDetailStatus_evaluate = 6
}OrderDetailStatus;


@interface OrderDetailViewController : HSViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,applyRefundDelegate,OrderDatailFooterDelagate>
/***订单ID***/
@property(nonatomic,strong) NSString *OrderID;
/***主界面表***/
@property (nonatomic,strong) UITableView *tableView;
/***订单状态***/
@property (nonatomic,assign) OrderDetailStatus orderStatus;
/***数据字典***/
@property (nonatomic,strong) NSDictionary *dataDict;
/***数据数组***/
@property (nonatomic,strong) NSMutableArray *dataArray;
/****物流字典**/
@property (nonatomic,strong) NSDictionary *expressDict;
/***物流数组***/
@property (nonatomic,strong) NSArray *expressArr;
/******/
@property (nonatomic,strong) NSDictionary *OrderAuditDic;
/***订单model***/
@property (nonatomic,strong) MyOrder_Model *order;
/***单独存放订单状态之类***/
@property (nonatomic,strong) NSMutableArray *orderStatusDic;

/**<#description#>*/
@property(nonatomic,copy)NSString * productID;

@end
