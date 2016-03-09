//
//  SearchListCollectionVC.m
//  Bqu
//
//  Created by WONG on 15/10/22.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "SearchListCollectionVC.h"
#import "searchListCell.h"
#import "TopicDetailModel.h"
#import "TopIcModuleModel.h"
#import "GoodsDetailViewController.h"
#define UITabBarHeight 55
@interface SearchListCollectionVC ()
@property (nonatomic,strong)UIImageView *image;
@property (nonatomic,strong)NSString *tit;
@property (nonatomic,strong)UILabel *titleLable;
@property (nonatomic,strong)NSMutableArray *TopicModelAry;//接受模块个数的数组
@property (nonatomic,strong)NSMutableArray *ProductsAry;
@property (nonatomic,strong)NSMutableArray  *singleProductAry;

@property (nonatomic,strong)NSMutableArray *array1;
@property (nonatomic,strong)NSArray *array;

@property (nonatomic,strong)TopIcModuleModel *TopicModel;
@end

@implementation SearchListCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    [self createBackBar];
    [self initCollectionView];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor   = [UIColor colorWithHexString:@"eeeeee"];
}
-(void)createBackBar {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(backBarClicked) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 20, 21);
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

#pragma mark -- 初始化CollectionView
-(void)initCollectionView
{
    
    if (!self.collectionView)
    {
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        double pw = ScreenWidth/375;
        double h = 120*pw;
        
        self.image = [[UIImageView alloc]initWithFrame:CGRectMake(0, -h,ScreenWidth, h)];
        _image.backgroundColor = [UIColor lightGrayColor];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - UITabBarHeight) collectionViewLayout:layout];
        self.collectionView.contentInset = UIEdgeInsetsMake(h, 0, 0, 0);
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerNib:[UINib nibWithNibName:@"searchListCell" bundle:nil] forCellWithReuseIdentifier:@"cellID"];
        
        self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        _titleLable.text = @"品牌专场";
        _titleLable.font = [UIFont systemFontOfSize:18];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.textColor = [UIColor blackColor];
        self.navigationItem.titleView = _titleLable;
        
        [self.view addSubview:self.collectionView];
        [self.collectionView addSubview:self.image];
        
        //下拉刷新,加上会影响区头视图
//        self.collectionView.header.backgroundColor = [UIColor colorWithHexString:@"#f2f1f1"];
//        self.collectionView.header = [DIYHeader headerWithRefreshingBlock:^{
//            [self requestData];
//        }];
    }
}
- (void)requestData {
    NSString * urlStr = [NSString stringWithFormat:@"%@//api/home/topic/detail",TEST_URL];
    
    NSDictionary *dict = @{@"tid":self.TopicId};
    NSString *realSign = [HttpTool returnForSign:dict];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    dic[@"tid"] = self.TopicId;
    dic[@"sign"] = realSign;
    
    [HttpTool post:urlStr params:dic success:^(id json) {
                NSString *resultCode = json[@"resultCode"];
        //请求成功
        if (!resultCode.intValue)
        {
            //先把无网络状态View 去除
            [self removeNewView];
            
            self.TopicModelAry = [NSMutableArray arrayWithCapacity:0];
            // 创建一个数组 记录每个分区数组的元素个数
            self.array1 = [NSMutableArray array];
            self.array = [NSArray array];
            self.ProductsAry = [NSMutableArray arrayWithCapacity:0];
            self.singleProductAry = [NSMutableArray arrayWithCapacity:0];
            //NSLog(@"++++++%@",json);
            NSString *imageUrl = json[@"data"][@"TopIcImage"];
            
            
            [self.image sd_setImageWithURL:[NSURL URLWithString:imageUrl]];// 头部图片，定死，不需要修改
            
            
            NSArray *ary = json[@"data"][@"TopIcModule"];// 返回分区个数
            
            for (int i = 0; i < ary.count; i++) {
                NSDictionary *topicModelDic = ary[i];
                TopIcModuleModel *model = [TopIcModuleModel createModelWithDic:topicModelDic];
                self.TopicModel = model;
                
                //            NSLog(@"%@",model.ModuleCount);
                [self.TopicModelAry addObject:model];
            }
            
            [self.collectionView reloadData];
        }
        else
        {
            NSLog(@"%@",json[@"message"]);
            [self addAlertView];
        }
        
    } failure:^(NSError *error) {
        [self addNetView];
    }];
    
}
//添加netView
-(void)addNetView
{
    if (self.TopicModelAry.count == 0) {
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
    [self requestData];
}


//直接左键返回首页
- (void)backBarClicked {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark
#pragma mark UICollectionViewDelegate -- CollectionView代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    TopIcModuleModel *topIcModuleModel = self.TopicModelAry[section];
    self.singleProductAry = topIcModuleModel.ModuleProduct;
    return topIcModuleModel.ModuleProduct.count;
}


// 分区数根据分区数组返回
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.TopicModelAry == nil)
    {
        return 0;
    }
    else
    return self.TopicModelAry.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TopIcModuleModel *model = [self.TopicModelAry objectAtIndex:indexPath.section];
    searchListCell * cell = [searchListCell searchListCellWithCollectionView:collectionView indexPath:indexPath];
    [cell setTopIcModuleModel:model index:indexPath.row];
    return cell;
}


#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake((ScreenWidth - 30)/2.0, 260);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 20, 10);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TopIcModuleModel *model = [self.TopicModelAry objectAtIndex:indexPath.section];
    NSArray * ary = [[NSArray alloc]init];
    ary = model.ModuleProduct;
    NSDictionary *dict = [ary objectAtIndex:indexPath.row];
    
    self.ProductId = dict[@"ProductId"];// 商品的ID
    self.Moods = dict[@"Moods"];// 人气数（收藏数）
    self.Comment = dict[@"Comment"];// 评论数
    
    GoodsDetailViewController *goodVC = [[GoodsDetailViewController alloc]init];
    goodVC.productId = self.ProductId;
//    goodVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodVC animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
