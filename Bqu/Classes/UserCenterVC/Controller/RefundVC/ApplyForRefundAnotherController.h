//
//  ApplyForRefundAnotherController.h
//  Bqu
//
//  Created by yb on 15/10/27.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyForRefundAnotherController : UIViewController


/**可退金额*/
@property(nonatomic,strong)NSString * totalCount;


/** 退货数量*/
@property(nonatomic,strong)NSString * itemCount;

/** 商品de单价*/
@property(nonatomic,strong)NSString * itemPrice;
/**商品id*/
@property(nonatomic,strong)NSString * orderId;


/**<#description#>*/
@property(nonatomic,copy)NSString * RefundType;


/**退款金额*/
@property(nonatomic,copy)NSString * money;


/**商品的id*/
@property(nonatomic,copy)NSString * productId;

/**主键id*/
@property (nonatomic,copy) NSString * OrderItemId;


/**是否是二次申请售后*/
@property(nonatomic,assign)BOOL  isTwiceApplyForRefund;


/**重复售后传当前售后单号,否则传0*/
@property(nonatomic,copy)NSString * ParentRefundId;

@end
