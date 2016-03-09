//
//  OrderSumitTableViewCell.h
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
// // 支付成功 之后  显示支付成功的cell；

#import <UIKit/UIKit.h>

@interface OrderSumitTableViewCell : UITableViewCell
@property (nonatomic)UIImageView * image;
@property (nonatomic)UILabel * orderLab;
@property (nonatomic)UILabel * sumitLab;
@property (nonatomic)UIView *bgView;
-(void)setValue:(NSString*)str1 str:(NSString*)str;
@end
