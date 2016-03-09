//
//  TipView.h
//  Bqu
//
//  Created by yingbo on 15/10/14.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipView : UIView

#pragma mark ------> 延时执行

+ (void)doSomething:(void (^)(void))functions
     afterDelayTime:(double)delayInSeconds;

+ (void)doSomethingLater:(void (^)(void))functions;


#pragma mark ------->
//提示用户操作的提示层
+(void)remindAnimationWithTitle:(NSString *)title;

+ (void)showAlertInfoWithString:(NSString *)message withSure:(NSString *)str;

#pragma mark ----->  遮罩效果

//遮罩效果
+ (void)ShadeWithTitle:(NSString *)title withImage:(UIImage *)image;


@end
