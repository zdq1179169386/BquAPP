//
//  NewfeatureController.m
//  Bqu
//
//  Created by yb on 15/10/17.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "NewfeatureController.h"
#define NewfeatureCount 3
@interface NewfeatureController ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)UIPageControl * pageControl;

@end

@implementation NewfeatureController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 1.创建一个scrollView：显示所有的新特性图片
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    // 2.添加图片到scrollView中
    CGFloat scrollW = scrollView.width;
    CGFloat scrollH = scrollView.height;
    for (int i = 0; i<NewfeatureCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.width = scrollW;
        imageView.height = scrollH;
        imageView.y = 0;
        imageView.x = i * scrollW;
        // 显示图片
        NSString *name = [NSString stringWithFormat:@"new_feature_%d", i + 1];
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        
        // 如果是最后一个imageView，就往里面添加其他内容
        if (i == NewfeatureCount - 1) {
            [self setupLastImageView:imageView];
        }
    }
#warning 默认情况下，scrollView一创建出来，它里面可能就存在一些子控件了
#warning 就算不主动添加子控件到scrollView中，scrollView内部还是可能会有一些子控件
    
    // 3.设置scrollView的其他属性
    // 如果想要某个方向上不能滚动，那么这个方向对应的尺寸数值传0即可
    scrollView.contentSize = CGSizeMake(NewfeatureCount * scrollW, 0);
    scrollView.bounces = NO; // 去除弹簧效果
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double page = scrollView.contentOffset.x / scrollView.width;
    // 四舍五入计算出页码
    self.pageControl.currentPage = (int)(page + 0.5);
    // 1.3四舍五入 1.3 + 0.5 = 1.8 强转为整数(int)1.8= 1
    // 1.5四舍五入 1.5 + 0.5 = 2.0 强转为整数(int)2.0= 2
    // 1.6四舍五入 1.6 + 0.5 = 2.1 强转为整数(int)2.1= 2
    // 0.7四舍五入 0.7 + 0.5 = 1.2 强转为整数(int)1.2= 1
}

/**
 *  初始化最后一个imageView
 *
 *  @param imageView 最后一个imageView
 */
- (void)setupLastImageView:(UIImageView *)imageView
{
    // 开启交互功能
    imageView.userInteractionEnabled = YES;
    
    
    // 2.开始微博
    UIButton *startBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 180, 55)];
//    startBtn.backgroundColor = [UIColor redColor];
    startBtn.centerX = ScreenWidth*0.5;
//    5,H:40 ,y:70; 6 :50,80;6p H:50,y:80
    startBtn.centerY = ScreenHeight-80;
    [startBtn addTarget:self action:@selector(startClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startBtn];
}
- (void)startClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(startClickDelegate:withBtn:)]) {
        [self.delegate startClickDelegate:self withBtn:btn];
    }
    // 切换到HWTabBarController
    /*
     切换控制器的手段
     1.push：依赖于UINavigationController，控制器的切换是可逆的，比如A切换到B，B又可以回到A
     2.modal：控制器的切换是可逆的，比如A切换到B，B又可以回到A
     3.切换window的rootViewController
     */
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    window.rootViewController = [[HWTabBarViewController alloc] init];
    
    // modal方式，不建议采取：新特性控制器不会销毁
    //    HWTabBarViewController *main = [[HWTabBarViewController alloc] init];
    //    [self presentViewController:main animated:YES completion:nil];
}

- (void)dealloc
{
//    HWLog(@"HWNewfeatureViewController-dealloc");
}

@end
