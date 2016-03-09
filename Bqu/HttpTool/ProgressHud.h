//
//  ProgressHud.h
//  Bqu
//
//  Created by yb on 15/10/19.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@interface ProgressHud : NSObject


+(void)addProgressHudWithView:(UIView *)selfView andWithTitle:(NSString *)title;
+(void)hideProgressHudWithView:(UIView *)selfView;
/**提示*/
+(void)addProgressHudWithView:(UIView *)selfView andWithTitle:(NSString *)title withTime:(NSTimeInterval)time withType:(MBProgressHUDMode)type;


+ (void)showHUDWithView:(UIView *)view withTitle:(NSString *)title withTime:(NSTimeInterval)time;

@end
