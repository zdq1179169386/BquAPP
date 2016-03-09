//
//  LeveyTabBarController.h
//  BquAPP
//
//  Created by yb on 15/10/14.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeveyTabBar.h"


@class UITabBarController;
@protocol LeveyTabBarControllerDelegate;
@interface LeveyTabBarController : UIViewController <LeveyTabBarDelegate>
{
    LeveyTabBar *_tabBar;
    UIView      *_containerView;
    UIView		*_transitionView;
    
    NSMutableArray *_viewControllers;
    NSUInteger _selectedIndex;
    
    BOOL _tabBarTransparent;
    BOOL _tabBarHidden;
    
    NSInteger animateDriect;
    UIImageView * _userImgView;
    NSArray * tabBarTlter;
    BOOL showImg;
    UIButton * _leftBtn;
    UIButton * _rightBtn;
    
}

@property(nonatomic, copy) NSMutableArray *viewControllers;

@property(nonatomic, readonly) UIViewController *selectedViewController;
@property(nonatomic) NSUInteger selectedIndex;

// Apple is readonly
@property (nonatomic, readonly) LeveyTabBar *tabBar;
@property(nonatomic,assign) id<LeveyTabBarControllerDelegate> delegate;


// Default is NO, if set to YES, content will under tabbar
@property (nonatomic) BOOL tabBarTransparent;
@property (nonatomic) BOOL tabBarHidden;

@property(nonatomic,assign) NSInteger animateDriect;

- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr;

- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated;
//- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated driect:(NSInteger)driect;

// Remove the viewcontroller at index of viewControllers.
- (void)removeViewControllerAtIndex:(NSUInteger)index;

// Insert an viewcontroller at index of viewControllers.
- (void)insertViewController:(UIViewController *)vc withImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index;

-(void)rightDrawerButtonPress:(id)sender;
-(void)leftDrawerButtonPress:(id)sender;
@end


@protocol LeveyTabBarControllerDelegate <NSObject>
@optional
- (BOOL)tabBarController:(LeveyTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
- (void)tabBarController:(LeveyTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
@end

@interface UIViewController (LeveyTabBarControllerSupport)
@property(nonatomic, readonly) LeveyTabBarController *leveyTabBarController;
@end

