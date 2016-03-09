//
//  ProductDetailThreeRowCell.h
//  Bqu
//
//  Created by yb on 15/10/21.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

@class ProductDetailThreeRowCell;
@protocol   ProductDetailThreeRowCellDelegate<NSObject>

@optional
-(void)ProductDetailThreeRowCellBtnClick:(ProductDetailThreeRowCell*)cell withBtn:(UIButton *)btn;

@end


@interface ProductDetailThreeRowCell : UITableViewCell

@property (nonatomic,assign)id<ProductDetailThreeRowCellDelegate>delegate;
/**销售价*/
@property (nonatomic,strong)UILabel *SalePrice;

/**市场价*/
@property (nonatomic,strong)UILabel *MarketPrice;

@property (nonatomic,strong)ProductModel * productModel;

@property (nonatomic,strong) UILabel * lineOne;

@end
