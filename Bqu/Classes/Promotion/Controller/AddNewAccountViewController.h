//
//  AddNewAccountViewController.h
//  Bqu
//
//  Created by WONG on 15/12/9.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "PromotionBsaeViewController.h"
#import "ApplyForRefundAlertView.h"

@interface AddNewAccountViewController : PromotionBsaeViewController<UITableViewDataSource,UITableViewDelegate,ApplyForRefundAlertViewDelaget>


@property (nonatomic,strong) NSString *accountId;

@end
