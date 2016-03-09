//
//  CouponCell.h
//  Bqu
//
//  Created by yingbo on 15/10/27.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *couponImg_ImgView;
@property (strong, nonatomic) IBOutlet UILabel *couponPrice_Lab;
@property (strong, nonatomic) IBOutlet UILabel *couponTip_Lab;
@property (strong, nonatomic) IBOutlet UILabel *couponDate_Lab;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIView *grayView;

@end
