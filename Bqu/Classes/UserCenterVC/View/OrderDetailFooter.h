//
//  OrderDetailFooter.h
//  Bqu
//
//  Created by 张胜瀚 on 15/12/3.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderDetailFooter;
@protocol OrderDatailFooterDelagate <NSObject>
@optional
- (void)detailfooter:(NSInteger)section withBtn:(UIButton *)button;

@end
@interface OrderDetailFooter : UITableViewHeaderFooterView

@property (nonatomic,strong) UIView *line1;
@property (nonatomic,strong) UIView *line2;
@property (nonatomic,strong) UIView *line3;
@property (nonatomic,strong) UIView *line4;
@property (nonatomic,strong) UIView *line5;
@property (nonatomic,strong) UIView *line6;
@property (nonatomic,strong) UIView *line7;

@property (nonatomic,strong) UILabel *totalPriceTipLab;
@property (nonatomic,strong) UILabel *freighTiptLab;
@property (nonatomic,strong) UILabel *taxTipLab;
@property (nonatomic,strong) UILabel *totalPriceLab;
@property (nonatomic,strong) UILabel *freightLab;
@property (nonatomic,strong) UILabel *taxLab;
@property (nonatomic,strong) UILabel *shouPayLab;
@property (nonatomic,strong) UIView *grayView;
@property (nonatomic,strong) UILabel *couponLab;
@property (nonatomic,strong) UILabel *dateLab;
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) MyOrder_Model *order;
@property (nonatomic,strong) MyOrderItems_Model *item;



@property (nonatomic,assign) id<OrderDatailFooterDelagate> delegate;


@property (nonatomic,strong) NSDictionary *dataDic;
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier withSection:(NSInteger)section;
- (void)setValue:(id)value withOrder:(id)order;


@end
