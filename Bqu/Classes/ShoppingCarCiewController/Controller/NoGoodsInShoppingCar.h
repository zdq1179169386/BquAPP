//
//  NoGoodsInShoppingCar.h
//  Bqu
//
//  Created by yb on 15/10/19.
//  Copyright (c) 2015年 yb. All rights reserved.
//  购物车内没有物品 或者没有登入时候 页面

#import <UIKit/UIKit.h>


@protocol JumpToLoginOrOtherDelegate <NSObject>
@optional
@optional
-(void)jumpToLoginOrOther:(UIButton*)sender ;

@end

@interface NoGoodsInShoppingCar : UIView
@property (nonatomic)UILabel * sweetPrompt;//温馨提示
@property (nonatomic)UIButton *loginBtn;//登入
@property (nonatomic)UIButton *promptBtn;//去逛逛
@property (nonatomic)UIImageView *headImage;

@property (nonatomic,weak)id<JumpToLoginOrOtherDelegate>delegate;


-(void)noLoginStatus;
-(void)LoginStatus;
-(void)LoginNOGoodsStatus;
@end
