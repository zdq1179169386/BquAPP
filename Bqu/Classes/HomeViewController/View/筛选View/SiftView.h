//
//  SiftView.h
//  Bqu
//
//  Created by yb on 15/11/20.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SiftTypeModel;

typedef void (^SiftViewBlock) (SiftTypeModel*model);


@interface SiftView : UIView
@property (nonatomic,strong)NSMutableArray * Classifys;

-(void)setBlock:(SiftViewBlock)block;

-(void)animateWithDuration:(CGFloat)time rect:(CGRect)rect;
-(void)reloadTableView;
@end
