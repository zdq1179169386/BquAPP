//
//  SubClassifyViewController.m
//  Bqu
//
//  Created by yb on 15/10/10.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "SubClassifyViewController.h"
#import "ZDQBtn.h"
#import "ZDQCollectionReusableView.h"
#import "BrandAndKindController.h"
#import "ProductCategoryData.h"
#import "SubClassifyVCCollectionViewCell.h"
#import "AllBrandCell.h"
#import "ClassifyTableOneCell.h"
#import "SearchController.h"
#define leveloneTableTag 1111
#define leveltwoTableTag 2222

#define CollectionView_H 70/568.00
#define TableOne_W 114
@interface SubClassifyViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray * _leveloneArray;
    NSMutableArray * _levelTwoArray;
    BOOL _isRequst;
    NSInteger selectedBtn;
    NSInteger lastRow;
}

/**一级表*/
@property(nonatomic,strong)UITableView * leveloneTable;
/**二级表*/
@property(nonatomic,strong)UICollectionView * levelTwoTable;
/** 数据源数组*/
@property(nonatomic,retain)NSArray * bigArray;


//@property(nonatomic,strong)NSMutableArray * realLeveTwoArray;

/**选中的标题*/
@property (nonatomic,copy)NSString * selectedTitle;

@end

@implementation SubClassifyViewController


-(void)dealloc
{
    self.leveloneTable = nil;
    self.levelTwoTable = nil;
    self.bigArray = nil;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    NSLog(@"%s",__func__);
     //没网的情况下，再次打开分类页面,获取数据
 
        if(![self.levelOneArray count] || ![self.leveTwoArray count]) {
//            [self requestForData];
        }
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"%s",__func__);
    _isRequst = NO;
