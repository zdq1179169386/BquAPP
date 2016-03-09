//
//  SearchCell.m
//  Bqu
//
//  Created by WONG on 15/10/26.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "SearchCell.h"

@implementation SearchCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setSearchModel:(SearchModel *)searchModel
{
    _searchModel = searchModel;
    
    [self.goodsIMG sd_setImageWithURL:[NSURL URLWithString:_searchModel.ImgUrl]];
    self.goodsName.text = _searchModel.ProductName;
    self.marketPrice.text = [NSString stringWithFormat:@"市场价￥%@",_searchModel.MarketPrice];
    self.minPrice.text = [NSString stringWithFormat:@"￥%@",_searchModel.MinSalePrice];
    double a = (double)[_searchModel.MarketPrice doubleValue];
    double b = (double)[_searchModel.MinSalePrice doubleValue];
    double c = (double)(b/a);
    self.disCount.text = [NSString stringWithFormat:@"%.1f折",c * 10];
    
    
    // cell的图层设置
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 4.0;
    self.layer.borderColor = [RGB_A(229, 229, 229) CGColor];
    self.disCount.layer.borderWidth = 1;
    self.disCount.layer.cornerRadius = 4.0;
    self.disCount.layer.borderColor = [RGB_A(232, 16, 60) CGColor];
}


+(instancetype)searchCellWithCollectionView:(UICollectionView*)collectionView indexPath:(NSIndexPath*)indexPath
{
    static NSString *identifier= @"searchID";
    SearchCell* cell =[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"SearchCell" owner:nil options:nil]firstObject];
    }
    return cell;
}
@end
