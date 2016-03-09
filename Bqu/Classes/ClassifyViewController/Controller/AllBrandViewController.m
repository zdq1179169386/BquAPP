//
//  AllBrandViewController.m
//  Bqu
//
//  Created by yb on 15/10/12.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "AllBrandViewController.h"
#import "CateBrands.h"
#import "AllBrandCell.h"
#import "BrandAndKindController.h"
#import "BrandCollectionReusableView.h"
#import "SearchViewController.h"

@interface AllBrandViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView * collectionView;

@property (nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation AllBrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (IOS7_OR_LATER)
    {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    [self initNavgationBar];
    [self initCollectionView];
    [self requestForData];
    

}
#pragma mark -- 请求
-(void)requestForData
{
        self.dataArray = [NSMutableArray array];
        NSString * urlStr = [NSString stringWithFormat:@"%@/api/home/Product/Brand/List",TEST_URL];
        NSDictionary * dict = @{@"action":@"ProductBrandList"};
    
        NSString * signStr = [HttpTool returnForSign:dict];
    
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:dict];
        dic[@"sign"] = signStr;
         __block AllBrandViewController * blockSelf = self;
        [HttpTool post:urlStr params:dic success:^(id json) {
            NSString * success = json[@"resultCode"];
            //0是成功
            if (success.intValue == 0) {
                NSArray * array = [CateBrands objectArrayWithKeyValuesArray:json[@"data"]];
//                  NSLog(@"%ld",array.count);
                for (int i =0; i<array.count; i++) {
                    CateBrands * brand = array[i];
//                    NSLog(@"%@",brand);
                    [blockSelf.dataArray addObject:brand];
                }
                //  NSLog(@"%@",_singleSectionArray);
                //刷新表
                [self.collectionView reloadData];
            }
            for (UIView * view in self.view.subviews) {
                if (view == self.netView) {
                    [self.netView removeFromSuperview];
                    break;
                }
            }
        } failure:^(NSError *error) {
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
-(void)initNavgationBar
{
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.text = @"全部品牌";
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
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initCollectionView
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.headerReferenceSize = CGSizeMake(ScreenWidth, 40);
//    layout.itemSize =CGSizeMake(70, 70);
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight-64) collectionViewLayout:layout];
    [self.collectionView registerClass:[AllBrandCell class] forCellWithReuseIdentifier:@"cellID"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical = YES;
    [self.view addSubview:self.collectionView];
    
}
#pragma mark -- collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString * cellID = @"cellID";
    AllBrandCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    CateBrands * brand = [self.dataArray objectAtIndex:indexPath.row];
    [cell.Image sd_setImageWithURL:[NSURL URLWithString:brand.Logo] placeholderImage:[UIImage imageNamed:@"分类占位图"]];
        return cell;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView  * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(10, 16, 2, 17)];
    line.backgroundColor = [UIColor colorWithHexString:@"#F52748"];
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 150, 30)];
    title.text = @"全部商品";
    title.textColor =  [UIColor colorWithHexString:@"#333333"];
    [header addSubview:line];
    [header addSubview:title];
    return header;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%s",__func__);
    CGFloat itemW = (ScreenWidth - 50)/4.0;
    return CGSizeMake(itemW, itemW);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(ScreenWidth, 50);
}
#pragma mark -- 最小行距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    
//}
#pragma mark -- 最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 10, 10);
}
#pragma mark -- 跳转
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchViewController *search = [[SearchViewController alloc]init];
    BquSearchConditionModel *model  = [[BquSearchConditionModel alloc] init];
    CateBrands * brand = [self.dataArray objectAtIndex:indexPath.row];
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

-(void)dealloc
{
    self.collectionView = nil;
    self.dataArray = nil;
}
@end
