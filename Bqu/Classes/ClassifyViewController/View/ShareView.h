//
//  ShareView.h
//  Bqu
//
//  Created by yb on 15/10/21.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShareView;

@protocol  ShareViewDelegate<NSObject>

@optional
-(void)ShareViewDelegate:(ShareView *)view withBtn:(UIButton *)selectedBtn;

@end

@interface ShareView : UIView

@property (nonatomic,assign)id<ShareViewDelegate>delegate;

@property (nonatomic,strong) UIView * buttomView;

@property (nonatomic,strong) UIButton * dismissBtn;

+(instancetype)creatShareView;

@end

