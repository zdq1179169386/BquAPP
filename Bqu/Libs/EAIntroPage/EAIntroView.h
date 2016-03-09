//
//  EAIntroView.h
//  BquAPP
//
//  Created by yb on 15/10/14.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAIntroPage.h"

@protocol EAIntroDelegate
@optional
- (void)introDidFinish;
@end

@interface EAIntroView : UIView <UIScrollViewDelegate>

@property (nonatomic, assign) id<EAIntroDelegate> delegate;

// titleView Y position - from top of the screen
// pageControl Y position - from bottom of the screen
@property (nonatomic, assign) bool swipeToExit;
@property (nonatomic, assign) bool tapToNext;
@property (nonatomic, assign) bool hideOffscreenPages;
@property (nonatomic, assign) bool easeOutCrossDisolves;
@property (nonatomic, assign) bool showSkipButtonOnlyOnLastPage;
@property (nonatomic, assign) bool useMotionEffects;

@property (nonatomic, retain) UIImage *bgImage;
@property (nonatomic, retain) UIView *titleView;
@property (nonatomic, assign) CGFloat titleViewY;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, assign) CGFloat pageControlY;
@property (nonatomic, retain) UIButton *skipButton;

@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIImageView *bgImageView;
@property (nonatomic, retain) UIImageView *pageBgBack;
@property (nonatomic, retain) UIImageView *pageBgFront;
@property (nonatomic, retain) NSArray *pages;

- (id)initWithFrame:(CGRect)frame andPages:(NSArray *)pagesArray;
- (void)showInView:(UIView *)view animateDuration:(CGFloat)duration;
- (void)hideWithFadeOutDuration:(CGFloat)duration;

@end
