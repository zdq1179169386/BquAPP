//
//  AllOnTimeCell.h
//  Bqu
//
//  Created by WONG on 15/11/3.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllOnTimeModel.h"

@interface AllOnTimeCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsIMG;
@property (weak, nonatomic) IBOutlet UILabel *disAndNameLab;
@property (weak, nonatomic) IBOutlet UILabel *XXXlable;
@property (weak, nonatomic) IBOutlet UILabel *PriceLab;
@property (weak, nonatomic) IBOutlet UILabel *MarketPriceLab;
@property (weak, nonatomic) IBOutlet UIButton *BuyNowBtn;
@property (weak, nonatomic) IBOutlet UILabel *StorageLab;
@property (weak, nonatomic) IBOutlet UILabel *xxxLab;
@property (nonatomic) AllOnTimeModel *allOnTimeModel;

+(instancetype)allOnTimeCellWithcollectionView:(UICollectionView*)collectionView indexPath:(NSIndexPath*)indexPath;


@end
