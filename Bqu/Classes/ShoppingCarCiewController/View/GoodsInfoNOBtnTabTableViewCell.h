//
//  GoodsInfoNOBtnTabTableViewCell.h
//  Bqu
//
//  Created by yb on 15/10/17.
//  Copyright (c) 2015年 yb. All rights reserved.
//  确认订单上 已经选择的商品cell 没有选择按钮

#import <UIKit/UIKit.h>
#import "GoodsInfomodel.h"

@interface GoodsInfoNOBtnTabTableViewCell : UITableViewCell
@property (nonatomic)UIImageView *image;//商品的图片
@property (nonatomic)UILabel * describeLab;//商品的描述
@property (nonatomic)UILabel * price;//商品的价格
@property (nonatomic)UILabel * count;//商品的数量
@property (nonatomic)UILabel *rateLab;

-(void)setValue:(GoodsInfomodel*)goods;
@end
