//
//  PromoterInfoModel.m
//  Bqu
//
//  Created by wyy on 15/12/9.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "PromoterInfoModel.h"

@implementation PromoterInfoModel

- (void)promoterInfoModelFromDictionary:(NSDictionary *)dic
{
    if(![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    self.userId = dic[@"UserId"];
    self.accountID = dic[@"AccountID"];
    self.referImage = dic[@"ReferImage"];
    self.referURL = dic[@"ReferURL"];
    self.usableMoney = dic[@"BalancePrice"];
    self.freezMoney = dic[@"FreezPrice"];
    self.totalRebate = dic[@"TotalPrice"];
    self.memberId = dic[@"MemberId"];
}

@end
