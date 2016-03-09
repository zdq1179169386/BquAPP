//
//  SiftConditionDetailShowView.h
//  Bqu
//
//  Created by yb on 15/12/10.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^conditionDetailShowViewBlock) (NSInteger tag);

@interface SiftConditionDetailShowView : UIView
@property (nonatomic)NSArray * conditionArray;

-(void)setConditionDetailShowViewBlock:(conditionDetailShowViewBlock)block;
@end
