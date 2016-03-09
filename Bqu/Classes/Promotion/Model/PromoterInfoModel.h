//
//  PromoterInfoModel.h
//  Bqu
//
//  Created by wyy on 15/12/9.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PromoterInfoModel : NSObject

@property (nonatomic, copy) NSString *userId;        //用户ID
@property (nonatomic, copy) NSString *accountID;     //账户ID
@property (nonatomic, copy) NSString *referImage;    //推广二维码
@property (nonatomic, copy) NSString *referURL;      //推广地址
@property (nonatomic, copy) NSString *usableMoney;   //可用金额
@property (nonatomic, copy) NSString *freezMoney;    //冻结金额
@property (nonatomic, copy) NSString *totalRebate;   //总计返利
@property (nonatomic, copy) NSString *memberId;      //会员ID

- (void)promoterInfoModelFromDictionary:(NSDictionary *)dic;

@end
