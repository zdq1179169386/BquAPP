//
//  BquTool.m
//  Bqu
//
//  Created by yb on 15/12/1.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "BquTool.h"

@implementation BquTool


+(void)urlAnalysis:(NSString*)url success:(void (^)(NSDictionary* data))data
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    UrlType type;
    NSString *urlLower = [url lowercaseString];
    //APP内页前缀APP://
    if ([urlLower rangeOfString:@"app://"].length > 0) {
        //登录
        if([urlLower rangeOfString:@"login"].length > 0)
        {
            type = UrlTypeLogin;
        }
        //注册
        else if ([urlLower rangeOfString:@"userregister"].length>0)
        {
            type = UrlTypeUserRegister;
        }
        //商品详情
        else if ([urlLower rangeOfString:@"product/detail"].length>0)
        {
            type = UrlTypeProductDetail;
            NSRange range = [urlLower rangeOfString:@"/" options:NSBackwardsSearch];
            NSString *pid = [urlLower  substringFromIndex:NSMaxRange(range)];
            dic[@"pid"] = pid;
        }
        //品牌团详情
        else if ([urlLower rangeOfString:@"topic/detail"].length>0)
        {
            type = UrlTypeTopicDetail;
            NSRange range = [urlLower rangeOfString:@"/" options:NSBackwardsSearch];
            NSString *tid = [urlLower  substringFromIndex:NSMaxRange(range)];
            dic[@"tid"] = tid;
        }
        //加入购物车
        else if ([urlLower rangeOfString:@"addtocart"].length>0)
        {
            type = UrlTypeAddToCart;
            NSRange range = [urlLower rangeOfString:@"/" options:NSBackwardsSearch];
            NSString *skuid = [urlLower  substringFromIndex:NSMaxRange(range)];
            dic[@"skuid"] = skuid;
        }
        //立即购买
        else if ([urlLower rangeOfString:@"productconfirm"].length>0)
        {
            type = UrlTypeProductConfirm;
            NSRange range = [urlLower rangeOfString:@"/" options:NSBackwardsSearch];
            NSString *skuid = [urlLower  substringFromIndex:NSMaxRange(range)];
            dic[@"skuid"] = skuid;
        }
        //收藏
        else if ([urlLower rangeOfString:@"addfavoriteproduct"].length>0)
        {
            type = UrlTypeAddFavoriteProduct;
            NSRange range = [urlLower rangeOfString:@"/" options:NSBackwardsSearch];
            NSString *pid = [urlLower  substringFromIndex:NSMaxRange(range)];
            dic[@"pid"] = pid;
        }
        //搜索
        else if ([urlLower rangeOfString:@"search"].length>0)
        {
            type = UrlTypeSearch;
            NSRange range = [urlLower rangeOfString:@"?" options:NSBackwardsSearch];
            NSString *conditions = [urlLower  substringFromIndex:NSMaxRange(range)];
            NSArray * searchList = [conditions componentsSeparatedByString:@"&"];
            for (NSString *condition in searchList)
            {
                NSArray *keyValue =[condition componentsSeparatedByString:@"="];
                NSString * key = keyValue[0];
                //如果是cid
                if ([key isEqualToString:@"cid"]) {
                    NSString * Value = keyValue[1];
                    NSArray* detail =[Value componentsSeparatedByString:@","];
                    if (detail && detail.count>=2)
                    {
                        dic[@"cid"] = detail[0];
                        dic[@"cidName"] = detail[1];
                    }
                }
                //如果是bid
                else if ([key isEqualToString:@"bid"]) {
                    NSString * Value = keyValue[1];
                    NSArray* detail =[Value componentsSeparatedByString:@","];
                    if (detail && detail.count>=2)
                    {
                        dic[@"bid"] = detail[0];
                        dic[@"bidName"] = detail[1];
                    }
                }
                //如果是shopid
                else if ([key isEqualToString:@"shopid"]) {
                    NSString * Value = keyValue[1];
                    NSArray* detail =[Value componentsSeparatedByString:@","];
                    if (detail && detail.count>=2)
                    {
                        dic[@"shopid"] = detail[0];
                        dic[@"shopidName"] = detail[1];
                    }
                }
                //如果是countryid
                else if ([key isEqualToString:@"countryid"]) {
                    NSString * Value = keyValue[1];
                    NSArray* detail =[Value componentsSeparatedByString:@","];
                    if (detail && detail.count>=2)
                    {
                        dic[@"countryid"] = detail[0];
                        dic[@"scountryidName"] = detail[1];
                    }
                }
                //keyWord
                else if ([key isEqualToString:@"keyword"]||[key isEqualToString:@"keywords"])
                {
                    dic[@"keyword"] = keyValue[1];
                }
            }
            
        }

    }
    //H5页面前统一加http://
    else  if ([urlLower rangeOfString:@"http://"].length > 0) {
        type = UrlTypeActivitywap;
        dic[@"url"]= url;
    }
    //其他
    else
    {
        type = UrlTypeNil;
        
        
    }
    dic[@"type"] = @(type);
    data(dic);
}


/** 保存did */
+(void)saveDid:(NSString *)didStr
{
    [[NSUserDefaults standardUserDefaults] setObject:didStr forKey:DistributorIDKey];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 如果是真机调试，转换这种欧美时间，需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString * nowStr = [fmt stringFromDate:[NSDate date]];
   //NSDate * now = [fmt dateFromString:nowStr];
//   NSLog(@"now= %@",nowStr);
    [[NSUserDefaults standardUserDefaults] setObject:nowStr forKey:DistributorIDSaveTime];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
/** 取出did */
+(NSString *)getDid
{
    NSString * didStr = [[NSUserDefaults standardUserDefaults] objectForKey:DistributorIDKey];
    NSString * saveTimeStr = [[NSUserDefaults standardUserDefaults] objectForKey:DistributorIDSaveTime];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 如果是真机调试，转换这种欧美时间，需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate * saveDate = [fmt dateFromString:saveTimeStr];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: saveDate];
    saveDate = [saveDate  dateByAddingTimeInterval: interval];
    
    NSDate *date = [NSDate date];
    NSTimeZone *zone1 = [NSTimeZone systemTimeZone];
    NSInteger interval1 = [zone1 secondsFromGMTForDate: date];
    NSDate * now = [date  dateByAddingTimeInterval: interval1];
    //    NSLog(@"enddate=%@",now);
    NSTimeInterval  timeTnterval = [now timeIntervalSinceDate:saveDate];
    //    NSLog(@"saveDate= %@ ,saveTime= %@,now=%@ timeTnterval=%lf",saveDate,saveTimeStr,now,timeTnterval);
    
    if (timeTnterval>24*60*60) {
        //时间差大于一天
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:DistributorIDKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return @"0";
    }else
    {
        if (didStr==nil) {
            return @"0";
        }
        return didStr;
    }
    return @"0";

}
@end
