//
//  LeveyTabBarController.m
//  BquAPP
//
//  Created by yb on 15/10/14.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "LeveyTabBarController.h"
#import "LeveyTabBar.h"
#import "Header.h"

#define HEIGHT_MENU_VIEW 64

static LeveyTabBarController *leveyTabBarController;

@implementation UIViewController (LeveyTabBarControllerSupport)

- (LeveyTabBarController *)leveyTabBarController
{
    return leveyTabBarController;
}

@end

@interface LeveyTabBarController (private)
- (void)displayViewAtIndex:(NSUInteger)index;
@end

@implementation LeveyTabBarController
@synthesize delegate = _delegate;
@synthesize selectedViewController = _selectedViewController;
@synthesize viewControllers = _viewControllers;
@synthesize selectedIndex = _selectedIndex;
@synthesize tabBarHidden = _tabBarHidden;
@synthesize animateDriect;
#pragma mark -
#pragma mark lifecycle
- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr
{
    self = [super init];
    if (self != nil)
    {
        if (arr>0) {
            
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
            
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
            [self prefersStatusBarHidden];
            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
#endif
            
            _viewControllers = [NSMutableArray arrayWithArray:vcs];
            
            _containerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            _transitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                       ScreenWidth,
                                                                       _containerView.frame.size.height - kTabBarHeight)];
            _tabBar = [[LeveyTabBar alloc] initWithFrame:CGRectMake(0,
                                                                    _containerView.frame.size.height - kTabBarHeight,
                                                                    ScreenWidth, kTabBarHeight)
                                            buttonImages:arr];
            _tabBar.delegate = self;
            leveyTabBarController = self;
            animateDriect = 0;
            tabBarTlter =[arr copy];
        }
    }
    return self;
}

-(void)pushLogin:(id)sende
{
    //    NewLoginViewController *VC = [[NewLoginViewController alloc] init];
    //    VC.shouldHideTabbar = YES;
    //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:VC];
    //    [self presentViewController:nav animated:NO completion:nil];
}
- (void)loadView
{
    [super loadView];
    
    [_containerView addSubview:_transitionView];
    [_containerView addSubview:_tabBar];
    self.view = _containerView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置iOS的返回按钮
    UIImage  *backButtonImage = [[UIImage imageNamed:@"back_bt_7.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIOffset adjustment= [[UIBarButtonItem appearance]  backButtonTitlePositionAdjustmentForBarMetrics:UIBarMetricsDefault];
    UIOffset newAdjustment = UIOffsetMake(adjustment.horizontal-10 , adjustment.vertical-5 );
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:newAdjustment forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:17], NSFontAttributeName, nil]];
}
-(void)rightDrawerButtonPress:(id)sender{
    
}

- (void)leftDrawerButtonPress:(id)sender{
    
}

#pragma mark - instant methods

- (LeveyTabBar *)tabBar
{
    return _tabBar;
}

- (BOOL)tabBarTransparent
{
    return _tabBarTransparent;
}

- (void)setTabBarTransparent:(BOOL)yesOrNo
{
    if (yesOrNo == YES)
    {
        _transitionView.frame = _containerView.bounds;
    }
    else
    {
        _transitionView.frame = CGRectMake(0, 0, ScreenWidth, _containerView.frame.size.height - kTabBarHeight);
    }
}

- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated
{
    if (yesOrNO == YES)
    {
        if (self.tabBar.frame.origin.y == self.view.bounds.size.height)
        {
            return;
        }
    }
    else
    {
        if (self.tabBar.frame.origin.y == _containerView.frame.size.height -kTabBarHeight)
        {
            return;
        }
    }
    
    if (animated == YES)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
        if (yesOrNO == YES)
        {
            //DLog(@"taBar隐身==frame==%@",NSStringFromCGRect(self.tabBar.frame));
            self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y + kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
        }
        else
        {
            //DLog(@"taBar隐身==frame==%@",NSStringFromCGRect(self.tabBar.frame));
            self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, _containerView.frame.size.height  - kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
        }
        [UIView commitAnimations];
    }
    else
    {
        if (yesOrNO == YES)
        {
            self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y + kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
        }
        else
        {
            self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y - kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
        }
    }
}

- (NSUInteger)selectedIndex
{
    return _selectedIndex;
}
- (UIViewController *)selectedViewController
{
    return [_viewControllers objectAtIndex:_selectedIndex];
}

-(void)setSelectedIndex:(NSUInteger)index
{
    [_tabBar selectTabAtIndex:index];
    
    [self displayViewAtIndex:index];
}

- (void)removeViewControllerAtIndex:(NSUInteger)index
{
    if (index >= [_viewControllers count])
    {
        return;
    }
    // Remove view from superview.
    [[(UIViewController *)[_viewControllers objectAtIndex:index] view] removeFromSuperview];
    // Remove viewcontroller in array.
    [_viewControllers removeObjectAtIndex:index];
    // Remove tab from tabbar.
    [_tabBar removeTabAtIndex:index];
}

//添加一个新视图控制到指定的位置
//参数 VC 视图控制器 dict 附带的信息如bartitle图片.名字等    index 指定到插入到位置
- (void)insertViewController:(UIViewController *)vc withImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index
{
    [_viewControllers insertObject:vc atIndex:index];
    [_tabBar insertTabWithImageDic:dict atIndex:index];
}

#pragma mark - Private methods
- (void)displayViewAtIndex:(NSUInteger)index
{
    // Before change index, ask the delegate should change the index.
    if ([_delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)])
    {
        if (![_delegate tabBarController:self shouldSelectViewController:[self.viewControllers objectAtIndex:index]])
        {
            return;
        }
    }
    // If target index if equal to current index, do nothing.
    if (_selectedIndex == index && [[_transitionView subviews] count] != 0)
    {
        return;
    }
    
    _selectedIndex = index;
    
    UINavigationController *selectedVC = [self.viewControllers objectAtIndex:index];
    //    if (_selectedIndex==2)
    //    {
    //        UIViewController *destCtl = selectedVC.visibleViewController;
    //        if ([destCtl isKindOfClass:[ShoppingViewController class]])
    //        {
    //            ShoppingViewController *sCtl = (ShoppingViewController *)destCtl;
    //            [sCtl refreshBtnClicked];
    //        }
    //    }
    
    // add by will
    [selectedVC.visibleViewController viewWillAppear:YES];
    
    
    selectedVC.view.frame = _transitionView.frame;
    if ([selectedVC.view isDescendantOfView:_transitionView])
    {
        [_transitionView bringSubviewToFront:selectedVC.view];
    }
    else
    {
        [_transitionView addSubview:selectedVC.view];
    }
    
    // Notify the delegate, the viewcontroller has been changed.
    if ([_delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)])
    {
        [_delegate tabBarController:self didSelectViewController:selectedVC];
    }
}

#pragma mark - tabBar delegates

- (void)tabBar:(LeveyTabBar *)tabBar didSelectIndex:(NSInteger)index
{
    if (self.selectedIndex == index) {
        UINavigationController  *nav = [self.viewControllers objectAtIndex:index];
        [nav popToRootViewControllerAnimated:YES];
    }else if (index == 2){
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationRefreshPerson object:nil userInfo:nil];
        [self displayViewAtIndex:index];
    }else if (index == 3){
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationRefreshPerson object:nil userInfo:nil];
        [self displayViewAtIndex:index];
    }
    else {
        [self displayViewAtIndex:index];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return false;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (1 << UIInterfaceOrientationPortrait);
}
@end
