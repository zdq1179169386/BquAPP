//
//  GetShopCarSetterInformation.h
//  Bqu
//
//  Created by yb on 15/10/23.
//  Copyright (c) 2015年 yb. All rights reserved.
// 购物车清单模型

#import <Foundation/Foundation.h>
#import "AddressModel.h"
#import "PreferentialModel.h"
#import "CartProductModel.h"

@class ScoreModel;
@interface GetShopCarSetterInformation : NSObject
@property (nonatomic)NSArray * cartProductModels;//购物车清单
@property (nonatomic)AddressModel * address;//默认地址
@property (nonatomic)ScoreModel* dedMoneyInfo;//消耗积分
@property (nonatomic)NSArray * userCoupons;//优惠券

@property (nonatomic,copy)NSString * totalAmount;//商品总金额
@property (nonatomic,copy)NSString * totalTax;//总关税
@property (nonatomic,copy)NSString * pushCustomsTax ;// 海关推送的关税
@property (nonatomic,copy)NSString * totalFreight;//总运费
@property (nonatomic,copy)NSString * orderAmount;//订单总金额
@property (nonatomic,copy)NSString * amount;//订单额外金额(税费+邮费)



-(instancetype)initWithDic:(NSDictionary*)dic;
@end
