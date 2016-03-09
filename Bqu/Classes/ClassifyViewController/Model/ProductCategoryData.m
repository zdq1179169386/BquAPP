//
//  ProductCategoryData.m
//  Bqu
//
//  Created by yb on 15/10/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "ProductCategoryData.h"
@implementation ProductCategoryData


+(NSDictionary *)objectClassInArray
{
     return @{
                @"SubCategories" : @"ProductCategoryData",
                @"CateBrands" : @"CateBrands"
              };

}
@end

