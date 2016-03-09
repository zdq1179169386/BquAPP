//
//  ProductDetailFirstRowCell.h
//  Bqu
//
//  Created by yb on 15/10/20.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

@class ProductDetailFirstRowCell;
@protocol   ProductDetailFirstRowCellDelegate<NSObject>

-(void)ProductDetailFirstRowCellBtnClick:(ProductDetailFirstRowCell*)cell withBtn:(UIButton *)btn;

@end

@interface ProductDetailFirstRowCell : UITableViewCell

@property(nonatomic,assign)id<ProductDetailFirstRowCellDelegate>delegate;

@property (nonatomic,strong)ProductModel * productModel;

@property (nonatomic,strong)UIImageView * picture;
/**产地*/
@property (nonatomic,strong)UILabel * ProductAddress;
/**税率*/
@property (nonatomic,strong)UIButton * taxlabel;

/**查看详情*/
@property (nonatomic,strong)UIButton * lookDetail;

/**国籍图标*/
@property (nonatomic,strong)UIImageView *CountryLogo;

/**国籍名称*/
@property (nonatomic,strong)UILabel *CountryLogoName;

/**商品名称*/
@property (nonatomic,strong)UILabel *ProductName;


/**销售价*/
@property (nonatomic,strong)UILabel *SalePrice;

/**市场价*/
@property (nonatomic,strong)UILabel *MarketPrice;

/**评价数*/
@property (nonatomic,strong)UILabel *commentCount;


/**评分*/
@property (nonatomic,strong)UILabel *commentScore;

/**查看更多评价*/
@property (nonatomic,strong)UIButton *moreComment;

/**正品保障*/
@property (nonatomic,strong)UIButton *btn1;
/**海外直购*/
@property (nonatomic,strong)UIButton *btn2;
/**线下店铺*/
@property (nonatomic,strong)UIButton *btn3;
/**闪电发货*/
@property (nonatomic,strong)UIButton *btn4;

@property (nonatomic,strong) UILabel * lineOne;

@end


