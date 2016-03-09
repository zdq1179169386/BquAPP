//
//  HotHistoryCollectionReusableView.h
//  Bqu
//
//  Created by yb on 15/11/20.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^clearBlock)();

@interface HotHistoryCollectionReusableView : UICollectionReusableView
@property (nonatomic)UILabel * textLab;
@property (nonatomic)UIButton * deleteBtn;
@property(nonatomic,copy)clearBlock block;

-(void)setBlock:(clearBlock)block;

@end
