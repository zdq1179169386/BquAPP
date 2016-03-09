//
//  HttpEngine.m
//  Bqu
//
//  Created by 张胜瀚 on 15/12/7.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "HttpEngine.h"

@implementation HttpEngine

+ (void)setDefaultAddressWithAddressId:(NSString *)addressId success:(void (^)(id json))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,setDefaultAddresslUrl];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"MemberID"] = [UserManager getMyObjectForKey:userIDKey];
    dict[@"token"] = [UserManager getMyObjectForKey:accessTokenKey];
    dict[@"AddressID"] = addressId;
    
    NSString *realSign = [HttpTool returnForSign:dict];
    dict[@"sign"] = realSign;
    
    [HttpTool post:urlStr params:dict success:^(id json)
     {
         success(json);
     }
     failure:^(NSError *error)
     {
         failure(error);
     }];

}


//添加或者修改地址
+ (void)saveAddressWithShopTo:(NSString *)ShopTo withRegionId:(NSString *)regionId withPhone:(NSString *)Phone withIDCard:(NSString *)IDCard withdetailAddress:(NSString *)detailAddress withisDefault:(NSString *)IsDefault  success:(void (^)(id json))success failure:(void(^)(NSError *error))failure
{

    NSString *urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,AddAddresslUrl];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"MemberID"] = [UserManager getMyObjectForKey:userIDKey];
    dict[@"token"] = [UserManager getMyObjectForKey:accessTokenKey];
    dict[@"ShipTo"] = ShopTo;
    dict[@"RegionId"] = regionId;
    dict[@"Phone"] = Phone;
    dict[@"Address"] = detailAddress;
    dict[@"IDCard"] = IDCard;
    dict[@"IsDefault"] = IsDefault;
    
    NSString *realSign = [HttpTool returnForSign:dict];
    dict[@"sign"] = realSign;

    [HttpTool post:urlStr params:dict success:^(id json)
     {
         NSLog(@"新增dict == %@",dict);
         NSLog(@"新增地址 == %@",json);

         success(json);
     }
           failure:^(NSError *error)
     {
         failure(error);
     }];

}

//修改地址
+ (void)updateAddressWithaddressID:(NSString *)addressId withShopTo:(NSString *)ShopTo withRegionId:(NSString *)regionId withPhone:(NSString *)Phone withIDCard:(NSString *)IDCard withdetailAddress:(NSString *)detailAddress withisDefault:(NSString *)IsDefault  success:(void (^)(id json))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,changeAddresslUrl];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"MemberID"] = [UserManager getMyObjectForKey:userIDKey];
    dict[@"token"] = [UserManager getMyObjectForKey:accessTokenKey];
    dict[@"AddressID"] = addressId;
    dict[@"ShipTo"] = ShopTo;
    dict[@"RegionId"] = regionId;
    dict[@"Phone"] = Phone;
    dict[@"Address"] = detailAddress;
    dict[@"IDCard"] = IDCard;
    dict[@"IsDefault"] = IsDefault;

    
    NSString *realSign = [HttpTool returnForSign:dict];
    dict[@"sign"] = realSign;
    
    [HttpTool post:urlStr params:dict success:^(id json)
     {
         NSLog(@"修改dict == %@",dict);
         NSLog(@"修改地址 == %@",json);

         success(json);
     }
           failure:^(NSError *error)
     {
         failure(error);
     }];
}


//删除订单
+ (void)deleteOrderWithorderId:(NSString *)orderId success:(void (^)(id json))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,deleteOrder];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"MemberID"] = [UserManager getMyObjectForKey:userIDKey];
    dict[@"token"] = [UserManager getMyObjectForKey:accessTokenKey];
    dict[@"OrderId"] = orderId;
    NSString *realSign = [HttpTool returnForSign:dict];
    dict[@"sign"] = realSign;
    [HttpTool post:urlStr params:dict success:^(id json)
    {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}


//取消订单原因
+ (void)deleteTheOrderReasonsuccess:(void (^)(id json))success failure:(void(^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,deleteOrderReason];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"Action"] = @"CancelReason";
    NSString *realSign = [HttpTool returnForSign:dict];
    dict[@"sign"] = realSign;
    [HttpTool post:urlStr params:dict success:^(id json)
    {
        NSLog(@"取消原因 = %@",dict);
        NSLog(@"取消原因 = %@",json);

        success(json);
    } failure:^(NSError *error)
    {
        failure(error);
    }];

}

@end
