//
//  PreferentialSelectTableViewCell.h
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//  确认订单页面上  优惠劵cell

#import <UIKit/UIKit.h>
#import "PreferentialModel.h"

@interface PreferentialSelectTableViewCell : UITableViewCell
@property (nonatomic)UILabel * price;
@property (nonatomic)UILabel *useLimit;
@property (nonatomic)UIImageView * isSelect;

-(void)setValue:(PreferentialModel*)pm;
@end
