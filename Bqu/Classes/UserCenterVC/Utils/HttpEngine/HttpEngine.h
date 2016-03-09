//
//  HttpEngine.h
//  Bqu
//
//  Created by 张胜瀚 on 15/12/7.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpEngine : NSObject

//设置为默认地址
+ (void)setDefaultAddressWithAddressId:(NSString *)addressId success:(void (^)(id json))success failure:(void(^)(NSError *error))failure;

//添加地址
+ (void)saveAddressWithShopTo:(NSString *)ShopTo withRegionId:(NSString *)regionId withPhone:(NSString *)Phone withIDCard:(NSString *)IDCard withdetailAddress:(NSString *)detailAddress withisDefault:(NSString *)IsDefault  success:(void (^)(id json))success failure:(void(^)(NSError *error))failure;
//修改地址
+ (void)updateAddressWithaddressID:(NSString *)addressId withShopTo:(NSString *)ShopTo withRegionId:(NSString *)regionId withPhone:(NSString *)Phone withIDCard:(NSString *)IDCard withdetailAddress:(NSString *)detailAddress withisDefault:(NSString *)IsDefault  success:(void (^)(id json))success failure:(void(^)(NSError *error))failure;


//删除订单
+ (void)deleteOrderWithorderId:(NSString *)orderId success:(void (^)(id json))success failure:(void(^)(NSError *error))failure;

//取消订单原因
+ (void)deleteTheOrderReasonsuccess:(void (^)(id json))success failure:(void(^)(NSError *error))failure;

@end
