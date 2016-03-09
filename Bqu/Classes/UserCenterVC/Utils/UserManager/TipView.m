//
//  TipView.m
//  Bqu
//
//  Created by yingbo on 15/10/14.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "TipView.h"
#import "AppDelegate.h"

@implementation TipView

+ (void)doSomething:(void (^)(void))functions
     afterDelayTime:(double)delayInSeconds
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       functions();
                   });
}
+ (void)doSomethingLater:(void (^)(void))functions
{
    [self doSomething:functions
               afterDelayTime:0.8];
}


#pragma mark  -  提示用户操作的提示层

+(void)remindAnimationWithTitle:(NSString *)title
{
     // 计算文字的高度
    CGRect rect = [title boundingRectWithSize:CGSizeMake(320, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    //    float height = ceilf(rect.size.height);
    float width =  ceilf(rect.size.width);

    UIView * loadView=[[UIView alloc]init];
    loadView.bounds=CGRectMake(0, 0, width + 28, 40);
    loadView.center = CGPointMake(ScreenWidth/2, ScreenHeight/3+80 +20);
    loadView.layer.cornerRadius=20;
    loadView.alpha=0.9;
    loadView.backgroundColor=RGB_A(81, 80, 80);

    //提示的文字
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(14, 10, width, 20)];
    label.text=title;
    label.font =[UIFont fontWithName:@"Helvetica-Bold" size:12];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment=NSTextAlignmentCenter;
     label.textColor=RGB_A(250, 250, 250);
    label.backgroundColor=[UIColor clearColor];
    [loadView addSubview:label];

    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:loadView];
    
    //延时将自己删除
    [self doSomething:^
    {
          [loadView removeFromSuperview];
    }  afterDelayTime:1];

}


// 显示简单的确认框
+ (void)showAlertInfoWithString:(NSString *)message withSure:(NSString *)str
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:str
                                          otherButtonTitles:nil];
    [alert show];
}


//遮罩效果
+ (void)ShadeWithTitle:(NSString *)title withImage:(UIImage *)image;
{
    // 计算文字的宽度
    CGRect rect = [title boundingRectWithSize:CGSizeMake(160, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    float width =  ceilf(rect.size.width);
    
    //全屏半透明
    CALayer *maskLayer = [CALayer layer];
    [maskLayer setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [maskLayer setBackgroundColor:[[UIColor colorWithRed:128/255 green:128/255  blue:128/255  alpha:0.4] CGColor]];
    
        
   //底部视图
    TipView * loadView=[[TipView alloc]init];
    loadView.bounds=CGRectMake(0, 0, width + 60 + 32, 53);
    loadView.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
    loadView.layer.cornerRadius=10;
    loadView.alpha=1;
    loadView.backgroundColor=[UIColor whiteColor];
    CALayer *loadViewLayer = loadView.layer;
    [maskLayer addSublayer:loadViewLayer];

    
    
    CATextLayer *label = [[CATextLayer alloc] init];
    [label setFont:@"Helvetica"];
    [label setFontSize:17];
    [label setFrame:CGRectMake(55, 16, width, 30)];
    [label setString:title];
    [label setAlignmentMode:kCAAlignmentCenter];
    [label setForegroundColor:[[UIColor blackColor] CGColor]];
    [loadViewLayer addSublayer:label];

    

    //提示的图片
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(26, 20, 18, 18)];
    imgV.image = image;
    CALayer *imgLayer = imgV.layer;
    [loadViewLayer addSublayer:imgLayer];
    
    
    //延时将自己删除
    [TipView doSomething:^
     {
         [maskLayer removeFromSuperlayer];
     }  afterDelayTime:1.9];
    
    
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    [window.layer addSublayer:maskLayer];
}


@end
