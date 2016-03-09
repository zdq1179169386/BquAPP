

//  HomeViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/9.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//
#define slideViewHeight 158/375.0f
#define cellHeight 147.0f
#define buttonsHeight 95.0f
#define PointX 275/375.0
#import "HomeViewController.h"
#import "Header.h"
#import "DiscountViewController.h"
#import "ThemeJumpToVC.h"
#import "ListTableView.h"
//#import "ButtonsView.h"
#import "AllPeakController.h"
#import "SearchViewController.h"
#import "ScanController.h"
#import "ClassifyViewController.h"
#import "SearchListCollectionVC.h"//由搜索列表界面改为品牌专场界面
#import "OntimeJumpToVC.h"
#import "SearchController.h"


#import "OnTimeCell.h"
#import "ThemeCell.h"
#import "OverSeaCell.h"

#import "HttpTool.h"
#import "NSString+MD5.h"

#import "SlideViewModel.h"
#import "OntimeModel.h"
#import "ThemeModel.h"
#import "OverSeaModel.h"
#import "ProductModel.h"

//需要跳转的VC
#import "GoodsDetailViewController.h"
#import "HomeTableViewHead.h"
#import "HomeTableViewFoot.h"
#import "ShoppingCarTool.h"

#import "HomeTableFirstCell.h"
#import "HomeTableFourBtnCell.h"


#import "BquTool.h"
#import "SataicViewController.h"
#import "LoginViewController.h"
#import "PageView.h"
#import "StaticJumpToAppViewController.h"
@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,OverSeaCellDelegate,HomeTableViewFootDalegate,HomeTableFirstCellDelegate,HomeTableFourBtnCellDelegate>
{
    NSTimer * timer;
    //添加到购物车的数量
    NSInteger _count;
    NSString * _uid;
    NSInteger _page;
    NSInteger _pagrSize;
    //最大分页数
    NSInteger _maxPage;
    
    CALayer     *_layer;
    
    NSInteger    _cnt;


}
@property (nonatomic ,strong)UIButton * scrollToTopBtn;
@property (nonatomic ,strong)NSMutableArray *sliveAry;
@property (nonatomic ,strong)NSMutableArray *onTimeAry;
@property (nonatomic ,strong)NSMutableArray *themeAry;
@property (nonatomic ,strong)NSMutableArray *overseaAry;
@property (nonatomic ,assign)NSInteger ontimeCount;
@property (nonatomic ,assign)NSInteger themeCount;
@property (nonatomic ,assign)NSInteger overseaCount;


@property (nonatomic ,strong)NSString *shopingCarNum;
@property (nonatomic ,strong)UILabel *shopingCarLab;
/**当前页面的商品model*/
@property (nonatomic,strong)OverSeaModel * product;
@property (nonatomic,strong)OverSeaModel * overSeaModel;
@property (nonatomic,strong)OntimeModel *production;

@property (nonatomic,strong)UITableView * listTableView;
@property (nonatomic ,strong)NSIndexPath *index;

@property (nonatomic,assign)BOOL isLogin;

/**<#property#>*/
@property (nonatomic,strong)NetWorkView * netWorkView;

//遮盖 正在添加到服务器
@property (nonatomic,strong)MBProgressHUD *mBProgressHUD;

/**<#property#>*/
@property (nonatomic,strong)PageView * pageView;


@property (nonatomic,strong) UIBezierPath *path;

@end

static NSString * const ThemeID = @"Theme";
static NSString * const OverSeaID = @"Sea";
static NSString * const OnTimeID = @"Ontime";
@implementation HomeViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotohomeVC" object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{   // 首先判断用户是否登录
    
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotify:) name:@"gotohomeVC" object:nil];
    [self testUserIsOnline];
    UIColor * color = [UIColor colorWithHexString:@"e8103c"];
    self.navigationController.navigationBar.barTintColor = color;
    self.navigationController.navigationBar.translucent = NO;
}

