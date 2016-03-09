//
//  OverSeaModel.m
//  Bqu
//
//  Created by WONG on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "OverSeaModel.h"

@implementation OverSeaModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (OverSeaModel *)createOverSeaModelDictionary:(NSDictionary *)dic {
    OverSeaModel *overSea = [[OverSeaModel alloc]init];
    overSea.identifier = dic[@"Id"];
    overSea.Name = dic[@"Name"];
    overSea.MarketPrice = dic[@"MarketPrice"];
    overSea.SalePrice = dic[@"SalePrice"];
    overSea.ImageUrl = dic[@"ImageUrl"];
    overSea.CommentsCount = dic[@"CommentsCount"];
    overSea.Ico = dic[@"Ico"];
    overSea.BrandName = dic[@"BrandName"];
    overSea.SkuId = dic[@"SkuId"];
    overSea.Stock = dic[@"Stock"];
    overSea.LimitPrice = dic[@"LimitPrice"];
    overSea.CountryName = dic[@"CountryName"];
    return overSea;
}
@end
