//
//  AllUseCouponView.h
//  Bqu
//
//  Created by yb on 15/10/20.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreferentialModel.h"

@protocol selectCouponDelegate <NSObject>

@optional
-(void)selectCoupon:(NSInteger)index ;
@end

@interface AllUseCouponView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic)NSArray *coupons;
@property (nonatomic,weak)id<selectCouponDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame deleagte:(id)delegate coupons:(NSArray*)coupons;
@end
