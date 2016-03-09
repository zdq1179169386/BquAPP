//
//  ApplyForRefundController.h
//  Bqu
//
//  Created by yb on 15/10/26.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MyOrder_Model"
@interface ApplyForRefundController : UIViewController


/**RefundType退款类型（1，仅退款；2，退货退款；）*/
@property(nonatomic,strong)NSString * RefundType;


/**OrderItemId 订单商品编号(订单退款:0;售后传订单商品编号)*/
@property(nonatomic,strong)NSString * OrderItemId;


/**ReturnQuantity退货数量*/
@property(nonatomic,copy)NSString * ReturnQuantity;


/**我的订单模型*/
@property(nonatomic,strong)MyOrder_Model * order;


/**订单编号*/
@property(nonatomic,copy)NSString * orderId;


/**<#description#>*/
@property(nonatomic,copy)NSString * totalAcount;



/**订单模型*/
@property(nonatomic,strong)MyOrder_Model * model;




@end
