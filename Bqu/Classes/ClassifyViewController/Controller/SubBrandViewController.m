//
//  SubBrandViewController.m
//  Bqu
//
//  Created by yb on 15/10/10.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "SubBrandViewController.h"
#import "BrandCollectionReusableView.h"
#import "AllBrandCollectionReusableView.h"
#import "BrandAndKindController.h"
#import "CateBrands.h"
#import "ProductCategoryData.h"
#import "AllBrandCell.h"
#import "AllBrandViewController.h"
#import "ClassifyViewHeader.h"
#import "SearchViewController.h"
@interface SubBrandViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

{
    NSMutableArray * _sectionHeaderArray;
    NSMutableArray * _singleSectionArray;
}
@property (nonatomic ,strong)UICollectionView * collectionView;
@end

@implementation SubBrandViewController
-(void)dealloc
{
    self.collectionView = nil;
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
    [self initArray];
    //获取数据
//    [self requestData];
    [self initCollectionView];
    
}
-(void)initArray
{
    _sectionHeaderArray = [NSMutableArray array];
    _singleSectionArray = [NSMutableArray array];
}
#pragma mark -- 获取数据
-(void)setAllArray:(NSArray *)allArray
{
    _allArray = allArray;
    for (int i =0; i<_allArray.count; i++) {
        ProductCategoryData * data =_allArray[i];
        //                NSLog(@"%@",data.CateBrands);
        [_sectionHeaderArray addObject:data.Name];
        //   NSLog(@"%@",data.SubCategories);
        //                if (data.CateBrands.count !=0) {
        //
        //                }
        [_singleSectionArray addObject:data.CateBrands];
        
    }
    //            NSLog(@"%@",_singleSectionArray);
//    [self.collectionView.header endRefreshing];
    //刷新表
    [self.collectionView reloadData];

    
}
#pragma mark -- 获取数据
-(void)requestData
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/api/home/product/category/list",TEST_URL];
    NSDictionary * dict = @{@"action":@"ProductCategoryList"};
    NSString * signStr = [HttpTool returnForSign:dict];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"action"] = @"ProductCategoryList";
    dic[@"sign"] = signStr;
    
//  __block SubBrandViewController * blockSelf = self;
    [_sectionHeaderArray removeAllObjects];
    [_singleSectionArray removeAllObjects];
    [HttpTool post:urlStr params:dic success:^(id json) {
        
        
        if (!json[@"error"]) {
            
            NSArray * array = [ProductCategoryData objectArrayWithKeyValuesArray:json[@"data"]];
           
//            NSLog(@"%ld",array.count);
            for (int i =0; i<array.count; i++) {
                ProductCategoryData * data = array[i];
//                NSLog(@"%@",data.CateBrands);
                [_sectionHeaderArray addObject:data.Name];
                //   NSLog(@"%@",data.SubCategories);
//                if (data.CateBrands.count !=0) {
//                    
//                }
                [_singleSectionArray addObject:data.CateBrands];
                
            }
//            NSLog(@"%@",_singleSectionArray);
            [self.collectionView.header endRefreshing];
            //刷新表
            [self.collectionView reloadData];
        }
    } failure:^(NSError *error) {
        
        [self.collectionView.header endRefreshing];

    }];
    
}

-(void)initCollectionView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.headerReferenceSize = CGSizeMake(ScreenWidth, 40);
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,ScreenHeight-ClassifyViewHeaderH-64-55) collectionViewLayout:layout];
    [self.collectionView registerClass:[AllBrandCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.collectionView registerClass:[AllBrandCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionView registerClass:[BrandCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header2"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical = YES;
//    //下拉刷新
//    self.collectionView.header = [DIYHeader headerWithRefreshingBlock:^{
//        [self requestData];
//    }];
    [self.view addSubview:self.collectionView];
}
#pragma mark -- collectionView delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _sectionHeaderArray.count + 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else
    {
      NSMutableArray * array = [_singleSectionArray objectAtIndex:section - 1];
        return array.count;
     }
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"UICollectionViewCell";
    AllBrandCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    if (indexPath.section==0) {
        
    }else
    {
        if (_singleSectionArray.count>0) {
            NSMutableArray * array = [_singleSectionArray objectAtIndex:indexPath.section - 1];
            CateBrands * brand = [array objectAtIndex:indexPath.row];
            [cell.Image sd_setImageWithURL:[NSURL URLWithString:brand.Logo] placeholderImage:[UIImage imageNamed:@"分类占位图"]];
        }

    }
 
    return cell;
}
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
           AllBrandCollectionReusableView * reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];

            [reusableView.btn addTarget:self action:@selector(allBrand) forControlEvents:UIControlEventTouchUpInside];
            return  reusableView;
            
        }else
        {
           BrandCollectionReusableView * reusableView2 = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header2" forIndexPath:indexPath];
            reusableView2.title.text = [_sectionHeaderArray objectAtIndex:indexPath.section-1];
            
            return  reusableView2;
        }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat  itemW = (ScreenWidth-50)/4.0;
    return CGSizeMake(itemW, itemW);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return  UIEdgeInsetsMake(0, 10, 0, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
#pragma mark -- 全部品牌
-(void)allBrand
{
    
    AllBrandViewController * allBrand = [[AllBrandViewController alloc] init];
    allBrand.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:allBrand animated:YES];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(ScreenWidth, 50);
    }else{
        return CGSizeMake(ScreenWidth, 70);
    }
}
#pragma mark -- 跳转
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return;
    }

    
    SearchViewController *search = [[SearchViewController alloc]init];
    BquSearchConditionModel *model  = [[BquSearchConditionModel alloc] init];
    NSMutableArray * array = [_singleSectionArray objectAtIndex:indexPath.section - 1];
    CateBrands * brand = [array objectAtIndex:indexPath.row];
    model.bid = brand.ID;
    model.bidName = brand.Name;
    search.conditions = model;
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];

    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
