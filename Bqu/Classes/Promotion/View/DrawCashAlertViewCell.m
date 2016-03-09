//
//  DrawCashAlertViewCell.m
//  Bqu
//
//  Created by yb on 15/12/11.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "DrawCashAlertViewCell.h"

@interface DrawCashAlertViewCell ()



@end

@implementation DrawCashAlertViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5,ScreenWidth-60 , 20)];
        self.accountLabel.font = [UIFont systemFontOfSize:13];
        self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, ScreenWidth-60, 20)];
        self.numberLabel.font = [UIFont systemFontOfSize:13];
        self.numberLabel.textColor = [UIColor lightGrayColor];
        UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, ScreenWidth, 1)];
        self.accountLabel.textAlignment = NSTextAlignmentLeft;
        self.numberLabel.textAlignment = NSTextAlignmentLeft;
//        line.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.accountLabel];
        [self.contentView addSubview:self.numberLabel];
        [self.contentView addSubview:line];
    }
    return self;
}
-(void)setModel:(PromotionAccountModel *)model
{
    _model = model;
    if (_model.Type.intValue==1) {
        //支付宝
        self.accountLabel.text = @"支付宝";
        self.numberLabel.text = _model.AccountNumber;
        
    }else if (_model.Type.intValue == 2)
    {
        //银行卡
        self.accountLabel.text = @"银行卡";
        self.numberLabel.text = _model.BankCardNumber;

    }
}
@end
