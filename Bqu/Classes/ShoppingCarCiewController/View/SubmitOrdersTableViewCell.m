//
//  SubmitOrdersTableViewCell.m
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "SubmitOrdersTableViewCell.h"

@implementation SubmitOrdersTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
        
        _payLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 15, 60, 20)];
        _payLab.text = @"实付款：";
        _payLab.font = [UIFont systemFontOfSize:13];
        _payLab.textColor = [UIColor colorWithHexString:@"#333333"];
        [bgView addSubview:_payLab];
        
        _moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 100, 20)];
        [_moneyLab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        _moneyLab.textAlignment = NSTextAlignmentLeft;
        _moneyLab.textColor = [UIColor colorWithHexString:@"E8103c"];
        
        [bgView addSubview:_moneyLab];
        
        _subitBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-102, 9, 92, 30)];
        [_subitBtn setTitle:@"提交订单" forState:UIControlStateNormal];
        [_subitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _subitBtn.backgroundColor = [UIColor colorWithHexString:@"#EE1C3F"];
        _subitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _subitBtn.layer.cornerRadius = 3;
        [_subitBtn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        [bgView addSubview:_subitBtn];
        [self addSubview:bgView];
        
    }
    return self;
}


-(void)touchDown:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(submitOrder:)]) {
        [self.delegate submitOrder:button];
    }
}

-(void)setValue:(NSString*)money {
    _moneyLab.text = [NSString stringWithFormat:@"￥%@",money];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
