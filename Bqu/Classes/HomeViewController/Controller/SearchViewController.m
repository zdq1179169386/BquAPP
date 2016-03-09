//
//  SearchViewController.m
//  Bqu
//
//  Created by WONG on 15/10/20.
//  Copyright (c) 2015年 yb. All rights reserved.
//  搜索页面 ，有历史搜索和 最近搜索

#import "SearchViewController.h"
#import "HomeViewController.h"
#import "HotWordModel.h"
#import "SearchController.h"
#import "HotHistorySearchCollectionView.h"
#import "KeyWordSizeModul.h"
#import "GoodsDetailViewController.h"

@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong)NSMutableArray * HotWordAry;
//历史搜索记录
@property (nonatomic,strong)NSMutableArray * historySearchArray;

@property (nonatomic, strong)UISearchBar *searchBar;

@property(nonatomic,strong)SearchController *searchListCVC ;

//@property (nonatomic ,strong)HotWordView *HotWordView;
@property (nonatomic,strong)HotHistorySearchCollectionView * SearchCollectView;

@property (nonatomic,strong)NSString *hotWord;
@end

static NSString * const searchID = @"Search";
static NSString * const HotWordID = @"HotWord";

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置nav 颜色
    UIColor * color = [UIColor colorWithHexString:@"ededed"];
    self.navigationController.navigationBar.barTintColor = color;
    
    self.navigationController.navigationBar.translucent = YES;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    _HotWordAry = [NSMutableArray arrayWithCapacity:10];
    [self getHotWordRequest];
    
    _historySearchArray = [KeyWordSizeModul getHistorySearch];
    
    
    __block SearchViewController * blockSearch = self;
//    _searchListCVC = [[SearchController alloc] init];
//    [_searchListCVC setblock:^(NSString *Id) {
//        [blockSearch dealToDetail:Id];
//    }];
    
    self.SearchCollectView = [[HotHistorySearchCollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.SearchCollectView.historySearchArray = self.historySearchArray;
    self.SearchCollectView.hotSearchArray = self.HotWordAry;
    [self.view addSubview:self.SearchCollectView];
    
    
    
    [self.SearchCollectView setKeyBlock:^(NSString *key) {
        [blockSearch dealBlock:key];
    }];
    
    [self createBackBar];
    [self createSearchBar];
    // 搜索条
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(50, 40, ScreenWidth * 2 / 3 , 40)];
    searchBar.center = CGPointMake(ScreenWidth / 2, 42);
    searchBar.tintColor = [UIColor colorWithHexString:@"ededed"];
    [searchBar setPlaceholder:@"请输入要搜索的关键字"];
    
    [self.navigationController.view addSubview:searchBar];
    self.searchBar = searchBar;
    self.searchBar.delegate = self;
    //[self.searchBar becomeFirstResponder];
    //self.searchBar.
    for (UIView *view in searchBar.subviews) {
        // for before iOS7.0
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            break;
        }
        // for later iOS7.0(include)
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    
    
    if (self.conditions) {
        [self addList:self.keyWord];
    }
    if(self.keyWord)
    {
        [self addList:self.keyWord];
    }
    
    //添加触摸手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

//点击空白区域m],收起键盘，
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.searchBar resignFirstResponder];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.searchBar.hidden = NO;
    if (self.conditions) {
         [self.searchBar endEditing:YES];
    }
    else
    {
        [self.searchBar becomeFirstResponder];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.searchBar.hidden = YES;
    [self.searchBar endEditing:YES];
}

-(void)dealloc
{
    self.searchBar.delegate = nil;
}


-(void)dealToDetail:(NSString*)Id
{
    GoodsDetailViewController *goodVC = [[GoodsDetailViewController alloc]init];
    goodVC.productId = Id;
    goodVC.hidesBottomBarWhenPushed = YES;
    //[self.searchListCVC.view removeFromSuperview];
    [self.navigationController pushViewController:goodVC animated:YES];
}

//获取热门词
- (void)getHotWordRequest
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/api/home/HotKeyWord",TEST_URL];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:@"HotKeyWord" forKey:@"action"];
    
    NSString * realSign = [HttpTool returnForSign:dict];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"action"] = @"HotKeyWord";
    dic[@"sign"] = realSign;
    
    [HttpTool post:urlStr params:dic success:^(id json) {
        [self getDataSussessWithObject:json];
    }
           failure:^(NSError *error) {
           }];
}

//处理热门词
- (void)getDataSussessWithObject:(id)json {
    NSString * str = json[@"data"];
    NSArray * temp = [str componentsSeparatedByString:@","];
    for (NSString * word in temp)
    {
        KeyWordSizeModul * key = [[KeyWordSizeModul alloc] init];
        key.keyWord = word;
        [self.HotWordAry addObject:key];
    }
    [self.SearchCollectView reloadData];
}

//将点击得到的热门词
-(void) dealBlock:(NSString*)key
{
    //_searchListCVC.keyword = key;
    //将搜索栏 设置为热门词
    self.searchBar.text = key;
    [self addList:key];
}
// 设置返回按键
- (void)createBackBar
{
    //    [self hideLoadingView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(backBarClicked1) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 20, 21);
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}
- (void)backBarClicked1
{
    [self.navigationController popViewControllerAnimated:YES];
    //    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)createSearchBar {
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(search:)];
    right.tintColor = [UIColor colorWithHexString:@"333333"];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)search:(UIBarButtonItem *)sender {
    //去除空格
    self.searchBar.text = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (self.searchBar.text.length > 0) {
        [self addList:self.searchBar.text];
        [self.searchBar resignFirstResponder];
    }else
    {
        [ProgressHud addProgressHudWithView:self.view andWithTitle:@"请输入关键字" withTime:1 withType:MBProgressHUDModeText];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self search:nil];
}


//将key 添加到searchListCVC 页面
-(void)addList:(NSString*)key
{
    NSString *trueKey = [key stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.searchBar.text = trueKey;
    __block SearchViewController * blockSearch = self;
    _searchListCVC = [[SearchController alloc] init];
    [_searchListCVC setblock:^(NSString *Id) {
        [blockSearch dealToDetail:Id];
    }];
    
    [_searchListCVC setNODataBlock:^{
        [blockSearch.searchListCVC.view removeFromSuperview];
    }];
    _searchListCVC.view.frame = self.view.bounds;
    
     [self.view insertSubview:self.searchListCVC.view atIndex:self.view.subviews.count];
    self.searchListCVC.view.hidden = NO;
    self.searchListCVC.keyword = trueKey;
    self.searchListCVC.conditions =self.conditions? self.conditions : nil;
    
    [self.searchListCVC reload];
    [self.searchBar resignFirstResponder];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0 && !self.conditions) {
        self.conditions = nil;
        [self.searchListCVC.view removeFromSuperview];
    }
}


@end
