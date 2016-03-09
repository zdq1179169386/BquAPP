//
//  RefundTableFooterView.h
//  Bqu
//
//  Created by yb on 15/11/4.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AfterSaleOrderModel.h"

@class RefundTableFooterView;

@protocol RefundTableFooterViewDelegate <NSObject>

@optional

-(void)RefundTableFooterViewBtnClick:(RefundTableFooterView*)view sectionOpened:(NSInteger)section;

-(void)RefundTableFooterViewBtnClick:(RefundTableFooterView*)view sectionClosed:(NSInteger)section;

-(void)RefundTableFooterViewBtnClick:(RefundTableFooterView*)view withOtherBtn:(UIButton *)otherBtn withSection:(NSInteger)section;

-(void)RefundTableFooterViewBtnClick:(RefundTableFooterView*)view withFindMoney:(UIButton *)findMoney withSection:(NSInteger)section;


@end
@interface RefundTableFooterView : UITableViewHeaderFooterView

/**显示其他*/
@property (nonatomic,strong) UIButton * otherBtn;

/**小三角*/
@property (nonatomic,strong) UIImageView * icon;

/**钱款去向*/
@property (nonatomic,strong) UIButton * findMoney;


/**是否展开*/
@property(nonatomic,assign)BOOL  isOpen;


/**代理*/
@property(nonatomic,assign)id<RefundTableFooterViewDelegate>  delegate;


/**区*/
@property(nonatomic,assign)NSInteger * selectedSection;


/**模型*/
@property(nonatomic,strong)AfterSaleOrderModel * afterSaleOrder;

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier withSection:(NSInteger)selectedSection withDelegate:(id)Adelegate;

@end

