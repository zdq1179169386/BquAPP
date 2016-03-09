//
//  ClassifyViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/9.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "ClassifyViewController.h"
#import "NSString+MD5.h"
#import "ProductCategoryData.h"
#import "BrandAndKindController.h"
#import "ClassifyViewHeader.h"
#import "SubClassifyViewController.h"
#import "SubBrandViewController.h"
#import "SearchViewController.h"
#import "SubClassifyTwoViewController.h"
#define topView_H 38/667.0
@interface ClassifyViewController ()<UISearchBarDelegate,ClassifyViewHeaderDelegate,NetWorkViewDelegate,UIScrollViewDelegate>
{
    
    //第二部分的起始值
    CGFloat  secondY ;
    NSArray * _allArray;
    
}
@property(nonatomic,strong)UILabel * line;

/**分类控制器*/
@property(nonatomic,strong)SubClassifyTwoViewController * subClassify_VC;

/**品牌控制器*/
@property(nonatomic,strong)SubBrandViewController * subBrand_VC;

@property(nonatomic,strong)UISearchBar * searchBar;

/**网络连接失败*/
@property (nonatomic,strong)NetWorkView * netWorkView;

/**scrollview*/
@property (nonatomic,strong)UIScrollView * scrollview;

/**<#property#>*/
@property (nonatomic,strong)ClassifyViewHeader * headView;

/**<#property#>*/
@property (nonatomic,strong)UIButton * searchBtn;

@end

@implementation ClassifyViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //搜索框
    [self initSearchBar];
   
}
#pragma mark -- 搜索框
-(void)initSearchBar
{
    [self.navigationController.navigationBar setBarTintColor:RGB_A(248, 248, 248)];
    if (!self.searchBar) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationController.navigationBar.hidden = NO;
        UISearchBar * searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth -20, 44)];
        searchBar.delegate = self;
        searchBar.placeholder = @"请输入商品名称";
        //searchBar UI样式修改
        UITextField *searchField = [searchBar valueForKey:@"_searchField"];
        searchField.textColor = [UIColor whiteColor];
        searchField.backgroundColor = RGB_A(234, 234, 234);
