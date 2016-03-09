//
//  MyTool.h
//  Bqu
//
//  Created by yingbo on 15/11/26.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTool : NSObject
/**遮挡身份证**/
+ (NSString *)shadowIdCardString:(NSString *)str;

/**计算文字高度**/
+ (float)returnStringWidth:(NSString *)str withHeight:(float)height withFont:(int)font;

/**计算文字宽度**/
+ (float)returnStringHeight:(NSString *)str withWidth:(float)width withFont:(int)font;


@end