//接收通知
-(void)receiveNotify:(NSNotification *)notify
{
    [self.listTableView setContentOffset:CGPointMake(0, 0) animated:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    //初始化导航
    [self setNavgation];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (IOS7_OR_LATER)
    {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
       //UI
    self.sliveAry  = [[NSMutableArray alloc] init];
    self.onTimeAry = [[NSMutableArray alloc]initWithCapacity:0];
    self.overseaAry = [NSMutableArray arrayWithCapacity:0];
    self.themeAry = [NSMutableArray arrayWithCapacity:0];

    [self initTableView];
    [self initScrollToTopBtn];
    //request
    [self FourRequest];
    
}
-(void)FourRequest
{
    [ProgressHud addProgressHudWithView:self.view andWithTitle:@"加载中"];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        //轮播图请求
        [self SlideViewRequest];
    });
    dispatch_group_async(group, queue, ^{
        //限时特卖请求
        [self OnTimeRequest];
    });
    dispatch_group_async(group, queue, ^{
//        [NSThread sleepForTimeInterval:10];
        //海外精选请求
        [self OverSeaRequset];
    });
    dispatch_group_async(group, queue, ^{
        //主题专场请求
        [self ThemeRequset];
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [ProgressHud hideProgressHudWithView:self.view];
    });
}
#pragma mark -- 上拉 OverSeaRequsetForPull
-(void)OverSeaRequsetForPull
{
    _page = _page + 1;
    if (_page>_maxPage) {
        [self.listTableView.footer endRefreshing];
        [self.listTableView.footer noticeNoMoreData];
        return;
    }
    NSString * page = [NSString stringWithFormat:@"%ld",(long)_page];
    NSString * pageSize = [NSString stringWithFormat:@"%ld",(long)_pagrSize];

    NSString *urlStr = [NSString stringWithFormat:@"%@/api/home/handpick/list",TEST_URL];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:page forKey:@"page"];
    [dict setObject:@"10" forKey:@"pagesize"];
    
    NSString * realSign = [HttpTool returnForSign:dict];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"page"] = page;
    dic[@"pagesize"] = @"10";
    dic[@"sign"] = realSign;
    
    [HttpTool post:urlStr params:dic success:^(id json) {
        
        NSArray * array = json[@"data"];
        //NSLog(@"海外精选%@",array);
        self.overseaCount = [json[@"totalCount"] floatValue];
        if (![array isKindOfClass:[NSNull class]] && array.count > 0)
        {
            for (int i = 0; i< array.count; i++)
            {
                NSDictionary *dictionary = array[i];
                OverSeaModel * overSeaModel = [OverSeaModel createOverSeaModelDictionary:dictionary];
                [self.overseaAry addObject:overSeaModel];
            }
//            [self.listTableView.header endRefreshing];
            [self.listTableView reloadData];
//            NSIndexSet * set = [[NSIndexSet alloc] initWithIndex:3];
//            [self.listTableView reloadSections:set withRowAnimation:UITableViewRowAnimationBottom];
        }
        [self.listTableView.footer endRefreshing];
    } failure:^(NSError *error) {
        
        [self.listTableView.footer endRefreshing];
        
    }];

}

-(void)initTableView
{
    _page = 1;
    _maxPage = 1;
    _pagrSize = 10;
    if (!self.listTableView) {
        self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-50) style:UITableViewStyleGrouped];
        self.listTableView.delegate = self;
        self.listTableView.dataSource = self;
        self.listTableView.showsVerticalScrollIndicator = NO;
        UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.01)];
//        PageView * header = [[PageView alloc] initPageViewFrame:CGRectMake(0, 0, ScreenWidth, slideViewHeight*ScreenWidth)];
        self.listTableView.tableHeaderView = header;
//        self.pageView = header;
        self.listTableView.tableFooterView = header;
        self.listTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.listTableView.separatorColor = [UIColor whiteColor];
       // self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        self.listTableView.backgroundColor = [UIColor redColor];
        //下拉刷新
        self.listTableView.header = [DIYHeader headerWithRefreshingBlock:^{
            [self FourRequest];
        }];
        //上拉加载
        self.listTableView.footer = [DIYFooter footerWithRefreshingBlock:^{
            if (self.overseaAry.count==0) {
                [self OverSeaRequset];
            }else
            {
                [self OverSeaRequsetForPull];
            }
        }];
        [self.listTableView registerClass:[HomeTableFirstCell class] forCellReuseIdentifier:@"firstCell"];
        [self.listTableView registerClass:[HomeTableFourBtnCell class] forCellReuseIdentifier:@"FourBtnCell"];

        
        [self.listTableView registerNib:[UINib nibWithNibName:@"OverSeaCell" bundle:nil] forCellReuseIdentifier:OverSeaID];
        [self.listTableView registerNib:[UINib nibWithNibName:@"OnTimeCell" bundle:nil] forCellReuseIdentifier:OnTimeID];
        [self.listTableView registerNib:[UINib nibWithNibName:@"ThemeCell" bundle:nil] forCellReuseIdentifier:ThemeID];
        [self.view addSubview:self.listTableView];
    }
}
-(void)initScrollToTopBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(ScreenWidth - 60, ScreenHeight-110 -70, 38, 38)];
    [btn setBackgroundImage:[UIImage imageNamed:@"1012app首页-切图@3x_35"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(BTNClic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.hidden = YES;
    self.scrollToTopBtn = btn;
}
/**
 *  滑动时出现回顶端按钮方法
 *
 *  @param sender sender description
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.listTableView.contentOffset.y > ScreenWidth)
    {
        self.scrollToTopBtn.hidden = NO;
    }
    else
    {
        self.scrollToTopBtn.hidden = YES;
    }
    
}
-(void)BTNClic
{
    [self.listTableView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (void)setNavgation
{
    UIButton *button_HomeNav = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_HomeNav addTarget:self action:@selector(homeNavButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [button_HomeNav setImage:[UIImage imageNamed:@"1012app首页-切图@2x_05"] forState:UIControlStateNormal];
    //button_HomeNav
    
    button_HomeNav.bounds = CGRectMake(0, 0, 27, 33);
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button_HomeNav];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    /*
     左按键扫一扫 暂时取消 打开可用
     */
    UIButton *scan_HomeNav = [UIButton buttonWithType:UIButtonTypeCustom];
    [scan_HomeNav addTarget:self action:@selector(Scan) forControlEvents:UIControlEventTouchUpInside];
    [scan_HomeNav setImage:[UIImage imageNamed:@"1012app首页-切图@2x_03"] forState:UIControlStateNormal];
    scan_HomeNav.bounds = CGRectMake(0, 0, 33, 33);
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:scan_HomeNav];
    self.navigationItem.leftBarButtonItem = left;
    //
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setNeedsStatusBarAppearanceUpdate];
}


