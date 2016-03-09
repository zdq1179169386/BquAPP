//
//  BrandAndKindControllerCell.h
//  Bqu
//
//  Created by yb on 15/10/19.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandAndKindControllerCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView * productImage;

@property(nonatomic,strong)UILabel * productName;

@property(nonatomic,strong)UILabel * price;
/**市场价*/
@property(nonatomic,strong)UILabel * referencePrice;


@end
