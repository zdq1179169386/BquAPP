//
//  SiftView.h
//  Bqu
//
//  Created by yb on 15/11/20.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SiftViewBlock) (NSString * name);


@interface SiftView : UIView
-(void)setBlock:(SiftViewBlock)block;

-(void)animateWithDuration:(CGFloat)time rect:(CGRect)rect;
@end
