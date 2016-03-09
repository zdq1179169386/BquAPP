//
//  SubmitOrdersTableViewCell.h
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//  确认订单上 最后的提交订单的cell

#import <UIKit/UIKit.h>


@protocol SubmitOrderDelegate <NSObject>
@optional
-(void)submitOrder:(UIButton*)sender;

@end


@interface SubmitOrdersTableViewCell : UITableViewCell
@property (nonatomic)UILabel *payLab;
@property (nonatomic)UILabel *moneyLab;
@property (nonatomic)UIButton *subitBtn;

@property (nonatomic,weak)id<SubmitOrderDelegate>delegate;
-(void)setValue:(NSString*)money;
@end
