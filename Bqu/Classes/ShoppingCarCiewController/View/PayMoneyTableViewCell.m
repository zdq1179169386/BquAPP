//
//  PayMoneyTableViewCell.m
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "PayMoneyTableViewCell.h"

@implementation PayMoneyTableViewCell


//@property (nonatomic)UILabel *payMoney;
//@property (nonatomic)UILabel *payPrice;


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        _payMoney = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2-60, 11, 60, 20)];
        _payMoney.text = @"支付金额：";
        _payMoney.textAlignment = NSTextAlignmentRight;
        _payMoney.textColor = [UIColor colorWithHexString:@"#333333"];
        _payMoney.font = [UIFont systemFontOfSize:11];
        [view addSubview:_payMoney];
        
        _payPrice = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2+10, 11, 70, 20) ];
        _payPrice.font = [UIFont systemFontOfSize:13];
        _payPrice.textAlignment = NSTextAlignmentLeft;
        _payPrice.textColor = [UIColor colorWithHexString:@"E8103C"];
        [view addSubview:_payPrice];
        [self addSubview:view];
    }
    return self;
}



-(void)setValue:(NSString *)price
{
    NSString * str = price?price:@"";
    _payPrice.text = [NSString stringWithFormat:@"￥%@",str];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
