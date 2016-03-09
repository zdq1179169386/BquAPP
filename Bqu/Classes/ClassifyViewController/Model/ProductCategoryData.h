//
//  ProductCategoryData.h
//  Bqu
//
//  Created by yb on 15/10/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CateBrands.h"

@interface ProductCategoryData : NSObject


@property (nonatomic,copy)NSString * Id;

@property(nonatomic,copy)NSString * Name;

@property(nonatomic,copy)NSString * Image;

@property(nonatomic,copy)NSString * Depth;

@property(nonatomic,strong)NSMutableArray * SubCategories;

@property(nonatomic,strong)NSMutableArray * CateBrands;


+(NSArray *)paserWithJson:(id)json;

+(instancetype)initWithDic:(NSDictionary *)dic;

//"Id": 126,//一级分类编号
//"Name": "家用电器",//一级分类名称
//"Image": null,//一级分类图片
//"Depth": 0,
//"SubCategories": [
//"CateBrands": [
//

@end
