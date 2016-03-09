//
//  PayMoneyTableViewCell.h
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//   支付 成功或者支付时候 显示订单的金额 cell

#import <UIKit/UIKit.h>

@interface PayMoneyTableViewCell : UITableViewCell
@property (nonatomic)UILabel *payMoney;
@property (nonatomic)UILabel *payPrice;

-(void)setValue:(NSString *)price;
@end
