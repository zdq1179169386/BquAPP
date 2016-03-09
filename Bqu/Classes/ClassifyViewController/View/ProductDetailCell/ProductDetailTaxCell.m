//
//  ProductDetailTaxCell.m
//  Bqu
//
//  Created by yb on 15/11/30.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "ProductDetailTaxCell.h"

@interface ProductDetailTaxCell ()

@property (nonatomic,strong) UILabel * taxLabel;

@end
@implementation ProductDetailTaxCell

+(instancetype)ProductDetailTaxCellForTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"taxCell";
    ProductDetailTaxCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ProductDetailTaxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
        self.taxLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth-30, 27)];
        self.taxLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.taxLabel];
    }
    return self;
}

-(void)setModel:(ProductModel *)model
{
    _model = model;
    if (_model.IsVirtualProduct.intValue == 1) {
        
    }else{
        NSString *str = [NSString stringWithFormat:@"%@:%@", @"商品税率", _model.TaxRate];
        // 创建一个带有属性的字符串（比如颜色属性、字体属性等文字属性）
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        // 添加属性
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#e8103c"] range:[str rangeOfString:@"商品税率:"]];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:[str rangeOfString:_model.TaxRate]];
        self.taxLabel.attributedText = attrStr;
      
    }
}
@end
