//
//  GoodsDetailViewController.m
//  Bqu
//
//  Created by yb on 15/10/12.
//  Copyright (c) 2015年 yingbo. All rights reserved.
// 商品详情页

#import "GoodsDetailViewController.h"
#import "BuyAndShoppingCarButtomBar.h"
#import "BuyButtomView.h"
#import "ClassifyViewController.h"
#import "ProductModel.h"
#import "FirmOrderTableViewController.h"
#import "ProductDetailFirstRowCell.h"
#import "ProductDeatilSecondSectionHeader.h"
#import "ShareView.h"
#import "CommentDataViewController.h"
#import "ProductDetailSecondRowCell.h"
#import "ProductDetailThreeRowCell.h"
#import "ProductDeatailWebCell.h"
#import "ProductDetailFirstRowCell.h"
#import "ProductDetailBaseinformationCell.h"
#import "ProductDeatilBquCell.h"
#import "ProductDetailThreeRowAnotherCell.h"
#import "ProductDetailFourRowCell.h"
#import "AllPeakController.h"
#import "LoginViewController.h"
#import "ProductWebController.h"
#import "ProductDetailTaxCell.h"
#import "ProductDetailSecondPartHeader.h"
#import "ProductRefreshFooter.h"
//ShareSDK
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>

#define NavBarH 64
#define ButtomBarH 49
#define FirstCell_H 318/375.0f
#define VirtualProductFirstCell_H 290/375.0f
#define AnimationX 30/375.0f

@interface GoodsDetailViewController ()<UITableViewDataSource,UITableViewDelegate,BuyAndShoppingCarButtomBarDelegate,ProductDetailThreeRowCellDelegate,ProductDeatilSecondSectionHeaderDelegate,ShareViewDelegate,ProductDetailFirstRowCellDelegate,ProductDetailFourRowCellDelegate,UIWebViewDelegate,NetWorkViewDelegate,UIAlertViewDelegate>
{
    NSTimer * timer;
    //添加到购物车的数量
    NSInteger _count;
    NSString * _uid;
    
    int time;
    
    CGFloat  web_H;
}

@property (nonatomic,strong)UITableView * tableView;
/**直接购买和购物车bar*/
@property (nonatomic,strong)BuyAndShoppingCarButtomBar * buttomBar;
/**弹出的view*/
@property (nonatomic,strong)BuyButtomView * buyView;
/**当前页面的商品model*/
@property (nonatomic,strong)ProductModel * product;
/**收藏按钮*/
@property (nonatomic,strong)UIButton * addBtn;

/**分享视图*/
@property (nonatomic,strong) ShareView * shareView;

/**判断用户是否登录*/
@property (nonatomic, assign)BOOL isOnline;

/**<#property#>*/
@property (nonatomic,strong)NSMutableArray * cartArray;

/**大的scrollview*/
@property (nonatomic, strong)UIScrollView * bigSrollV;

/**放web的scrollview*/
@property (nonatomic,strong)UIScrollView * webScrollV;
/**web*/
@property (nonatomic,strong)UIWebView * webView;

/**加入购物车的动画*/
@property (nonatomic,strong)UIImageView * animationImage;


@end

@implementation GoodsDetailViewController

