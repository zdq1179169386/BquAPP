//
//  DIYFooter.h
//  Bqu
//
//  Created by WONG on 15/12/4.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "MJRefreshBackStateFooter.h"

@interface DIYFooter : MJRefreshBackStateFooter
@property (weak, nonatomic, readonly) UIImageView *arrowView;
/** 菊花的样式 */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@end
