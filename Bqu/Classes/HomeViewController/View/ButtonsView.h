//
//  ButtonsView.h
//  Bqu
//
//  Created by WONG on 15/10/10.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonsView : UIView

@property(strong,nonatomic)UILabel *trueLable;//闪电发货
@property(strong,nonatomic)UILabel *offlineLable;//满88包邮
@property(strong,nonatomic)UILabel *overseeLable;//海外直供
@property(strong,nonatomic)UILabel *slightLable;//线下店铺

@property(strong,nonatomic)UIButton *trueBtn;
@property(strong,nonatomic)UIButton *offlineBtn;
@property(strong,nonatomic)UIButton *overseeBtn;
@property(strong,nonatomic)UIButton *slightBtn;

@property(strong,nonatomic)UIImageView *trueImg;
@property(strong,nonatomic)UIImageView *offlineImg;
@property(strong,nonatomic)UIImageView *overseaImg;
@property(strong,nonatomic)UIImageView *slightImg;



@end
