//
//  DIYHeader.m
//  测试1
//
//  Created by yb on 15/10/21.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "DIYHeader.h"
#import "MJRefresh.h"
@interface DIYHeader ()

@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UILabel *bg;
@property (weak, nonatomic) UIImageView *logo;
@property (weak, nonatomic) UIImageView *loading;

@property (weak,nonatomic) UIImageView * arrowView;
@end


@implementation DIYHeader
- (void)prepare
{
    [super prepare];
    // 设置控件的高度
    self.mj_h = 40;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor redColor];
    label.textColor = [UIColor colorWithHexString:@"#777777"];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    // 添加label
    UILabel *bg = [[UILabel alloc] init];
    bg.backgroundColor = [UIColor redColor];
    [self addSubview:bg];
    self.bg = bg;
    
    // logo
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"头部刷新来自世界商店"]];
    [self addSubview:logo];
    self.logo = logo;
    
    // loading
    UIImageView *loading = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"头部刷新加载圈"]];
    [self addSubview:loading];
    self.loading = loading;
    self.loading.hidden = YES;
    
    UIImageView * arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"头部刷新箭头"]];
    [self addSubview:arrowView];
    self.arrowView = arrowView;
    self.arrowView.hidden = NO;
    
    
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
//    NSLog(@"+++++%f,%f",self.logo.mj_h,self.mj_h);
    
    self.label.frame = self.bounds;
    self.bg.frame = CGRectMake(0, 0, self.mj_w, 250);
//    [self.label sizeToFit];
    self.label.center = CGPointMake(self.mj_w *0.5, self.mj_h * 0.5);
    self.label.backgroundColor = [UIColor colorWithHexString:@"#f2f1f1"];
    self.logo.center = CGPointMake(self.mj_w * 0.5, - self.logo.mj_h + 20);
    self.bg.center = CGPointMake(self.mj_w * 0.5, - self.bg.mj_h/2.0);
    self.bg.backgroundColor = [UIColor colorWithHexString:@"#f2f1f1"];
    self.loading.center = CGPointMake(self.mj_w*0.5-40 , self.mj_h * 0.5);
    self.arrowView.center = CGPointMake(self.mj_w*0.5-60, self.mj_h * 0.5);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        
        self.label.text = @"下拉可以刷新";
        [self.label sizeToFit];
        self.loading.hidden = YES;
        if (oldState == MJRefreshStateRefreshing) {
            self.arrowView.transform = CGAffineTransformIdentity;
            
            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                self.loading.hidden = YES;
            } completion:^(BOOL finished) {
                // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                if (self.state != MJRefreshStateIdle) return;
                
                self.loading.hidden = YES;
                [self.loading.layer removeAnimationForKey:@"rotationAnimation"];
//                [self.loading stopAnimating];
                self.arrowView.hidden = NO;
            }];
        } else {
            [self.loading.layer removeAnimationForKey:@"rotationAnimation"];
//            [self.loading stopAnimating];
            self.arrowView.hidden = NO;
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                self.arrowView.transform = CGAffineTransformIdentity;
            }];
        }
    } else if (state == MJRefreshStatePulling) {
        
        self.label.text = @"松开即可刷新";
        [self.label sizeToFit];
        self.loading.hidden = YES;
        //停止动画
         [self.loading.layer removeAnimationForKey:@"rotationAnimation"];
//        [self.loading stopAnimating];
        self.arrowView.hidden = NO;
        
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
        }];
    } else if (state == MJRefreshStateRefreshing) {
        self.label.text = @"加载中";
        [self.label sizeToFit];

        self.loading.hidden = NO; // 防止refreshing -> idle的动画完毕动作没有被执行
        
        self.arrowView.hidden = YES;

        //开始动画
//        [self.loading startAnimating];
        CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        rotationAnimation.duration = 0.5;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = MAXFLOAT;
        [self.loading.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        
    }

}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];

}




@end
