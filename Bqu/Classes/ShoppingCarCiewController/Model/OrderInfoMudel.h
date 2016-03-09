//
//  OrderInfoMudel.h
//  Bqu
//
//  Created by yb on 15/10/17.
//  Copyright (c) 2015年 yb. All rights reserved.
//  订单模型

#import <Foundation/Foundation.h>

@interface OrderInfoMudel : NSObject
@property (nonatomic,copy)NSString * orderNum;
@property (nonatomic,copy)NSString * orderTime;
@property (nonatomic,copy)NSString * orderPrice;
@property (nonatomic,copy)NSString * orderStatus;
@property (nonatomic,copy)NSArray *  goodsArr;

+(OrderInfoMudel*)orderInfoMudelWithDic:(NSDictionary*)dic;
@end
