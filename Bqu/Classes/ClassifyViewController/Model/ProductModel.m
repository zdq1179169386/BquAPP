//
//  ProductModel.m
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "ProductModel.h"

@implementation ProductModel
-(NSString *)OverTime
{
    NSDateFormatter * fmt = [[NSDateFormatter alloc] init];
    // 如果是真机调试，转换这种欧美时间，需要设置locale
    //        fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
//    _OverTime = @"2015/11/25 12:00:00";
    NSDate * overtime = [fmt dateFromString:_OverTime];
    
    NSDate * now = [NSDate date];
    NSTimeZone * zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:now];
    NSDate * localeDate = [now dateByAddingTimeInterval:interval];
    NSDate * overDate = [overtime dateByAddingTimeInterval:interval];
//    NSLog(@"now=%@,overTime=%@",localeDate,overDate);
    int aTimer = [overDate timeIntervalSinceDate:localeDate];
    
//    NSLog(@"%d",aTimer);
    int day = (int)(aTimer/3600/24);
        int hour = (int)(aTimer-day*3600*24)/3600;
    int minute = (int)(aTimer-day*3600*24 - hour*3600)/60;
    int second = aTimer -day*3600*24- hour*3600 - minute*60;
    NSLog(@"剩下的时间 _%d,_%d,_%d,_%d",day,hour,minute,second);
    
    NSString * time = [NSString stringWithFormat:@"%d",aTimer];
    if (_OverTime) {
        
        return time;
        
    }else
    {
        return NULL;
    }
}
-(NSString*)TaxRate
{
    NSLog(@"_TaxRate=%@",_TaxRate);
    NSString * str = [NSString stringWithFormat:@"%@%%",_TaxRate];
    return str;
}
//-(NSString*)Stock
//{
//    return @"0";
//}
//-(NSString*)IsVirtualProduct
//{
//    return @"1";
//}
//-(NSString*)IsLimitProduct{
//    NSLog(@"_IsLimitProduct%@",_IsLimitProduct);
//    return _IsLimitProduct;
//}
-(NSString *)CustomPushPrice
{
    NSLog(@"_CustomPushPrice=%@",_CustomPushPrice);
    return _CustomPushPrice;
}
@end
