//
//  HomeTableFirstCell.h
//  Bqu
//
//  Created by yb on 15/11/13.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeTableFirstCell;
@protocol HomeTableFirstCellDelegate <NSObject>

@optional


-(void)HomeTableFirstCellDelegate:(HomeTableFirstCell *)cell withSelectedPage:(NSInteger)currentPage;

@end

@interface HomeTableFirstCell : UITableViewCell
{
    
}


/***/
@property(nonatomic,weak)id<HomeTableFirstCellDelegate> delegate;

/**图片数组*/
@property(nonatomic,retain)NSMutableArray *sourceArray;


@end

