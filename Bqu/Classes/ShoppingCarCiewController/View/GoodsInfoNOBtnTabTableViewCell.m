//
//  GoodsInfoNOBtnTabTableViewCell.m
//  Bqu
//
//  Created by yb on 15/10/17.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "GoodsInfoNOBtnTabTableViewCell.h"

@implementation GoodsInfoNOBtnTabTableViewCell

//@property (nonatomic)UIImageView *image;//商品的图片
//@property (nonatomic)UILabel * describeLab;//商品的描述
//@property (nonatomic)UILabel * price;//商品的价格
//@property (nonatomic)UILabel * count;//商品的数量


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        double per = 1;
        if ( ScreenWidth == 414) {
            per = 1.16;
        }
        
        _image = [[UIImageView alloc] initWithFrame:CGRectMake(10*per, 10*per, 60*per, 60*per)];
        [self addSubview:_image];
        
        
        _price = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-110, 20*per , 100, 15)];
        _price.textAlignment = NSTextAlignmentRight;
        [_price setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13*per]];
        _price.textColor = [UIColor colorWithHexString:@"#333333"];
        [self addSubview:_price];
        
        _describeLab = [[UILabel alloc] initWithFrame:CGRectMake(80*per, 20*per, ScreenWidth-100-80*per, 10)];
        _describeLab.font = [UIFont systemFontOfSize:13*per];
        _describeLab.numberOfLines = 2;
        _describeLab.textColor = [UIColor colorWithHexString:@"#333333"];
        [self addSubview:_describeLab];
        
        _count = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-110, 40*per, 100, 15)];
        _count.font = [UIFont systemFontOfSize:12*per];
        _count.textAlignment = NSTextAlignmentRight;
        _count.textColor = [UIColor colorWithHexString:@"#333333"];
        [self addSubview:_count];
        //商品税率
        
        _rateLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-110, _count.y+_count.height+3, 100,15)];
        _rateLab.text = @"税率：";
        _rateLab.textColor = [UIColor colorWithHexString:@"#999999"];
        _rateLab.font = [UIFont systemFontOfSize:10*per];
        _rateLab.textAlignment = NSTextAlignmentRight;
//        _rateLab.lineBreakMode = NSLineBreakByWordWrapping;
//        CGSize size = [_rateLab sizeThatFits:CGSizeMake(_rateLab.width, MAXFLOAT)];
//        _rateLab.height = size.height;
        [self addSubview:_rateLab];
        
    }
    return  self;
}
-(void)setValue:(GoodsInfomodel*)goods
{
    [_image sd_setImageWithURL:[NSURL URLWithString:goods.imgUrl] placeholderImage:[UIImage imageNamed:@"购物车&提交订单&支付失败-商品占位图120x120-"]];
    _describeLab.text = goods.name;
    _price.text =[NSString stringWithFormat:@"￥%0.2f",goods.price.doubleValue];
    _count.text =[NSString stringWithFormat:@"x%@",goods.count];
    _rateLab.text = [NSString stringWithFormat:@"税率：%@%%",goods.taxRate];
    
    _describeLab.textAlignment = NSTextAlignmentLeft;
    _describeLab.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [_describeLab sizeThatFits:CGSizeMake(_describeLab.width, MAXFLOAT)];
    _describeLab.height = size.height;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
