//
//  OneHouse.m
//  Bqu
//
//  Created by yb on 15/10/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "OneHouse.h"

@implementation OneHouse

+(OneHouse*)oneHouseWithID:(NSInteger)shopId shopName:(NSString*)shopName {
    OneHouse * oneHouse = [[OneHouse alloc] init ];
    oneHouse.shopId = shopId;
    oneHouse.shopName = shopName;
    oneHouse.goods = [[NSMutableArray alloc] init];
    oneHouse.isAllSelect = YES;
    return oneHouse;
}


-(void)addOneGoods:(GoodsInfomodel*)goods {
    [self.goods addObject:goods];
}


-(NSInteger)isINArray:(GoodsInfomodel*)goodsMudel array:(NSArray*)array {
    for (int i = 0 ; i < array.count ;i ++) {
        OneHouse *oneHouse = array[i];
        if (oneHouse.shopId == goodsMudel.shopId.integerValue) {
            return i;
        }
    }
    return -1;
}
@end
