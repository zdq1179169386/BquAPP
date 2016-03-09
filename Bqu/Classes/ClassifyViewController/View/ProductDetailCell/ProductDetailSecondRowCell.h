//
//  ProductDetailSecondRowCell.h
//  Bqu
//
//  Created by yb on 15/10/21.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
@interface ProductDetailSecondRowCell : UITableViewCell

/**商品名称*/
@property (nonatomic,strong)UILabel *ProductName;


@property (nonatomic,strong)ProductModel * productModel;


@end
