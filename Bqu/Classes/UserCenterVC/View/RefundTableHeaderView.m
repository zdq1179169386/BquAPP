//
//  RefundTableHeaderView.m
//  Bqu
//
//  Created by yb on 15/11/6.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "RefundTableHeaderView.h"

@interface RefundTableHeaderView ()

@property(nonatomic,strong) UILabel * refundOrderStatus;

@property(nonatomic,strong) UILabel * refundOrderDate;
@end

@implementation RefundTableHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.refundOrderStatus = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth/2.0, 30)];
        self.refundOrderStatus.font = [UIFont systemFontOfSize:15];
        self.refundOrderStatus.textColor = [UIColor colorWithHexString:@"#333333"];
        
        self.refundOrderDate = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2.0, 5, ScreenWidth/2.0, 30)];
        self.refundOrderDate.font = [UIFont systemFontOfSize:15];
        self.refundOrderDate.textColor = [UIColor colorWithHexString:@"#999999"];
        
        [self.contentView addSubview:self.refundOrderStatus];
        [self.contentView addSubview:self.refundOrderDate];
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        self.btn = btn;
        
        UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(10, 39, ScreenWidth-20, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#cccccc" alpha:0.5];
        [self.contentView addSubview:line];
        
    }
    return self;
}
-(void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(RefundTableHeaderViewClick:withBtn:)]) {
        [self.delegate RefundTableHeaderViewClick:self withBtn:btn];
    }
}
-(void)setRefundModel:(AfterSaleOrderModel *)refundModel
{
    _refundModel = refundModel;
    
    if ([_refundModel.SellerAuditStatus isEqualToString:@"商家通过审核"]) {
        //显示平台状态
        self.refundOrderStatus.text = refundModel.ManagerConfirmStatus;
        
    }else
    {
        //显示商家状态
        self.refundOrderStatus.text = refundModel.SellerAuditStatus;
    }
    self.refundOrderDate.text = _refundModel.InfoDate;
    CGSize size = [_refundModel.InfoDate sizeWithFont:[UIFont systemFontOfSize:15]];
    self.refundOrderDate.frame = CGRectMake(ScreenWidth-size.width-10, 5, size.width, 30);
    
}
@end
