//
//  ThemeCell.m
//  Bqu
//
//  Created by WONG on 15/10/12.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "OverSeaCell.h"
#import <UIKit/UIKit.h>

#import "PriceStr.h"

@interface OverSeaCell ()
@property (weak, nonatomic) IBOutlet UILabel *line;
@end


@implementation OverSeaCell
- (void)awakeFromNib {
    self.line.alpha = 0.5;
    double per = 1;
    if (ScreenWidth < 375) {
        per = 0.85;
    }
    if (ScreenWidth > 375) {
        per = 1.1;
    }
    _GoodsImg.width = _GoodsImg.width*per;
    _GoodsImg.height = _GoodsImg.height*per;
    _GoodsImg.centerY = self.centerY;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setOverSeaModel:(OverSeaModel *)overSeaModel
{
    _overSeaModel = overSeaModel;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.GoodsImg sd_setImageWithURL:[NSURL URLWithString:_overSeaModel.ImageUrl] placeholderImage:[UIImage imageNamed:@"1106首页占位图-04海外特价"]];
    [self.CountryImg sd_setImageWithURL:[NSURL URLWithString:_overSeaModel.Ico]];
    self.SessionLab.text = [NSString stringWithFormat:@"%@",_overSeaModel.CountryName];
    self.SessionLab.x = self.CountryImg.x+self.CountryImg.width+4;
    self.GoodsNameLab.text = _overSeaModel.Name;
    self.GoodsNameLab.contentMode =UIViewContentModeScaleAspectFill;//图片比例不变，但是是填充整个ImageView的，可能只有部分图片显示出来
    NSString *NowPrice;
    if (overSeaModel.LimitPrice.doubleValue > 0) {
        NowPrice = overSeaModel.LimitPrice;
    }
    else
    {
        NowPrice = overSeaModel.SalePrice;
    }
    self.NowPriceLab.attributedText = [PriceStr priceToStr:NowPrice];
    self.EXPriceLab.text = [NSString stringWithFormat:@"国内参考价￥%@",_overSeaModel.MarketPrice];
    //设置国家图标 圆
    [self.CountryImg sd_setImageWithURL:[NSURL URLWithString:_overSeaModel.Ico]];
    self.CountryImg.contentMode= UIViewContentModeScaleAspectFill;
    self.CountryImg.layer.masksToBounds =YES;
    self.CountryImg.layer.cornerRadius = 7;
    
    
    //商品描述，左上角开始写
    self.GoodsNameLab.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [self.GoodsNameLab sizeThatFits:CGSizeMake(self.GoodsNameLab.width, MAXFLOAT)];
    self.GoodsNameLab.height = size.height;
    //label.frame =CGRectMake(10, 100, 300, size.height);
    
}

- (IBAction)addProduct:(id)sender {
//    if ([self.delegate respondsToSelector:@selector(touchDownAddShoppingButton:withImageView:)]) {
//        [self.delegate touchDownAddShoppingButton:_overSeaModel withImageView:self.GoodsImg];
//    }
    if (self.shopCartBlock) {
        self.shopCartBlock(self.GoodsImg,_overSeaModel);
    }
}


+(instancetype)overSeaCellWithTableView:(UITableView*)tableView
{
    static NSString *identifier= @"Sea";
    OverSeaCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {

        cell=[[[NSBundle mainBundle]loadNibNamed:@"ThemeCell" owner:nil options:nil]firstObject];
    }
    return cell;
}


@end
