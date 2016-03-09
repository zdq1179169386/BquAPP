//
//  BquSearchHttpTool.h
//  Bqu
//
//  Created by yb on 15/12/10.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BquSearchHttpTool : NSObject
//请求发货地
+(void)requestAllBondedAreas:(void (^)(id json))success failure:(void(^)(NSError *error))failure;

//请求国家
+(void)requestAllCountry:(void (^)(id json))success failure:(void(^)(NSError *error))failure;
@end
