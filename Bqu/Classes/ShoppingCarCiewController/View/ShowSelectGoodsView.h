//
//  ShowSelectGoodsView.h
//  Bqu
//
//  Created by yb on 15/10/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//  每个发货仓库上 显示已经购买的商品情况cell

#import <UIKit/UIKit.h>
#import "GoodsInfomodel.h"
#import "PromptPriceView.h"


//添加代理，用于点击结算的实现
@protocol MySettleDelegate <NSObject>
@optional
-(void)SettlebtnClick:(UIView *)view andFlag:(int)flag;

@end

@interface ShowSelectGoodsView : UIView
@property (nonatomic,strong)UILabel *selectGoodsCountLab; //选择商品个数
@property (nonatomic,strong)UILabel *allGoodsPriceLab; //
@property (nonatomic,strong)UILabel *showGoodsPriceLab;//显示商品总额
@property (nonatomic,strong)UILabel *tax;
@property (nonatomic,strong)UILabel *showTax;//显示税金
@property (nonatomic,strong)UILabel *freight;//
@property (nonatomic,strong)UILabel *showFreight;//显示运费
@property (nonatomic,strong)UILabel *allPrice;//
@property (nonatomic,strong)UILabel *showAllPrice;//显示所有的价格
@property (nonatomic,strong)UIButton *settleBtn;//结算
@property (nonatomic,strong)PromptPriceView * promptPrice;

@property (nonatomic,strong)UIImageView * view;// 税金提示图
@property (nonatomic,strong)UILabel *lable;

@property (nonatomic,strong)UIButton * showCalculateRateBtn;
@property (nonatomic,strong)UIImageView *showCalculateRateImage;

@property(weak,nonatomic)id<MySettleDelegate>delegate;


-(void)setValue:(NSArray *)Allgoods;

-(void)setValueNOLine:(NSArray *)Allgoods;
@end
