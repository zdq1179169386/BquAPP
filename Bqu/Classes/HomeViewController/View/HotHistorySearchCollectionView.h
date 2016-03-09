//
//  HotHistorySearchCollectionView.h
//  Bqu
//
//  Created by yb on 15/11/19.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchCollectionViewCell.h"

typedef void (^selectSearchKeyBlock) (NSString *key);

@interface HotHistorySearchCollectionView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)NSMutableArray *historySearchArray;
@property (nonatomic,strong)NSMutableArray *hotSearchArray;

-(void)setKeyBlock:(selectSearchKeyBlock)block;
@end
