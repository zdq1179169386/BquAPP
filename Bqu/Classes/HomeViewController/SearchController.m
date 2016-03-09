//
//  SearchController.m
//  Bqu
//
//  Created by WONG on 15/10/26.
//  Copyright (c) 2015年 yb. All rights reserved.
//  搜索到结果 显示的界面，可以进行排序

#import "SearchController.h"
#define UITabBarHeight 55
#import "SearchCell.h"
#import "GoodsDetailViewController.h"
#import "SearchModel.h"
#import "KeyWordSizeModul.h"
#import "SequenceToolView.h"
#import "SiftView.h"
#import "SiftTypeModel.h"
#import "SiftConditionDetailShowView.h"
#import "SiftCOnditionDetailShowViewModel.h"
#import "SiftTypeModel.h"


#define Pagesize @"10"

@interface SearchController ()
{
    NSInteger _page;
    NSInteger _maxPage;
    NSString* _orderkey;//排序字段(0,默认商品编号;1,上架时间;2,销售数;3,销售价格;4,评论数;
    NSString* _asc;//排序(1,升序;0,降序)
    
    BOOL siftViewAppear;
    BOOL noCondition;
    
}
@property (nonatomic,strong)NSMutableArray *dataArray;

//筛选工具条
@property (nonatomic,strong)SequenceToolView * sequenceToolView;

@property (nonatomic,strong)UILabel *titleLable;

@property (nonatomic,strong)SearchBlock block;

@property (nonatomic,strong)SearchNODataBlock noDatablock;

@property (nonatomic,strong)SiftView * siftView;
/**灰色的背景*/
@property (nonatomic,strong)UIButton* hideView;
// 显示多个具体条件View
@property (nonatomic,strong)SiftConditionDetailShowView * conditionDetailShowView;
// 给显示多个具体条件 数组
@property (nonatomic,strong)NSMutableArray * conditionArray;
//未搜到商品时候提示语
@property(nonatomic,strong)UILabel *promptLabel;

@property(nonatomic,assign)BOOL isFind;
@end

@implementation SearchController

//懒加载

-(UILabel*)promptLabel
{
    if (!_promptLabel) {
        _promptLabel = [[UILabel  alloc] initWithFrame:CGRectMake(10, 40, ScreenWidth-20, 40)];
        _promptLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _promptLabel.textAlignment = NSTextAlignmentLeft;
        _promptLabel.font = [UIFont systemFontOfSize:11];
        _promptLabel.numberOfLines = 2;
        _promptLabel.backgroundColor = [UIColor whiteColor];
        
        NSUInteger index = [self.view.subviews indexOfObject:_sequenceToolView];
        [self.view insertSubview:_promptLabel atIndex:index-1];
    }
    return _promptLabel;
}

-(SiftConditionDetailShowView*)conditionDetailShowView
{
    if (!_conditionDetailShowView ) {
        _conditionDetailShowView = [[SiftConditionDetailShowView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, 40)];
        __block SearchController* SearchControllerBlock = self;
        [_conditionDetailShowView setConditionDetailShowViewBlock:^(NSInteger tag) {
            [SearchControllerBlock deleteConditions:tag];
        }];
        NSUInteger index = [self.view.subviews indexOfObject:_sequenceToolView];
        [self.view insertSubview:_conditionDetailShowView atIndex:index-1];
    }
    return _conditionDetailShowView;
}

-(NSMutableArray*)conditionArray
{
    if (!_conditionArray) {
        _conditionArray = [[NSMutableArray alloc] init];
    }
    return _conditionArray;
}

