//
//  BrandAndKindController.m
//  Bqu
//
//  Created by yb on 15/10/14.
//  Copyright (c) 2015年 yb. All rights reserved.
//这页面是公用的，

#import "BrandAndKindController.h"
#import "GoodsDetailViewController.h"
#import "SearchDataForProductModel.h"
#import "BrandAndKindControllerCell.h"
#import "SearchController.h"
#import "BquSearchConditionModel.h"
@interface BrandAndKindController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSInteger _page;
    NSInteger _pageSize;
    NSString *  _totalCount;
    NSInteger _maxPage;
}

@property (nonatomic,strong)UICollectionView * collectionView;


@property(nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation BrandAndKindController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (IOS7_OR_LATER)
    {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    
    [self initNavBar];
    SearchController * vc = [[SearchController alloc] init];
    BquSearchConditionModel *model = [[BquSearchConditionModel alloc] init];
    NSLog(@"%@,%@,%@",self.cid,self.bid,self.navBarTitle);
    model.cid = self.cid;
    model.cidName = self.navBarTitle;
    model.bid = self.bid;
    model.bidName = self.navBarTitle;
    vc.conditions = model;
    [vc setblock:^(NSString *Id) {
        GoodsDetailViewController * vc = [[GoodsDetailViewController alloc] init];
        vc.productId = Id;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    
//    [self initCollectionView];
//    [self requestForData];
}

#pragma mark -- 获取数据
-(void)requestForData
{
//    NSLog(@"cid or bid = %@ %@",self.cid ,self.bid);
    NSString * urlStr = [NSString stringWithFormat:@"%@/api/home/Product/Search",TEST_URL];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];

    if (self.searchWordType == 0) {
        // cid
        //创建，安字段创建
        NSDictionary * dict = @{@"cid":self.cid,@"bid":@"0",@"page":@"1",@"pagesize":@"10",@"orderkey":@"0",@"asc":@"1",@"shopid":@"0"};
        dic = [HttpTool getDicToRequest:dict];
        dic[@"keyword"] = @"";
        

    }else if (self.searchWordType == 1)
    {
        // bid
        NSDictionary * dict = @{@"cid":@"0",@"bid":self.bid,@"page":@"1",@"pagesize":@"10",@"orderkey":@"0",@"asc":@"1",@"shopid":@"0"};
        dic = [HttpTool getDicToRequest:dict];
        dic[@"keyword"] = @"";
        
  
        
    }else if (self.searchWordType == 2)
    {
        // keyword
        NSDictionary * dict = @{@"cid":@"0",@"bid":@"0",@"keyword":self.keyword,@"page":@"1",@"pagesize":@"10",@"orderkey":@"0",@"asc":@"1",@"shopid":@"0"};
        dic = [HttpTool getDicToRequest:dict];
        
    }
   
//    NSLog(@"dic%@",dic);
    __block BrandAndKindController * blockSelf = self;
    [HttpTool post:urlStr params:dic success:^(id json) {
        
//        NSLog(@"分类%@",json);
        NSString * success = json[@"resultCode"];
        if (success.intValue == 0) {
            self.dataArray = [NSMutableArray array];
            self.dataArray = [SearchDataForProductModel objectArrayWithKeyValuesArray:json[@"data"]];
            //计算最大分页数
          _maxPage = [self workMaxPage:json[@"totalCount"]];
           
        }
        if (self.dataArray.count==0 || self.dataArray == nil) {
            [self initBgView];
        }
          //刷新表
        [blockSelf.collectionView reloadData];
        [blockSelf.collectionView.header endRefreshing];
        
        for (UIView * view in self.view.subviews) {
            if (view == self.netView) {
                [self.netView removeFromSuperview];
                break;
            }
        }
        
    } failure:^(NSError *error) {
        
        [blockSelf.collectionView.header endRefreshing];
        if (error.code == NetWorkingErrorCode) {
            
            [self.view addSubview:self.netView];
        }

    }];
    
}
#pragma mark -- NetWorkViewDelegate
-(void)NetWorkViewDelegate:(NetWorkView*)view withBtn:(UIButton *)btn
{
    [self requestForData];
}
#pragma mark -- 获取最大页数
-(NSInteger)workMaxPage:(NSString*)totalCount
{
    float x = totalCount.floatValue/10.0;
    NSInteger maxPage =  ceilf(x);
    return maxPage;
}
#pragma mark --
-(void)initBgView
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f1f1"];
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    image.image = [UIImage imageNamed:@"empty"];
    [self.view addSubview:image];
    image.center = CGPointMake(ScreenWidth/2.0,(ScreenHeight-64)/2.0);
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    lable.text = @"暂无结果";
    [self.view addSubview:lable];
    CGFloat labelY = CGRectGetMaxY(image.frame);
    //  lable.font = [UIFont systemFontOfSize:12];
    lable.textColor = [UIColor lightGrayColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.center = CGPointMake(ScreenWidth/2.0, labelY+25);
    
}
#pragma mark --
-(void)initNavBar
{
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.text = self.navBarTitle;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:18];
    self.navigationItem.titleView = titleLabel;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"f9f9f9"]];
    UIButton * backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];

}
-(void)back
{
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark -- 初始化CollectionView
-(void)initCollectionView
{
    _page = 1;
    _pageSize = 10;
    if (!self.collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];

        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerClass:[BrandAndKindControllerCell class] forCellWithReuseIdentifier:@"cellID"];
        //下拉刷新
        self.collectionView.header = [DIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        //上拉加载
        self.collectionView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [self.view addSubview:self.collectionView];
    }
    
}
#pragma mark --- 下拉刷新
-(void)loadNewData
{
    [self requestForData];
}
#pragma mark ---- 上拉加载
-(void)loadMoreData
{
    _page = _page + 1;
    if (_page>_maxPage) {
        [self.collectionView.footer endRefreshing];
        [self.collectionView.footer noticeNoMoreData];
        return;
    }
    NSString * pageStr = [NSString stringWithFormat:@"%ld",_page];
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/api/home/Product/Search",TEST_URL];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    if (self.searchWordType == 0) {
        // cid
        //创建，安字段创建
        NSDictionary * dict = @{@"cid":self.cid,@"bid":@"0",@"page":pageStr,@"pagesize":@"10",@"orderkey":@"0",@"asc":@"1",@"shopid":@"0"};
        dic = [HttpTool getDicToRequest:dict];
        dic[@"keyword"] = @"";

    }else if (self.searchWordType == 1)
    {
        // bid
        NSDictionary * dict = @{@"cid":@"0",@"bid":self.bid,@"page":pageStr,@"pagesize":@"10",@"orderkey":@"0",@"asc":@"1",@"shopid":@"0"};
        dic = [HttpTool getDicToRequest:dict];
        dic[@"keyword"] = @"";

        
    }else if (self.searchWordType == 2)
    {
        // keyword
        NSDictionary * dict = @{@"cid":@"0",@"bid":@"0",@"keyword":self.keyword,@"page":pageStr,@"pagesize":@"10",@"orderkey":@"0",@"asc":@"1",@"shopid":@"0"};
        dic = [HttpTool getDicToRequest:dict];
        
    }
    
    __block BrandAndKindController * blockSelf = self;
    [HttpTool post:urlStr params:dic success:^(id json) {
        
        NSLog(@"页数＝%@,%@",pageStr,json[@"message"]);
        
        if (!json[@"error"]) {
            
            NSArray * array = [SearchDataForProductModel objectArrayWithKeyValuesArray:json[@"data"]];
            //加到数组的最后面
            if (array.count>0) {
                [self.dataArray addObjectsFromArray:array];

            }
        }
        //刷新表
        [blockSelf.collectionView reloadData];
        [blockSelf.collectionView.footer endRefreshing];
        
    } failure:^(NSError *error) {
        
        [blockSelf.collectionView.footer endRefreshing];

        
    }];

    
}
#pragma mark --collectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * Identifier = @"cellID";
    BrandAndKindControllerCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
    SearchDataForProductModel * model = [self.dataArray objectAtIndex:indexPath.row];
    [cell.productImage sd_setImageWithURL:[NSURL URLWithString:model.ImgUrl] placeholderImage:[UIImage imageNamed:@"品牌"]];
    cell.productName.text = model.ProductName;
    cell.price.text = [NSString stringWithFormat:@"¥ %@",model.MinSalePrice];
    cell.referencePrice.text = [NSString stringWithFormat:@"市场价 ¥ %@",model.MarketPrice];
    return cell;
}
#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake((ScreenWidth - 30)/2.0, 260);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDetailViewController * detail_VC = [[GoodsDetailViewController alloc] init];
    SearchDataForProductModel * model = [self.dataArray objectAtIndex:indexPath.row];
    //把商品ID传过去，获取商品详情
    detail_VC.productId = model.Id;
    [self.navigationController pushViewController:detail_VC animated:NO];
}

-(void)dealloc
{
    self.collectionView = nil;
    self.dataArray = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
