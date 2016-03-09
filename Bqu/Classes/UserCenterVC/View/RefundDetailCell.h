//
//  RefundDetailCell.h
//  Bqu
//
//  Created by yb on 15/10/29.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefundMessage.h"
@class RefundDetailCell;

@protocol RefundDetailCellDelegate <NSObject>

-(void)returenGoodsOrTwiceToApplyRefund:(RefundDetailCell *)cell with:(UIButton *)btn;

@end

@interface RefundDetailCell : UITableViewCell

/**之前订单的状态,1 为订单退款，没有二次申请的机会，2，3 有*/
@property(nonatomic,copy)NSString * orderStatus;

/**<#description#>*/
@property(nonatomic,assign)id<RefundDetailCellDelegate>  delegate;

/**<#description#>*/
@property(nonatomic,strong)UILabel * date;


/**<#description#>*/
@property(nonatomic,strong)UIView * bgImage;


/**<#description#>*/
@property(nonatomic,strong)UILabel * name;


/**<#description#>*/
@property(nonatomic,strong)UILabel * content;



/**<#description#>*/
@property(nonatomic,strong)UIButton * btn;


/**<#description#>*/
@property(nonatomic,strong)UILabel * line1;

/**<#description#>*/
@property(nonatomic,strong)UILabel * line2;


/**<#description#>*/
@property(nonatomic,strong)UIImageView * iconLeft;


/**<#description#>*/
@property(nonatomic,strong)UIImageView * iconRight;


/**退款消息*/
@property(nonatomic,strong)RefundMessageFrame * messageF;


@end
