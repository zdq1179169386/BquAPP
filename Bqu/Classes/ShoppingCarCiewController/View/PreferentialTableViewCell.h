//
//  PreferentialTableViewCell.h
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//  使用优惠劵页面上 的cell

#import <UIKit/UIKit.h>

@protocol SelectPreferentialDelegate <NSObject>
@optional
-(void)selectPreferential:(UIButton*)sender;

@end



@interface PreferentialTableViewCell : UITableViewCell

@property (nonatomic) UIButton *selectBtn;

@property (nonatomic,weak)id<SelectPreferentialDelegate>delegate;

-(void)setImage:(BOOL)select;
@end
