
//
//  RefundTableCell.m
//  Bqu
//
//  Created by yb on 15/10/27.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "RefundTableCell.h"

@implementation RefundTableCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel * line1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth-20, 1)];
        line1.backgroundColor = [UIColor colorWithHexString:@"#f2f1f1"];
//        [self.contentView addSubview:line1];
        
        CGFloat  line1Y = CGRectGetMaxY(line1.frame) +10;
        CGFloat imageW = 80;
        self.orderImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, line1Y, imageW, imageW)];
        [self.contentView addSubview:self.orderImage];
        CGFloat nameX = CGRectGetMaxX(self.orderImage.frame);
        
        self.orderName = [[UILabel alloc] initWithFrame:CGRectMake(nameX, line1Y+5, 170, 5)];
        self.orderName.font = [UIFont systemFontOfSize:13];
        self.orderName.textColor = [UIColor colorWithHexString:@"#333333"];
        self.orderName.numberOfLines = 2;
//        self.orderName.backgroundColor = [UIColor redColor];
        self.orderName.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.orderName];
        
        self.dealPrice = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-50, line1Y+5, 50, 30)];
        self.dealPrice.font = [UIFont systemFontOfSize:13];
        self.dealPrice.textColor = [UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:self.dealPrice];
        
        
        self.number = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-50, line1Y+30, 50, 30)];
        self.number.font = [UIFont systemFontOfSize:13];
        self.number.textColor = [UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:self.number];
        
        UILabel * lineBottom = [[UILabel alloc] initWithFrame:CGRectMake(10, 99, ScreenWidth-20, 1)];
        lineBottom.backgroundColor = [UIColor colorWithHexString:@"#cccccc" alpha:0.5];
        [self.contentView addSubview:lineBottom];

    }
    return self;
}
-(void)setModel:(AfterSaleOrderModel *)model
{
    _model = model;
    [self.orderImage sd_setImageWithURL:[NSURL URLWithString:_model.ThumbnailsUrl] placeholderImage:nil];
    self.orderName.lineBreakMode = NSLineBreakByWordWrapping;
    self.orderName.text = _model.ProductName;
    CGSize size = [self.orderName sizeThatFits:CGSizeMake(self.orderName.width, MAXFLOAT)];
    self.orderName.size = CGSizeMake(170, size.height);
    self.dealPrice.text = _model.SalePrice;
    [self.dealPrice sizeToFit];
    self.dealPrice.frame = CGRectMake(ScreenWidth-self.dealPrice.size.width-10, self.orderName.frame.origin.y, self.dealPrice.width, self.dealPrice.height);
    if (_model.ReturnQuantity.intValue>0) {
        self.number.hidden = NO;
        NSString * str = [NSString stringWithFormat:@"x %@",_model.ReturnQuantity];
        self.number.text = str;
        [self.number sizeToFit];
        CGFloat number_Y = CGRectGetMaxY(self.dealPrice.frame);
        self.number.frame = CGRectMake(ScreenWidth - self.number.width-10 , number_Y, self.number.width, self.number.height);

    }else
    {
        self.number.hidden = YES;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
