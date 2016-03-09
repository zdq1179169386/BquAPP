//
//  OneHouse.h
//  Bqu
//
//  Created by yb on 15/10/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsInfomodel.h"

@interface OneHouse : NSObject
@property (nonatomic) NSInteger shopId;//店铺id
@property (nonatomic,strong)NSString *shopName;
@property (nonatomic) NSMutableArray * goods; //在该店铺下的东西
@property (nonatomic) BOOL isAllSelect;


+(OneHouse*)oneHouseWithID:(NSInteger)shopId shopName:(NSString*)shopName;

-(void)addOneGoods:(GoodsInfomodel*)goods;

@end
