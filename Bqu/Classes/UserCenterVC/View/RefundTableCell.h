//
//  RefundTableCell.h
//  Bqu
//
//  Created by yb on 15/10/27.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AfterSaleOrderModel.h"
@interface RefundTableCell : UITableViewCell

@property(nonatomic,strong) UILabel *  orderStatus;

@property(nonatomic,strong) UILabel *  orderDate;

@property(nonatomic,strong) UIImageView *  orderImage;

@property(nonatomic,strong) UILabel *  orderName;

@property(nonatomic,strong) UILabel *  Price;

@property(nonatomic,strong) UILabel *  number;

@property(nonatomic,strong) UILabel *  dealPrice;


/**model*/
@property(nonatomic,strong)AfterSaleOrderModel * model;


///**捆绑商品的model*/
//@property(nonatomic,strong)RefundItemModel * itemModel;


@end
