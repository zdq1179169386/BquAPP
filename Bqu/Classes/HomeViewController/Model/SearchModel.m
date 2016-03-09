//
//  SearchModel.m
//  Bqu
//
//  Created by WONG on 15/10/26.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel
//- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//    
//}

+(SearchModel *)createSearchModelWithDic:(NSMutableDictionary *)dic {
    SearchModel *searchModel = [[SearchModel alloc]init];
    searchModel.Identifier = dic[@"Id"];
    searchModel.ProductName = dic[@"ProductName"];
    searchModel.ShopId = dic[@"ShopId"];
    searchModel.CategoryId = dic[@"CategoryId"];
    searchModel.BrandId = dic[@"BrandId"];
    searchModel.MinSalePrice = dic[@"MinSalePrice"];
    searchModel.Price = dic[@"Price"];
    searchModel.MarketPrice = dic[@"MarketPrice"];
    searchModel.SaleCounts = dic[@"SaleCounts"];
    searchModel.CommentCounts = dic[@"CommentCounts"];
    searchModel.Stock = dic[@"Stock"];
    searchModel.SKUId = dic[@"SKUId"];
    searchModel.SKU = dic[@"SKU"];
    searchModel.TradeType = dic[@"TradeType"];
    searchModel.TaxRate = dic[@"TaxRate"];
    searchModel.ImgUrl = dic[@"ImgUrl"];
    searchModel.IsVirtualProduct = dic[@"IsVirtualProduct"];
    return searchModel;
}
@end
