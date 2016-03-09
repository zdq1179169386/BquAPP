//
//  AllOnTimeCell.m
//  Bqu
//
//  Created by WONG on 15/11/3.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "AllOnTimeCell.h"

@implementation AllOnTimeCell

- (void)awakeFromNib {
    // Initialization code
}


-(void)setAllOnTimeModel:(AllOnTimeModel *)allOnTimeModel
{
    _allOnTimeModel = allOnTimeModel;
    [self.goodsIMG sd_setImageWithURL:[NSURL URLWithString:_allOnTimeModel.ImgPath] placeholderImage:[UIImage imageNamed:@"1106首页占位图-04海外特价"]];
    NSString *str1 = [NSString stringWithFormat:@"%@折/%@",_allOnTimeModel.Discount,_allOnTimeModel.ProductName];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:str1];
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"F42848"] range:NSMakeRange(0, 5)];
    
    self.disAndNameLab.attributedText = str2;
    self.PriceLab.text = [NSString stringWithFormat:@"￥%@",_allOnTimeModel.LimitPrice];
    self.MarketPriceLab.text = [NSString stringWithFormat:@"￥%@",_allOnTimeModel.MarketPrice];
    self.StorageLab.text = _allOnTimeModel.Storage;
    self.BuyNowBtn.userInteractionEnabled = NO;
    //    cell.BuyNowBtn.imageView
    // cell的图层设置
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 4.0;
    self.layer.borderColor = [RGB_A(229, 229, 229) CGColor];
    
    self.xxxLab.layer.masksToBounds =YES;
    self.xxxLab.layer.borderWidth = 1;
    self.xxxLab.layer.borderColor = [UIColor colorWithHexString:@"#d9e0e3"].CGColor ;
    self.xxxLab.layer.cornerRadius = 7;
}


+(instancetype)allOnTimeCellWithcollectionView:(UICollectionView*)collectionView indexPath:(NSIndexPath*)indexPath
{
    static NSString *identifier= @"OntimeID";
    AllOnTimeCell* cell =[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        if (cell == nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"AllOnTimeCell" owner:nil options:nil]firstObject];
    }
    return cell;
}

@end
