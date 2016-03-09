//
//  PaySuccessMessage.h
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//  支付成功之后返回的数据 模型

#import <Foundation/Foundation.h>

@interface PaySuccessMessage : NSObject
@property (nonatomic,copy)NSString *orderTime;
@property (nonatomic,copy)NSString *orderId;
@property (nonatomic,copy)NSString *orderState;
@property (nonatomic,copy)NSString *payWay;
@property (nonatomic,copy)NSString *price;

+(PaySuccessMessage*)PaySuccessMessageWithDic:(NSDictionary*)dic;

+(PaySuccessMessage*)PaySuccessMessageWithDicFromPaySuccess:(NSDictionary*)dic;
@end