#pragma mark ------------- NetWorkViewDelegate  ------------------
-(void)NetWorkViewDelegate:(NetWorkView*)view withBtn:(UIButton *)btn
{
    [self requestForData];
}
-(void)dealloc
{
    self.tableView = nil;
    self.buyView = nil;
    self.product = nil;
    self.addBtn = nil;
}
-(UIImageView*)animationImage
{
    if (!_animationImage) {
        _animationImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        //_animationImage.backgroundColor = [UIColor redColor];
        //_animationImage.layer.cornerRadius = 15;
        _animationImage.clipsToBounds = YES;
        _animationImage.hidden = YES;
        _animationImage.image = [UIImage imageNamed:@"详情页购物车动画"];
        [self.view addSubview:_animationImage];
        _animationImage.center = CGPointMake(ScreenWidth/2.0, ScreenHeight/3.0);
    }
    return _animationImage;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.buttomBar.frame = CGRectMake(0, ScreenHeight- 64 - ButtomBarH, ScreenWidth, ButtomBarH);
    //每次进入详情页，都需判断，用户是否登录
    [self requestForData];
    [HttpTool testUserIsOnlineSuccess:^(BOOL msg) {
        if (msg==YES) {
             self.isOnline = YES;
            [self requestForShoppingCart];
           
        }else
        {
            self.isOnline = NO;
        }
    }];

    
  
}
#pragma mark -- web重新加载
-(void)webViewReload
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/app/ProductDetail?id=%@",WX_URL,self.productId];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@",request);
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"%f,%f",ScreenHeight,ScreenWidth);
    self.automaticallyAdjustsScrollViewInsets = NO;

    if (IOS7_OR_LATER)
    {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
   
    
//    [self requestForData];

    [self initNavBar];
//    [self.view addSubview:self.netWorkView];
    [self initTableView];

    
    //请求数据
    
   

}
-(void)openTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(GoodscellTimerRun) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
#pragma mark --  请求数据
-(void)requestForData
{

    [ProgressHud addProgressHudWithView:self.view andWithTitle:@"加载中"];
    NSString * memberID = [UserManager getMyObjectForKey:userIDKey];
    NSString * token = [UserManager getMyObjectForKey:accessTokenKey];
    
    if (!memberID && !token) {
        
         _uid = @"0";
    }else if (memberID && token)
    {
        _uid = memberID;
    }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                

    NSString * urlStr = [NSString stringWithFormat:@"%@/api/home/product/detail",TEST_URL];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:_uid forKey:@"uid"];
//    NSLog(@"uid==%@",_uid);
    [dict setObject:self.productId forKey:@"pid"];
    [dict setObject:_uid forKey:@"uid"];

    NSString * signStr = [HttpTool returnForSign:dict];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"uid"] = _uid;
    dic[@"pid"] = self.productId;
    dic[@"sign"] = signStr; 
    
      __block GoodsDetailViewController * blockSelf = self;
    [HttpTool post:urlStr params:dic success:^(id json) {
        NSLog(@"商品详情%@,",json);
        NSString * resultCode = json[@"resultCode"];
        if (resultCode.intValue == 0) {
        ProductModel * model = [ProductModel objectWithKeyValues:json[@"data"]];
        self.product = model;
          
            if (model.IsFavorite.boolValue) {
                 [self.addBtn setImage:[UIImage imageNamed:@"B区详情页04-收藏红爱心"] forState:UIControlStateNormal];
            }else
            {
                [self.addBtn setImage:[UIImage imageNamed:@"B区详情页04-收藏"] forState:UIControlStateNormal];
            }
            //传值
            self.buttomBar.product = model;
            [blockSelf.tableView reloadData];
            [self.tableView.header endRefreshing];
            [ProgressHud hideProgressHudWithView:self.view];
            //有数据才开定时器
            [self openTimer];
            
        }else
        {
            [ProgressHud hideProgressHudWithView:self.view];
            UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"商品有误" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [view show];
        }
        
        for (UIView * view in self.view.subviews) {
            if (view == self.netView) {
                [self.netView removeFromSuperview];
                break;
            }
        }
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [ProgressHud hideProgressHudWithView:self.view];
      
        if (error.code == NetWorkingErrorCode) {
            [self.view addSubview:self.netView];
        }
    }];
    
  
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 初始化导航条
-(void)initNavBar
{
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.text = @"商品详情";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:18];
    self.navigationItem.titleView = titleLabel;

    [self.navigationController.navigationBar setTranslucent:YES];//王加
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHexString:@"#333333"]];
    
     [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"f9f9f9"]];
    UIButton * backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
   
    UIButton * storeBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-50, 0, 22, 22)];

    //    storeBtn.backgroundColor = [UIColor yellowColor];
    [storeBtn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item2 = [[UIBarButtonItem alloc] initWithCustomView:storeBtn];
    NSLog(@"%@",self.product.IsFavorite);
    if (self.product.IsFavorite.boolValue) {
        storeBtn.selected = YES;
        [storeBtn setImage:[UIImage imageNamed:@"B区详情页04-收藏红爱心"] forState:UIControlStateNormal];

    }else
    {
        storeBtn.selected = NO;
        [storeBtn setImage:[UIImage imageNamed:@"B区详情页04-收藏"] forState:UIControlStateNormal];
    }
    
    CGFloat storeBtn_X = CGRectGetMinX(storeBtn.frame);
   
    UIButton * shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(storeBtn_X - 40, 0, 22, 22)];
    [shareBtn setImage:[UIImage imageNamed:@"B区详情页01-分享"] forState:UIControlStateNormal];
    UIBarButtonItem * itema1 = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    [shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchDown];
