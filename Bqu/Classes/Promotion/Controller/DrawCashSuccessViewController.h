//
//  DrawCashSuccessViewController.h
//  Bqu
//
//  Created by yb on 15/12/11.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "PromotionBsaeViewController.h"

@interface DrawCashSuccessViewController : PromotionBsaeViewController

/**推广员id*/
@property(nonatomic,strong)NSString * accountID;

/**返回提现记录ID*/
@property(nonatomic,strong)NSString * RecordID;


/**提现金额*/
@property(nonatomic,strong)NSString * money;

@end
