//
//  ProductMudel.h
//  Bqu
//
//  Created by yb on 15/10/26.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductMudel : NSObject
@property (nonatomic) NSString * orderID; //订单id
@property (nonatomic)NSString *productName;//订单的名字
@property (nonatomic)NSString *productDescription;//订单描述
@property (nonatomic)NSString *amount;//订单的价格

+(ProductMudel*)productMudelWithDic:(NSDictionary*)dic;
@end
