//
//  PromotionShareCell.h
//  Bqu
//
//  Created by wyy on 15/12/10.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PromotionShareCell;
@class PromoterInfoModel;

@protocol PromotionShareCellDelegate <NSObject>
@optional
//点击二维码图片
- (void)qrCodeClicked:(PromotionShareCell *)cell;

//点击复制，发送好友
- (void)shareButtonClicked:(PromotionShareCell *)cell;

@end

@interface PromotionShareCell : UITableViewCell

@property (nonatomic, weak) id<PromotionShareCellDelegate> delegate;

- (void)setShareCellContent:(PromoterInfoModel *)model;

@end
