//
//  DrawCashAlertViewCell.h
//  Bqu
//
//  Created by yb on 15/12/11.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PromotionAccountModel.h"
@interface DrawCashAlertViewCell : UITableViewCell

@property (nonatomic,strong)UILabel * accountLabel;

@property (nonatomic,strong) UILabel * numberLabel;

/**<#description#>*/
@property(nonatomic,strong)PromotionAccountModel * model;


@end