//        searchField.layer.masksToBounds = YES;
//        searchField.layer.cornerRadius = 4;
//        [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
//        [searchBar setImage:[UIImage imageNamed:@"searchBarIcon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        self.navigationItem.titleView = searchBar;
        searchBar.userInteractionEnabled = NO;
        self.searchBar = searchBar;
        [searchBar endEditing:NO];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pageViewClick:)];
        [self.navigationController.navigationBar addGestureRecognizer:tapGesture];

    }
}
-(void)pageViewClick:(UITapGestureRecognizer *)tap
{
    SearchViewController * vc = [[SearchViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    self.navigationItem.rightBarButtonItem = nil;
//    self.searchBar.text = nil;
    [self.searchBar endEditing:YES];
    
}
-(void)dealloc{
    self.searchBar = nil;
    self.searchBar.delegate = nil;
    self.subBrand_VC = nil;
    self.subClassify_VC = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (IOS7_OR_LATER)
    {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    [self initUI];
    [self requestForData];
}
#pragma mark -- 获取数据
-(void)requestForData
{
    [ProgressHud addProgressHudWithView:self.view andWithTitle:@"加载中"];
    NSString * urlStr = [NSString stringWithFormat:@"%@/api/home/product/category/list",TEST_URL];
    //创建，安字段创建
    NSDictionary * dict = @{@"action":@"ProductCategoryList"};
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic = [HttpTool getDicToRequest:dict];
    
    [HttpTool post:urlStr params:dic success:^(id json) {
         NSString * resultCode = json[@"resultCode"];
        
        if (resultCode.intValue == 0) {
//            NSLog(@"data=%@",json[@"data"]);
            NSArray * array = [ProductCategoryData objectArrayWithKeyValuesArray:json[@"data"]];
            self.subClassify_VC.dataArray= array;
            self.subBrand_VC.allArray = array;
            _allArray = array;
            
        }else
        {
            UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器数据出错" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [view show];
        }
        [ProgressHud hideProgressHudWithView:self.view];

       // [self hideNetWorkingView];
//        self.netWorkView.hidden = YES;
        [self.netWorkView removeFromSuperview];

        
        for (UIView * view in self.view.subviews) {
            if (view == self.netView) {
                [self.netView removeFromSuperview];
                break;
            }
        }


    } failure:^(NSError *error) {
        [ProgressHud hideProgressHudWithView:self.view];
       
        if (error.code == NetWorkingErrorCode) {
            [self.view addSubview:self.netView];
        }
    }];
    
}
#pragma mark -- 初始化UI
-(void)initUI
{
    _allArray = [[NSArray alloc] init];

    ClassifyViewHeader * header = [ClassifyViewHeader creatHeader];
    header.delegate = self;
    [self.view addSubview:header];
    self.headView = header;
    UIScrollView * scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ClassifyViewHeaderH, ScreenWidth, ScreenHeight)];
    scrollview.delegate = self;
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.pagingEnabled = YES;
    scrollview.userInteractionEnabled = YES;
    scrollview.contentSize = CGSizeMake(ScreenWidth * 2.0, ScreenHeight);
    [self.view addSubview:scrollview];
    self.scrollview = scrollview;
    [self initSecondPart];
    
}
#pragma mark -- NetWorkViewDelegate
-(void)NetWorkViewDelegate:(NetWorkView*)view withBtn:(UIButton *)btn
{
    [self requestForData];
}
#pragma mark -- ClassifyViewHeaderDelegate
-(void)ClassifyViewHeaderDelegate:(ClassifyViewHeader*)view with:(UIButton *)btn
{
    NSInteger index = btn.tag - 100;
    [self.scrollview setContentOffset:CGPointMake(ScreenWidth * index , 0) animated:YES];
   
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double page = self.scrollview.contentOffset.x/ScreenWidth;
    int index = (int)(page + 0.5);
    [self.headView setupBtn:index];
//    UIButton * btn = [self.headView.buttons objectAtIndex:index];
}
-(UIButton *)searchBtn
{
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(searchBarSearchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}
#pragma mark -- searchBar delegate
//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
//{
//    SearchViewController * vc = [[SearchViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:NO];
//    return YES;
//}
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//    [searchBar endEditing:YES];
//    SearchViewController * vc = [[SearchViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:NO];
////    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:self.searchBtn];
////    self.navigationItem.rightBarButtonItem = item;
//}
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    if (self.searchBar.text.length>0) {
//        BrandAndKindController * vc = [[BrandAndKindController alloc] init];
//        vc.hidesBottomBarWhenPushed = YES;
//        vc.keyword = self.searchBar.text;
//        vc.searchWordType =2;
//        vc.navBarTitle = self.searchBar.text;
//        [self.searchBar endEditing:YES];
//        [self.navigationController pushViewController:vc animated:YES];
//
//    }else
//    {
//        [ProgressHud addProgressHudWithView:self.view andWithTitle:@"请输入关键字" withTime:1.5 withType:MBProgressHUDModeText];
//    }
//}
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
//{
//    //结束编辑
//    self.navigationItem.rightBarButtonItem = nil;
//
//}
#pragma mark -- 界面
-(void)initSecondPart
{
    SubClassifyTwoViewController * subClassify_VC = [[SubClassifyTwoViewController alloc] init];
    [self addChildViewController:subClassify_VC];
    
    [self.scrollview addSubview:subClassify_VC.view];
    subClassify_VC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - ClassifyViewHeaderH);
    self.subClassify_VC = subClassify_VC;
    
    SubBrandViewController * subBrand_VC = [[SubBrandViewController alloc] init];
    [self addChildViewController:subBrand_VC];
    subBrand_VC.view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight - ClassifyViewHeaderH);
     self.subBrand_VC = subBrand_VC;
    [self.scrollview addSubview:subBrand_VC.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)reload_data
{
    NSLog(@"ClassifyViewController");
}
@end
