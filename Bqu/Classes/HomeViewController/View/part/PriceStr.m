//
//  PriceStr.m
//  Bqu
//
//  Created by yb on 15/12/3.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "PriceStr.h"

@implementation PriceStr
+(NSMutableAttributedString*)priceToStr:(NSString*)price
{
    double per = ScreenWidth/375;
    
    NSString *temp = [NSString stringWithFormat:@"￥%0.2f",price.doubleValue];
    NSMutableAttributedString*priceToStr = [[NSMutableAttributedString alloc] initWithString:temp];
    
    [priceToStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#e8103c"] range:NSMakeRange(0,price.length-1)];
    
    [priceToStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14*per] range:NSMakeRange(0,1)];
    
    NSRange range = [temp rangeOfString:@"."];
    [priceToStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22*per] range:NSMakeRange(1, range.location-1)];
    [priceToStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14*per] range:NSMakeRange(range.location,3)];
    return priceToStr;
}
@end
