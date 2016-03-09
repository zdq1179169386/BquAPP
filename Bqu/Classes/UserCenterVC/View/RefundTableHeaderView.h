//
//  RefundTableHeaderView.h
//  Bqu
//
//  Created by yb on 15/11/6.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AfterSaleOrderModel.h"

@class RefundTableHeaderView;
@protocol RefundTableHeaderViewDelegate <NSObject>

@optional
-(void)RefundTableHeaderViewClick:(RefundTableHeaderView *)header withBtn:(UIButton *)btn;

@end


@interface RefundTableHeaderView : UITableViewHeaderFooterView


/**<#description#>*/
@property(nonatomic,assign)id<RefundTableHeaderViewDelegate> delegate;


/**模型*/
@property(nonatomic,strong)AfterSaleOrderModel * refundModel;


/**<#description#>*/
@property(nonatomic,strong)UIButton * btn;


-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end

