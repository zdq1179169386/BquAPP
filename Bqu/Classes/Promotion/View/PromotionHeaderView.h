//
//  PromotionHeaderView.h
//  Bqu
//
//  Created by wyy on 15/12/8.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PromotionHeaderView;
@class PromoterInfoModel;

@protocol PromotionHeaderViewDelegate <NSObject>
@optional
//点击明细
- (void)showDetailsClicked:(PromotionHeaderView *)headerView;

//点击我邀请的好友
- (void)invitedFriendsClicked:(PromotionHeaderView *)headerView;

//点击提现
- (void)withdrawCashClicked:(PromotionHeaderView *)headerView;

//点击一键成为推广员
- (void)becomePromoterClicked:(PromotionHeaderView *)headerView;

@end

@interface PromotionHeaderView : UIView

@property (nonatomic, weak) id<PromotionHeaderViewDelegate> delegate;

- (void)resetHeaderViewData:(PromoterInfoModel *)model;

@end
