//
//  ProductDeatailWebCell.h
//  Bqu
//
//  Created by yb on 15/10/22.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
@interface ProductDeatailWebCell : UITableViewCell

@property (nonatomic,strong)ProductModel * model;

@property (nonatomic,strong) UILabel * productName;
@property (nonatomic,strong) UILabel * productId;
@property (nonatomic,strong) UIWebView * web;
@end
