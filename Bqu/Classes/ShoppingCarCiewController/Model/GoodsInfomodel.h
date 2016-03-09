//
//  GoodsInfomodel.h
//  Bqu
//
//  Created by yb on 15/10/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//  商品详情模型

#import <Foundation/Foundation.h>

@interface GoodsInfomodel : NSObject
@property(copy,nonatomic)NSString* cartItemId;// 购物车编号
@property(copy,nonatomic)NSString* skuId;//SKU编号
@property(copy,nonatomic)NSString* Id;//商品编号
@property(copy,nonatomic)NSString* imgUrl;//商品图片
@property(copy,nonatomic)NSString* name;//商品名称

@property(copy,nonatomic)NSString* price;//商品价格
@property(copy,nonatomic)NSString* count;//商品数量
@property(copy,nonatomic)NSString* shopId;//店铺编号
@property(copy,nonatomic)NSString* shopName;//店铺名称
@property(copy,nonatomic)NSString* status;//商品状态(1,正常;0,失效;)
@property(copy,nonatomic)NSString* tradeType;//贸易类型(1,E贸易;0,一般贸易)

@property(copy,nonatomic)NSString* maxSale;//库存
@property(copy,nonatomic)NSString* taxRate;//商品税率
@property(copy,nonatomic)NSString* showStatus;//商品排序()
@property(copy,nonatomic)NSString* pushCustomsPrice;//推送海关价

@property (nonatomic,copy)NSString *preferentialPrice;// 优惠后的价格
@property (nonatomic)NSArray *virtualProductArray;//虚拟商品
@property (nonatomic)NSString *isVirtualProduct;//是否虚拟商品
@property (nonatomic) BOOL selectState;//是否被选择了


-(instancetype)initWithDict:(NSDictionary *)dict;
+(CGFloat)getAllGoodsPrice:(NSArray*)goodsArray;
@end
