//
//  HomeTableFourBtnCell.h
//  Bqu
//
//  Created by yb on 15/11/30.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeTableFourBtnCell;
@protocol HomeTableFourBtnCellDelegate <NSObject>

@optional
-(void)HomeTableFourBtnCellClick:(HomeTableFourBtnCell *)cell withBtn:(UIButton *)btn;

@end

@interface HomeTableFourBtnCell : UITableViewCell



/**<#description#>*/
@property(nonatomic,weak)id<HomeTableFourBtnCellDelegate> delegate;

@end

