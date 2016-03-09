//
//  DeliveryAddressView.h
//  Bqu
//
//  Created by yb on 15/10/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//   购物车主页面 上每个仓库下 的购物车  包括全选按钮 仓库地址

#import <UIKit/UIKit.h>

@protocol MyAllSelectDelegate <NSObject>
@optional
@optional

-(void)allSelectbtnClick:(UIView *)view sender:(BOOL)sender ;

@end

@interface DeliveryAddressView : UIView
@property (nonatomic)UIButton *selectAllBtn;
@property (nonatomic)UIImageView *storeHouseImage;
@property (nonatomic) UILabel *deliveryAddress;
@property (nonatomic)UIImageView *selectView;

@property (nonatomic)BOOL AllSelect;
@property (nonatomic,weak)id<MyAllSelectDelegate>delegate;

@property(assign,nonatomic)BOOL selectState;//选中状态


+(DeliveryAddressView *)deliveryAddressView;
-(void)setValue:(NSString*)deliveryAddress isAllSelect:(BOOL)isAllSelect;
@end
