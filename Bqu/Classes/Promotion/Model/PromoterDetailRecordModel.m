//
//  PromoterDetailRecord.m
//  Bqu
//
//  Created by wyy on 15/12/11.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "PromoterDetailRecordModel.h"

@implementation PromoterDetailRecordModel

- (void)promoterDetailRecordModelFromDictionary:(NSDictionary *)dic
{
    if(![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    self.recordId = dic[@"Id"];
    self.mobile = dic[@"Mobile"];
    self.createDate = dic[@"CreateDate"];
    self.price = dic[@"Price"];
    self.cardNo = dic[@"CardNo"];
    self.bankName = dic[@"BankName"];
    self.statusName = dic[@"StatusName"];
    self.showName = dic[@"ShowName"];
    self.type = dic[@"Type"];
    self.status = dic[@"Status"];
}


@end
