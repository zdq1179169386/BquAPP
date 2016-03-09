//
//  BquTool.h
//  Bqu
//
//  Created by yb on 15/12/1.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum{
    UrlTypeNil = 0,
    UrlTypeActivitywap = 1,
    UrlTypeLogin,
    UrlTypeUserRegister,
    UrlTypeProductDetail,
    UrlTypeTopicDetail,
    UrlTypeAddToCart,
    UrlTypeProductConfirm,
    UrlTypeAddFavoriteProduct,
    UrlTypeSearch,
} UrlType;



@interface BquTool : NSObject

//解析url
+(void)urlAnalysis:(NSString*)url success:(void (^)(NSDictionary* data))data ;


/** 保存did */
+(void)saveDid:(NSString *)didStr;
/** 取出did */
+(NSString *)getDid;
@end
