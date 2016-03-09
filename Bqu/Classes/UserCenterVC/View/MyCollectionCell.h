//
//  MyCollectionCell.h
//  Bqu
//
//  Created by yingbo on 15/10/19.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyCollectionCell;
@protocol MyCollectionPraiceDelegate <NSObject>

- (void)cancelPriceBtn:(UIButton *)button;

@end

@interface MyCollectionCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *goodsPhoto_ImgVIew;
@property (strong, nonatomic) IBOutlet UILabel *goodsName_Lab;
@property (strong, nonatomic) IBOutlet UILabel *goddsPrice_Lab;
@property (strong, nonatomic) IBOutlet UILabel *goddMarketPrice_Lab;
@property (strong, nonatomic) IBOutlet UIImageView *redHeart_imgView;
@property (strong, nonatomic) IBOutlet UILabel *collectionCount_Lab;
@property (strong, nonatomic) IBOutlet UIButton *cancelPraice;

@property (strong, nonatomic)  MyCollection_Model *model;
@property (nonatomic, assign)  id<MyCollectionPraiceDelegate> delegate;



- (void)setValue:(id)value;


@end
