//
//  SearchCell.h
//  Bqu
//
//  Created by WONG on 15/10/26.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchModel.h"

@interface SearchCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsIMG;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *minPrice;
@property (weak, nonatomic) IBOutlet UILabel *disCount;
@property (weak, nonatomic) IBOutlet UILabel *marketPrice;
@property (nonatomic)SearchModel *searchModel;

+(instancetype)searchCellWithCollectionView:(UICollectionView*)collectionView indexPath:(NSIndexPath*)indexPath;
@end
