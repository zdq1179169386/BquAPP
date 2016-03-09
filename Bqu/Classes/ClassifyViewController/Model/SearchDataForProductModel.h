//
//  SearchDataForProductModel.h
//  Bqu
//
//  Created by yb on 15/10/19.
//  Copyright (c) 2015年 yb. All rights reserved.
// 搜索接口，返回的商品模型

#import <Foundation/Foundation.h>

@interface SearchDataForProductModel : NSObject
/**商品ID*/
@property (nonatomic,copy) NSString * Id;

@property (nonatomic,copy) NSString * ProductName;
/**限时购价格(正常商品显示null)*/
@property (nonatomic,copy) NSString * Price;
/**销售价*/
@property (nonatomic,copy) NSString * MinSalePrice;
/**市场价*/
@property (nonatomic,copy) NSString * MarketPrice;

@property (nonatomic,copy) NSString * ImageUrl;

@property (nonatomic,copy) NSString * ImgUrl;

@end
/*
"Id": 148,//编号
"ProductName": "奥克斯空调",//名称
"ShopId": 1,//店铺编号
"CategoryPath": "1|6|69",//分类路径
"CategoryId": 69,//分类ID
"BrandId": 53,//品牌ID
"MinSalePrice": 3600,//销售价
"Price": null,//限时购价格(正常商品显示null)
"MarketPrice": 3000,//市场价
"SaleCounts": 0,//名称
"CommentCounts": null,//评论数
"Stock": 99,//库存数
"SKUId": "148_0_0_0",//SKU编号
"SKU": "1510140001_0_0_0",//货号
"TradeType": 1,//贸易类型(1,E贸易;0,一般贸易;)
"TaxRate": 0,//商品税率
"DomainName": "http://192.168.18.250:10000",//
"ImagePath": "/Storage/Shop/1/Products/148",//
"ImageUrl": "http://192.168.18.250:10000/Storage/Shop/1/Products/148",//
"ImageCount": "ed741228-7871-4623-9158-ce91b51125eb",//
"ImgUrl": "http://192.168.18.250:10000/Storage/Shop/1/Products/148/ed741228-7871-4623-9158-ce91b51125eb_350.jpg",//图片地址
"IsVirtualProduct": 0//是否捆绑商品(0,否;1,是;)
*/