//导航栏右按钮点击事件
- (void)homeNavButtonClick
{
    SearchViewController *search = [[SearchViewController alloc]init];
    search.hidesBottomBarWhenPushed = YES;
    
    
    [self.navigationController pushViewController:search animated:YES];
}
//导航栏左按钮点击事件
- (void)Scan
{
    ScanController *scan = [[ScanController alloc]init];
    scan.hidesBottomBarWhenPushed = YES;
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:scan];
    [self presentViewController:nav animated:YES completion:nil];
    
    scan.SYQRCodeSuncessBlock = ^(ScanController * vc,NSString * objStr)
    {
        NSLog(@"objStr%@",objStr);
        if ([objStr rangeOfString:@"http"].length>0 || [objStr rangeOfString:@"https"].length>0)
        {
            if ([objStr hasPrefix:ScanPrefix]) {
                //B区的链接
                NSArray * strArray = [objStr componentsSeparatedByString:@"?"];
              
                if ([strArray.firstObject rangeOfString:ProductDeatil].length>0) {
                    //商品详情
                    NSString * andStr = strArray.lastObject;
                    NSArray * strArray = [andStr componentsSeparatedByString:@"&"];
                    NSString * idStr = strArray.firstObject;
                    NSString * didStr = nil;
                    for (NSString * arStr in strArray) {
                      
                        if ([arStr containsString:@"did="]) {
                            didStr = arStr;
                        }
                    }
//                    NSLog(@"strArray=%@",strArray);
//                    NSLog(@"idStr= %@,didStr= %@",idStr,didStr);
                    NSString * firstStr = strArray.firstObject;
                    NSRange  range = [idStr rangeOfString:@"id="];
                    NSRange  valuesRange = NSMakeRange( range.length, firstStr.length - range.length);
                    idStr = [idStr substringWithRange: valuesRange];
                    NSRange didRange = [didStr rangeOfString:@"did="];
                    didStr = [didStr substringWithRange:NSMakeRange(didRange.length, didStr.length - didRange.length)];
                    NSLog(@"idStr= %@,didStr= %@",idStr,didStr);
                    if (idStr.length>0) {
                        
                        [vc dismissViewControllerAnimated:NO completion:^{
                            GoodsDetailViewController * goodsVC = [[GoodsDetailViewController alloc] init];
                            goodsVC.productId = idStr;
                            goodsVC.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:goodsVC animated:NO];
                            //didstr保存起来
                            [BquTool saveDid:didStr];
                        }];
                        
                    }
                    
                }else
                {
                    //其他链接
                    [vc dismissViewControllerAnimated:NO completion:^{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:objStr]];
                    }];
                    
                }
                
                
            }else
            {
                //其他链接
                [vc dismissViewControllerAnimated:NO completion:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:objStr]];
                }];
                
            }
            
        }else
        {
            //其他链接
            [vc dismissViewControllerAnimated:NO completion:^{
                UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"扫一扫" message:objStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [view show];
            }];
        }

        
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma TableViewDelegate
//每个分区的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section)
    {
        case 0:
            return 2;
            break;
        case 1:
            if ([self.onTimeAry isKindOfClass:[NSNull class]])
            {
                return 0;
            }
            else{
                return self.onTimeAry.count;
            }
            break;
            
        case 2:
            if ([self.themeAry isKindOfClass:[NSNull class]])
            {
                return 0;
            }
            else {
                return self.themeAry.count;
            }
            break;
            
        case 3:
            if ([self.overseaAry isKindOfClass:[NSNull class]])
            {
                return 0;
            }
            else {
                return self.overseaAry.count;
            }
            
            break;
            
        default:
            break;
    }
    return 0;
}


