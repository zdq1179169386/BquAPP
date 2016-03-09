//
//  GetShopCarSetterInformation.m
//  Bqu
//
//  Created by yb on 15/10/23.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "GetShopCarSetterInformation.h"
#import "ScoreModel.h"


@implementation GetShopCarSetterInformation
-(instancetype)initWithDic:(NSDictionary*)dic
{
    NSLog(@"看清单%@",dic);
    if (self = [super init])
    {
        if (![dic isKindOfClass:[NSNull class]] )
        {
            self.totalAmount = dic[@"TotalAmount"];
            self.totalTax = dic[@"TotalTax"];
            self.pushCustomsTax = dic[@"TotalPushCustomsTax"];
            self.totalFreight = dic[@"TotalFreight"];
            self.amount = dic[@"Amount"];
            self.orderAmount = dic[@"OrderAmount"];
            
            NSArray *cartArray = dic[@"CartProductModel"];
            NSMutableArray * cartemp = [[NSMutableArray alloc ] init];
            for (int  i = 0 ;i <  cartArray.count ;i++)
            {
                CartProductModel * carModel = [[CartProductModel alloc] initWithDic:cartArray[i]];
                [cartemp addObject:carModel];
            }
            self.cartProductModels =cartemp;
            
            if(![dic[@"DefaultAddressInfo"] isKindOfClass:[NSNull class]])
            {
            self.address =[AddressModel addressModelWithDict:dic[@"DefaultAddressInfo"]];
            }
            ScoreModel *score = [[ScoreModel alloc] init];
            
            score.integral = dic[@"UseIntegralInfo"];
            score.integralPerMoney = dic[@"IntegralRuleInfo"];
            score.dedMoneyInfo = dic[@"DedMoneyInfo"];
            score.isUse = 0;
            self.dedMoneyInfo = score;
            
            NSMutableArray * tempArray = [[NSMutableArray alloc] init];
            
            NSArray * CouponsArray = dic[@"UserCoupon"];
            if (CouponsArray)
            {
                for (int  i = 0 ;i <  CouponsArray.count ;i++ )
                {
                    PreferentialModel * coupon = [PreferentialModel preferentialModelWithDict:CouponsArray[i]];
                    [tempArray addObject: coupon ];
                }
                self.userCoupons = tempArray;
            }
        }
    }
    return self;
}

@end