//删除 选择的条件 执行
-(void)deleteConditions:(NSUInteger)tag
{
    // 将选择的条件根据 删除的内容
    [self clearCondition:tag];
    if (tag>5)
    {
        [_conditionArray removeAllObjects];
        self.conditionDetailShowView.hidden = YES;
        [self moveupCollectionView];
    }
    else
    {
        [_conditionArray removeObjectAtIndex:tag];
        [_conditionDetailShowView setConditionArray:_conditionArray];
        if (self.conditionArray.count == 0) {
            self.conditionDetailShowView.hidden = YES;
            [self moveupCollectionView];
        }
    }
    [self.collectionView.header beginRefreshing];
    
}
// 将选择的条件根据 删除的内容
-(void)clearCondition:(NSUInteger)tag
{
    if (tag>5) {
        [self.conditions clearAllData];
    }
    else
    {
        SiftCOnditionDetailShowViewModel *model =_conditionArray[tag];
        NSString * type = model.type;
        [self.conditions cleardata:type];
    }
}

//懒加载
-(SiftView*)siftView
{
    if (_siftView == nil) {
        _siftView = [[SiftView alloc] initWithFrame:CGRectMake(0, -ScreenHeight*3/5-64, ScreenWidth, ScreenHeight*3/5)];
        __block SearchController *searchControllerBlock = self;
        [_siftView setBlock:^(SiftTypeModel *model) {
            [searchControllerBlock  siftViewChangBidShopId:model];
        }];
    }
    return _siftView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //判断进来时候 是不是没有条件
    noCondition = NO;
    if (self.conditions == nil) {
        noCondition = YES;
    }
    if (IOS7_OR_LATER)
    {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    siftViewAppear = NO;
    
    [self initCollectionView];
    [self.view addSubview:self.siftView];
    _sequenceToolView = [[SequenceToolView alloc] init];
    _sequenceToolView.frame = CGRectMake(0, 0, ScreenWidth, 40);
    __block SearchController * blockSearch = self;
    [_sequenceToolView setBlock:^(NSInteger tag) {
        [blockSearch dealSift:tag];
    }];
    _orderkey = @"0";
    _asc = @"1";
    [self.view addSubview:_sequenceToolView];
    
    [self createBackBar];
    
    [self.collectionView.header beginRefreshing];
    //[self requestForData];
}

//如果条件数组 有内容。则显示 条件， 设置相应的frame
-(void)setConditionDetailShow
{
    if (_conditionArray.count > 0)
    {
        self.conditionDetailShowView.hidden = NO;
        [self.conditionDetailShowView setConditionArray:_conditionArray];
        if (self.conditions) {
            self.promptLabel.hidden = YES;
        }
        [self moveDownCollectionView];
    }
}

//collectView往下移
-(void)moveDownCollectionView
{
    self.collectionView.frame = CGRectMake(0, 40+40, ScreenWidth, ScreenHeight - UITabBarHeight-45-40);
}
//collectView往上移
-(void)moveupCollectionView
{
    self.collectionView.frame = CGRectMake(0, 40, ScreenWidth, ScreenHeight - UITabBarHeight-45);
}


//设置查询条件
//-(void)setSearchCondition:(NSDictionary*)searchConditionDictionary
//{
//    if (_conditions == nil) {
//        _conditions = [[BquSearchConditionModel alloc] init];
//    }
//    [self.conditions setValueFromDic:searchConditionDictionary];
//    self.keyword =searchConditionDictionary[@"keyword"]?searchConditionDictionary[@"keyword"]:self.keyword;
//    //保存相应的关键字
//}


//判断有几个属性被选中了， 选中的就放进数组中
-(void)setCondition
{
    //判断条件属性中有几个 条件
    [self.conditionArray removeAllObjects];
    if (self.conditions)
    {
        if (![self.conditions.cid isEqualToString:@"0"]) {
            SiftCOnditionDetailShowViewModel *model = [[SiftCOnditionDetailShowViewModel alloc] init];
            model.name = _conditions.cidName;
            model.type = @"cid";
            [self.conditionArray addObject:model];
        }
        if (![_conditions.bid isEqualToString:@"0"]) {
            SiftCOnditionDetailShowViewModel *model = [[SiftCOnditionDetailShowViewModel alloc] init];
            model.name = _conditions.bidName;
            model.type = @"bid";
            [self.conditionArray addObject:model];
        }
        if (![_conditions.shopid isEqualToString:@"0"]) {
            SiftCOnditionDetailShowViewModel *model = [[SiftCOnditionDetailShowViewModel alloc] init];
            model.name = _conditions.shopidName;
            model.type = @"shopid";
            [self.conditionArray addObject:model];
        }
        if (![_conditions.countryid isEqualToString:@"0"]) {
            SiftCOnditionDetailShowViewModel *model = [[SiftCOnditionDetailShowViewModel alloc] init];
            model.name = _conditions.countryidName;
            model.type = @"countryid";
            [self.conditionArray addObject:model];
        }
    }
}
-(void)reload
{
    [self.collectionView.header beginRefreshing];
}
#pragma mark -- 请求
-(void)requestForData
{
    if(!_conditions)
    {
        _conditions = [[BquSearchConditionModel alloc] init];
    }
    _page = 1;
    NSString * urlStr = [NSString stringWithFormat:@"%@/api/home/Product/SearchNew",TEST_URL];
    NSString * keyword = self.keyword? self.keyword :@"";
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"cid"] = self.conditions.cid;
    dic[@"bid"] = self.conditions.bid;
    dic[@"shopid"] = self.conditions.shopid;
    dic[@"countryid"] = self.conditions.countryid;
    dic[@"page"] = @"1";
    dic[@"pagesize"] = Pagesize;
    dic[@"keyword"] = keyword;
    dic[@"orderkey"] = _orderkey;
    dic[@"asc"] = _asc;
    
    NSString * realSign = [HttpTool returnForSign:dic];
    dic[@"sign"] = realSign;
    
    
    [HttpTool post:urlStr params:dic success:^(id json) {
        NSString *result = json[@"resultCode"];
        if ( !result.boolValue)
        {
            NSDictionary *dic =json[@"data"];
            NSArray *ary = dic[@"Products"];;
            
            //NSLog(@"数据：：%@",json);
            
            NSString * totalCount = json[@"totalCount"];
            float x = totalCount.floatValue/10.0;
            _maxPage =  ceilf(x);
            
            self.isFind = YES;
            if (!ary || ary.count== 0)
            {
                //清除相关的限制条件
                [_conditionArray removeAllObjects];
                // 隐藏 限制显示内容
                self.conditionDetailShowView.hidden = YES;
                //将关键字设置为其他
                //self.keyword = @"";
                //
                [self.conditions clearAllData];
                if(noCondition)
                {
                    self.keyword = nil;
                }
                self.conditions = nil;
                
                self.promptLabel.text = [NSString stringWithFormat:@"没搜索到相关产品，B区为您推荐热门相关产品"];
                self.isFind = NO;
                
                [self requestForDataAgain];
                
                
            }
            else
            {
                //保存记录
                self.view.hidden = NO;
                if (_keyword.length>0)
                {
                    [KeyWordSizeModul saveHistorySearch:_keyword];
                }
                self.dataArray = [NSMutableArray arrayWithCapacity:10];
                for (int i = 0; i< ary.count; i++)
                {
                    NSMutableDictionary *dict = ary[i];
                    SearchModel *model = [SearchModel createSearchModelWithDic:dict];
                    [self.dataArray addObject:model];
                }
                
                NSArray * brandsArray = [[NSArray alloc]init];
                NSMutableArray *Brands = [[NSMutableArray alloc]init];
                brandsArray = dic[@"Brands"];
                for (int i = 0 ; i< brandsArray.count; i++) {
                    NSDictionary *dict = brandsArray[i];
                    SiftTypeModel *model =[[SiftTypeModel alloc] init];
                    model.brandId =[NSString stringWithFormat:@"%@",dict[@"BrandId"]] ;
                    model.name =dict[@"BrandName"];
                    [Brands addObject:model];
                }
                //            NSMutableArray * array = [[NSMutableArray alloc] init];
                //            [array addObject:Brands];
                if (self.siftView.Classifys.count == 3) {
                    [self.siftView.Classifys removeObjectAtIndex:2];
                    [self.siftView.Classifys addObject:Brands];
                }
                else
                {
                    [self.siftView.Classifys addObject:Brands];
                }
                
                //设置相关的筛选条件
                [self setCondition];
                //如果条件数组 有内容。则显示 条件， 设置相应的frame
                [self setConditionDetailShow];
                //刷新表
                
                
                [self.collectionView reloadData];
                [self.collectionView.header endRefreshing];
            }
        }
        else [self.collectionView.header endRefreshing];
        
    } failure:^(NSError *error) {
        NSLog(@"错误%@",error);
        [self.collectionView.header endRefreshing];
    }];
}


