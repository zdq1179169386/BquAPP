//
//  HttpTool.h
//  weibo
//
//  Created by baohuai on 15/8/18.
//  Copyright (c) 2015年 baohuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpTool : NSObject
+(BOOL)isHasNetwork;


/**
 get请求
 */
+(void)get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError *error))failure;
/**
 post请求
 */
+(void)post:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError *error))failure;
///**判断用户是否登录*/
+(void)testUserIsOnlineSuccess:(void(^)(BOOL msg))success;

/**获取转码后的sign */
+(NSString *)returnForSign:(NSDictionary *)dict;

/**发送请求最终的字典，如果有值为空需要自己再添加*/
+(NSMutableDictionary *)getDicToRequest:(NSDictionary *)dic;

@end
