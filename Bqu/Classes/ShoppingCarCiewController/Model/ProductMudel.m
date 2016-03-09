//
//  ProductMudel.m
//  Bqu
//
//  Created by yb on 15/10/26.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "ProductMudel.h"

@implementation ProductMudel
+(ProductMudel*)productMudelWithDic:(NSDictionary*)dic
{
    ProductMudel* product = [[ProductMudel alloc]init];
    if (![dic isKindOfClass:[NSNull class]])
    {
        product.orderID = dic[@"id"];
        product.productName = dic[@"id"];
        product.orderID = dic[@"id"];//未完成
        product.amount = dic[@"orderTotalAmount"];
    }
    return product;
}
@end
