//
//  ClassifyBaseViewController.m
//  Bqu
//
//  Created by yb on 15/11/27.
//  Copyright © 2015年 yb. All rights reserved.
// 分类的VC基类

#import "ClassifyBaseViewController.h"

@implementation ClassifyBaseViewController

-(instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    NSString * version = [[UIDevice currentDevice] systemVersion];
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSLog(@"%@",version);
    if (IOS7_OR_LATER)
    {
       
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    
}

@end


