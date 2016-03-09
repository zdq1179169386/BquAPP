//
//  MyOrderFooter.h
//  Bqu
//
//  Created by yingbo on 15/11/24.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyOrderFooter;

@protocol OrderFooterDelegate <NSObject>

- (void)footer:(NSInteger)section restBtn:(UIButton *)restBtn;
- (void)footer:(NSInteger)section withBtn:(UIButton *)button;

@end


@interface MyOrderFooter : UITableViewHeaderFooterView


@property (nonatomic,strong) UIView *line1;
@property (nonatomic,strong) UIView *line2;
@property (nonatomic,strong) UIView *line3;
@property (nonatomic,strong) UIView *grayView;
@property (nonatomic,strong) UILabel *restCount;
@property (nonatomic,strong) UIImageView *arrowBtn;
@property (nonatomic,strong) UIButton *showRestBtn;
@property (nonatomic,strong) UILabel *totalCount;
@property (nonatomic,strong) UILabel *orderPay;
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;

@property (nonatomic,strong) MyOrder_Model *order;
@property (nonatomic,assign) id<OrderFooterDelegate> delegate;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier withSection:(NSInteger)section;
- (void)setValue:(id)value;

@end
