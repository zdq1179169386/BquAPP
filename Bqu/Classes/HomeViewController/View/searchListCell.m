//
//  searchListCell.m
//  Bqu
//
//  Created by WONG on 15/10/22.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "searchListCell.h"

@implementation searchListCell

- (void)awakeFromNib {
    // Initialization code
}


-(void)setTopIcModuleModel:(TopIcModuleModel *)topIcModuleModel index:(NSInteger)index
{
    _topIcModuleModel = topIcModuleModel;
    NSArray * ary = [[NSArray alloc]init];
    ary = _topIcModuleModel.ModuleProduct;
    NSDictionary *dict = [ary objectAtIndex:index];
    NSString *urlStr = dict[@"ImageUrl"];
    [self.GoodsImg sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    self.GoodsName.text = dict[@"ProductName"];
    self.MarketPrice.text = [NSString stringWithFormat:@"市场价￥%@",dict[@"MarketPrice"]];
    self.MinSalePrice.text = [NSString stringWithFormat:@"￥%@",dict[@"MinSalePrice"]];
    double a = (double)[dict[@"MarketPrice"] doubleValue];
    double b = (double)[dict[@"MinSalePrice"] doubleValue];
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


+(instancetype)searchListCellWithCollectionView:(UICollectionView*)collectionView indexPath:(NSIndexPath*)indexPath
{
    static NSString *identifier= @"cellID";
    searchListCell* cell =[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"searchListCell" owner:nil options:nil]firstObject];
    }
    return cell;
}
@end
