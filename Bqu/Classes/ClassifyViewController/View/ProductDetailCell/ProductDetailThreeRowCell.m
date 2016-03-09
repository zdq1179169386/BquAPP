//
//  ProductDetailThreeRowCell.m
//  Bqu
//
//  Created by yb on 15/10/21.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "ProductDetailThreeRowCell.h"
#define gap_W 5.0
@implementation ProductDetailThreeRowCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.SalePrice = [[UILabel alloc] initWithFrame:CGRectMake(15,  0+gap_W, 220, 30)];
        self.SalePrice.textColor = [UIColor colorWithHexString:@"#e8103c"];
        self.MarketPrice = [[UILabel alloc] initWithFrame:CGRectMake(15, 30+gap_W, 200, 30)];
//        self.MarketPrice.backgroundColor = [UIColor grayColor];
        self.MarketPrice.textColor = [UIColor colorWithHexString:@"#888888"];
        self.MarketPrice.font = [UIFont systemFontOfSize:17];
        
        UILabel * lineOne = [[UILabel alloc] initWithFrame:CGRectMake(0, 60+gap_W, ScreenWidth, 10)];
        lineOne.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
        [self.contentView addSubview:lineOne];
        [self.contentView addSubview:self.SalePrice];
        [self.contentView addSubview:self.MarketPrice];
        
    }
    return self;
}
-(void)setProductModel:(ProductModel *)productModel
{
    _productModel = productModel;
    // 创建一个带有属性的字符串（比如颜色属性、字体属性等文字属性）
    NSString *str2 = [NSString stringWithFormat:@"¥ %@", _productModel.SalePrice];
    NSMutableAttributedString *attrStr2 = [[NSMutableAttributedString alloc] initWithString:str2];
    // 添加属性
    if (_productModel.SalePrice) {
        [attrStr2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:[str2 rangeOfString:@"¥ "]];
        [attrStr2 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:[str2 rangeOfString:_productModel.SalePrice]];
    }
   
    self.SalePrice.attributedText = attrStr2;
    
    self.MarketPrice.text = [NSString stringWithFormat:@"市场价¥%@",_productModel.MarketPrice];
    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