// 每个cell的高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //double pw = (ScreenWidth-20)/355;
    double pw = 1;
    if (ScreenWidth > 375) {
        pw = 1.217;
    }
    else if (ScreenWidth < 375)
    {
        pw = 0.945;
    }
    

    if (indexPath.section==0) {
        if (indexPath.row == 0) {
            return slideViewHeight * ScreenWidth;

        }else
        {
            return 95;

        }
        
    }
    else if(indexPath.section == 1)
    {
        return 117*pw;
    }
    else if (indexPath.section == 2)
    {
        return 143*pw;
    }
    else
    {
        return 125;
    }
    
    
}
// 返回三个分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}
//区头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        return 0.01;
        
    }else
    {
        return 50;
    }
    
}
//区脚高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return 0.01;
    }else
    {
        return 0.01;
    }
}
// 区头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.01)];
        return header;
    }else
    {
        NSString * name ;
        if (section == 1 ) name = @"海外特价";
        else if (section == 2 )name = @"品牌专场";
        else name = @"全球精品";
        HomeTableViewHead * view = [HomeTableViewHead homeTableViewHeadWith:name];
        return view;
    }
    return nil;
    
}

// 区脚视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView * footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.01)];
    return footer;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section ==0 ) {
       
        if (indexPath.row == 0) {
            HomeTableFirstCell * cell = [tableView dequeueReusableCellWithIdentifier:@"firstCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            if (![self.sliveAry  isKindOfClass:[NSNull class]]) {
                cell.sourceArray = self.sliveAry;
            }
            return cell;
        }else
        {
            HomeTableFourBtnCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FourBtnCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }

    }
    else if (indexPath.section == 1)
    {
        OnTimeCell *cell1 = [OnTimeCell OnTimeCellWithTableView:tableView];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        if (![self.onTimeAry isKindOfClass:[NSNull class]] && indexPath.row < self.onTimeAry.count)
        {
            OntimeModel *model = [self.onTimeAry objectAtIndex:indexPath.row];
            cell1.onTimeModel = model;
        }
        return cell1;
    }
    
    else if (indexPath.section == 2)
    {
        ThemeCell *cell2 =[ThemeCell themeCellWithTableView:tableView];
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        if (![self.themeAry isKindOfClass:[NSNull class]] && indexPath.row < self.themeAry.count)
        {
            ThemeModel *model = [self.themeAry objectAtIndex:indexPath.row];
            cell2.themeModel =model;
        }
        return cell2;
    }
    
    else if (indexPath.section == 3)
    {
        OverSeaCell *cell3 =[OverSeaCell overSeaCellWithTableView:tableView];
        cell3.selectionStyle = UITableViewCellSelectionStyleNone;
        if (![self.overseaAry isKindOfClass:[NSNull class]] && indexPath.row < self.overseaAry.count)
        {
            OverSeaModel * model = [self.overseaAry objectAtIndex:indexPath.row];
            cell3.overSeaModel = model;
            cell3.delegate = self;
        }
        cell3.shopCartBlock = ^(UIImageView *imageView,OverSeaModel * overSeaModel)
        {
            if (self.isLogin == NO)
            {
                [self goToLoginView];
            }
            else
            {
                __block HomeViewController * blockSelf = self;
                [self addProductToShoppingCart:overSeaModel success:^(BOOL msg) {
                    if (msg) {
                        // 成功执行动画
                        CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
//                        NSLog(@"rect==%@,%@",NSStringFromCGRect(imageView.frame),NSStringFromCGRect(rect));
                        rect.origin.y = rect.origin.y - [self.listTableView contentOffset].y;
                        CGRect headRect = imageView.frame;
                        headRect.origin.y = rect.origin.y;
                        [blockSelf startAnimationWithRect:headRect ImageView:imageView];

                    }
                    
                } failure:^(NSError *error) {
                    
                    if (error) {
                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:error.domain delegate:blockSelf cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alert show];
                    }
                    
                }];
            }

            
            
        };
        return cell3;
    }
    
    else
    {
        return nil;
    }
}
-(void)startAnimationWithRect:(CGRect)rect ImageView:(UIImageView *)imageView
{
    if (!_layer) {
        //        _btn.enabled = NO;
        _layer = [CALayer layer];
        _layer.contents = (id)imageView.layer.contents;
        _layer.contentsGravity = kCAGravityResizeAspectFill;
        _layer.bounds = rect;
//        [_layer setCornerRadius:CGRectGetHeight([_layer bounds]) / 2];
//        _layer.masksToBounds = YES;
        // 导航64
        _layer.position = CGPointMake(imageView.center.x, CGRectGetMidY(rect)+64);
        UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
        //        [_tableView.layer addSublayer:_layer];
        [window.layer addSublayer:_layer];
        self.path = [UIBezierPath bezierPath];
        [_path moveToPoint:_layer.position];
        CGPoint point = CGPointMake(imageView.center.x-30, rect.origin.y);
        [_path addLineToPoint:point];
        [_path addLineToPoint:CGPointMake(PointX*ScreenWidth, ScreenHeight-20)];
        //        (SCREEN_WIDTH - 60), 0, 50, 50)
//        [_path addQuadCurveToPoint:CGPointMake(ScreenWidth - 40, ScreenHeight-40) controlPoint:CGPointMake(ScreenWidth/2,rect.origin.y-80)];
        //        [_path addLineToPoint:CGPointMake(SCREEN_WIDTH-40, 30)];
    }
    [self groupAnimation];
}
-(void)groupAnimation
{
    self.listTableView.userInteractionEnabled = NO;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    animation.duration = 0.5;
//    animation.fillMode = kCAFillModeRemoved;
    animation.removedOnCompletion = NO;
//    animation.rotationMode = kCAAnimationRotateAuto;
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnimation.duration = 0.5;
    expandAnimation.fromValue = [NSNumber numberWithFloat:1];
    expandAnimation.toValue = [NSNumber numberWithFloat:0.2f];
    expandAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    expandAnimation.removedOnCompletion = NO;
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,expandAnimation];
    groups.duration = 0.5;
    groups.removedOnCompletion=NO;
    groups.fillMode=kCAFillModeForwards;
    groups.delegate = self;
    [_layer addAnimation:groups forKey:@"group"];
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    if (anim == [_layer animationForKey:@"group"]) {
        self.listTableView.userInteractionEnabled = YES;
        [_layer removeFromSuperlayer];
        _layer = nil;
        [self requestForShoppingCart];
    }
}

