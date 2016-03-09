//
//  RefundOrderDetailController.h
//  Bqu
//
//  Created by yb on 15/10/28.
//  Copyright (c) 2015年 yb. All rights reserved.
//售后单详情页

#import <UIKit/UIKit.h>
#import "AfterSaleOrderModel.h"
//因为二次申请售后，必须得传，订单id，和售后单id
@interface RefundOrderDetailController : UIViewController


/**售后单编号*/
@property(nonatomic,copy)NSString * refundId;


/**售后单模型*/
@property(nonatomic,strong)AfterSaleOrderModel * afterMarketmodel;


@end
