//
//  AccountModel.m
//  Bqu
//
//  Created by WONG on 15/12/9.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "AccountModel.h"

@implementation AccountModel
- (void)setValue:(id)value forKey:(NSString *)key {
    
}

+ (instancetype)accountModel:(NSDictionary *)dic {
    AccountModel *accountModel = [[AccountModel alloc]init];
    accountModel.accountStyle = dic[@"TypeName"];
    
    if ([dic[@"Type"]  isEqualToNumber:[NSNumber numberWithInt:1]]) {
       accountModel.subTitle = [NSString stringWithFormat:@"%@ %@",dic[@"UserName"],dic[@"AccountNumber"]];
    }else {
        accountModel.subTitle = [NSString stringWithFormat:@"%@ %@",dic[@"UserName"],dic[@"BankCardNumber"]];
    }
    accountModel.BankId = dic[@"BankId"];
    accountModel.deleteState = 1;
    return accountModel;
}
@end
