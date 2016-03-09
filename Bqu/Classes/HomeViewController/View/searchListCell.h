//
//  searchListCell.h
//  Bqu
//
//  Created by WONG on 15/10/22.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopIcModuleModel.h"

@interface searchListCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *GoodsImg;
@property (weak, nonatomic) IBOutlet UILabel *GoodsName;
@property (weak, nonatomic) IBOutlet UILabel *MinSalePrice;
@property (weak, nonatomic) IBOutlet UILabel *MarketPrice;
@property (weak, nonatomic) IBOutlet UILabel *disCount;
@property (nonatomic)TopIcModuleModel *topIcModuleModel;


-(void)setTopIcModuleModel:(TopIcModuleModel *)topIcModuleModel index:(NSInteger)index;
+(instancetype)searchListCellWithCollectionView:(UICollectionView*)collectionView indexPath:(NSIndexPath*)indexPath;
@end
