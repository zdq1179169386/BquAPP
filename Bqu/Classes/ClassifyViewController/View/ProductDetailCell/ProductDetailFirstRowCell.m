//
//  ProductDetailFirstRowCell.m
//  Bqu
//
//  Created by yb on 15/10/20.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "ProductDetailFirstRowCell.h"
#define Picture_W 250/375.0f
#define Origin_x 15.0f

@interface ProductDetailFirstRowCell ()

@property (nonatomic,strong) UIView * taxBg;

@end

@implementation ProductDetailFirstRowCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.picture = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Picture_W * ScreenWidth, Picture_W * ScreenWidth)];
        self.picture.center = CGPointMake(ScreenWidth/2.0, (Picture_W * ScreenWidth)/2.0);
       
        CGFloat second_Y = CGRectGetMaxY(self.picture.frame) + 14;
        self.CountryLogo = [[UIImageView alloc] initWithFrame:CGRectMake(Origin_x, second_Y, 16, 16)];
        self.CountryLogo.contentMode = UIViewContentModeScaleAspectFill;
        self.CountryLogo.layer.cornerRadius = 8;
        self.CountryLogo.clipsToBounds = YES;
//        self.CountryLogo.backgroundColor = [UIColor redColor];
      
        self.CountryLogoName = [[UILabel alloc] initWithFrame:CGRectMake(36, second_Y-1, 100, 17)];
        self.CountryLogoName.textColor = [UIColor colorWithHexString:@"#999999"];
        self.CountryLogoName.font = [UIFont systemFontOfSize:15];
        
        self.ProductAddress = [[UILabel alloc] initWithFrame:CGRectMake(160, second_Y-1, 100, 17)];
//        self.ProductAddress.backgroundColor = [UIColor colorWithHexString:@"#e8103c"];
        self.ProductAddress.textColor = [UIColor colorWithHexString:@"#999999"];
        self.ProductAddress.font = [UIFont systemFontOfSize:15];
        
        CGFloat taxLabel_Y = CGRectGetMaxY(self.ProductAddress.frame) + 10 ;
        
        self.taxBg = [[UIView alloc] initWithFrame:CGRectMake(0, taxLabel_Y, ScreenWidth, 27)];
        self.taxBg.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
        [self.contentView addSubview:self.taxBg];
        self.taxlabel = [[UIButton alloc] initWithFrame:CGRectMake(Origin_x, taxLabel_Y, ScreenWidth,27)];
//        self.taxlabel.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
        self.taxlabel.titleLabel.font = [UIFont systemFontOfSize:15];
        
        self.lookDetail = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-52, second_Y - 64, 44, 44)];
        self.lookDetail.tag = 111;
        [self.lookDetail addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.lookDetail.layer.cornerRadius = 30;
        
        self.clipsToBounds = YES;
        [self.lookDetail setImage:[UIImage imageNamed:@"查看详情"] forState:UIControlStateNormal];
//
        [self.contentView addSubview:self.ProductAddress];
        [self.contentView addSubview:self.CountryLogo];
        [self.contentView addSubview:self.CountryLogoName];
        [self.contentView addSubview:self.picture];
        [self.contentView addSubview:self.lookDetail];

        NSLog(@"%lf", taxLabel_Y);
        
    }
    return self;
}
-(void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(ProductDetailFirstRowCellBtnClick:withBtn:)]) {
        [self.delegate ProductDetailFirstRowCellBtnClick:self withBtn:btn];
    }
}

-(void)setProductModel:(ProductModel *)productModel
{
    _productModel = productModel;
    
    [self.picture sd_setImageWithURL:[NSURL URLWithString:_productModel.ImageUrl] placeholderImage:[UIImage imageNamed:@"商品详情占位图"]];
    [self.CountryLogo sd_setImageWithURL:[NSURL URLWithString:_productModel.CountryLogo]];
    NSArray * array = [_productModel.ProductAddress componentsSeparatedByString:@" "];
//    NSLog(@"%@,%@",_productModel.ProductAddress,arr);
    self.CountryLogoName.text = [NSString stringWithFormat:@"%@直供", _productModel.CountryLogoName];
//    CGSize countrySize = [self.CountryLogoName.text sizeWithFont:<#(UIFont *)#> maxW:<#(CGFloat)#>];
    [self.CountryLogoName sizeToFit];
//    NSString * productAddress = [array lastObject];
//    CGSize  size = [productAddress sizeWithFont:[UIFont systemFontOfSize:17]];
    NSString * productAddress = [array lastObject];
    self.ProductAddress.text = [NSString stringWithFormat:@"%@发货",productAddress];
//    self.ProductAddress.size = CGSizeMake(size.width+5, size.height);
    
    self.ProductAddress.frame = CGRectMake(self.CountryLogoName.x + self.CountryLogoName.width+5, self.ProductAddress.frame.origin.y, 0, 0);
    [self.ProductAddress sizeToFit];
   
    //捆绑商品不显示税率
//    if (_productModel.IsVirtualProduct.intValue == 1) {
//        self.taxBg.hidden = YES;
//        self.taxlabel.hidden = YES;
//        
//    }else{
//        self.taxBg.hidden = NO;
//        self.taxlabel.hidden = NO;
//        NSString *str = [NSString stringWithFormat:@"%@:%@", @"商品税率", _productModel.TaxRate];
//        // 创建一个带有属性的字符串（比如颜色属性、字体属性等文字属性）
//        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
//        // 添加属性
//        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#e8103c"] range:[str rangeOfString:@"商品税率:"]];
//        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:[str rangeOfString:_productModel.TaxRate]];
//        [self.taxlabel setAttributedTitle:attrStr forState:UIControlStateNormal];
//        self.taxlabel.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, ScreenWidth-100);
//
//    }
    
    
}
@end
