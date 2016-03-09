//
//  SearchListCollectionVC.h
//  Bqu
//
//  Created by WONG on 15/10/22.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeBaseViewController.h"

@interface SearchListCollectionVC : HomeBaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic)  UICollectionView *collectionView;

@property (strong,nonatomic)NSString *TopicId;

@property (nonatomic,copy)NSString *ProductId;
@property (nonatomic,copy)NSString *Moods;
@property (nonatomic,copy)NSString *SaleCount;
@property (nonatomic,copy)NSString *Comment;

@end
