//
//  OrderProductMudel.m
//  Bqu
//
//  Created by yb on 15/10/26.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "OrderProductMudel.h"

@implementation OrderProductMudel
+(OrderProductMudel*)productMudelWithDic:(NSDictionary*)dic
{
    OrderProductMudel* product = [[OrderProductMudel alloc]init];
    if (![dic isKindOfClass:[NSNull class]])
    {
        product.orderID = dic[@"id"];
        NSArray *array  = dic[@"itemInfo"];
        NSDictionary *dict = array[0];
        product.productDescription =dict[@"productName"] ;//未完成
        product.productName = dict[@"productName"];
        product.amount = dic[@"orderTotalAmount"];
        product.OverSecondTime = dic[@"OverSecondTime"];
    }
    return product;
}

@end
