//
//  OntimeJumpToVC.m
//  Bqu
//
//  Created by WONG on 15/11/3.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "OntimeJumpToVC.h"
#import "AllOnTimeCell.h"
#import "AllOnTimeModel.h"

#import "GoodsDetailViewController.h"
#define UITabBarHeight 55
@interface OntimeJumpToVC ()
@property (nonatomic,strong)UIImageView *image;
@property (nonatomic,strong)UILabel *titleLable;
@property (nonatomic,strong)UIView *topView;

@property (nonatomic,strong)NSMutableArray *datasAry;
@property (nonatomic,strong)NSArray * countAry;
@property (nonatomic,strong)NSMutableArray * dataAry;

@property (nonatomic ,strong)NSIndexPath *index;
@end

@implementation OntimeJumpToVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createBackBar];
    [self initCollectionView];
    [self requestForData];
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self requestForData];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor  = [UIColor colorWithHexString:@"eeeeee"];
    self.navigationController.navigationBar.translucent = NO;
}
- (void)createBackBar {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(backBarClicked) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 30, 21);
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}
- (void)backBarClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestForData {
    NSString * urlStr = [NSString stringWithFormat:@"%@/API/home/Limit/Product",TEST_URL];
    
    NSDictionary * dict = @{@"keywords":@" ",@"orderKey":@1,@"orderType":@1,@"catename":@" ",@"page":@1,@"pagesize":@50};
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    NSString * realSign = [HttpTool returnForSign:dict];
    dic[@"keywords"] = @" ";
    dic[@"orderKey"] = @1;
    dic[@"orderType"] = @1;
    dic[@"catename"] = @" ";
    dic[@"page"] = @1;
    dic[@"pagesize"] = @50;
    dic[@"sign"] = realSign;

    
    [HttpTool post:urlStr params:dic success:^(id json) {
        
        //NSLog(@"海外特价%@",json);
        self.dataAry = [[NSMutableArray alloc]initWithCapacity:0];
        self.datasAry = [[NSMutableArray alloc]initWithCapacity:0];
        NSDictionary *diction = [[NSDictionary alloc]init];
        diction = json[@"data"];
        if (diction[@"LimitAdv"] == NULL) {
          
        }else
           [self ReturnNoPic];
        self.datasAry = diction[@"LimitProduct"];
        for (NSMutableDictionary *dictionary in self.datasAry) {
            AllOnTimeModel *model = [AllOnTimeModel createModelWithDic:dictionary];
            [self.dataAry addObject:model];
        }
        
        //刷新表
        [self.collectionView reloadData];
        [self.collectionView.header endRefreshing];
        
    } failure:^(NSError *error) {
        
        
    }];
}
// 返回无图模式
- (void)ReturnNoPic {
    [self.image removeFromSuperview];
    self.collectionView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
}
#pragma mark -- 初始化CollectionView
-(void)initCollectionView
{
    
    if (!self.collectionView)
    {
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        self.image = [[UIImageView alloc]initWithFrame:CGRectMake(0, -170,ScreenWidth, 110)];
        self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, -60, ScreenWidth, 60)];

        UILabel *leftLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 20,(ScreenWidth - 48) / 3 - 20 , 1)];
        UILabel *rightLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 2 / 3 + 28, 20, (ScreenWidth - 48) / 3 - 20, 1)];
        UILabel *wordLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth  / 3 - 20, 0, ScreenWidth / 3 + 40, 40)];
        wordLab.textAlignment = NSTextAlignmentCenter;
        wordLab.textColor = [UIColor yellowColor];
        wordLab.text = @"海外直供 限时特卖";
        wordLab.font = [UIFont systemFontOfSize:16];
        leftLab.backgroundColor = [UIColor whiteColor];
        rightLab.backgroundColor = [UIColor whiteColor];

        _image.backgroundColor = [UIColor lightGrayColor];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - UITabBarHeight) collectionViewLayout:layout];
        self.collectionView.contentInset = UIEdgeInsetsMake(170, 0, 0, 0);
        self.collectionView.backgroundColor = [UIColor colorWithHexString:@"8851FC"];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.alwaysBounceVertical = YES;
        [self.collectionView registerNib:[UINib nibWithNibName:@"AllOnTimeCell" bundle:nil] forCellWithReuseIdentifier:@"OntimeID"];
        
        self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        _titleLable.text = @"海外特价";
        _titleLable.font = [UIFont systemFontOfSize:18];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.textColor = [UIColor blackColor];
        self.navigationItem.titleView = _titleLable;
        
        [self.view addSubview:self.collectionView];
        [self.collectionView addSubview:self.image];
        [self.collectionView addSubview:self.topView];
        [self.topView addSubview:leftLab];
        [self.topView addSubview:rightLab];
        [self.topView addSubview:wordLab];
    }
}
#pragma UICollectionViewDelegate -- CollectionView代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.datasAry.count;
    
}
// 分区数根据分区数组返回
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AllOnTimeCell * cell =[AllOnTimeCell allOnTimeCellWithcollectionView:collectionView indexPath:indexPath ];
    AllOnTimeModel *model = [self.dataAry objectAtIndex:indexPath.row];
    cell.allOnTimeModel = model;
    self.Pid = model.Pid;
    
    //NSLog(@"%ld个%@,%@",(long)indexPath.row, NSStringFromCGRect(cell.frame),cell);
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AllOnTimeModel *model = [self.dataAry objectAtIndex:indexPath.row];
    
    self.Pid = model.Pid;// 商品的ID
//    self.Moods = dict[@"Moods"];// 人气数（收藏数）
//    self.Comment = dict[@"Comment"];// 评论数
    
    GoodsDetailViewController *goodVC = [[GoodsDetailViewController alloc]init];
    goodVC.productId = self.Pid;
    goodVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodVC animated:YES];
}
#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake((ScreenWidth - 30)/2.0, 235); 
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
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
