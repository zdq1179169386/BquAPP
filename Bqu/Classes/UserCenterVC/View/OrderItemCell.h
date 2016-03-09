//
//  OrderItemCell.h
//  Bqu
//
//  Created by yingbo on 15/12/1.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderItemCell;
@protocol applyRefundDelegate <NSObject>

- (void)applyRefundButtonClick:(UIButton *)button;

@end

@interface OrderItemCell : UITableViewCell


@property (nonatomic,strong) UIImageView *productImg;
@property (nonatomic,strong) UILabel *productName;
@property (nonatomic,strong) UILabel *productPrice;
@property (nonatomic,strong) UILabel *productCount;
@property (nonatomic,strong) UIButton *refundBtn;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) OrderDetailItem *item;
@property (nonatomic,strong) MyOrder_Model *order;

@property (nonatomic,assign) id<applyRefundDelegate> delegate;


@property (nonatomic,strong) NSDictionary *dataDic;

- (void)setValue:(id)value withRecycle:(id)order;


@end
