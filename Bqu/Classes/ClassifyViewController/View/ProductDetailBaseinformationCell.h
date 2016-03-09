//
//  ProductDetailBaseinformationCell.h
//  Bqu
//
//  Created by yb on 15/10/22.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
@interface ProductDetailBaseinformationCell : UITableViewCell
@property (nonatomic,strong) UILabel * productBrand;
@property (nonatomic,strong) UILabel * productUnit;
@property (nonatomic,strong) UILabel * weight;
@property (nonatomic,strong) UILabel * volume;

@property (nonatomic,strong)ProductModel * model;

@end
