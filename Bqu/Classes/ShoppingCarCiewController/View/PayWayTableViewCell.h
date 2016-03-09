//
//  PayWayTableViewCell.h
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//  支付方式cell 支付宝或者银联

#import <UIKit/UIKit.h>

@interface PayWayTableViewCell : UITableViewCell

@property (nonatomic)UIImageView *image;
-(void)setValue2:(BOOL)on;
@end
