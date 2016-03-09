//
//  MyCollectViewController.h
//  Bqu
//
//  Created by yingbo on 15/10/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "HSViewController.h"
#import "MyCollectionCell.h"


@interface MyCollectViewController : HSViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MyCollectionPraiceDelegate>

@property (strong, nonatomic)  UICollectionView *collectionView;
@property (strong, nonatomic)  NSMutableArray *dataArray;


@property (strong, nonatomic) UIView * lineView; // button下方点击时移动的红色线条
@property (strong, nonatomic) UIView * viewBlank; //  暂无数据
@property (strong, nonatomic) NSMutableArray * array_button;// buttonArray

@property (nonatomic,strong) NSString *isLogin;


@end
