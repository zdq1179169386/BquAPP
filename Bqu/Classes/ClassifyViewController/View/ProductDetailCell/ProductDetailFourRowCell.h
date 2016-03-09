//
//  ProductDetailFourRowCell.h
//  Bqu
//
//  Created by yb on 15/10/24.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"


@class ProductDetailFourRowCell;
@protocol   ProductDetailFourRowCellDelegate<NSObject>

@optional
-(void)ProductDetailFourRowCellBtnClick:(ProductDetailFourRowCell*)cell withBtn:(UIButton *)btn;

@end



@interface ProductDetailFourRowCell : UITableViewCell


/**代理*/
@property(nonatomic,assign)id<ProductDetailFourRowCellDelegate>  delegate;


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



/**model*/
@property(nonatomic,strong)ProductModel * model;


@end