#pragma mark --------------------------------------------------------------------------------
#pragma mark -- HomeTableFourBtnCellDelegate 4个btn的代理
-(void)HomeTableFourBtnCellClick:(HomeTableFourBtnCell *)cell withBtn:(UIButton *)btn;
{
        [self jumpToAllPeakView:btn];
}


#pragma mark --------------------------------------------------------------------------------
#pragma mark --轮播图 点击跳转
-(void)HomeTableFirstCellDelegate:(HomeTableFirstCell *)cell withSelectedPage:(NSInteger)currentPage
{
    if (currentPage < self.sliveAry.count) {
        NSDictionary *dicData = self.sliveAry[currentPage];
        NSString * urlData = dicData[@"Url"];
        if (urlData == nil) return;
        // 跳转 url
        [self url:urlData];
    }
}


- (void)jumpToAllPeakView:(UIButton *)sender
{
    //    NSLog(@"跳转B区保障界面%s",__FUNCTION__);
    AllPeakController *allpeak = [[AllPeakController alloc]init];
    allpeak.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController pushViewController:allpeak animated:YES];

    
}


#pragma mark -----------------------------------
#pragma mark --OverSeaModelDelegate 实现，添加购物车
//-(void)touchDownAddShoppingButton:(OverSeaModel *)overSeaModel withImageView:(UIImageView *)imageView
//{
//    if (self.isLogin == NO)
//    {
//        [self goToLoginView];
//    }
//    else
//    {
////        NSLog(@"=%@",imageView.image);
//        [self addProductToShoppingCart:overSeaModel success:^(BOOL msg) {
//            
//        } failure:^(NSError *error) {
//            
//        }];
//    }
//}
#pragma mark -- 跳到登录页面
-(void)goToLoginView
{
    [ProgressHud addProgressHudWithView:self.view andWithTitle:@"请登录" withTime:1 withType:MBProgressHUDModeText];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       
                       //未登录，跳到登录页面
                       LoginViewController * vc = [[LoginViewController alloc] init];
                       vc.hidesBottomBarWhenPushed = YES;
                       [self.navigationController pushViewController:vc animated:YES];
                       
                   });
    
}
#pragma mark -- 检测用户是否已经登入
- (void)testUserIsOnline
{
    [ShoppingCarTool isLogin:^(BOOL success) {
        if (success) {
            self.isLogin = YES;
        }
        else
        {
            self.isLogin = NO;
        }
    } failure:^(NSError *error) {
        self.isLogin = NO;
    }];
}

