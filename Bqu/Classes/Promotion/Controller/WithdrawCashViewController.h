//
//  WithdrawCashViewController.h
//  Bqu
//
//  Created by wyy on 15/12/9.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "PromotionBsaeViewController.h"

@interface WithdrawCashViewController : PromotionBsaeViewController


/**推广员id*/
@property(nonatomic,strong)NSString * accountID;


/**可用金额*/
@property(nonatomic,strong)NSString * usableMoney;


/**账户id*/
//@property(nonatomic,strong)NSString * accountID;

@end
