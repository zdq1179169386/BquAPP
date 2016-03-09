//
//  ScanController.h
//  Bqu
//
//  Created by WONG on 15/10/13.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeBaseViewController.h"

@interface ScanController : HomeBaseViewController

@property (nonatomic, copy) void (^SYQRCodeCancleBlock) (ScanController *vc);//扫描取消
@property (nonatomic, copy) void (^SYQRCodeSuncessBlock) (ScanController *vc,NSString *str);//扫描结果
@property (nonatomic, copy) void (^SYQRCodeFailBlock) (ScanController *vc);//扫描失败

@end
