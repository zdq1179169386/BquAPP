//
//  ScoreModel.h
//  Bqu
//
//  Created by yb on 15/10/20.
//  Copyright (c) 2015年 yb. All rights reserved.
//  可用积分的模型

#import <Foundation/Foundation.h>
#import "GetShopCarSetterInformation.h"


@interface ScoreModel : NSObject
@property (nonatomic,copy)NSString* integral;//可用积分
@property (nonatomic,copy)NSString* integralPerMoney;//兑换比例
@property (nonatomic,copy)NSString* dedMoneyInfo;//抵扣金额
@property (nonatomic)BOOL isUse;//是否使用
+(ScoreModel*)scoreModelWithDictionary:(NSDictionary*)dictionary;

+(NSInteger)getMaxScore:(GetShopCarSetterInformation*)shopcar;
+(double)getMaxMoney:(GetShopCarSetterInformation*)shopcar;
+(double)isSelectScoreMaxMoney:(GetShopCarSetterInformation*)shopcar;
@end
