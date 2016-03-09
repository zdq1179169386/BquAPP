//
//  CartProductModel.h
//  Bqu
//
//  Created by yb on 15/10/23.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PreferentialModel.h"

@interface CartProductModel : NSObject
@property (nonatomic, copy)NSString *shopId;//店铺编号
@property (nonatomic, copy)NSString *shopName;//店铺名称
@property (nonatomic, copy)NSString *freight;//运费
@property (nonatomic, copy)NSString *isFreeFreight;//是否包邮(false,否；true，是)
@property (nonatomic, copy)NSString *shopFreeFreight;//店铺是否包邮(0,否;1,是)
@property (nonatomic, copy)NSString *tax;//税费
@property (nonatomic)NSArray * cartItemModels;//商品
@property (nonatomic)NSArray * canUseCoupons;//可用优惠券


-(instancetype)initWithDic:(NSDictionary*)dic;
@end
