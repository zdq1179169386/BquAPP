//
//  OrderCouponCell.m
//  Bqu
//
//  Created by yingbo on 15/12/1.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "OrderCouponCell.h"

@implementation OrderCouponCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        /**我的订单图片**/
        self.orderImg = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/4-(29/2), 5, 29, 29)];
        self.orderImg.image = [UIImage imageNamed:@"我的订单_不带点"];
         /**我的收藏图片**/
        self.couponImg = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/4*3-(29/2), 5, 29, 29)];
        self.couponImg.image = [UIImage imageNamed:@"我的收藏1"];
        /**我的订单**/
        self.orderLab = [[UILabel alloc] init];
        self.orderLab.bounds = CGRectMake(0, 0, 60, 15);
        self.orderLab.center = CGPointMake(ScreenWidth/4, 48);
        self.orderLab.text = @"我的订单";
        self.orderLab.textColor = [UIColor colorWithHexString:@"#333333"];
        self.orderLab.font = [UIFont systemFontOfSize:14];
        self.orderLab.textAlignment = NSTextAlignmentCenter;
        /**我的收藏**/
        self.couponLab = [[UILabel alloc] init];
        self.couponLab.bounds = CGRectMake(0, 0, 60, 15);
        self.couponLab.center = CGPointMake(ScreenWidth/4*3, 48);
        self.couponLab.text = @"我的收藏";
        self.couponLab.textColor = [UIColor colorWithHexString:@"#333333"];
        self.couponLab.font = [UIFont systemFontOfSize:14];
        self.couponLab.textAlignment = NSTextAlignmentCenter;

        /**竖线**/
        self.lineV = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2, 0, 1, 64)];
        self.lineV.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD" alpha:0.5];

        /**横线**/
        self.lineH = [[UIView alloc] initWithFrame:CGRectMake(0, 63, ScreenWidth, 1)];
        self.lineH.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC" alpha:0.5];

        /**订单按钮**/
        self.orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.orderBtn.frame = CGRectMake(0, 0, ScreenWidth/2, 64);
        [self.orderBtn addTarget:self action:@selector(orderCouponClick:) forControlEvents:UIControlEventTouchUpInside];
        self.orderBtn.tag = 1000;
        /**收藏按钮**/
        self.couponBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.couponBtn.frame = CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, 64);
        [self.couponBtn addTarget:self action:@selector(orderCouponClick:) forControlEvents:UIControlEventTouchUpInside];
        self.couponBtn.tag = 1001;

        [self.contentView addSubview:self.orderImg];
        [self.contentView addSubview:self.couponImg];
        [self.contentView addSubview:self.orderLab];
        [self.contentView addSubview:self.couponLab];
        [self.contentView addSubview:self.lineV];
        [self.contentView addSubview:self.lineH];
        [self.contentView addSubview:self.orderBtn];
        [self.contentView addSubview:self.couponBtn];

    }
    return self;
}

- (void)orderCouponClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(OrderCouponButtonClick:)])
    {
        [self.delegate OrderCouponButtonClick:button];
    }
}

@end
