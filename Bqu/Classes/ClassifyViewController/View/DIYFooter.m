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
//{
//    __weak UIImageView *_arrowView;
//}
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) UIImageView *loading;

@property (weak,nonatomic) UIImageView * arrowView;
@end

@implementation DIYFooter
#pragma mark - 懒加载子控件
//- (UIImageView *)arrowView
//{
//    if (!_arrowView) {
//        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MJRefreshSrcName(@"arrow.png")]];
//        [self addSubview:_arrowView = arrowView];
//    }
//    return _arrowView;
//}

- (UIActivityIndicatorView *)loadingView
{
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorViewStyle];
        loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}
- (UIImageView *)loading
{
    if (!_loading) {
        UIImageView *loading = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MJRefreshSrcName(@"arrow.png")]];
        [self addSubview:_loading = loading];
    }
    return _loading;
}
// 懒加载完毕
- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    
    self.loadingView = nil;
    [self setNeedsLayout];
}
#pragma makr - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
//    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    // loading
        UIImageView *loading = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"头部刷新加载圈"]];
        [self addSubview:loading];
        self.loading = loading;
        self.loading.hidden = YES;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor redColor];
    label.textColor = [UIColor colorWithHexString:@"#777777"];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    UIImageView * arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"头部刷新加载圈"]];
    [self addSubview:arrowView];
    self.arrowView = arrowView;
    self.arrowView.hidden = NO;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    // 箭头
    self.arrowView.mj_size = self.arrowView.image.size;
    CGFloat arrowCenterX = self.mj_w * 0.5;
    if (!self.stateLabel.hidden) {
        arrowCenterX -= 100;
    }
    CGFloat arrowCenterY = self.mj_h * 0.5;
//    self.arrowView.center = CGPointMake(arrowCenterX, arrowCenterY);
    self.arrowView.center = CGPointMake(self.mj_w*0.5-40 , self.mj_h * 0.5);
    // 圈圈
//    self.loadingView.frame = self.arrowView.frame;
    
    self.loading.center = CGPointMake(self.mj_w*0.5-40 , self.mj_h * 0.5);
    
    self.label.frame = self.bounds;
    self.label.center = CGPointMake(self.mj_w *0.5, self.mj_h * 0.5);
    self.label.backgroundColor = [UIColor colorWithHexString:@"#f2f1f1"];
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        self.loadingView.hidden = YES;
        self.label.text = @"加载中";
        [self.label sizeToFit];
        self.loading.hidden = YES;
        if (oldState == MJRefreshStateRefreshing) {
//            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
            CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
            rotationAnimation.duration = 0.5;
            rotationAnimation.cumulative = YES;
            rotationAnimation.repeatCount = MAXFLOAT;
            [self.arrowView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
            
            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
//                self.loadingView.alpha = 0.0;
                self.loading.hidden = YES;
                
            } completion:^(BOOL finished) {
//                self.loadingView.alpha = 1.0;
//                [self.loadingView stopAnimating];
                
            if (self.state != MJRefreshStateIdle) return;

            self.loading.hidden = YES;
            [self.loading.layer removeAnimationForKey:@"rotationAnimation"];
                
            self.arrowView.hidden = NO;
            }];
        } else {
            [self.loading.layer removeAnimationForKey:@"rotationAnimation"];
            self.arrowView.hidden = NO;
//          [self.loadingView stopAnimating];
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
//            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
                CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
                rotationAnimation.duration = 0.5;
                rotationAnimation.cumulative = YES;
                rotationAnimation.repeatCount = MAXFLOAT;
                [self.arrowView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
            }];
        }
    } else if (state == MJRefreshStatePulling) {
        self.label.text = @"加载中";
        [self.label sizeToFit];
        self.arrowView.hidden = NO;
//        [self.loadingView stopAnimating];
        self.loading.hidden = YES;
        //停止动画
        [self.loading.layer removeAnimationForKey:@"rotationAnimation"];
        
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
//            self.arrowView.transform = CGAffineTransformIdentity;
            CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
            rotationAnimation.duration = 0.5;
            rotationAnimation.cumulative = YES;
            rotationAnimation.repeatCount = MAXFLOAT;
            [self.arrowView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
            
        }];
    } else if (state == MJRefreshStateRefreshing) {
        self.arrowView.hidden = NO;
//        [self.loadingView startAnimating];
        self.loading.hidden = NO; // 防止refreshing -> idle的动画完毕动作没有被执行
        CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        rotationAnimation.duration = 0.5;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = MAXFLOAT;
        [self.loading.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    } else if (state == MJRefreshStateNoMoreData) {
        self.arrowView.hidden = YES;
//        [self.loadingView stopAnimating];
        self.loading.hidden = YES;
        self.label.text = @"没有更多商品了";
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
}
@end