//添加购物车
- (void)addProductToShoppingCart:(OverSeaModel *)goods success:(void(^)(BOOL msg))success failure:(void(^)(NSError *error))failure

{
    //添加遮盖
//    [self showLoadingView:@"添加到购物车"];
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/API/Cart/AddToCart",TEST_URL];
    NSString * memberID = [UserManager getMyObjectForKey:userIDKey];
    NSString * token = [UserManager getMyObjectForKey:accessTokenKey];
    
    NSString *GOODSTag = goods.identifier;
    NSDictionary * signDict = @{@"pid":GOODSTag,@"MemberID":memberID,@"token":token,@"skuid":goods.SkuId,@"count":@"1"};
    
    NSString * signStr = [HttpTool returnForSign:signDict];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    dic[@"pid"] = GOODSTag;
    dic[@"skuid"] = goods.SkuId;
    dic[@"count"] = @"1";
    dic[@"MemberID"] = memberID;
    dic[@"token"] = token;
    dic[@"sign"] = signStr;
    
    
    [HttpTool post:urlStr params:dic success:^(id json) {
        //移除遮盖
        [self hideLoadingView];
        NSString * resultCode = json[@"resultCode"];
        if (resultCode.intValue == 0)
        {
            if (success) {
                success(YES);
            }
//            [ProgressHud addProgressHudWithView:self.view andWithTitle:@"添加成功" withTime:0.5 withType:MBProgressHUDModeText];
//            [self requestForShoppingCart];
        }
        else
        {
            NSError * error = [[NSError alloc] initWithDomain:json[@"message"] code:100 userInfo:nil];
            if (failure) {
                failure(error);
            }
//            //显示超过50种显示
//            NSString * str = json[@"message"];
//            str = [str substringWithRange:NSMakeRange(3, str.length-3)];
//            [ProgressHud addProgressHudWithView:self.view andWithTitle:str withTime:1 withType:MBProgressHUDModeText];
        }
    } failure:^(NSError *error) {
        [self hideLoadingView];
    }];
}


//遮盖，用户点击添加到购物车 时候，显示，防止网络慢时候 ，点击其他，软件闪退
- (void)showLoadingView:(NSString*)showName
{
    if (!_mBProgressHUD)
    {
        // 基于哪个view?
        //UIView *baseView = self.navigationController.view ? self.navigationController.view : self.view;
        
        UIView *baseView = [[UIApplication sharedApplication].delegate window]  ? [[UIApplication sharedApplication].delegate window]  : self.view;
        _mBProgressHUD = [[MBProgressHUD alloc] initWithView:baseView];
        //_mBProgressHUD.labelText = @"添加到购物车";
        _mBProgressHUD.color = [UIColor blackColor];//这儿表示无背景
        [baseView addSubview:_mBProgressHUD];
        
    }
    _mBProgressHUD.labelText = showName;
    [_mBProgressHUD show:YES];
}

-(void)hideLoadingView
{
    _mBProgressHUD.hidden = YES;
}


