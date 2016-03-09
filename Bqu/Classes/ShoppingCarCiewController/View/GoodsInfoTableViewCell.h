//
//  GoodsInfoTableViewCell.h
//  Bqu
//
//  Created by yb on 15/10/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//  购物车主页面上 每个物品对应的cell 

#import <UIKit/UIKit.h>
#import "GoodsInfomodel.h"
#define WIDTH ([UIScreen mainScreen].bounds.size.width)
//添加代理，用于按钮加减的实现
@protocol MyCustomCellDelegate <NSObject>
@optional
-(void)btnClick:(UITableViewCell *)cell andFlag:(int)flag;

@end



@interface GoodsInfoTableViewCell : UITableViewCell

@property(strong,nonatomic)UIImageView *goodsImgV;//商品图片
@property(strong,nonatomic)UILabel *goodsTitleLab;//商品标题
@property(strong,nonatomic)UILabel *rateOfTaxationLab;//商品税率
@property(strong,nonatomic)UILabel *priceLab;//具体价格
@property(strong,nonatomic)UILabel *numCountLab;//购买商品的数量
@property(strong,nonatomic)UILabel *CountLab;//选择购买商品的数量
@property(strong,nonatomic)UIButton *addBtn;//添加商品数量
@property(strong,nonatomic)UIButton *deleteBtn;//删除商品数量
@property(strong,nonatomic)UIButton *isSelectBtn;//是否选中按钮
@property(strong,nonatomic)UIImageView *isSelectImg;//是否选中图片
@property(nonatomic,strong)UILabel *lable;//显示失效显示
@property(nonatomic)BOOL selectState;//选中状态
@property(nonatomic,strong)GoodsInfomodel *goodsModel;


@property(weak,nonatomic)id<MyCustomCellDelegate>delegate;


//赋值
-(void)addTheValue:(GoodsInfomodel*)goodsModel;

@end