//    shareBtn.backgroundColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItems = @[itema1,item2];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
    
    self.addBtn = storeBtn;
    storeBtn.size = storeBtn.imageView.image.size;
}
#pragma mark -- 返回
-(void)back
{
//     UIViewAnimationOptionTransitionFlipFromBottom
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark -- 初始化表
-(void)initTableView
{
    //整体的scrollview
    if (_bigSrollV == nil) {
        self.bigSrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - ButtomBarH)];
        self.bigSrollV.contentSize = CGSizeMake(ScreenWidth, (ScreenHeight - ButtomBarH) * 2);
        self.bigSrollV.pagingEnabled = YES;
        self.bigSrollV.scrollEnabled = NO;
        self.bigSrollV.backgroundColor = [UIColor colorWithHexString:@"#f2f1f1"];
        [self.view addSubview:self.bigSrollV];
    }

    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - ButtomBarH -60) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f2f1f1"];
        [self.tableView registerClass:[ProductDetailFirstRowCell class] forCellReuseIdentifier:@"cellRowOne"];
        [self.tableView registerClass:[ProductDetailSecondRowCell class] forCellReuseIdentifier:@"cellRowTwo"];
        [self.tableView registerClass:[ProductDetailThreeRowCell class] forCellReuseIdentifier:@"cellRowThree"];
        [self.tableView registerClass:[ProductDetailThreeRowAnotherCell class] forCellReuseIdentifier:@"cellRowThree2"];
        [self.tableView registerClass:[ProductDetailFourRowCell class] forCellReuseIdentifier:@"cellRowFour"];

        [self.tableView registerClass:[ProductDeatailWebCell class] forCellReuseIdentifier:@"webCell"];
        [self.tableView registerClass:[ProductDetailBaseinformationCell class] forCellReuseIdentifier:@"baseCell"];
        [self.tableView registerClass:[ProductDeatilBquCell class] forCellReuseIdentifier:@"BquCell"];

        [self.tableView registerClass:[ProductDeatilSecondSectionHeader class] forHeaderFooterViewReuseIdentifier:@"header"];
        //下拉刷新
        self.tableView.header.backgroundColor = [UIColor colorWithHexString:@"#f2f1f1"];
        self.tableView.header = [DIYHeader headerWithRefreshingBlock:^{
            [self requestForData];
            [self webViewReload];
        }];
        //自定义上拉
        ProductRefreshFooter *footer = [ProductRefreshFooter footerWithRefreshingBlock:^{
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.bigSrollV.contentOffset = CGPointMake(0, ScreenHeight - ButtomBarH);
            } completion:^(BOOL finished) {
                //结束加载
                [self.tableView.footer endRefreshing];
            }];
            
        }];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.bigSrollV addSubview:self.tableView];
        self.tableView.footer = footer;
        //web
        if (!_webView) {
            _webView  = [[UIWebView alloc] initWithFrame:CGRectMake(0, ScreenHeight - ButtomBarH, ScreenWidth, ScreenHeight -NavBarH - ButtomBarH)];
            _webView.backgroundColor = [UIColor colorWithHexString:@"#f2f1f1"];
            _webView.scalesPageToFit = YES;
            _webView.delegate = self;
            ProductDetailSecondPartHeader *header  = [ProductDetailSecondPartHeader headerWithRefreshingBlock:^{
                [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                    self.bigSrollV.contentOffset = CGPointMake(0, 0);
                } completion:^(BOOL finished) {
                    //结束加载
                    [self.webView.scrollView.header endRefreshing];
                }];
            }];
            [self.bigSrollV addSubview:_webView];
            self.webView.scrollView.header = header;
            [self webViewReload];
            
            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-50, _webView.frame.size.height-50, 40, 40)];
            [btn setImage:[UIImage imageNamed:@"1012app首页-切图@3x_35"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
            [_webView addSubview:btn];
        }
        //底部的bar
        if (!self.buttomBar) {
            BuyAndShoppingCarButtomBar * bar = [[BuyAndShoppingCarButtomBar alloc] initWithFrame:CGRectMake(0, ScreenHeight- 64 - ButtomBarH, ScreenWidth, ButtomBarH)];
            bar.delagate = self;
            [self.view addSubview:bar];
            self.buttomBar = bar;
        }
    }
}
//滑动到最上方
-(void)btnClick
{
    [self.bigSrollV setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.tableView.header endRefreshing];
    [self.webView.scrollView.header endRefreshing];
}
#pragma mark -- 初始化购买页面
-(void)initBuyView
{
    UIWindow * window = [[[UIApplication sharedApplication]delegate]window];
    if (!self.buyView) {
        self.buyView = [BuyButtomView creatBuyButtomView];
        self.buyView.product = self.product;
        [window addSubview:self.buyView];
        __block GoodsDetailViewController * blockSelf = self;
        // 调用block
        self.buyView.buyViewBlock = ^(UIButton * selectedBtn)
        {
//            NSLog(@"%ld",selectedBtn.tag);
            switch (selectedBtn.tag) {
                case 111://弹框消失
                {
                    if (blockSelf.buyView) {
                        [blockSelf.buyView removeFromSuperview];
                    }
                }
                    break;
                case 222://改变商品的数量
                {
                    
                }
                    break;
                case 333://确认购买，跳提交订单页面
                {
                    
                        [blockSelf.buyView removeFromSuperview];
                        [blockSelf buyNow:blockSelf.buyView.productCount];
                }
                    break;
                    
                default:
                    break;
            }
        };
    }else
    {
        [window addSubview:self.buyView];
    }
}
//立即支付  点击之后调转到订单页面
-(void)buyNow:(NSString *)count
{
//    NSLog(@"----%@",count);
//    return;
//    NSString * urlStr = [NSString stringWithFormat:@"%@/API/Cart/GetUserIntegral",TEST_URL];
    NSString * memberID = [UserManager getMyObjectForKey:userIDKey];
    NSString * token = [UserManager getMyObjectForKey:accessTokenKey];
    
    //    NSLog(@"%@,%@",memberID,token);
    
//    NSMutableDictionary * signDict = [NSMutableDictionary dictionary];
//    
//    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
//    
//    NSString * sign = nil;
    if (!memberID || !token || self.isOnline==NO) {
        
        [self goToLoginView];
        return;
        
    }else if (memberID && token && self.isOnline == YES)
    {
        GoodsInfomodel *goods = [[GoodsInfomodel alloc] init];
        goods.skuId = _product.DefaultSkuId;
        goods.Id = _product.Id;
        goods.imgUrl = _product.ImageUrl;
        goods.name = _product.ProductName;
        goods.price = _product.SalePrice;
        goods.count = count;
        goods.shopId = _product.ShopName;
        goods.shopName = _product.ShopName;
        goods.tradeType = _product.TradeType;
        NSString*taxRate =_product.TaxRate;
        goods.taxRate = [taxRate stringByReplacingOccurrencesOfString:@"%" withString:@""];
        
        FirmOrderTableViewController * commitOrder_VC = [[FirmOrderTableViewController alloc] initWithGoods:goods];
        [self.navigationController pushViewController:commitOrder_VC animated:YES];


    }
}


