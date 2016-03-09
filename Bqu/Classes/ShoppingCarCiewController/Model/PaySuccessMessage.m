//
//  PaySuccessMessage.m
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "PaySuccessMessage.h"


//@property (nonatomic)NSString *orderTime;
//@property (nonatomic)NSString *orderId;
//@property (nonatomic)NSString *orderState;
//@property (nonatomic)NSString *payWay;
@implementation PaySuccessMessage
+(PaySuccessMessage*)PaySuccessMessageWithDic:(NSDictionary*)dic
{
    PaySuccessMessage *pay = [[PaySuccessMessage alloc] init];
    if (![dic isKindOfClass:[NSNull class]])
    {
        pay.orderId = dic[@"orderId"];
        pay.orderTime = dic[@"orderTime"];
        pay.orderState = dic[@"orderState"];
        pay.payWay = dic[@"payWay"];
    }
    return pay;
}

+(PaySuccessMessage*)PaySuccessMessageWithDicFromPaySuccess:(NSDictionary*)dic
{
    PaySuccessMessage *pay = [[PaySuccessMessage alloc] init];
    if (![dic isKindOfClass:[NSNull class]])
    {
        pay.orderTime = dic[@"orderDate"];
        pay.orderId = dic[@"id"];
        pay.orderState = dic[@"status"];
        pay.payWay = @"支付宝";
        pay.price =dic[@"orderTotalAmount"];
//        pay.orderId = dic[@"orderId"];
//        pay.orderTime = dic[@"orderTime"];
//        pay.orderState = dic[@"orderState"];
//        pay.payWay = dic[@"payWay"];
    }
    return pay;
}
@end
