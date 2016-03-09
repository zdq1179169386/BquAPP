//
//  HttpTool.m
//  weibo
//
//  Created by baohuai on 15/8/18.
//  Copyright (c) 2015年 baohuai. All rights reserved.
//

#import <sys/sysctl.h>
#import <CommonCrypto/CommonCryptor.h>//用于加密算法
#import <CommonCrypto/CommonDigest.h>//用于加密算法
#import "HttpTool.h"
#import "Reachability.h"
@interface HttpTool ()
{
    NSString * _NSDATA_IV ;
    NSString * _NSDATA_KEY;
  
}
@end

@implementation HttpTool
static NSString * IV = @"!@#$%^&*";   //加密向量
static NSString * Key  = @"!@#$%^&"; //加密密钥

//static NSString * NSDATA_IV = IV.dataUsingEncoding(NSUTF8StringEncoding)
//static NSString NSDATA_KEY = Key.dataUsingEncoding(NSUTF8StringEncoding)
#pragma mark -- 判断网络
+(BOOL)isHasNetwork
{
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    
    if (!isExistenceNetwork) {
        UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];//MBProgressHUD为第三方库，不需要可以省略或使用AlertView
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"网络连接失败";
        hud.margin = 5.0f;
        hud.cornerRadius = 15.0f;
        hud.minSize = CGSizeMake(120, 10);
        hud.animationType = MBProgressHUDAnimationZoom;
        [hud hide:YES afterDelay:1.5];

        //    return hud;
        return NO;
    }
    
    return isExistenceNetwork;
}



//get请求
+(void)get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError *error))failure
{
    if (![self isHasNetwork]) {
//        return;
    }
    //创建管理者
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    //发请求
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}
//post请求
+(void)post:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError *error))failure
{
    
    if (![self isHasNetwork]) {
        NSError * error = [[NSError alloc] initWithDomain:@"网络连接失败" code:11111 userInfo:nil];
        if (failure) {
            failure(error);
        }
        return;
    }
    //创建管理者                        bv
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20.f;
    //发请求
//     manager.responseSerializer = [AFHTTPResponseSerializerserializer];
    //很重要，去掉就容易遇到错误，暂时还未了解更加详细的原因

    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
//        NSError * error = nil;
//        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
//
//        NSLog(@"---%@,%@",operation.responseData,error);
        
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark -- 获取转码后的sign 
//如果传的字段为空的话，dic里面就不要包含这个字段，但是传给服务器的data里还是加上 “字段” ＝“”
+(NSString *)returnForSign:(NSDictionary *)dict
{
    NSMutableDictionary * mutableDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
//    NSLog(@"没去空值mutableDict==%@",mutableDict);
    for (NSString * keyStr in [mutableDict allKeys]) {
        id value = [mutableDict objectForKey:keyStr];
//        NSLog(@"keyStr=%@,value=%@",keyStr,value);
        if ([value isKindOfClass:[NSNumber class]]) {
            //NSNumber类型
            
        }
        if ([value isKindOfClass:[NSString class]]) {
            if ([(NSString *)value isEqualToString:@""]) {
                //NSString类型
                [mutableDict removeObjectForKey:keyStr];
            }
        }
    }
//    NSLog(@"去除空值mutableDict==%@",mutableDict);
    NSArray *keysArray = [mutableDict allKeys];
    NSArray *resultArray = [keysArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {

        //不区分大小写
         return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];

    }];
    NSMutableArray * data = [NSMutableArray array];
    for (int i = 0  ;i<resultArray.count ;i++) {
        NSString * key = [resultArray objectAtIndex:i];
        
        NSString * str = [NSString stringWithFormat:@"%@=%@",key,[mutableDict objectForKey:key]];
        [data addObject:str];
    }

    NSString * str8 = [data componentsJoinedByString:@"&"];
    
    NSString * str9 = [NSString stringWithFormat:@"%@&key=%@",str8,KEY];
    
    NSString * strM = [str9 MD5];
    return  strM.uppercaseString;
}
#pragma mark -- 
+(NSMutableDictionary *)getDicToRequest:(NSDictionary *)dic
{
    NSMutableDictionary * realDict = [NSMutableDictionary dictionary];
    NSString * signStr = [self returnForSign:dic];
    realDict[@"sign"] = signStr;
    [realDict addEntriesFromDictionary:dic];
    return realDict;
}
#pragma mark -- 检测用户是否在线
+(void)testUserIsOnlineSuccess:(void(^)(BOOL msg))success 
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/API/Users/CheckLogin",TEST_URL];
    NSString * memberID = [UserManager getMyObjectForKey:userIDKey];
    NSString * token = [UserManager getMyObjectForKey:accessTokenKey];
    
//    NSLog(@"memberID=%@,memberID=%@",memberID,memberID);
    
    NSMutableDictionary * signDict = [NSMutableDictionary dictionary];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    NSString * sign = nil;
    if (!memberID || !token) {
        if (success) {
            success(NO);
        }
//        UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
//        [ProgressHud addProgressHudWithView:window andWithTitle:@"用户尚未登录" withTime:1 withType:MBProgressHUDModeText];
            return;
    }else if (memberID && token)
    {
        [signDict setObject:memberID forKey:@"MemberID"];
        [signDict setObject:token forKey:@"token"];
        
        sign  = [HttpTool returnForSign:signDict];
        dict[@"MemberID"] = memberID;
        dict[@"token"] = token;
        dict[@"sign"] = sign;
        
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        //发请求
        //  manager.responseSerializer = [AFHTTPResponseSerializerserializer]; //很重要，去掉就容易遇到错误，暂时还未了解更加详细的原因
        NSLog(@"%@",dict);
        [manager POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSError * error = nil;
            NSDictionary * dict = responseObject;
            NSLog(@"%@,%@,%@",dict[@"resultCode"],dict[@"message"],dict[@"data"]);
            if (!dict[@"error"] && [dict[@"message"] isEqualToString:@"操作成功"]) {
                if (success) {
                    success(YES);
                }
                
            }else
            {
                if (success) {
                    success(NO);
                }

            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (success) {
                success(NO);
            }
            
        }];
    }
}
@end