#pragma mark -- 请求
-(void)requestForDataAgain
{
    if(!_conditions)
    {
        _conditions = [[BquSearchConditionModel alloc] init];
    }
    _page = 1;
    NSString * urlStr = [NSString stringWithFormat:@"%@/api/home/Product/SearchNew",TEST_URL];
    NSString * keyword = self.keyword? self.keyword :@"";
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"cid"] = self.conditions.cid;
    dic[@"bid"] = self.conditions.bid;
    dic[@"shopid"] = self.conditions.shopid;
    dic[@"countryid"] = self.conditions.countryid;
    dic[@"page"] = @"1";
    dic[@"pagesize"] = Pagesize;
    dic[@"keyword"] = keyword;
    dic[@"orderkey"] = _orderkey;
    dic[@"asc"] = _asc;
    
    NSString * realSign = [HttpTool returnForSign:dic];
    dic[@"sign"] = realSign;
    
    
    [HttpTool post:urlStr params:dic success:^(id json) {
        NSString *result = json[@"resultCode"];
        if ( !result.boolValue)
        {
            
            NSDictionary *dic =json[@"data"];
            NSArray *ary = dic[@"Products"];;
            
            //NSLog(@"数据：：%@",json);
            
            NSString * totalCount = json[@"totalCount"];
            float x = totalCount.floatValue/10.0;
            _maxPage =  ceilf(x);
            if (!ary || ary.count== 0)
            {}
            else
            {
                //保存记录
                self.view.hidden = NO;
                if (_keyword.length>0)
                {
                    [KeyWordSizeModul saveHistorySearch:_keyword];
                }
                self.dataArray = [NSMutableArray arrayWithCapacity:10];
                for (int i = 0; i< ary.count; i++)
                {
                    NSMutableDictionary *dict = ary[i];
                    SearchModel *model = [SearchModel createSearchModelWithDic:dict];
                    [self.dataArray addObject:model];
                }
                
                NSArray * brandsArray = [[NSArray alloc]init];
                NSMutableArray *Brands = [[NSMutableArray alloc]init];
                brandsArray = dic[@"Brands"];
                for (int i = 0 ; i< brandsArray.count; i++)
                {
                    NSDictionary *dict = brandsArray[i];
                    SiftTypeModel *model =[[SiftTypeModel alloc] init];
                    model.brandId =[NSString stringWithFormat:@"%@",dict[@"BrandId"]] ;
                    model.name =dict[@"BrandName"];
                    [Brands addObject:model];
                }
                
                if (self.siftView.Classifys.count == 3)
                {
                    [self.siftView.Classifys removeObjectAtIndex:2];
                    [self.siftView.Classifys addObject:Brands];
                }
                else
                {
                    [self.siftView.Classifys addObject:Brands];
                }
                
                //设置相关的筛选条件
                [self setCondition];
                //如果条件数组 有内容。则显示 条件， 设置相应的frame
                [self setConditionDetailShow];
                //刷新表
                
                
                [self.collectionView reloadData];
                [self.collectionView.header endRefreshing];
            }
        }
        else [self.collectionView.header endRefreshing];
        
    } failure:^(NSError *error) {
        NSLog(@"错误%@",error);
        [self.collectionView.header endRefreshing];
    }];
    
}


