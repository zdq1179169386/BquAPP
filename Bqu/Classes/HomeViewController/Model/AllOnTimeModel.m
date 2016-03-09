//
//  AllOnTimeModel.m
//  Bqu
//
//  Created by WONG on 15/11/3.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "AllOnTimeModel.h"

@implementation AllOnTimeModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
+ (AllOnTimeModel *)createModelWithDic:(NSMutableDictionary *)dic {
    AllOnTimeModel *model = [[AllOnTimeModel alloc]init];
    model.Discount = dic[@"Discount"];
    model.ImgPath = dic[@"ImgPath"];
    model.LimitPrice = dic[@"LimitPrice"];
    model.MarketPrice = dic[@"MarketPrice"];
    model.Pid = dic[@"Pid"];
    model.ProductName = dic[@"ProductName"];
    model.Storage = dic[@"Storage"];
    return model;
}
@end
