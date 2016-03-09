//
//  SearchModel.h
//  Bqu
//
//  Created by WONG on 15/10/26.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchModel : NSObject
@property (nonatomic,strong)NSString *Identifier;//编号
@property (nonatomic,strong)NSString *ProductName;//名称
@property (nonatomic,strong)NSString *ShopId;//店铺编号
@property (nonatomic,strong)NSString *CategoryPath;//分类路径
@property (nonatomic,strong)NSString *CategoryId;//分类ID
@property (nonatomic,strong)NSString *BrandId;//品牌ID
@property (nonatomic,strong)NSString *MinSalePrice;//销售价
@property (nonatomic,strong)NSString *Price;//限时购价格(正常商品显示null)
@property (nonatomic,strong)NSString *MarketPrice;//市场价
@property (nonatomic,strong)NSString *SaleCounts;//名称
@property (nonatomic,strong)NSString *CommentCounts;//评论数
@property (nonatomic,strong)NSString *Stock;//库存数
@property (nonatomic,strong)NSString *SKUId;//SKU编号
@property (nonatomic,strong)NSString *SKU;//货号
@property (nonatomic,strong)NSString *TradeType;//贸易类型(1,E贸易;0,一般贸易;)
@property (nonatomic,strong)NSString *TaxRate;//商品税率
@property (nonatomic,strong)NSString *ImgUrl;//图片地址
@property (nonatomic,strong)NSString *IsVirtualProduct;//是否捆绑商品(0,否;1,是;)

+(SearchModel *)createSearchModelWithDic:(NSMutableDictionary *)dic;

@end
