//
//  MyTool.m
//  Bqu
//
//  Created by yingbo on 15/11/26.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "MyTool.h"

@implementation MyTool

+ (NSString *)shadowIdCardString:(NSString *)str
{
    NSString *string = [str substringToIndex:4];
    NSString *string1 = [str substringFromIndex:14];
    NSString *idStr = [NSString stringWithFormat:@"%@**********%@",string,string1];
    return idStr;
}


/**计算文字宽度**/
+ (float)returnStringWidth:(NSString *)str withHeight:(float)height withFont:(int)font
{
    // 计算文字的高度
    CGRect rect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
   //  float height = ceilf(rect.size.height);
    return ceilf(rect.size.width);
}

/**计算文字高度**/
+ (float)returnStringHeight:(NSString *)str withWidth:(float)width withFont:(int)font
{
    // 计算文字的高度
    CGRect rect = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    float height =  ceilf(rect.size.height);
    
    return height;
//    CGRect rect = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
//    float height = ceilf(rect.size.height);

}

@end