//重写是否找到商品
-(void)setIsFind:(BOOL)isFind
{
    _isFind = isFind;
    if (_isFind == NO) {
        
        [self moveDownCollectionView];
        self.promptLabel.hidden = NO;
    }
    else
    {
        if (self.conditionArray.count==0) {
            [self moveupCollectionView];
        }
        self.promptLabel.hidden = YES;
    }
}

//处理 筛选过来的 店铺 或者 品牌 或者国家
-(void)siftViewChangBidShopId:(SiftTypeModel*)model
{
    if(model.brandId)
    {
        self.conditions.bid =model.brandId;
        self.conditions.bidName = model.name;
    }
    if(model.shopId)
    {
        self.conditions.shopid =model.shopId;
        self.conditions.shopidName = model.name;
    }
    // 重新赋值
    if (model.countryId) {
        self.conditions.countryid = model.countryId;
        self.conditions.countryidName = model.name;
    }
    [self setCondition];
    // 加载条件数组
    [self setConditionDetailShow];
    
    [self hideSiftView:_orderkey];
    self.hideView.hidden = YES;
    [self.collectionView.header beginRefreshing];
    //处理 条件数组内容
    
}


-(void)dealSift:(NSInteger)tag
{
    //排序字段(0,默认商品编号;1,上架时间;2,销售数;3,销售价格;4,评论数;
    // NSString* _asc;//排序(1,升序;0,降序)
    NSString * last = _orderkey;
    switch (tag) {
        case 1:
        {
            _orderkey = @"0";
            _asc = @"1";
            if (![last isEqualToString:_orderkey]) {
            [self.collectionView.header beginRefreshing];
            }
            [self hideSiftView:last];
            break;
        }
        case 2:
        {
            
            _orderkey = @"3";
            _asc = [NSString stringWithFormat:@"%d",!_asc.boolValue];
            [_sequenceToolView setImage:_asc.boolValue];
            [self.collectionView.header beginRefreshing];
            [self hideSiftView:last];
            break;
        }
        case 3:
        {
            
            _orderkey = @"2";
            _asc = @"1";
            if (![last isEqualToString:_orderkey]) {
                [self.collectionView.header beginRefreshing];
            }
            [self hideSiftView:last];
            break;
        }
        case 4:
        {
            self.isFind = YES;
            if (siftViewAppear == NO) {
                [self.siftView animateWithDuration:0.5 rect:CGRectMake(0, 40, ScreenWidth, ScreenHeight*3/5)];
                siftViewAppear = YES;
                self.hideView.hidden = NO;
                [self.siftView reloadTableView];
            }
            else
            {
                [self hideSiftView:last];
                self.hideView.hidden = YES;
            }
            break;
        }
        default:
            break;
    }
}
-(UIButton*)hideView
{
    if (_hideView == nil) {
        _hideView = [[UIButton alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight)];
        _hideView.backgroundColor = [UIColor colorWithRed:169/255 green:169/255 blue:169/255 alpha:1];
        
        [_hideView addTarget:self action:@selector(hideSelf) forControlEvents:UIControlEventTouchUpInside];
        _hideView.alpha = 0.5;
        
        NSInteger index=  [self.view.subviews indexOfObject:self.collectionView];
        [self.view insertSubview:_hideView atIndex:index+1];
    }
    return _hideView;
}
//点击遮盖 收起
-(void)hideSelf
{
    [self dealSift:4];
}


