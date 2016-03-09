//
//  ProductDetailSecondRowCell.m
//  Bqu
//
//  Created by yb on 15/10/21.
//  Copyright (c) 2015年 yb. All rights reserved.
// 商品名称

#import "ProductDetailSecondRowCell.h"

@implementation ProductDetailSecondRowCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        
        self.ProductName = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, ScreenWidth-30, 20)];
        self.ProductName.textColor = [UIColor colorWithHexString:@"#333333"];
        self.ProductName.numberOfLines = 0;
        self.ProductName.font = [UIFont systemFontOfSize:18];
       [self.contentView addSubview:self.ProductName];

    }
    return self;
}
-(void)setProductModel:(ProductModel *)productModel
{
    _productModel = productModel;
    self.ProductName.text = _productModel.ProductName;
    CGSize nameSize = [_productModel.ProductName sizeWithFont:[UIFont systemFontOfSize:18] maxW:ScreenWidth-30];
    self.ProductName.size = nameSize;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
