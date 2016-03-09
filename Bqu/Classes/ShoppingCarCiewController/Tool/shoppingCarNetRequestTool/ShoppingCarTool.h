//
//  ShoppingCarTool.h
//  Bqu
//
//  Created by yb on 15/11/12.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCarTool : NSObject
//检测是否登入
+(void)isLogin:(void (^)(BOOL success))isLogin failure:(void(^)(NSError *error))failure;

//获取购物车信息
+(void)GetCartInfo:(void (^)(id json))success failure:(void(^)(NSError *error))failure;

//更新购物车内商品的个数
+(void)updateCartInfo:(NSString*)skuid count:(NSString*)count success:(void (^)(id json))isLogin failure:(void(^)(NSError *error))failure;

//删除购物车数据
+(void)requestDeleteCatInfo:(NSArray*)array success:(void (^)(BOOL success))success failure:(void(^)(NSError *error))failure;

//更换地址
+(void)requestAllAddress:(void (^)(id json))success failure:(void(^)(NSError *error))failure;

//获取购物车种类
+(void)getUserCartCount:(void (^)(NSString* count))success failure:(void(^)(NSError *error))failure;

+(void)getOrderDetail:(NSString *)orderID success:(void (^)(id success))success failure:(void(^)(NSError *error))failure;

@end
