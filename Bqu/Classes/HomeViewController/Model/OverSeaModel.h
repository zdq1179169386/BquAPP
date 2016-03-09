//
//  OverSeaModel.h
//  Bqu
//
//  Created by WONG on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OverSeaModel : NSObject
@property (nonatomic ,copy)NSArray *data;
@property (nonatomic ,copy)NSString *BrandName;//品牌名
@property (nonatomic ,copy)NSString *Ico;//国籍图标
@property (nonatomic, copy)NSString *CountryName;//国家名字
@property (nonatomic ,copy)NSString *identifier;//ID编号
@property (nonatomic ,copy)NSString *ImageUrl;//图片地址
@property (nonatomic ,copy)NSString *Name;//名称
@property (nonatomic ,copy)NSString *MarketPrice;//市场价
@property (nonatomic ,copy)NSString *SalePrice;//销售价
@property (nonatomic ,copy)NSString *CommentsCount;// 评论数
@property (nonatomic ,copy)NSString *SkuId;//SKU编号
@property (nonatomic ,copy)NSString *Stock;// 库存
@property (nonatomic ,copy)NSString *LimitPrice;//是否限时


+ (OverSeaModel *)createOverSeaModelDictionary:(NSDictionary *)dic;
@end
