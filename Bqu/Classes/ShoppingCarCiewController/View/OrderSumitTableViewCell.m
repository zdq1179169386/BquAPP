//
//  OrderSumitTableViewCell.m
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.


#import "OrderSumitTableViewCell.h"

@implementation OrderSumitTableViewCell


//@property (nonatomic)UIImageView * image;
//@property (nonatomic)UILabel * orderLab;
//@property (nonatomic)UILabel * sumitLab;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
        
        CGFloat width = ScreenWidth/100;
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 18, 300, 16)];
        
        [bg addSubview:_bgView];
        
        _image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cartfalse.png"]];
        _image.frame = CGRectMake(0, 0, 20, 20);
        [_bgView addSubview:_image];
        
        _orderLab = [[UILabel alloc] initWithFrame:CGRectMake(40,1,300,16)];
        _orderLab.textAlignment = NSTextAlignmentLeft;
        _orderLab.font = [UIFont systemFontOfSize:14];
        _orderLab.textColor = [UIColor colorWithHexString:@"#333333"];
        //_orderLab.text = @"订单已提交";
        [_bgView addSubview:_orderLab];
        
        _sumitLab = [[UILabel alloc] initWithFrame:CGRectMake(0 ,46 , ScreenWidth, 20)];
        _sumitLab.font = [UIFont systemFontOfSize:12];
        _sumitLab.textAlignment = NSTextAlignmentCenter;
        _sumitLab.textColor = [UIColor colorWithHexString:@"#333333"];
        //_sumitLab.text = @"（请在24小时内完成支付）";
        [bg addSubview:_sumitLab];
        
        [self addSubview:bg];
    }
    return  self;
}

-(void)setValue:(NSString*)str1 str:(NSString*)str
{
    _orderLab.text = str1;
    
    _orderLab.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [_orderLab sizeThatFits:CGSizeMake(_orderLab.width, MAXFLOAT)];
    _orderLab.width = size.width;
    
    _bgView.width = 40+size.width;
    _bgView.x = ScreenWidth *0.5-20-size.width*0.5;
    
    _sumitLab.text = str;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
