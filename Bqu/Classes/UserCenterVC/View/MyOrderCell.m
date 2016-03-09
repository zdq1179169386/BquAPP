//
//  MyOrderCell.m
//  Bqu
//
//  Created by yingbo on 15/10/20.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "MyOrderCell.h"

@implementation MyOrderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setValue:(id)value
{
    _ordrItem = value;
    
    self.refund_Lab.hidden = YES;
    [self.goodsPhoto_ImgView  sd_setImageWithURL:[NSURL URLWithString:_ordrItem.image] placeholderImage:[UIImage imageNamed:@"个人中心-我的订单&评价商品&商品详情-占位图-118x118-"]];
    self.goodsPhoto_ImgView.layer.borderColor = [UIColor colorWithHexString:@"#EEEEEE"].CGColor;
    self.goodsPhoto_ImgView.layer.borderWidth = 1;
    
     self.goodsName_Lab.text = _ordrItem.productName;
     self.goodsCount_Lab.text = [NSString stringWithFormat:@"x%@",_ordrItem.count];
     self.goodsPrice_Lab.text = [NSString stringWithFormat:@"￥%@", _ordrItem.price];
    
    
    self.line_View.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD" alpha:0.5];
    self.goodsPhoto_ImgView.layer.borderColor = [UIColor colorWithHexString:@"#EEEEEE" alpha:0.5].CGColor;
}
@end
