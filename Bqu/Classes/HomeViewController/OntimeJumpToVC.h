//
//  OntimeJumpToVC.h
//  Bqu
//
//  Created by WONG on 15/11/3.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeBaseViewController.h"

@interface OntimeJumpToVC : HomeBaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic)  UICollectionView *collectionView;

@property (strong,nonatomic)NSString *Pid;

@end