-(void)hideSiftView:(NSString*)last
{
    if (![last isEqualToString:@"4"]) {
        [self.siftView animateWithDuration:0.5 rect:CGRectMake(0, -ScreenHeight*3/5-50, ScreenWidth, ScreenHeight*3/5)];
        siftViewAppear = NO;
        self.hideView.hidden = YES;
    }
}

-(void)initCollectionView
{
    
    if (!self.collectionView)
    {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight - UITabBarHeight-45) collectionViewLayout:layout];
        
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellWithReuseIdentifier:@"searchID"];
        
        self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        _titleLable.text = self.keyword;
        _titleLable.font = [UIFont systemFontOfSize:20];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = _titleLable;
        
        NSInteger index=  [self.view.subviews indexOfObject:self.siftView];
        
        [self.view insertSubview:self.collectionView atIndex:index];
        
        
        //        下拉刷新,加上会影响区头视图
        self.collectionView.header.backgroundColor = [UIColor colorWithHexString:@"#f2f1f1"];
        self.collectionView.header = [DIYHeader headerWithRefreshingBlock:^{
            [self requestForData];
        }];
        //上拉加载
        self.collectionView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self requestForMoreData];
        }];
    }
    
    
}
#pragma mark  ------ 上拉加载
-(void)requestForMoreData
{
    if(!self.conditions)
    {
        self.conditions = [[BquSearchConditionModel alloc] init];
    }
    _page = _page + 1;
    if (_page>_maxPage) {
        [self.collectionView.footer endRefreshing];
        [self.collectionView.footer noticeNoMoreData];
        return;
    }
    NSString * pageStr = [NSString stringWithFormat:@"%ld",_page];
    NSString * urlStr = [NSString stringWithFormat:@"%@/api/home/Product/SearchNew",TEST_URL];
    NSString * keyword = self.keyword? self.keyword :@"";
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"cid"] = self.conditions.cid;
    dic[@"bid"] = self.conditions.bid;
    dic[@"shopid"] = self.conditions.shopid;
    dic[@"countryid"] = self.conditions.countryid;
    dic[@"page"] = pageStr;
    dic[@"pagesize"] = Pagesize;
    dic[@"keyword"] = keyword;
    dic[@"orderkey"] = _orderkey;
    dic[@"asc"] = _asc;
    
    NSString * realSign = [HttpTool returnForSign:dic];
    dic[@"sign"] = realSign;
    
    [HttpTool post:urlStr params:dic success:^(id json) {
        
        NSString *result = json[@"resultCode"];
        if ( !result.boolValue)
        {
            NSDictionary *dic =json[@"data"];
            NSArray *ary = [[NSArray alloc]init];
            ary = dic[@"Products"];
            //NSLog(@"%@",ary);
            if (ary.count == 0)
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"对不起" message:@"未找到该种物品" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else
            {
                for (int i = 0; i< ary.count; i++) {
                    NSMutableDictionary *dict = ary[i];
                    SearchModel *model = [SearchModel createSearchModelWithDic:dict];
                    [self.dataArray addObject:model];
                }
                NSArray * brandsArray = [[NSArray alloc]init];
                NSMutableArray *Brands = [[NSMutableArray alloc]init];
                brandsArray = dic[@"Brands"];
                for (int i = 0 ; i< brandsArray.count; i++) {
                    NSDictionary *dict = brandsArray[i];
                    SiftTypeModel *model =[[SiftTypeModel alloc] init];
                    model.brandId =[NSString stringWithFormat:@"%@",dict[@"BrandId"]];
                    model.name =dict[@"BrandName"];
                    [Brands addObject:model];
                }
                if (self.siftView.Classifys.count == 3) {
                    [self.siftView.Classifys removeObjectAtIndex:2];
                    [self.siftView.Classifys addObject:Brands];
                }
                else
                {
                    [self.siftView.Classifys addObject:Brands];
                }            //刷新表
                [self.collectionView reloadData];
                [self.collectionView.footer endRefreshing];
            }
        }
        else [self.collectionView.footer endRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.collectionView.footer endRefreshing];
    }];
    
}
-(void)createBackBar {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 20, 21);
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}
//直接左键返回首页
- (void)goBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma UICollectionViewDelegate -- CollectionView代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
    
}
// 分区数根据分区数组返回
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCell * cell = [SearchCell searchCellWithCollectionView:collectionView indexPath:indexPath];
    SearchModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.searchModel = model;
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

#pragma mark -- collection的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchModel * model = [self.dataArray objectAtIndex:indexPath.row];
    if (_block) {
        _block(model.Identifier);
    }
    
    //GoodsDetailViewController *goodVC = [[GoodsDetailViewController alloc]init];
    //goodVC.productId = model.Identifier;
    //    goodVC.hidesBottomBarWhenPushed = YES;
    //[self.navigationController pushViewController:goodVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setblock:(SearchBlock)block
{
    _block = block;
}
-(void)setNODataBlock:(SearchNODataBlock)block
{
    _noDatablock = block;
}
@end
