//
//  HomeTableViewFoot.h
//  Bqu
//
//  Created by yb on 15/11/9.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HomeTableViewFootDalegate <NSObject>
@optional
-(void)homeTableViewFootTouchDown;

@end


@interface HomeTableViewFoot : UIView
@property(nonatomic,weak)id<HomeTableViewFootDalegate>delegate;

+(instancetype)homeTableViewFoot;

@end
