//
//  PreferentialModel.h
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//  优惠劵模型

#import <Foundation/Foundation.h>

@interface PreferentialModel : NSObject
@property (nonatomic,copy) NSString * couponId;//优惠劵ID
@property (nonatomic,copy) NSString * price;// 优惠劵金额
@property (nonatomic,copy) NSString * couponName;//优惠劵名称
@property (nonatomic,copy) NSString * endTime;//优惠劵到期时间
@property (nonatomic,copy) NSString * orderAmount;//订单满减的额度
@property (nonatomic) BOOL isSelect;
+(PreferentialModel*)preferentialModelWithDict:(NSDictionary*)dic;


//工具方法 用来判断优惠劵 哪张被使用， －1表示没有被使用的
+(NSInteger)whichIsByUse:(NSArray*)Preferentials;
+(CGFloat)getCouponPrice:(NSArray*)Preferentials;
+(NSString*)whichIDIsByUse:(NSArray*)Preferentials;
@end
