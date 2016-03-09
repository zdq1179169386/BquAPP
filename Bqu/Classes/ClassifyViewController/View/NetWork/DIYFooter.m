//
//  DIYFooter.m
//  Bqu
//
//  Created by WONG on 15/12/4.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "DIYFooter.h"
#import "MJRefresh.h"

@interface DIYFooter ()
@property (weak, nonatomic) UIImageView *loading;
@end
@implementation DIYFooter
-(void)prepare {
    [super prepare];
    
    // loading
    UIImageView *loading = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"头部刷新加载圈"]];
    [self addSubview:loading];
    self.loading = loading;
    self.loading.hidden = YES;
}
#pragma mark 在这里设置子控件的位置和尺寸
-(void)placeSubviews {
    [super placeSubviews];
    self.loading.center = CGPointMake(self.mj_w*0.5-40 , self.mj_h * 0.5);
}

@end
