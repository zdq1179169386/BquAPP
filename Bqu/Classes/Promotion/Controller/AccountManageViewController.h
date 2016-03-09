//
//  AccountManageViewController.h
//  Bqu
//
//  Created by WONG on 15/12/8.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "PromotionBsaeViewController.h"

@interface AccountManageViewController : PromotionBsaeViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSString *MemberID;
@property (nonatomic,strong)NSString *AccountID;
@property (nonatomic,strong)NSString *token;
@end