#pragma mark -- BuyAndShoppingCarButtomBarDelegate
-(void)BuyAndShoppingCarButtomBarDelegate:(BuyAndShoppingCarButtomBar *)BuyAndShoppingCarButtomBar withBtn:(UIButton *)selectedBtn
{
    switch (selectedBtn.tag) {
        case 100://购买
        {
            //弹出购买界面
            [self initBuyView];

            
        }
            break;
        case 200://加入购物车
        {
            //1:接口
            //避免用户点击购物车按钮
            self.buttomBar.addShoppingCart.enabled = NO;
            [self testUserIsOnline2];


            
        }
            break;
        case 300://购物车
        {
            //跳转到购物车界面
//            self.buttomBar.shoppingCart.enabled = YES;

             [self.navigationController.tabBarController setSelectedIndex:3];
            
             [self.navigationController popToRootViewControllerAnimated:NO];

        }
            break;
            
        default:
            break;
    }
}
#pragma mark -- 跳到登录页面
-(void)goToLoginView
{
    [ProgressHud addProgressHudWithView:self.view andWithTitle:@"请登录" withTime:1 withType:MBProgressHUDModeText];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{

                       //未登录，跳到登录页面
                       LoginViewController * vc = [[LoginViewController alloc] init];
                       [self.navigationController pushViewController:vc animated:YES];
                       
                   });

}
-(NSMutableArray *)cartArray
{
    if (!_cartArray) {
        _cartArray = [[NSMutableArray alloc] init];
    }
    return _cartArray;
}
-(void)setProductId:(NSString *)productId
{
    _productId = productId;
    
}
#pragma mark -- 检测用户是否登录2
-(void)testUserIsOnline2
{
      //检测用户是否在线
      if (self.isOnline) {
          
          [self addProductToShoppingCart];
          
          return;
          
          
        }else
        {
            self.buttomBar.addShoppingCart.enabled = YES;
            [self goToLoginView];
        }
  
}
//获取购物车信息
-(void)getCartInfo:(void(^)(NSMutableArray *cartArray))cartArrayBlock
{
//    __block NSInteger countOfGoods = 0;
    NSString * urlStr =[NSString stringWithFormat:@"%@%@",TEST_URL,GetCartInfoURL];
    NSString * token =[UserManager getMyObjectForKey:accessTokenKey];
    NSString * MemberID = [UserManager getMyObjectForKey:userIDKey];
    NSMutableArray * array= [NSMutableArray array];
    if (token && MemberID)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:token forKey:@"token"];
        [dic setValue:MemberID forKey:@"MemberID"];
        NSString * sign = [HttpTool returnForSign:dic];
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setValue:token forKey:@"token"];
        [dict setValue:MemberID forKey:@"MemberID"];
        dict[@"sign"] = sign;
        [HttpTool post:urlStr params:dict success:^(id json) {
            NSArray *dataArray = json[@"data"];
            if (dataArray != nil && dataArray.count > 0)
            {
                for (NSArray * array2 in dataArray)
                {
                    for ( NSDictionary *dic in array2)
                    {
                        GoodsInfomodel *goods = [[GoodsInfomodel alloc] initWithDict:dic];
                        [array addObject:goods];
                       
                    }
                    NSLog(@"artArray==%@",array);
                    if (cartArrayBlock) {
                        cartArrayBlock(array);
                    }
                }
            }else
            {
                if (cartArrayBlock) {
                    cartArrayBlock(array);
                }
            }
          
        } failure:^(NSError *error) {
        }];
    }
}
#pragma mark ---------------------------------------------------------------------------------
#pragma mark -- tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (section ==0) {
        return 5;
    }else
    {
        return 0;

    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * staticCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!staticCell) {
        staticCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.section == 0) {
       
        if (indexPath.row == 0) {
             ProductDetailFirstRowCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellRowOne"];
                if (!cell) {
                    cell = [[ProductDetailFirstRowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellRowOne"];
                    
                }
                if (self.product) {
                    cell.productModel = self.product;
                    cell.delegate = self;
                }
              cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
                
        }else if (indexPath.row ==1){
            
            //显示税率的cell
            ProductDetailTaxCell * cell = [ProductDetailTaxCell ProductDetailTaxCellForTableView:tableView forIndexPath:indexPath];
            if (self.product) {
                cell.model = self.product;
            }
            return cell;
            
        }else if (indexPath.row ==2)
        {
            
            ProductDetailSecondRowCell * cellTwo = [tableView dequeueReusableCellWithIdentifier:@"cellRowTwo"];
                if (!cellTwo) {
                    cellTwo = [[ProductDetailSecondRowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellRwoTwo"];
                    
                }
                if (self.product) {
                    cellTwo.productModel = self.product;
 
                }
                cellTwo.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cellTwo;

            }else if (indexPath.row ==3)
            {
                if (self.product.IsLimitProduct.boolValue==YES) {//是否限卖
                    ProductDetailThreeRowAnotherCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellRowThree2" forIndexPath:indexPath];
                    cell.model = self.product;
                    time = self.product.OverTime.intValue;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                    
                }else
                {
                    ProductDetailThreeRowCell * cellThree = [tableView dequeueReusableCellWithIdentifier:@"cellRowThree"];
                    if (!cellThree) {
                            cellThree = [[ProductDetailThreeRowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellRowThree"];
                    
                    }
                    if (self.product) {
                            cellThree.productModel = self.product;
                            cellThree.delegate = self;
                    
                    }
                            cellThree.selectionStyle = UITableViewCellSelectionStyleNone;
                            return cellThree;
                }

            }else
            {
                ProductDetailFourRowCell * cell = [[ProductDetailFourRowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellRowFour"];
                if (self.product) {
                    
                    cell.model = self.product;
                    cell.delegate = self;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
                return cell;
            }
        return nil;
        
    }else
    {
        return nil;
        

       
    }
     return nil;

}
-(void)GoodscellTimerRun
{
    NSIndexPath * index = [NSIndexPath indexPathForItem:3 inSection:0];
    ProductDetailThreeRowAnotherCell * cell = (ProductDetailThreeRowAnotherCell *)[self.tableView cellForRowAtIndexPath:index];
       time--;
//    NSLog(@"time=%d",time);
    if (time <=0) {
        [timer invalidate];
         timer = nil;
    }else
    {
        int day = (int)(time/3600/24);
        int hour = (int)(time-day*3600*24)/3600;
        int minute = (int)(time-day*3600*24 - hour*3600)/60;
        int second = time -day*3600*24- hour*3600 - minute*60;
//        NSLog(@"cellTimerRun =_%d,_%d,_%d,_%d",day,hour,minute,second);
        NSString *strTime = [NSString stringWithFormat:@"距结束:%d天%d时%d分",day,hour,minute];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //设置界面的按钮显示 根据自己需求设置
            cell.date.text = strTime;
        });
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        if (indexPath.row == 0) {
            return VirtualProductFirstCell_H * ScreenWidth;

        }else if (indexPath.row == 1)
        {
            if (self.product.IsVirtualProduct.intValue == 1) {
                
                return 0;
            }else
            {
                return 27;
            }

        }else if (indexPath.row == 2)
        {
            CGSize size = [self.product.ProductName sizeWithFont:[UIFont systemFontOfSize:18] maxW:ScreenWidth -30];
            return size.height+10;
            
        }else if (indexPath.row ==3)
        {
            if (self.product.IsLimitProduct.boolValue==YES) {
                return 80;
            }else
            {
               return 75;
            }
        }else if (indexPath.row ==4)
        {
            return 250;
        }
        
    }else
    {
        return 0;
    
    }
    return 0;
    
}
#pragma mark -- ProductDetailFirstRowCellDelegate
-(void)ProductDetailFirstRowCellBtnClick:(ProductDetailFirstRowCell*)cell withBtn:(UIButton *)btn
{
    if (btn.tag ==111) {
        [self.tableView setContentOffset:CGPointMake(0, 740) animated:YES];
    }
}

#pragma mark -- ProductDetailFirstRowCellDelegate
-(void)ProductDetailFourRowCellBtnClick:(ProductDetailFourRowCell*)cell withBtn:(UIButton *)btn
{
//    NSLog(@"%ld",btn.tag);
    if (btn.tag == 222) {
        //查看详情
        // 查看更多评价
        CommentDataViewController * commentVC = [[CommentDataViewController alloc] init];
        commentVC.productId = self.product.Id;
        //商品的平均评分传过去
        commentVC.ReviewMark = self.product.ReviewMark;
        [self.navigationController pushViewController:commentVC animated:YES];
        
    }else
    {
        //B区保障
        AllPeakController * vc = [[AllPeakController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}
#pragma mark -- 收藏
-(void)addClick:(UIButton *)addBtn
{
//    addBtn.selected = !addBtn.selected;
    //首先检查用户是否登录，登录之后才能收藏
//    [self testUserIsOnline];
    
    if (self.isOnline) {
        //在线
        if (self.product.IsFavorite.boolValue) {
            //删除收藏
            [self cutFavoriteProduct];
            
        }else
        {
            //判断登录不过期，才能收藏
            [self addFavoriteProduct];
        }
    }else
    {
        //去登录
        [self goToLoginView];
    }
}
#pragma mark -- 收藏请求
-(void)addFavoriteProduct
{
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/api/home/AddFavoriteProduct",TEST_URL];
    NSString * memberID = [UserManager getMyObjectForKey:userIDKey];
    NSString * token = [UserManager getMyObjectForKey:accessTokenKey];
//    NSLog(@"%@,%@,%@",self.product.Id,memberID,token);
    if (memberID && token) {
        
        NSDictionary * signDict = @{@"pid":self.product.Id,@"MemberID":memberID,@"token":token};
        NSString * signStr = [HttpTool returnForSign:signDict];
    
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:signDict];
        dic[@"sign"] = signStr;
    
        [HttpTool post:urlStr params:dic success:^(id json) {
       
//        NSLog(@"%@",json[@"message"]);
         if (!json[@"error"]) {
            //收藏成功，改变图片
            self.product.IsFavorite = @"1";
            [self.addBtn setImage:[UIImage imageNamed:@"B区详情页04-收藏红爱心"] forState:UIControlStateNormal];
           
            [ProgressHud showHUDWithView:self.view withTitle:@"收藏成功" withTime:1.5];
         }else
         {
               self.product.IsFavorite = @"0";
             
         }
        
           } failure:^(NSError *error) {
               self.product.IsFavorite = @"0";
               
        }];
       
    }

}
#pragma mark -- 删除收藏
-(void)cutFavoriteProduct
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/api/home/CancelFavoriteProduct",TEST_URL];
    NSString * memberID = [UserManager getMyObjectForKey:userIDKey];
    NSString * token = [UserManager getMyObjectForKey:accessTokenKey];
    
    NSDictionary * signDict = @{@"pid":self.product.Id,@"MemberID":memberID,@"token":token};
    NSString * signStr = [HttpTool returnForSign:signDict];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:signDict];
    dic[@"sign"] = signStr;
    [HttpTool post:urlStr params:dic success:^(id json) {
        
//        NSLog(@"%@",json[@"message"]);
        if (!json[@"error"]) {
            //删除成功
            self.product.IsFavorite = @"0";
            [self.addBtn setImage:[UIImage imageNamed:@"B区详情页04-收藏"] forState:UIControlStateNormal];
            [ProgressHud showHUDWithView:self.view withTitle:@"取消收藏" withTime:1.5];
        }else
        {
              self.product.IsFavorite = @"1";
            //删除失败
        }
        
    } failure:^(NSError *error) {
          self.product.IsFavorite = @"1";
    }];

}
#pragma mark -- 添加商品到购物车接口
-(void)addProductToShoppingCart
{
  
    NSString * urlStr = [NSString stringWithFormat:@"%@/API/Cart/AddToCart",TEST_URL];
    NSString * memberID = [UserManager getMyObjectForKey:userIDKey];
    NSString * token = [UserManager getMyObjectForKey:accessTokenKey];
    
    //    NSLog(@"%@,%@,%@",self.product.Id,memberID,token);
    if (!self.product.Id || !memberID || !token || !self.product.DefaultSkuId) {
        return;
    }
    NSDictionary * signDict = @{@"pid":self.product.Id,@"MemberID":memberID,@"token":token,@"skuid":self.product.DefaultSkuId,@"count":@"1"};
    NSString * signStr = [HttpTool returnForSign:signDict];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"pid"] = self.product.Id;
    dic[@"skuid"] = self.product.DefaultSkuId;
    dic[@"count"] = @"1";
    dic[@"MemberID"] = memberID;
    dic[@"token"] = token;
    dic[@"sign"] = signStr;
    
    NSLog(@"%@",self.product.Id);
    __block GoodsDetailViewController * blockSelf = self;
    [HttpTool post:urlStr params:dic success:^(id json) {
        
        //        NSLog(@"%@",json[@"message"]);
        NSString * str = json[@"message"];
        NSString * resultCode = json[@"resultCode"];
        if (resultCode.intValue == 0) {
            [self startAddAnimation];
//            [ProgressHud addProgressHudWithView:self.view andWithTitle:@"添加成功" withTime:1 withType:MBProgressHUDModeText];
            //改变tabbaar的文字
//            [blockSelf requestForShoppingCart];
            
        }else
        {
            str = [str substringWithRange:NSMakeRange(3, str.length-3)];
            [ProgressHud addProgressHudWithView:self.view andWithTitle:str withTime:1 withType:MBProgressHUDModeText];

        }
    } failure:^(NSError *error) {
        self.buttomBar.shoppingCart.enabled = YES;
        
    }];
}
#pragma mark -- 开始动画
-(void)startAddAnimation
{
    self.animationImage.hidden = NO;
    _animationImage.center = CGPointMake(ScreenWidth/2.0, ScreenHeight/3.0);
    _animationImage.alpha = 0 ;
    [UIView animateWithDuration:1 animations:^{
//        _animationImage .size = CGSizeMake(70, 70);
//        _animationImage.center =CGPointMake(ScreenWidth/2.0, ScreenHeight/3.0);
        _animationImage.frame = CGRectMake(ScreenWidth/2.0-35, ScreenHeight/3.0-35, 70, 70);
        _animationImage.alpha = 1 ;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6 animations:^{
            _animationImage .frame =  CGRectMake(AnimationX*ScreenWidth, ScreenHeight-95, 10, 10);
        } completion:^(BOOL finished) {
            _animationImage.alpha = 0 ;
            self.buttomBar.addShoppingCart.enabled = YES;
            [self requestForShoppingCart];
        }];
        
    }];


}
#pragma mark -- 获取购物车物品数量
-(void)requestForShoppingCart
{
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/API/Cart/GetCartInfo",TEST_URL];
    NSString * memberID = [UserManager getMyObjectForKey:userIDKey];
    NSString * token = [UserManager getMyObjectForKey:accessTokenKey];
    
    //    NSLog(@"%@,%@",memberID,token);
    
    NSMutableDictionary * signDict = [NSMutableDictionary dictionary];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    NSString * sign = nil;
    if (!memberID || !token) {
        
        return;
        
    }else if (memberID && token)
    {
        [signDict setObject:memberID forKey:@"MemberID"];
        [signDict setObject:token forKey:@"token"];
        
        sign  = [HttpTool returnForSign:signDict];
        dict[@"MemberID"] = memberID;
        dict[@"token"] = token;
        dict[@"sign"] = sign;
        __block GoodsDetailViewController * blockSelf = self;
        [HttpTool post:urlStr params:dict success:^(id json) {
            //                NSLog(@"%@",json);
            if (!json[@"error"]) {
                NSInteger arrarCount = 0;
                NSMutableArray * dataArray = [[NSMutableArray alloc] initWithCapacity:0];
                dataArray = json[@"data"];
                if (!dataArray) {
                    return ;
                }
                if(![dataArray isKindOfClass:[NSNull class]])
                {
                    if (dataArray.count==0) {
                        blockSelf.buttomBar.shoppingCart.number.text = @"0";
                        return ;
                    }
                    
                    for (int i=0; i<dataArray.count; i++) {
                        NSArray * subArray = dataArray[i];
                        arrarCount = arrarCount +subArray.count;
                    }
                    //                    NSLog(@"arrarCount=%ld",arrarCount);
                    //改变购物车按钮的数量
                    NSString * number = [NSString stringWithFormat:@"%ld",arrarCount];
                    blockSelf.buttomBar.shoppingCart.number.text = number;
                    //TODO:－－－－－改变tabbar的数量
                    UITabBarItem * item = [self.tabBarController.tabBar.items objectAtIndex:3];
                    [item setBadgeValue:number];
                    
                }
                //
                
            }
        } failure:^(NSError *error) {
            
        }];
    }
}
//-(ShareView *)shareView
//{
//    if (!_shareView) {
//        _shareView = [ShareView creatShareView];
//        _shareView.delegate = self;
//    }
//    return _shareView;
//}
#pragma mark -- 分享
-(void)shareClick
{
    NSString * urlStr = nil;
    if (self.product.IsLimitProduct.intValue==1) {
       
         urlStr = [NSString stringWithFormat:@"http://www.bqu.com/LimitTimeBuy/Detail/%@",self.product.Id];
    }else
    {
         urlStr = [NSString stringWithFormat:@"http://www.bqu.com/Product/Detail/%@",self.product.Id];
    }
    NSURL * url = [NSURL URLWithString:@"http://43.247.89.26:10017/Images/share_ilogo.png"];
    NSData * data = [NSData dataWithContentsOfURL:url];
    //1、创建分享参数
    UIImage * image = [UIImage imageWithData:data];
    //    NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (image) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"购物还能领红包？接受我的邀请注册B区领取现金并购物，我们一起愉快购物开心拿红包！海淘？有B区就够了!"
                                         images:image
                                            url:[NSURL URLWithString:urlStr]
                                          title:@"注册送现金 B区新手福利-来自世界的商店"
                                           type:SSDKContentTypeAuto];
       
        //2、分享（可以弹出我们的分享菜单和编辑界面）
     SSUIShareActionSheetController * sheet = [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:@[ @(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformSubTypeQZone)]
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                       
                   }];
        //跳过编辑页面
        [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
        
        
    }

}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if ([timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
   
}
@end
