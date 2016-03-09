//
//  OrderInfoMudel.m
//  Bqu
//
//  Created by yb on 15/10/17.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "OrderInfoMudel.h"
#import "GoodsInfomodel.h"


@implementation OrderInfoMudel


+(OrderInfoMudel*)orderInfoMudelWithDic:(NSDictionary*)dic
{
    OrderInfoMudel *order = [[OrderInfoMudel alloc] init];
    if (![dic isKindOfClass:[NSNull class]])
    {
        order.orderNum = dic[@"orderNum"];
        order.orderPrice = dic[@"orderPrice"];
        order.orderTime = dic[@"orderTime"];
        NSArray * arr = dic[@"goodsArr"];
        NSMutableArray * temp = [[NSMutableArray alloc] init];
        if (arr)
        {
            for ( NSDictionary * dict in arr)
            {
                GoodsInfomodel * goods = [[GoodsInfomodel alloc] initWithDict:dict];
                [temp addObject:goods];
            }
            order.goodsArr = temp;
        }
    }
    return order;
}

@end
