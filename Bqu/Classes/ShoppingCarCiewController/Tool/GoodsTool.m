//
//  GoodsTool.m
//  Bqu
//
//  Created by yb on 15/10/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "GoodsTool.h"
#import "GoodsInfomodel.h"
#import "ScoreModel.h"
#import <math.h>

@implementation GoodsTool


-(instancetype)initWithArray:(NSArray *)allGoods
{
    if(self = [super init ])
    {
        _allGoods = allGoods;
    }
    return self;
}

-(NSInteger)selectGoodsNum
{
    NSInteger num = 0;
    for (GoodsInfomodel * goods in _allGoods)
    {
        if (goods.selectState )
        {
            num = num + [goods.count integerValue];
        }
    }
    return num;
}

-(double)selectgoodsPrice
{
    double price = 0.f;
    for (GoodsInfomodel * goods in _allGoods)
    {
        if (goods.selectState )
        {
            price = price + ([goods.count integerValue] * [goods.price doubleValue]);
        }
    }
    return price;

}


-(double)selectGoodsTax
{
    double tax = 0.f;
    for (GoodsInfomodel * goods in _allGoods)
    {
        if (goods.selectState )
        {
            //如果是E贸易，就需要加上关税 。否则就是一般贸易。不用加关税 ，正常价格计算关税
            if (goods.tradeType.boolValue == 1)
            {
                tax = tax + ([goods.count integerValue] * [goods.price doubleValue] * [goods.taxRate integerValue]/100.0);
                NSString * taxString = [NSString stringWithFormat:@"%0.2f",tax];
                tax = taxString.doubleValue;
            }
        }
    }
    if (tax <= 50)
        return 0;
    return tax;
}


-(double)selectCustomsGoodsTax
{//获取海关推送的关税；
    double tax = [self selectCustomsGoodsTaxTure];
        if (tax <= 50)
        return 0;
    return tax;
}

-(double)selectCustomsGoodsTaxTure//获取海关推送的关税包括小于50，也显示；
{
    double tax = 0.f;
    for (GoodsInfomodel * goods in _allGoods)
    {
        if (goods.selectState )
        {
            //如果是E贸易，就需要加上关税 。否则就是一般贸易。不用加关税  ,这是按照海关推送价格计算关税
            if (goods.tradeType.boolValue == 1)
            {
                tax = tax + ([goods.count integerValue] * [goods.pushCustomsPrice doubleValue] * [goods.taxRate integerValue]/100.0);
                NSString * taxString = [NSString stringWithFormat:@"%0.2f",tax];
                tax = taxString.doubleValue;
            }
        }
    }
    return tax;
}


-(double)tureTax
{
    double tax ;
    if ([self selectGoodsTax] > [self selectCustomsGoodsTax])
    {
        tax = [self selectCustomsGoodsTax];
    }
    else tax = [self selectGoodsTax];
    if (tax <= 50 )
    {
        tax = 0;
    }
    return tax;
}


-(double)selectGoodsFreight {
    return 6;
}



-(double)selectAllPrice {
        return [self selectgoodsPrice]+ [self selectCustomsGoodsTax];
}

-(BOOL)isOutOfPrice
{
    if (_allGoods != nil) //如果不为空
    {
        GoodsInfomodel *goods = _allGoods[0];
        if (( goods.tradeType.boolValue &&([self selectgoodsPrice ] +[self selectCustomsGoodsTax]) <= 1000) || (_allGoods.count ==1 && goods.count.integerValue==1)) {
            return NO;
        }
        else return YES;
    }
    return NO;
}

+(double)getPriceFromOrder:(GetShopCarSetterInformation*)shopCar
{
    double allGoodsPrice = 0;
    for (int i = 0 ; i < shopCar.cartProductModels.count; i++)
    {
        CartProductModel *cartProductModel = shopCar.cartProductModels[i];
        allGoodsPrice = allGoodsPrice + [GoodsInfomodel getAllGoodsPrice:cartProductModel.cartItemModels];
        NSString * allGoodsPriceString = [NSString stringWithFormat:@"%0.2f",allGoodsPrice];
        allGoodsPrice = allGoodsPriceString.doubleValue;
    }
    return allGoodsPrice;
}


+(double)getTruePrice:(GetShopCarSetterInformation*)shopCar  {//总付款价格..
    //CartProductModel *cartProductModel  = shopCar.cartProductModels[0];
    
    CGFloat price = [GoodsTool getPriceFromOrder:shopCar ] + shopCar.totalFreight.doubleValue + [GoodsTool getCustomsGoodsTaxFromArray:shopCar] -[PreferentialModel getCouponPrice:shopCar.userCoupons];
    if (shopCar.dedMoneyInfo.isUse)
    {
        price -=[ScoreModel getMaxMoney:shopCar];
    }
    return   price;
    
}



