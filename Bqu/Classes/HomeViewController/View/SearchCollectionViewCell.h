//
//  SearchCollectionViewCell.h
//  Bqu
//
//  Created by yb on 15/11/19.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotHistorySearchCollectionView.h"
#import "KeyWordSizeModul.h"

@interface SearchCollectionViewCell : UICollectionViewCell
@property(nonatomic)KeyWordSizeModul *keySize;


+(instancetype)SearchCollectionViewCell:(UICollectionView*)collectionView NSIndexPath:(NSIndexPath*)indexPath;
-(void)hotSearch;
@end
