//
//  ProgressHud.m
//  Bqu
//
//  Created by yb on 15/10/19.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "ProgressHud.h"

@interface ProgressHud ()
{
    MBProgressHUD * _hudView;
}
@property (nonatomic,strong) MBProgressHUD * hudView ;

@end

@implementation ProgressHud

+(void)addProgressHudWithView:(UIView *)selfView andWithTitle:(NSString *)title
{
    //请求开始时  //添加烽火轮
     MBProgressHUD *  hudView = [MBProgressHUD showHUDAddedTo:selfView animated:YES];
     hudView.backgroundColor = [UIColor whiteColor];
     hudView.labelText = title;
////     hudView.square = YES;
//     hudView.margin = 10.f;
     hudView.removeFromSuperViewOnHide = YES;
    
}
+(void)hideProgressHudWithView:(UIView *)selfView
{
    //请求结束时  //隐藏烽火轮
//    [MBProgressHUD hideAllHUDsForView:selfView animated:NO ];
    [MBProgressHUD hideHUDForView:selfView animated:YES];
   
}
+(void)addProgressHudWithView:(UIView *)selfView andWithTitle:(NSString *)title withTime:(NSTimeInterval)time withType:(MBProgressHUDMode)type
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:selfView.window animated:YES];
    hud.removeFromSuperViewOnHide =YES;
    hud.detailsLabelText = title;
    hud.detailsLabelColor = [UIColor blackColor];
    hud.detailsLabelFont = [UIFont systemFontOfSize:17];
    hud.mode = type;
    hud.labelText = @"B区提醒您";
    hud.labelFont = [UIFont systemFontOfSize:15];
    hud.labelColor = [UIColor blackColor];
    hud.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    hud.color = [UIColor whiteColor];

    [hud hide:YES afterDelay:time];
}
+ (void)showHUDWithView:(UIView *)view withTitle:(NSString *)title withTime:(NSTimeInterval)time
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    hud.margin = 5.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.cornerRadius = 15;
    hud.minSize = CGSizeMake(100, 10);
    hud.square = NO;
    [hud hide:YES afterDelay:time];
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.labelFont = [UIFont systemFontOfSize:16];
//    return hud;
}
@end
