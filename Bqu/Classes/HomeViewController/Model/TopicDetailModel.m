//
//  TopicDetailModel.m
//  Bqu
//
//  Created by WONG on 15/10/23.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "TopicDetailModel.h"

@implementation TopicDetailModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+(TopicDetailModel *)createDetailModelWithDic:(NSDictionary *)dic {
    TopicDetailModel *model = [[TopicDetailModel alloc]init];
    model.Comment = dic[@"Comment"];
    model.ImageUrl = dic[@"ImageUrl"];
    model.MarketPrice = dic[@"MarketPrice"];
    model.MinSalePrice = dic[@"MinSalePrice"];
    model.Moods = dic[@"Moods"];
    model.ProductId = dic[@"ProductId"];
    model.ProductName = dic[@"ProductName"];
    model.SaleCount = dic[@"SaleCount"];
    return model;
}
@end