#pragma mark -- 获取购物车物品数量
-(void)requestForShoppingCart
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/API/Cart/GetCartInfo",TEST_URL];
    NSString * memberID = [UserManager getMyObjectForKey:userIDKey];
    NSString * token = [UserManager getMyObjectForKey:accessTokenKey];
    
    NSMutableDictionary * signDict = [NSMutableDictionary dictionary];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSString *signStr = nil;
    [signDict setObject:memberID forKey:@"MemberID"];
    [signDict setObject:token forKey:@"token"];
    signStr  = [HttpTool returnForSign:signDict];
    dict[@"MemberID"] = memberID;
    dict[@"token"] = token;
    dict[@"sign"] = signStr;
    
    
    [HttpTool post:urlStr params:dict success:^(id json) {
        if (!json[@"error"]) {
            NSInteger arrarCount = 0;
            NSMutableArray *dataArray = [[NSMutableArray alloc]initWithCapacity:0];
            dataArray = json[@"data"];
            if (!dataArray) {
                return ;
            }
            if (![dataArray isKindOfClass:[NSNull class]]) {
                if (dataArray.count == 0) {
                    self.shopingCarNum = 0;
                    return;
                }
                for (int i=0; i < dataArray.count; i++) {
                    NSArray * subArray = dataArray[i];
                    arrarCount = arrarCount + subArray.count;
                }
                //改变购物车按钮的数量
                NSString * number = [NSString stringWithFormat:@"%ld",(long)arrarCount];
                self.shopingCarNum = number;
                //                if (number.intValue > 50) {
                //                    [ProgressHud addProgressHudWithView:self.view andWithTitle:@"限购50件" withTime:0.5 withType:MBProgressHUDModeText];
                //                    return ;
                //                }else
                [self budgeValue];
            }
        }
        
    } failure:^(NSError *error) {
        [self.listTableView.header endRefreshing];
     
    }];
}
- (void)budgeValue
{
    UITabBarItem * item = [self.tabBarController.tabBar.items objectAtIndex:3];
    
    [item setBadgeValue:[NSString stringWithFormat:@"%@",self.shopingCarNum]];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    [self.shopingCarLab removeFromSuperview];
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


//cell添加点击事件
#pragma mark
#pragma mark --- cell添加点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //轮播图
        
    }
    else if (indexPath.section == 1 && indexPath.row <= self.onTimeAry.count)
    {
        OntimeModel *ontimeModel = [self.onTimeAry objectAtIndex:indexPath.row];
        
        if ([ontimeModel.ProductId integerValue] != 0)
        {
            GoodsDetailViewController *goodsDetailVC = [[GoodsDetailViewController alloc]init];
            goodsDetailVC.productId = ontimeModel.ProductId;
            goodsDetailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodsDetailVC animated:YES];
        }
        else
        {
            OntimeJumpToVC *AllonTime = [[OntimeJumpToVC alloc]init];
            AllonTime.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:AllonTime animated:YES];
        }
        
    }
    else if (indexPath.section == 2 && indexPath.row < self.themeAry.count)
    {
        ThemeModel *Thememodel = [self.themeAry objectAtIndex:indexPath.row];
        SearchListCollectionVC *jumpVC = [[SearchListCollectionVC alloc]init];
        jumpVC.TopicId = Thememodel.TopicID;
        jumpVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
    else if (indexPath.section == 3 && indexPath.row < self.overseaAry.count)
    {
        
        self.product = [self.overseaAry objectAtIndex:indexPath.row];
        GoodsDetailViewController *goodsDetailVC = [[GoodsDetailViewController alloc]init];
        goodsDetailVC.productId = self.product.identifier;
        goodsDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:goodsDetailVC animated:YES];
        
    }
    //    OverSeaModel *OverSeaModel = [self.overseaAry objectAtIndex:indexPath.row];
}

//添加netView
-(void)addNetView
{
    if (self.sliveAry.count== 0 ||self.onTimeAry.count== 0 || self.themeAry.count== 0 ||self.overseaAry.count== 0 ) {
        [self.view addSubview:self.netView];
        self.netView.delegate = self;
    }
}

-(void)removeNewView
{
    for (UIView * view  in self.view.subviews)
    {
        if (view == self.netView)
        {
            [self.netView removeFromSuperview];
            break;
        }
    }
}

-(void)addAlertView
{
    UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器请求数据失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [view show];
}

-(void)NetWorkViewDelegate:(NetWorkView *)view withBtn:(UIButton *)btn
{
    [self FourRequest];
}



