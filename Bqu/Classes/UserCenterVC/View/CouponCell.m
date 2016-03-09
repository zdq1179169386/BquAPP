//
//  CouponCell.m
//  Bqu
//
//  Created by yingbo on 15/10/27.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "CouponCell.h"

@implementation CouponCell

- (void)awakeFromNib
{
    self.couponPrice_Lab.textColor = [UIColor whiteColor];
    self.couponDate_Lab.textColor = [UIColor colorWithHexString:@"#888888"];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F2F0F1"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
