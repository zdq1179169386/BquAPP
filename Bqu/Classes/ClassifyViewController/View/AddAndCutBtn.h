//
//  AddAndCutBtn.h
//  Bqu
//
//  Created by yb on 15/10/19.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddAndCutBtn;

@protocol AddAndCutBtnDelegate <NSObject>

-(void)AddAndCutBtn:(AddAndCutBtn *)selfView withBtn:(UIButton *)btn withLabel:(UILabel *)label;

@end


@interface AddAndCutBtn : UIView

@property (nonatomic,strong) UIButton * cutBtn;

@property (nonatomic,strong) UIButton * addBtn;

@property (nonatomic,strong) UILabel * number;

@property(nonatomic,assign)id<AddAndCutBtnDelegate>delegate;

@end