+(double)getGoodsTaxFromArray:(GetShopCarSetterInformation*)shopCar //获得数组内商品的关税
{
    //总优惠
    double disCountPrice = [PreferentialModel getCouponPrice:shopCar.userCoupons] + [ScoreModel getMaxMoney:shopCar];
    //百分之优惠
    double percentageDisCountPrice = 0;
    if( [GoodsTool getPriceFromOrder:shopCar ])
    {
        percentageDisCountPrice = disCountPrice / [GoodsTool getPriceFromOrder:shopCar ];
    }
    
    double tax = 0.f;
    CartProductModel *cartProductModel  = shopCar.cartProductModels[0];
    for (GoodsInfomodel * goods in cartProductModel.cartItemModels)
    {
        //如果是E贸易，就需要加上关税 。否则就是一般贸易。不用加关税 ，正常价格计算关税
        if (goods.tradeType.boolValue == 1)
        {
            if (goods.isVirtualProduct.boolValue || goods.virtualProductArray.count>0)//如果是虚拟商品， 那就计算 虚拟商品里面的真实商品的价格
            {
                for (GoodsInfomodel * tureGoods in goods.virtualProductArray)
                {
                    tax = tax + (tureGoods.count.integerValue * tureGoods.price.doubleValue*(1-percentageDisCountPrice) * tureGoods.taxRate.doubleValue/100.0);
                    NSString * taxString = [NSString stringWithFormat:@"%0.2f",tax];
                    tax = taxString.doubleValue;
                }
                
            }
            else//如果不是虚拟商品， 那就计算该商品的价格
            {
                tax = tax + (goods.count.integerValue * goods.price.doubleValue*(1-percentageDisCountPrice) * goods.taxRate.doubleValue/100.0);
                NSString * taxString = [NSString stringWithFormat:@"%0.2f",tax];
                tax = taxString.doubleValue;
            }
            
        }
    }
    if (tax <= 50)
        return 0;
    return tax;
}


//获得所有商品的海关推送价格总和
+(double)getPushcustomspriceFrom:(NSArray*)goodsArray
{
    double Pushcustomsprice = 0.f;
    for (int i = 0 ; i<goodsArray.count;i++)
    {
        GoodsInfomodel * goods = goodsArray[i];
        if(goods.isVirtualProduct.boolValue || goods.virtualProductArray.count>0)//如果是虚拟商品， 那就计算 虚拟商品里面的真实商品的价格
        {
            for (GoodsInfomodel * tureGood in goods.virtualProductArray)
            {
                Pushcustomsprice = Pushcustomsprice + tureGood.pushCustomsPrice.doubleValue * tureGood.count.doubleValue;
                NSString * PushcustomspriceString = [NSString stringWithFormat:@"%0.2f",Pushcustomsprice];
                Pushcustomsprice = PushcustomspriceString.doubleValue;
            }
        }
        else
        {
            Pushcustomsprice = Pushcustomsprice + goods.pushCustomsPrice.doubleValue * goods.count.doubleValue;
            NSString * PushcustomspriceString = [NSString stringWithFormat:@"%0.2f",Pushcustomsprice];
            Pushcustomsprice = PushcustomspriceString.doubleValue;
        }
    }
    return Pushcustomsprice;
    
}

+(double)getCustomsGoodsTaxFromArray:(GetShopCarSetterInformation*)shopCar //获得数组内商品海关推送的关税；
{
    
    CartProductModel *cartProductModel  = shopCar.cartProductModels[0];
    //总优惠
    double disCountPrice = [PreferentialModel getCouponPrice:shopCar.userCoupons];
    if([ScoreModel isSelectScoreMaxMoney:shopCar] )
    {
        disCountPrice += [ScoreModel getMaxMoney:shopCar];
    }
    
    //百分之优惠
    double percentageDisCountPrice = 0;
    
    if( [GoodsTool getPushcustomspriceFrom:cartProductModel.cartItemModels])
    {
        percentageDisCountPrice = disCountPrice / [GoodsTool getPushcustomspriceFrom:cartProductModel.cartItemModels];
    }
  
    double tax = 0;
    for (GoodsInfomodel * goods in cartProductModel.cartItemModels)
    {
        if (goods.tradeType.boolValue == 1) //如果是E贸易，就需要加上关税 。否则就是一般贸易。不用加关税 ，正常价格计算关税
        {
            if (goods.isVirtualProduct.boolValue || goods.virtualProductArray.count>0)//如果是虚拟商品， 那就计算 虚拟商品里面的真实商品的价格
            {
                for (GoodsInfomodel * tureGoods in goods.virtualProductArray)
                {
                    double taxtemp = tureGoods.pushCustomsPrice.doubleValue*(1-percentageDisCountPrice) * tureGoods.taxRate.integerValue/100.0 ;
                    
                    //NSLog(@"我是单个商品税金：%f",[self getNumFourSix:taxtemp]);
                    taxtemp = [GoodsTool getNumFourSix:taxtemp ];
                        tax = tax + (tureGoods.count.integerValue * taxtemp);
                }
            }
            else
            {
               
                tax = tax + (goods.count.integerValue * goods.pushCustomsPrice.doubleValue*(1-percentageDisCountPrice) * goods.taxRate.integerValue/100.00);
                NSString * taxString = [NSString stringWithFormat:@"%0.2f",tax];
                tax = taxString.doubleValue;
            }
        }
    }
    if (tax <= 50)
        return 0;
    return tax;
}

+(double)getNumFourSix:(double)num
{
    
    NSRange index = [[NSString stringWithFormat:@"%f",num] rangeOfString:@"."];
    if (index.location > 0) {
        index.location += 3;
        NSString * onum = [[NSString stringWithFormat:@"%f",num] substringWithRange:index];
        if ([onum isEqualToString:@"5"])
        {
            NSString * st2 = [[NSString stringWithFormat:@"%f",num] substringToIndex:index.location];
            double num2 = st2.doubleValue;
            
            index.location+=1;
            NSString * num3 = [[NSString stringWithFormat:@"%f",num] substringWithRange:index];
            NSString * num4 = [[NSString stringWithFormat:@"%f",num2] substringWithRange:index];
            if ( ![num3 isEqualToString: num4])
            {
                return round(num*100)/100;
            }
            else {
                index.location -= 2;
                NSString * st3 = [[NSString stringWithFormat:@"%f",num] substringWithRange:index];
                NSInteger num5 = st3.integerValue;
                if ((num5 %2) == 0)
                {
                    return round((num-0.001)*100)/100;
                }
                else
                {
                    return round(num*100)/100;
                }
            }
        }
        else
        {
            return round(num*100)/100;
        }
    }
    else
    {
        return num;
    }
}@end
