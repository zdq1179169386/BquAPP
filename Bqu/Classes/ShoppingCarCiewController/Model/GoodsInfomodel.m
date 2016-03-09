//
//  GoodsInfomodel.m
//  Bqu
//
//  Created by yb on 15/10/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "GoodsInfomodel.h"

@implementation GoodsInfomodel
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if (![dict isKindOfClass:[NSNull class]])
        {
            self.cartItemId = dict[@"cartItemId"];
            self.skuId = dict[@"skuId"];
            self.Id = dict[@"id"] ;
            self.imgUrl = dict[@"imgUrl"];
            self.name = dict[@"name"];
            self.price = dict[@"price"] ;
            self.count = [NSString stringWithFormat:@"%@",dict[@"count"]];
            self.shopId = dict[@"shopId"] ;
            self.shopName = dict[@"shopName"];
            
            self.status = dict[@"status"] ;
            NSString * st =dict[@"isloseproduct"];
            BOOL temp = !st.boolValue;
            self.status = [NSString stringWithFormat:@"%d",temp];
            
            self.tradeType = dict[@"tradeType"];
            self.maxSale = dict[@"maxSale"] ;
            self.taxRate = dict[@"taxRate"] ;
            self.showStatus = dict[@"showStatus"] ;
            if(dict[@"pushcustomsprice"] != nil)
            {
                self.pushCustomsPrice = dict[@"pushcustomsprice"];
            }
            if (dict[@"pushCustomsPrice"] != nil)
            {
                self.pushCustomsPrice = dict[@"pushCustomsPrice"];
            }
            self.preferentialPrice =dict[@"price"] ;
            self.isVirtualProduct = dict[@"isVirtualProduct"];
            
            
            
            
            NSArray *virtualProductArrayDic = dict[@"VirtualProduct"];
            if (virtualProductArrayDic)
            {
                NSMutableArray *temp = [[NSMutableArray alloc] init];
                for (int i = 0 ; i < virtualProductArrayDic.count; i++)
                {
                    NSDictionary * tempDic = virtualProductArrayDic[i];
                    GoodsInfomodel *virtual = [[GoodsInfomodel alloc] init];
                    virtual.skuId =tempDic[@"SkuId"];
                    virtual.count =[NSString stringWithFormat:@"%@",tempDic[@"Quntity"]];
                    virtual.price =tempDic[@"Price"];
                    virtual.pushCustomsPrice =tempDic[@"PushCustomsPrice"];
                    virtual.taxRate =tempDic[@"TaxRate"];
                    [temp addObject:virtual];
                }
                
                self.virtualProductArray = temp;
            }
            if(self.status.boolValue == 0 || (self.tradeType.boolValue == 1 && self.taxRate.integerValue == 0&&self.isVirtualProduct.boolValue== 0) )
            {
                self.selectState = 0;
            }
            else self.selectState = 1;
            
        }
    }
    return  self;
}



+(CGFloat)getAllGoodsPrice:(NSArray*)goodsArray
{
    CGFloat allGoodsPrice = 0.f;
    if (![goodsArray isKindOfClass:[NSNull class]])
    {
        for (int  i = 0 ; i < goodsArray.count ; i++)
        {
            GoodsInfomodel *goods = goodsArray[i];
            
            if (goods.virtualProductArray.count > 0)
            {
                //如果这个商品为虚拟商品 ，就是虚拟商品数组内有个数，只需要计算数组内的所有价格，否则计算改商品价格
                for (int m = 0 ; m < goods.virtualProductArray.count ; m++)
                {
                    GoodsInfomodel *trueGoods = goods.virtualProductArray[m];
                    allGoodsPrice = allGoodsPrice + trueGoods.price.floatValue * trueGoods.count.intValue;
                }
            }
            else allGoodsPrice = allGoodsPrice + goods.price.floatValue * goods.count.intValue;
        }
    }
    return allGoodsPrice;
}
@end
