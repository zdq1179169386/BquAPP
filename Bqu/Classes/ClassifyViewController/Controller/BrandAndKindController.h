//
//  BrandAndKindController.h
//  Bqu
//
//  Created by yb on 15/10/14.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCategoryData.h"
#import "CateBrands.h"
#import "ClassifyBaseViewController.h"

typedef enum {
     SearchWord_cid = 0,
     SearchWord_bid = 1,
     SearchWord_keyword = 2
    
}SearchWordType;


@interface BrandAndKindController : ClassifyBaseViewController

@property (nonatomic,strong)ProductCategoryData * SubCategories;
@property (nonatomic,strong)CateBrands * cateBrands;

/**搜索的关键字*/
@property(nonatomic,assign) SearchWordType  searchWordType;

//cid 或者 bid ，或者
@property (nonatomic,copy) NSString * cid;
@property (nonatomic,copy) NSString * bid;
// 搜索词
@property (nonatomic,copy) NSString * keyword;
/**导航条的标题*/
@property (nonatomic,copy)NSString * navBarTitle;
@end
