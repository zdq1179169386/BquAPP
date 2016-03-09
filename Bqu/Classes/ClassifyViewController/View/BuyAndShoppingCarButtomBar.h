//
//  BuyAndShoppingCarButtomBar.h
//  Bqu
//
//  Created by yb on 15/10/14.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDQBtn.h"
#import "ProductModel.h"
@class BuyAndShoppingCarButtomBar;

@protocol BuyAndShoppingCarButtomBarDelegate <NSObject>

@optional
-(void)BuyAndShoppingCarButtomBarDelegate:(BuyAndShoppingCarButtomBar *)BuyAndShoppingCarButtomBar withBtn:(UIButton *)selectedBtn;



@end



@interface BuyAndShoppingCarButtomBar : UIView

/**购买按钮*/
@property (nonatomic,strong) UIButton * buyBtn;
/**加入购物车按钮*/
@property(nonatomic,strong) UIButton * addShoppingCart;
/**购物车按钮*/
@property(nonatomic,strong) ZDQBtn * shoppingCart;


/**已抢光*/
@property(nonatomic,strong)UILabel * notEnought;


@property(nonatomic,assign)id<BuyAndShoppingCarButtomBarDelegate>delagate;


/**<#description#>*/
@property(nonatomic,strong)ProductModel * product;


@end

