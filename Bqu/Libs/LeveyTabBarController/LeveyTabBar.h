//
//  LeveyTabBar.h
//  BquAPP
//
//  Created by yb on 15/10/14.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@protocol LeveyTabBarDelegate;

@interface LeveyTabBar : UIView
{
    UIImageView *_backgroundView;
    NSMutableArray *_buttons;
}
@property (nonatomic, retain) UIImageView *backgroundView;
@property (nonatomic, assign) id<LeveyTabBarDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *buttons;
@property (nonatomic, strong) UIView *lineView;

- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray;
- (void)selectTabAtIndex:(NSInteger)index;
- (void)removeTabAtIndex:(NSInteger)index;
- (void)insertTabWithImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index;
- (void)setBackgroundImage:(UIImage *)img;

@end
@protocol LeveyTabBarDelegate<NSObject>
@optional
- (void)tabBar:(LeveyTabBar *)tabBar didSelectIndex:(NSInteger)index;
//-(void)pushLogin:(id)sende;
@end
