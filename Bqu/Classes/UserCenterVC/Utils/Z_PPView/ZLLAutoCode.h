//
//  ZLLAutoCode.h
//  Bqu
//
//  Created by yingbo on 15/10/21.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLLAutoCode : UIView
@property (strong, nonatomic) NSArray *dataArray;//字符素材数组

@property (strong, nonatomic) NSMutableString *authCodeStr;//验证码字符串
@end
