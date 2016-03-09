//
//  OrderCouponCell.h
//  Bqu
//
//  Created by yingbo on 15/12/1.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderCouponCell;
@protocol OrderCouponDelegate <NSObject>

- (void)OrderCouponButtonClick:(UIButton *)button;

@end

@interface OrderCouponCell : UITableViewCell
@property (nonatomic,assign) id<OrderCouponDelegate> delegate;


@property (nonatomic,strong) UIImageView *orderImg;
@property (nonatomic,strong) UIImageView *couponImg;
@property (nonatomic,strong) UILabel *orderLab;
@property (nonatomic,strong) UILabel *couponLab;
@property (nonatomic,strong) UIView *lineH;
@property (nonatomic,strong) UIView *lineV;
@property (nonatomic,strong) UIButton *orderBtn;
@property (nonatomic,strong) UIButton *couponBtn;


@end
