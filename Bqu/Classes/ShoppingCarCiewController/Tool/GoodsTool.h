//
//  GoodsTool.h
//  Bqu
//
//  Created by yb on 15/10/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetShopCarSetterInformation.h"

@interface GoodsTool : NSObject
@property (nonatomic) NSArray *allGoods;

-(instancetype)initWithArray:(NSArray *)allGoods;

-(NSInteger)selectGoodsNum;//获取已经选择的商品个数；
-(double)selectgoodsPrice;//获取选择的商品总价格；
-(double)selectGoodsTax;//获取商品的关税；
-(double)selectCustomsGoodsTax;//获取海关推送的关税；
-(double)selectCustomsGoodsTaxTure;//获取海关推送的关税包括小于50，也显示；

-(double)tureTax;//通过判断，给出最终价格;
-(double)selectGoodsFreight;//获取运费；
-(double)selectAllPrice;//获取商品总价格 加上 关税的价格；

-(BOOL)isOutOfPrice;//如果是E贸易单子，多个商品的价格不能多于1000，单个商品可以多于1000；

+(double)getPriceFromOrder:(GetShopCarSetterInformation*)shopCar;//商品的总价
+(double)getTruePrice:(GetShopCarSetterInformation*)shopCar;//总付款价格



+(double)getGoodsTaxFromArray:(GetShopCarSetterInformation*)shopCar; //获得数组内商品的关税
+(double)getCustomsGoodsTaxFromArray:(GetShopCarSetterInformation*)shopCar; //获得数组内商品海关推送的关税；

@end
