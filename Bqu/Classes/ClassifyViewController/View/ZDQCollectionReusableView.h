//
//  ZDQCollectionReusableView.h
//  Bqu
//
//  Created by yb on 15/10/13.
//  Copyright © 2015年 yingbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZDQCollectionReusableView;
@protocol ZDQCollectionReusableViewDelegate <NSObject>

@optional

-(void)ZDQCollectionReusableViewClick:(ZDQCollectionReusableView *)view withBtn:(UIButton *)btn;

@end

@interface ZDQCollectionReusableView : UICollectionReusableView

/**<#description#>*/
@property(nonatomic,weak)id<ZDQCollectionReusableViewDelegate> delegate;

@property (nonatomic,strong)UILabel * title;
@property (nonatomic,strong)UILabel * lineOne;
@property (nonatomic,strong)UILabel * lineTwo;


/**新样式*/
@property(nonatomic,strong)UIButton * Btn;

@end
