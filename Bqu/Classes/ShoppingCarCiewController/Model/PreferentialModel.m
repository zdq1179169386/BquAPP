//
//  PreferentialModel.m
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "PreferentialModel.h"


//@property (nonatomic) NSInteger *couponId;//优惠劵ID
//@property (nonatomic) NSString *price;// 优惠劵金额
//@property (nonatomic) NSString * couponName;//优惠劵名称
//@property (nonatomic) NSString * endTime;//优惠劵到期时间
@implementation PreferentialModel
+(PreferentialModel*)preferentialModelWithDict:(NSDictionary*)dic
{
    PreferentialModel *pm = [[PreferentialModel alloc] init];
    if (![dic isKindOfClass:[NSNull class]])
    {
        pm.couponId = dic[@"CouponId"] ;
        pm.price = dic[@"Price"] ;
        pm.couponName = dic[@"CouponName"];
        pm.endTime = dic[@"EndTime"];
        pm.orderAmount = dic[@"OrderAmount"];
        pm.isSelect = NO;
    }
    return pm;
}

+(NSInteger)whichIsByUse:(NSArray*)Preferentials
{
    NSInteger index = -1;
    if (Preferentials)
    {
        for (int i = 0 ; i < Preferentials.count; i++)
        {
            PreferentialModel * pre= Preferentials[i];
            if (pre.isSelect == 1 )
            {
                index = i;
            }
        }
    }
    return index;
}


+(CGFloat)getCouponPrice:(NSArray*)Preferentials
{
    if (Preferentials == nil) {
        return 0;
    }
    NSInteger index= [PreferentialModel whichIsByUse:Preferentials];
    if (index < 0 ||index >= Preferentials.count )
        return 0;
    else
    {
        PreferentialModel *  pre = Preferentials[index];
        return pre.price.floatValue;
    }
}

+(NSString*)whichIDIsByUse:(NSArray*)Preferentials
{
    NSInteger index = [PreferentialModel whichIsByUse:Preferentials];
    if (index < 0 ||index >= Preferentials.count )
    {
        return @"";
    }
    else
    {
        PreferentialModel * pre = Preferentials[index];
        return pre.couponId;
    }
}
@end
