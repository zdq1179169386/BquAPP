//
//  ScoreModel.m
//  Bqu
//
//  Created by yb on 15/10/20.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "ScoreModel.h"
#import "GoodsInfomodel.h"
#import "GoodsTool.h"

@implementation ScoreModel
+(ScoreModel*)scoreModelWithDictionary:(NSDictionary*)dictionary
{
    ScoreModel *score = [[ScoreModel alloc] init];
    if (![dictionary isKindOfClass:[NSNull class]])
    {
        score.integral = dictionary[@"UseIntegralInfo"] ;
        score.integralPerMoney = dictionary[@"IntegralRuleInfo"];
        score.dedMoneyInfo = dictionary[@"DedMoneyInfo"];
        score.isUse = 0;
    }
    NSLog(@"%@,%@,%@",score.integral,score.integralPerMoney,score.dedMoneyInfo);
    return score;
}




+(double)getMaxMoney:(GetShopCarSetterInformation*)shopcar
{
//    //------------先   计算所有商品的总价格－－－－－－－－－
//    double allGoodsPrice = shopcar.totalAmount.doubleValue;
//    //--------------------------------------------------
//    
//    
//    //——————————————再  计算优惠卷的使用情况————————————————————————
//    PreferentialModel * prefer = nil ;
//    double couponsPrice = 0 ;
//    for (int i = 0 ; i < shopcar.userCoupons.count; i++)
//    {
//        prefer = shopcar.userCoupons[i];
//        if (prefer.isSelect)
//        {
//            break;
//        }
//    }
//    if (prefer != nil)
//    {
//        couponsPrice = prefer.price.doubleValue;
//    }
//    //___________________________________________________________
//    
//    
//    //——————————————最后  计算可用积分情况————————————————————————
//    ScoreModel * scoreModel = shopcar.dedMoneyInfo;
//    double money = allGoodsPrice/2.0 - couponsPrice;
//    //如果计算出的积分大于  可用积分， 就返回可用积分
//    if (money > (scoreModel.dedMoneyInfo.doubleValue))
//    {
//        money =  scoreModel.dedMoneyInfo.doubleValue;//+0.005 ;
//    }
//    //___________________________________________________________
    
    ScoreModel * scoreModel = shopcar.dedMoneyInfo;
    
    return scoreModel.dedMoneyInfo.doubleValue;
}

+(NSInteger)getMaxScore:(GetShopCarSetterInformation*)shopcar
{
//    if (shopcar == nil)
//        return 0;
//    double Score =[ScoreModel getMaxMoney:shopcar];
//    ScoreModel * scoreModel = shopcar.dedMoneyInfo;
//    NSInteger money = Score*scoreModel.integralPerMoney.doubleValue;
     ScoreModel * scoreModel = shopcar.dedMoneyInfo;
    return scoreModel.integral.intValue;
}


+(double)isSelectScoreMaxMoney:(GetShopCarSetterInformation*)shopcar
{
    double Score = [self getMaxScore:shopcar];
    if (shopcar.dedMoneyInfo.isUse)
    {
        return Score;
    }
    return 0;
}

@end
