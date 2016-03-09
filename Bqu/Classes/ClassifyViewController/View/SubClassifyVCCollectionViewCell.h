//
//  SubClassifyVCCollectionViewCell.h
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCategoryData.h"
@interface SubClassifyVCCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong) UILabel * name ;
@property(nonatomic,strong) UIImageView * Image;
@property (nonatomic,strong)ProductCategoryData * data;

-(instancetype)initWithFrame:(CGRect)frame;

@end