#pragma mark - 轮播图请求
- (void)SlideViewRequest
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/api/home/adv/list",TEST_URL];
    
    
    NSDictionary * dict = @{@"action":@"AdvList"};
    
    NSString * realSign = [HttpTool returnForSign:dict];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"action"] = @"AdvList";
    dic[@"sign"] = realSign;
    
    [HttpTool post:urlStr params:dic success:^(id json) {
        NSString *resultCode = json[@"resultCode"];
        if (!resultCode.intValue)
        {
            [self removeNewView];
            [self.sliveAry removeAllObjects];
            NSArray * array = json[@"data"];
//            NSLog(@"萝卜兔：%@",json[@"data"]);
            NSString *resultCode = json[@"resultCode"];
            if (resultCode.intValue == 0)
            {
                
                NSMutableArray * array =[NSMutableArray arrayWithArray:json[@"data"]];
//               array = [self getImageUrl:array];
                self.sliveAry = array;
//               self.pageView.imageArray = array;
            }
            else
            {
                [self addAlertView];
            }
        }
//        NSIndexSet * set = [[NSIndexSet alloc] initWithIndex:0];
        [self.listTableView reloadData];
        [self.listTableView.header endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        if (error.code == NetWorkingErrorCode) {
            
            [self.view addSubview:self.netView];
        }
        [self.listTableView.header endRefreshing];
        
    }];
}
-(NSMutableArray *)getImageUrl:(NSMutableArray*)sliveAry
{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for (int i=0 ; i< sliveAry.count; i++) {
        NSDictionary * dic = sliveAry[i];
        NSString * str = dic[@"ImageUrl"];
        [array addObject:str];
    }
    return array;
}
#pragma mark - 限时特卖请求
- (void)OnTimeRequest {
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/home/limit/list",TEST_URL];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:@"LimitList" forKey:@"action"];
    
    NSString * realSign = [HttpTool returnForSign:dict];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"action"] = @"LimitList";
    dic[@"sign"] = realSign;
    
    [HttpTool post:urlStr params:dic success:^(id json) {
        
        
        NSString *resultCode = json[@"resultCode"];
        //请求成功
        if (!resultCode.intValue)
        {
            [self removeNewView];
            [self.onTimeAry removeAllObjects];
            self.ontimeCount = [json[@"totalCount"] floatValue];
            NSArray *array = json[@"data"];
            
            if (![array isKindOfClass:[NSNull class]] && array.count > 0)
            {
                for (int i = 0; i< array.count; i++)
                {
                    NSDictionary *dictionary = array[i];
                    OntimeModel *model = [OntimeModel createOntimeModel:dictionary];
                    [self.onTimeAry addObject:model];
                }
                [self.listTableView.header endRefreshing];
                NSIndexSet * set = [[NSIndexSet alloc] initWithIndex:1];
                [self.listTableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        else
        {
            [self addAlertView];
        }
        
    } failure:^(NSError *error) {
        if (error.code == NetWorkingErrorCode) {
            
            [self.view addSubview:self.netView];
        }
        [self.listTableView.header endRefreshing];
        
    }];
}
#pragma mark - 海外精选请求
- (void)OverSeaRequset
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/home/handpick/list",TEST_URL];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:@"1" forKey:@"page"];
    [dict setObject:@"10" forKey:@"pagesize"];
    
    NSString * realSign = [HttpTool returnForSign:dict];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"page"] = @"1";
    dic[@"pagesize"] = @"10";
    dic[@"sign"] = realSign;
    
    [HttpTool post:urlStr params:dic success:^(id json) {
        NSString *resultCode = json[@"resultCode"];
        //请求成功
        if (resultCode.intValue == 0)
        {
            [self removeNewView];
            [self.overseaAry removeAllObjects];
            NSArray * array = json[@"data"];
            if (![array isKindOfClass:[NSNull class]] && array.count > 0)
            {
                for (int i = 0; i< array.count; i++)
                {
                    NSDictionary *dictionary = array[i];
                    OverSeaModel * overSeaModel = [OverSeaModel createOverSeaModelDictionary:dictionary];
                    [self.overseaAry addObject:overSeaModel];
                }
                NSIndexSet * set = [[NSIndexSet alloc] initWithIndex:3];
                [self.listTableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
                [self.listTableView.header endRefreshing];
                [self.listTableView.footer endRefreshing];
                //最大分页数
                NSLog(@"totalCount=%@",json[@"totalCount"]);
                NSString * totalCount = json[@"totalCount"];
                float x = totalCount.floatValue/10.0;
                _maxPage = ceilf(x);
                
            }
            
        }
        else
        {
            [self addAlertView];
        }
        [self.listTableView.footer endRefreshing];
    } failure:^(NSError *error) {
        if (error.code == NetWorkingErrorCode) {
            
            [self.view addSubview:self.netView];
        }
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
        
    }];
}
#pragma mark - 主题专场请求
-(void)ThemeRequset {
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/home/topic/list",TEST_URL];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"TopIc" forKey:@"action"];
    
    NSString * realSign = [HttpTool returnForSign:dict];
    
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"action"] = @"TopIc";
    dic[@"sign"] = realSign;
    
    [HttpTool post:urlStr params:dic success:^(id json) {

        NSString *resultCode = json[@"resultCode"];
        if (resultCode.intValue == 0)
        {
            [self removeNewView];
            [self.themeAry removeAllObjects];
            NSArray *array = json[@"data"];
            if (![array isKindOfClass:[NSNull class]] && array.count > 0)
            {
                for (int i = 0; i < array.count; i++)
                {
                    NSMutableDictionary *dictionary = array[i];
                    ThemeModel *model = [ThemeModel createModelDictionary:dictionary];
                    [self.themeAry addObject:model];
                }
                [self.listTableView.header endRefreshing];
                NSIndexSet * set = [[NSIndexSet alloc] initWithIndex:2];
                [self.listTableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        else
        {
            [self addAlertView];
        }
    } failure:^(NSError *error) {
        if (error.code == NetWorkingErrorCode) {
            
            [self.view addSubview:self.netView];
        }
        [self.listTableView.header endRefreshing];
        
    }];
}

@end