//    [self requestForData];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (IOS7_OR_LATER)
    {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
     [self creatTable];
    
}
-(void)setAllArray:(NSArray *)allArray
{
    NSLog(@"SubClassifyViewController");
    _allArray = allArray;
    
    [self.levelOneArray removeAllObjects];
    [self.leveTwoArray removeAllObjects];
    
    self.levelOneArray = (NSMutableArray *)_allArray;

    for (int i =0; i<_allArray.count; i++) {
            ProductCategoryData * data = _allArray[i];
            //二级表的数据源
            if (i==0) {
                //                        [ self.leveTwoArray removeAllObjects];
                [self.leveTwoArray addObject:data.SubCategories];
                [self.leveTwoArray addObject:data.CateBrands];
            }
        }
        //设置选中第一行
        if (self.levelOneArray.count>0) {
            ProductCategoryData * data = self.levelOneArray[0];
            self.selectedTitle = data.Name;
        }
        //刷新表
        [self.leveloneTable reloadData];
        [self.levelTwoTable reloadData];
        self.bigArray = _allArray;
    
    
}
#pragma mark -- 获取数据
//-(void)requestForData
//{
//    _isRequst = YES;
//    
//    NSString * urlStr = [NSString stringWithFormat:@"%@/api/home/product/category/list",TEST_URL];
//    //创建，安字段创建
//    NSDictionary * dict = @{@"action":@"ProductCategoryList"};
//    NSString * realSign = [HttpTool returnForSign:dict];
//    
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//     dic[@"action"] = @"ProductCategoryList";
//     dic[@"sign"] = realSign;
//    
//    __block SubClassifyViewController * blockSelf = self;
//
//    [HttpTool post:urlStr params:dic success:^(id json) {
//        [self.levelOneArray removeAllObjects];
//        [self.leveTwoArray removeAllObjects];
//            _isRequst = NO;
//            if (!json[@"error"]) {
//               
//                NSArray * array = [ProductCategoryData objectArrayWithKeyValuesArray:json[@"data"]];
//                self.levelOneArray = (NSMutableArray *)array;
//                for (int i =0; i<array.count; i++) {
//                    ProductCategoryData * data = array[i];
////                    [self.levelOneArray addObject:data.Name];
//                  //二级表的数据源
//                    if (i==0) {
////                        [ self.leveTwoArray removeAllObjects];
//                        [self.leveTwoArray addObject:data.SubCategories];
//                        [self.leveTwoArray addObject:data.CateBrands];
//                    }
//                }
//                //设置选中第一行
//                if (self.levelOneArray.count>0) {
//                    ProductCategoryData * data = self.levelOneArray[0];
//                    self.selectedTitle = data.Name;
//                }
//                //刷新表
//                [blockSelf.leveloneTable reloadData];
//                [blockSelf.levelTwoTable reloadData];
//                blockSelf.bigArray = array;
//
//            }
//           
//        } failure:^(NSError *error) {
//            _isRequst = NO;
//            NSLog(@"error=%@",error);
//        }];
//    
//}
#pragma mark -- 初始化表
-(void)creatTable
 {
     self.levelOneArray = [[NSMutableArray alloc] init];
     self.leveTwoArray = [[NSMutableArray alloc] init];
     self.bigArray = [NSArray array];
     if(!self.leveloneTable)
      {
    self.leveloneTable = [[UITableView alloc]initWithFrame:CGRectMake(0,0,TableOne_W,ScreenHeight-Header_h-64-49) style:UITableViewStylePlain];
    self.leveloneTable.delegate = self;
    self.leveloneTable.dataSource = self;
    self.leveloneTable.rowHeight = 44;
    self.leveloneTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.leveloneTable.tag = leveloneTableTag;
    self.leveloneTable.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];

    [self.leveloneTable registerClass:[ClassifyTableOneCell class] forCellReuseIdentifier:@"TableOneCell"];
//    self.leveloneTable.scrollEnabled = NO;
    [self.view addSubview:self.leveloneTable];
          
 }
    if(!self.levelTwoTable)
   {
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
       layout.headerReferenceSize = CGSizeMake(ScreenWidth-TableOne_W, 40);
       [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
   self.levelTwoTable = [[UICollectionView alloc]initWithFrame:CGRectMake(TableOne_W,0,ScreenWidth - TableOne_W,ScreenHeight-44-64-55) collectionViewLayout:layout];
   [self.levelTwoTable registerClass:[SubClassifyVCCollectionViewCell class] forCellWithReuseIdentifier:@"cell1"];
   [self.levelTwoTable registerClass:[AllBrandCell class] forCellWithReuseIdentifier:@"cell2"];
   [self.levelTwoTable registerClass:[ZDQCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
   self.levelTwoTable.delegate = self;
   self.levelTwoTable.dataSource = self;
   self.levelTwoTable.backgroundColor = [UIColor whiteColor];
   self.levelTwoTable.tag = leveltwoTableTag;
   self.levelTwoTable.alwaysBounceVertical = YES;
 //  self.levelTwoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
       lastRow = 0;
   [self.view addSubview:self.levelTwoTable];
    }
     

}
#pragma mark -- tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return  self.levelOneArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * Id = @"TableOneCell";
    ClassifyTableOneCell * cell = [tableView dequeueReusableCellWithIdentifier:Id];
    ProductCategoryData * data = [self.levelOneArray objectAtIndex:indexPath.row];
    cell.title = data.Name;
    cell.isSelected = (self.selectedTitle == cell.title);
    
    return cell;
        
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    ProductCategoryData * firstData = [self.levelOneArray objectAtIndex:indexPath.row];
    self.selectedTitle = firstData.Name;
    [self.leveloneTable reloadData];
    
    //改变表2的数据源
    ProductCategoryData  * data   = [self.bigArray objectAtIndex:indexPath.row];
    [ self.leveTwoArray removeAllObjects];
    [ self.leveTwoArray addObject:data.SubCategories];
    [ self.leveTwoArray addObject:data.CateBrands];
    
    //刷新表
    [self.levelTwoTable reloadData];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}
#pragma mark -- collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (section==0) {
        if (! self.leveTwoArray.count) {
            return 0;
        }
        NSMutableArray * arrary = [ self.leveTwoArray objectAtIndex:0];
        return arrary.count;
    }else
    {
        if (! self.leveTwoArray.count) {
            return 0;
        }
        NSMutableArray * arrary = [ self.leveTwoArray objectAtIndex:1];
        return arrary.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString * cellID = @"UICollectionViewCell";
   
    if (indexPath.section == 0) {
         SubClassifyVCCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell1" forIndexPath:indexPath];
         NSMutableArray * array = [ self.leveTwoArray objectAtIndex:indexPath.section];
        ProductCategoryData * data = [array objectAtIndex:indexPath.row];
        [cell.Image sd_setImageWithURL:[NSURL URLWithString:data.Image] placeholderImage:[UIImage imageNamed:@"分类占位图"]];
//       cell.name.hidden = NO;
        cell.name.text = data.Name;
        return cell;
    }else
    {
        AllBrandCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell2" forIndexPath:indexPath];
        NSMutableArray * array = [ self.leveTwoArray objectAtIndex:indexPath.section];
        CateBrands * brand = [array objectAtIndex:indexPath.row];
        [cell.Image sd_setImageWithURL:[NSURL URLWithString:brand.Logo] placeholderImage:[UIImage imageNamed:@"分类占位图"]];
//        cell.name.height = YES;
        return cell;
    }
//    return cell;
}
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    ZDQCollectionReusableView * reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
     reusableView  =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        if (indexPath.section==0) {
            reusableView.title.text = @"精选分类";
        }else
        {
            reusableView.title.text = @"品牌分类";

        }
    }
   return  reusableView;

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat  itemW = (ScreenWidth-TableOne_W-46)/3.00;
    if (indexPath.section==0) {
            return CGSizeMake(itemW, CollectionView_H * ScreenHeight);
    }else
    {
        return CGSizeMake(itemW, itemW);
    }
   
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
   return  UIEdgeInsetsMake(0, 10, 0, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = CGSizeMake(ScreenWidth - TableOne_W, 60);
    return size;
}
#pragma mark -- 跳转页面
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BrandAndKindController * brandAndKind_VC = [[BrandAndKindController alloc] init];
    //传数据
    if (indexPath.section ==0) {
          ProductCategoryData * data = [[ self.leveTwoArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//        SearchController * search = [[SearchController alloc] init];
//        search.cid = data.Id;
//        search.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:search animated:YES];
     
//        brandAndKind_VC.searchWordType = 0;
        brandAndKind_VC.cid = data.Id;
        brandAndKind_VC.navBarTitle = data.Name;
    }else
    {
        CateBrands * brand = [[ self.leveTwoArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//        brandAndKind_VC.searchWordType = 1;
        brandAndKind_VC.bid = brand.ID;
        brandAndKind_VC.navBarTitle = brand.Name;
    }
    brandAndKind_VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:brandAndKind_VC animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
