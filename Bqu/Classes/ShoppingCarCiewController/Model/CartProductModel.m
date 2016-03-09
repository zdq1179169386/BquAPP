//
//  CartProductModel.m
//  Bqu
//
//  Created by yb on 15/10/23.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "CartProductModel.h"
#import "GoodsInfomodel.h"

@implementation CartProductModel

-(instancetype)initWithDic:(NSDictionary*)dic
{
    if (self = [super init])
    {
        if (![dic isKindOfClass:[NSNull class]])
        {
            self.shopId = dic[@"shopId"];
            self.shopName = dic[@"ShopName"];
            self.freight = dic[@"Freight"];
            self.isFreeFreight = dic[@"isFreeFreight"];
            self.shopFreeFreight = dic[@"shopFreeFreight"];
            self.tax = dic[@"Tax"];
            
            NSArray *  temp = dic[@"CartItemModels"];
            NSMutableArray * goodsArray = [[NSMutableArray alloc] init];
    
            for (int i = 0;  i< temp.count ; i++)
            {
                NSDictionary * goodsDic = temp[i];
                GoodsInfomodel * goodsmModel = [[GoodsInfomodel alloc] initWithDict:goodsDic];
                [goodsArray addObject:goodsmModel];
            }
            self.cartItemModels = goodsArray;
            
            NSMutableArray * tempArray = [[NSMutableArray alloc] init];
            NSArray * CouponsArray = dic[@"CanUseCoupons"];
            for (int  i = 0 ;i <  CouponsArray.count ;i++ )
            {
                PreferentialModel * coupon = [PreferentialModel preferentialModelWithDict:CouponsArray[i]];
                [tempArray addObject: coupon ];
            }
            self.canUseCoupons = tempArray;
        }
    }
    return self;
}
@end
