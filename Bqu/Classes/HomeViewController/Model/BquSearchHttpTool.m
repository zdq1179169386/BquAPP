//
//  BquSearchHttpTool.m
//  Bqu
//
//  Created by yb on 15/12/10.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "BquSearchHttpTool.h"

@implementation BquSearchHttpTool
+(void)requestAllBondedAreas:(void (^)(id json))success failure:(void(^)(NSError *error))failure
{
    NSString * urlStr =[NSString stringWithFormat:@"%@%@",TEST_URL,@"/API/home/GetShopList"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@"GetShopList" forKey:@"action"];
    NSString * sign = [HttpTool returnForSign:dic];
    dic[@"sign"] = sign;
    [HttpTool post:urlStr params:dic success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];

}

+(void)requestAllCountry:(void (^)(id json))success failure:(void(^)(NSError *error))failure
{
    NSString * urlStr =[NSString stringWithFormat:@"%@%@",TEST_URL,@"/API/home/GetCountryList"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@"GetCountryList" forKey:@"action"];
    NSString * sign = [HttpTool returnForSign:dic];
    dic[@"sign"] = sign;
    [HttpTool post:urlStr params:dic success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];

}
@end
