//
//  SubClassifyTwoViewController.m
//  Bqu
//
//  Created by yb on 15/12/7.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "SubClassifyTwoViewController.h"
#import "SubClassifyVCCollectionViewCell.h"
#import "ProductCategoryData.h"
#import "ClassifyViewHeader.h"
#import "ZDQCollectionReusableView.h"
#import "BrandAndKindController.h"
#import "SearchViewController.h"
#define Section_H 140/375.0f
@interface SubClassifyTwoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,ZDQCollectionReusableViewDelegate>

@property (nonatomic,strong)UICollectionView * collectionView;

@property (nonatomic,strong)NSArray * allArray;

@end

@implementation SubClassifyTwoViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initCollectionView];
    
}
#pragma mark -- 
-(void)initCollectionView
{
    _allArray = [[NSArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-ClassifyViewHeaderH-64-49) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
//        _collectionView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
        [_collectionView registerClass:[SubClassifyVCCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[ZDQCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        //全部商品
        UIButton * headBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, -50, ScreenWidth, 50)];
        headBtn.backgroundColor = [UIColor redColor];
        [headBtn setTitle:@"全部商品" forState:UIControlStateNormal];
        [headBtn setImage:[UIImage imageNamed:@"allProduct"] forState:UIControlStateNormal];
        headBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 180, 0, 0);
        [headBtn addTarget:self action:@selector(allKind:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_collectionView];
//        [self.collectionView addSubview:headBtn];
    }
}
-(void)allKind:(UIButton *)btn
{
    
}
#pragma mark -- setter
-(void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    self.allArray = _dataArray;
    NSLog(@"_dataArray=%ld",_dataArray.count);
    [self.collectionView reloadData];
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _dataArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    ProductCategoryData * data = _allArray[section];
    return data.SubCategories.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"cell";
    ProductCategoryData * data = _allArray[indexPath.section];
    ProductCategoryData * data2 = data.SubCategories[indexPath.item];
    SubClassifyVCCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.data = data2;
//    cell.name.text = data2.Name;
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if (kind == UICollectionElementKindSectionHeader) {
        ZDQCollectionReusableView * reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        reusableView.delegate = self;
        reusableView.Btn.tag = indexPath.section;
//        reusableView.backgroundColor = HWRandomColor;
        if (indexPath.section==0) {
            [reusableView.Btn setBackgroundImage:[UIImage imageNamed:@"母婴专区"] forState:UIControlStateNormal];
            
        }else if (indexPath.section == 1)
        {
            [reusableView.Btn setBackgroundImage:[UIImage imageNamed:@"美容彩妆"] forState:UIControlStateNormal];
            
        }else if (indexPath.section == 2)
        {
             [reusableView.Btn setBackgroundImage:[UIImage imageNamed:@"日化家居"] forState:UIControlStateNormal];
            
        }else if (indexPath.section == 3){
            
             [reusableView.Btn setBackgroundImage:[UIImage imageNamed:@"营养保健"] forState:UIControlStateNormal];
        }
        return  reusableView;
    }

    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductCategoryData * data = _allArray[indexPath.section];
    ProductCategoryData * data2 = data.SubCategories[indexPath.item];
    CGSize size = [data2.Name sizeWithFont:[UIFont systemFontOfSize:13]];
    return CGSizeMake(size.width+10, 20);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return  UIEdgeInsetsMake(25, 15, 25, 15);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 25;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 25;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    NSLog(@"%f",Section_H*ScreenWidth);
    return CGSizeMake(ScreenWidth, Section_H*ScreenWidth);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchViewController *search = [[SearchViewController alloc]init];
    BquSearchConditionModel *model  = [[BquSearchConditionModel alloc] init];
    ProductCategoryData * data = [_allArray objectAtIndex:indexPath.section];
    ProductCategoryData * data2 =  [data.SubCategories objectAtIndex:indexPath.row];
    model.cid = data2.Id;
    model.cidName = data2.Name;
    search.conditions = model;
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
    
//    BrandAndKindController * brandAndKind_VC = [[BrandAndKindController alloc] init];
//    ProductCategoryData * data = [_allArray objectAtIndex:indexPath.section];
//    ProductCategoryData * data2 =  [data.SubCategories objectAtIndex:indexPath.row];
//    brandAndKind_VC.cid = data2.Id;
//    brandAndKind_VC.navBarTitle = data2.Name;
//    brandAndKind_VC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:brandAndKind_VC animated:NO];

}
#pragma mark -- ZDQCollectionReusableViewDelegate
-(void)ZDQCollectionReusableViewClick:(ZDQCollectionReusableView *)view withBtn:(UIButton *)btn
{
//    BrandAndKindController * brandAndKind_VC = [[BrandAndKindController alloc] init];
//    ProductCategoryData * data = [_allArray objectAtIndex:btn.tag];
//    brandAndKind_VC.cid = data.Id;
//    brandAndKind_VC.navBarTitle = data.Name;
//    brandAndKind_VC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:brandAndKind_VC animated:NO];
  
    SearchViewController *search = [[SearchViewController alloc]init];
    BquSearchConditionModel *model  = [[BquSearchConditionModel alloc] init];
    ProductCategoryData * data = [_allArray objectAtIndex:btn.tag];
    NSLog(@"%@,%@",data.Id,data.Name);
    model.cid = data.Id;
    model.cidName = data.Name;
    search.conditions = model;
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];

}
@end
