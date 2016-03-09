//
//  NetWorkView.h
//  Bqu
//
//  Created by yb on 15/11/19.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NetWorkView;

@protocol NetWorkViewDelegate <NSObject>

@optional

-(void)NetWorkViewDelegate:(NetWorkView*)view withBtn:(UIButton *)btn;

@end

@interface NetWorkView : UIView



/**代理*/
@property(nonatomic,weak)id<NetWorkViewDelegate>  delegate;


-(instancetype)initWithFrame:(CGRect)frame;

@end

