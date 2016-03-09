//
//  ProductModel.h
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductModel : NSObject
/**品牌*/
@property (nonatomic,copy)NSString *BrandName;
/**国籍图标*/
@property (nonatomic,copy)NSString *CountryLogo;
/**国籍名称*/
@property (nonatomic,copy)NSString *CountryLogoName;

/**SKUID*/
@property (nonatomic,copy)NSString *DefaultSkuId;

/**编号*/
@property (nonatomic,copy)NSString *Id;

/**图片地址*/
@property (nonatomic,copy)NSString *ImageUrl;

/**是否收藏,1 收藏，0 否　*/
@property (nonatomic,copy)NSString * IsFavorite;

/**是否捆绑商品(0,否;1,是;捆绑商品不显示税率*/
@property (nonatomic,copy)NSString *IsVirtualProduct;

/**市场价*/
@property (nonatomic,copy)NSString *MarketPrice;

/**单位*/
@property (nonatomic,copy)NSString *MeasureUnit;

/**商品发货地*/
@property (nonatomic,copy)NSString *ProductAddress;

/**商品货号*/
@property (nonatomic,copy)NSString *ProductCode;

/**商品描述*/
@property (nonatomic,copy)NSString *ProductDescription;

/**名称*/
@property (nonatomic,copy)NSString *ProductName;

/**商品评分*/
@property (nonatomic,copy)NSString *ReviewMark;

/**销售价*/
@property (nonatomic,copy)NSString *SalePrice;
/**店铺*/
@property (nonatomic,copy)NSString *ShopName;
/**库存*/
@property (nonatomic,copy)NSString *Stock;
/**商品税率*/
@property (nonatomic,copy)NSString *TaxRate;
/**贸易类型(1,E贸易;0,一般贸易)*/
@property (nonatomic,copy)NSString *TradeType;

/**体积*/
@property (nonatomic,copy)NSString *Volume;

/**重量*/
@property (nonatomic,copy)NSString *Weight;

/**属性*/
@property (nonatomic,copy)NSArray *_PAttributesModel;

/**是否限时购商品（1，是；0，否；*/
@property (nonatomic,copy)NSString *IsLimitProduct;

/**限购数量(是限时购商品不为0,否则为0)*/
@property (nonatomic,copy)NSString * MaxBuyCount;


/**限时购结束日期(是限时购显示结束日期,非限时购为null)*/
@property (nonatomic,copy)NSString * OverTime;


/**评论数*/
@property(nonatomic,copy)NSString * CommentCount;


/**总的评论数*/
@property(nonatomic,copy)NSString * allCommentCount;



/**如果登录,且商品为限时购商品,该字段显示是否可购买(0,可购买;1,不可购买)*/
@property(nonatomic,copy)NSString * MaxLimit;


/**海关推送价格*/
@property(nonatomic,strong)NSString * CustomPushPrice;

//"IsLimitProduct":1,//是否限时购商品（1，是；0，否；）
//"MaxBuyCount":5,//限购数量(是限时购商品不为0,否则为0)
//"OverTime":"2015/10/25 12:00:00"//限时购结束日期(是限时购显示结束日期,非限时购为null)


@end
