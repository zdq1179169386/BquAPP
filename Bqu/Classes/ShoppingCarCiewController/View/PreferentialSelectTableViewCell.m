//
//  PreferentialSelectTableViewCell.m
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "PreferentialSelectTableViewCell.h"

@implementation PreferentialSelectTableViewCell
{
    BOOL select;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
        
        _price = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 60, 30)];
        _price.textColor = [UIColor colorWithHexString:@"#333333"];
        _price.font = [UIFont systemFontOfSize:18];
        [bg addSubview:_price];
        
        _useLimit = [[UILabel alloc] initWithFrame:CGRectMake(75, 11,110, 40)];
        _useLimit.font = [UIFont systemFontOfSize:10];
        _useLimit.textColor = [UIColor colorWithHexString:@"5d5d5d"];
        _useLimit.numberOfLines = 0;
        [bg addSubview:_useLimit];
        
        _isSelect = [[UIImageView alloc] initWithFrame:CGRectMake(190, 21, 15, 15)];
        _isSelect.image = [UIImage imageNamed:@"xunfalse.png"];
        [bg addSubview:_isSelect];
        
        [self addSubview:bg];
    }
    return self;
}

-(void)setValue:(PreferentialModel*)pm
{
    _price.text = [NSString stringWithFormat:@"￥%@",pm.price];
    _useLimit.text =[NSString stringWithFormat:@"满%@可用(不含运费)，有效期至:%@",pm.orderAmount,pm.endTime];
    if (pm.isSelect)
    {
        _isSelect.image = [UIImage imageNamed:@"xuntrue.png"];
    }
    else
    {
        _isSelect.image = [UIImage imageNamed:@"xunfalse.png"];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
