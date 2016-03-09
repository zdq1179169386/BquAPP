//
//  ShoppingCarTool.m
//  Bqu
//
//  Created by yb on 15/11/12.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "ShoppingCarTool.h"
#import "GoodsInfomodel.h"


@implementation ShoppingCarTool

+(void)isLogin:(void (^)(BOOL success))isLogin failure:(void(^)(NSError *error))failure
{
    
    NSString * urlStr =[NSString stringWithFormat:@"%@%@",TEST_URL,isLoginUrl];
    NSString * memberID = [UserManager getMyObjectForKey:userIDKey];
    NSString * token = [UserManager getMyObjectForKey:accessTokenKey];
    
    if (memberID && token)
    {
        NSMutableDictionary * signDict = [NSMutableDictionary dictionary];
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        
        NSString * sign = nil;
        [signDict setObject:memberID forKey:@"MemberID"];
        [signDict setObject:token forKey:@"token"];
        
        sign  = [HttpTool returnForSign:signDict];
        dict[@"MemberID"] = memberID;
        dict[@"token"] = token;
        dict[@"sign"] = sign;
        [HttpTool post:urlStr params:dict success:^(id json) {
            NSString *resultCode = json[@"resultCode"];
            if (!resultCode.boolValue)
            {
                isLogin(1);
            }
            else isLogin(0);
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
    else {
        isLogin(0);
    }
}


+(void)GetCartInfo:(void (^)(id json))success failure:(void(^)(NSError *error))failure
{
    NSString * urlStr =[NSString stringWithFormat:@"%@%@",TEST_URL,GetCartInfoURL];
    NSString * token =[UserManager getMyObjectForKey:accessTokenKey];
    NSString * MemberID = [UserManager getMyObjectForKey:userIDKey];
    if (token && MemberID)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:token forKey:@"token"];
        [dic setValue:MemberID forKey:@"MemberID"];
        NSString * sign = [HttpTool returnForSign:dic];
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setValue:token forKey:@"token"];
        [dict setValue:MemberID forKey:@"MemberID"];
        dict[@"sign"] = sign;
        [HttpTool post:urlStr params:dict success:^(id json) {
            success(json);
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
}


+(void)updateCartInfo:(NSString*)skuid count:(NSString*)count success:(void (^)(id json))success failure:(void(^)(NSError *error))failure
{
    NSString * urlStr =[NSString stringWithFormat:@"%@%@",TEST_URL,UpdateCartInfoURL];
    NSString * memberID = [UserManager getMyObjectForKey:userIDKey];
    NSString * token = [UserManager getMyObjectForKey:accessTokenKey];
    
    if (memberID && token)
    {
        NSMutableDictionary * signDict = [NSMutableDictionary dictionary];
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        
        NSString *skuID = skuid;
        NSString *Count = count;
        
        NSString * sign = nil;
        [signDict setObject:memberID forKey:@"MemberID"];
        [signDict setObject:token forKey:@"token"];
        [signDict setObject:skuID forKey:@"skuID"];
        [signDict setObject:Count forKey:@"Count"];
        
        sign  = [HttpTool returnForSign:signDict];
        
        dict[@"MemberID"] = memberID;
        dict[@"token"] = token;
        dict[@"sign"] = sign;
        dict[@"skuID"]= skuID;
        dict[@"Count"]= Count;
        [HttpTool post:urlStr params:dict success:^(id json) {
            success(json);
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
}


+(void)requestDeleteCatInfo:(NSArray*)array success:(void (^)(BOOL success))success failure:(void(^)(NSError *error))failure
{
    NSInteger count = array.count;
    if ( count > 0)
    {
        NSString * skuIDSString = @"";
        for (NSInteger i = 0 ;i < count;i++)
        {
            GoodsInfomodel * goods = array[i];
            if (i == count-1)
            {
                skuIDSString = [skuIDSString stringByAppendingFormat:@"%@",goods.skuId];
            }
            else
            {
                skuIDSString = [skuIDSString stringByAppendingFormat:@"%@,",goods.skuId];
            }
        }
        NSString * urlStr =[NSString stringWithFormat:@"%@%@",TEST_URL,ClearCartInfoURL];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:[UserManager getMyObjectForKey:accessTokenKey] forKey:@"token"];
        [dic setValue:[UserManager getMyObjectForKey:userIDKey] forKey:@"MemberID"];
        [dic setValue:skuIDSString forKey:@"skuIDs"];
        NSString * sign = [HttpTool returnForSign:dic];
        
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setValue:[UserManager getMyObjectForKey:accessTokenKey] forKey:@"token"];
        [dict setValue:[UserManager getMyObjectForKey:userIDKey] forKey:@"MemberID"];
        [dict setValue:skuIDSString forKey:@"skuIDs"];
        dict[@"sign"] = sign;
        
        [HttpTool post:urlStr params:dict success:^(id json) {
            NSString *resultCode = json[@"resultCode"];
            if (resultCode.boolValue) {
                success(0);
            }
            else
            {
                success(1);
            }
            
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
    
}


+(void)requestAllAddress:(void (^)(id json))success failure:(void(^)(NSError *error))failure
{
    NSString * urlStr =[NSString stringWithFormat:@"%@%@",TEST_URL,getAddresslUrl];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[UserManager getMyObjectForKey:accessTokenKey] forKey:@"token"];
    [dic setValue:[UserManager getMyObjectForKey:userIDKey] forKey:@"MemberID"];
    NSString * sign = [HttpTool returnForSign:dic];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserManager getMyObjectForKey:accessTokenKey] forKey:@"token"];
    [dict setValue:[UserManager getMyObjectForKey:userIDKey] forKey:@"MemberID"];
    dict[@"sign"] = sign;
    [HttpTool post:urlStr params:dict success:^(id json) {
        
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+(void)getUserCartCount:(void (^)(NSString* count))success failure:(void(^)(NSError *error))failure
{
    NSString * urlStr =[NSString stringWithFormat:@"%@%@",TEST_URL,GetUserCartCount];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[UserManager getMyObjectForKey:accessTokenKey] forKey:@"token"];
    [dic setValue:[UserManager getMyObjectForKey:userIDKey] forKey:@"MemberID"];
    NSString * sign = [HttpTool returnForSign:dic];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserManager getMyObjectForKey:accessTokenKey] forKey:@"token"];
    [dict setValue:[UserManager getMyObjectForKey:userIDKey] forKey:@"MemberID"];
    dict[@"sign"] = sign;
    [HttpTool post:urlStr params:dict success:^(id json) {
        NSDictionary* dataDic = json[@"data"];
        success(dataDic[@"Count"]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


+(void)getOrderDetail:(NSString *)orderID success:(void (^)(id success))success failure:(void(^)(NSError *error))failure
{
    NSString * urlStr =[NSString stringWithFormat:@"%@%@",TEST_URL,@"/API/Order/GetOrderDetail"];
    NSString * memberID = [UserManager getMyObjectForKey:userIDKey];
    NSString * token = [UserManager getMyObjectForKey:accessTokenKey];
    
    
    if (memberID && token && orderID)
    {
        NSMutableDictionary * signDict = [NSMutableDictionary dictionary];
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        
        NSString * sign = nil;
        [signDict setObject:memberID forKey:@"MemberID"];
        [signDict setObject:token forKey:@"token"];
        [signDict setObject:orderID forKey:@"OrderId"];
        
        
        sign  = [HttpTool returnForSign:signDict];
        dict[@"MemberID"] = memberID;
        dict[@"token"] = token;
        dict[@"sign"] = sign;
        dict[@"OrderId"] = orderID;
        
        [HttpTool post:urlStr params:dict success:^(id json) {
            success(json);
        } failure:^(NSError *error) {
            failure(error);
        }];
    }

    
}
@end
