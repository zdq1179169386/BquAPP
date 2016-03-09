//
//  MyCollectViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "MyCollectViewController.h"
#import "GoodsDetailViewController.h"

@interface MyCollectViewController ()

@end

@implementation MyCollectViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self createBackBar];
    
    if ([self.isLogin isEqualToString:@"0"])
    {
        [self requestData];
        //初始化CollectionView
        [self initCollectionView];
        
    }
    else
    {
        self.viewBlank.hidden = NO;
    }
    
    

}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"我的收藏";
    self.view.backgroundColor = RGB_A(240, 238, 238);

    NSLog(@"我的收藏是否登录1否，0是 ---》%@",self.isLogin);
    
   
    // 初始化空位置
    [self blankView];



}



- (void)blankView
{
    self.viewBlank = [[UIView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight)];
    self.viewBlank.backgroundColor = RGB_A(240, 238, 238);
    [self.view addSubview:self.viewBlank];
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.bounds = CGRectMake(0, 0, 102,102);
    imageView.center = CGPointMake(ScreenWidth / 2.0, ScreenHeight / 2.0 - 104);
    imageView.image = [UIImage imageNamed:@"我的收藏为空"];
    [self.viewBlank addSubview:imageView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth / 2.0 - 100, imageView.frame.size.height + imageView.frame.origin.y + 20, 200, 44)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.text = @"您的收藏夹还没有宝贝哦~";
    [self.viewBlank addSubview:label];
}

- (void)requestData
{
    

//    { "MemberID": "59","token": "555","sign": "123123"}PageNo PageNo
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,getMyCollectionUrl];
    NSLog(@"我的收藏 %@",urlStr);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"MemberID"] = [UserManager getMyObjectForKey:userIDKey];
    dict[@"token"] = [UserManager getMyObjectForKey:accessTokenKey];
    dict[@"PageNo"] = @"1";
    dict[@"PageSize"] = @"100";

    NSString *realSign = [HttpTool returnForSign:dict];
    dict[@"sign"] = realSign;
    [self showLoadingView];
    [HttpTool post:urlStr params:dict success:^(id json)
    {
        [self.collectionView.header endRefreshing];
        [self hideLoadingView];
        NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
        if ([resultStr isEqualToString:@"0"])
        {
            [self removeNewView];
            NSArray *dataArray = [NSArray array];
            dataArray = json[@"data"];
            
            if ((NSNull*)dataArray != [NSNull null])
            {
                self.viewBlank.hidden = YES;
                self.dataArray = [NSMutableArray array];
                
                if (dataArray.count == 0)
                {
                    self.viewBlank.hidden = NO;
                    self.dataArray = [NSMutableArray array];
                    self.collectionView.hidden = YES;
                }
                else
                {
                    self.collectionView.hidden = NO;
                    self.viewBlank.hidden = YES;
                    self.dataArray = [NSMutableArray array];
                    
                    for (NSDictionary *dict in dataArray)
                    {
                        MyCollection_Model *collection_Model = [MyCollection_Model parseUserInfoWithDictionary:dict];
                        [self.dataArray addObject:collection_Model];
                        
                    }
                    
                    [self.collectionView reloadData];
                }

            }
            else
            {
                self.viewBlank.hidden = NO;
                
            }
        }
        else
        {
            [self addAlertView];
        }
        
    } failure:^(NSError *error)
    
    {
        [self hideLoadingView];
        [self.collectionView.header endRefreshing];
        [self addNetView];
        
    }];
}

#pragma mark -- 初始化CollectionView
-(void)initCollectionView
{
    
    if (!self.collectionView)
    {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerNib:[UINib nibWithNibName:@"MyCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"cellID"];
        [self.view addSubview:self.collectionView];
        
       
        //下拉刷新
        self.collectionView.header.backgroundColor = [UIColor colorWithHexString:@"#f2f1f1"];
        self.collectionView.header = [DIYHeader headerWithRefreshingBlock:^{
            [self requestData];
        }];

    }

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * Identifier = @"cellID";
    MyCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
 
    cell.delegate = self;
    MyCollection_Model * model = [self.dataArray objectAtIndex:indexPath.row];
    [cell setValue:model];
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
    MyCollection_Model *myCollection_Model = [self.dataArray objectAtIndex:indexPath.row];
    detail_VC.productId = myCollection_Model.ProductID;
    [self.navigationController pushViewController:detail_VC animated:YES];
}

/**取消赞**/
- (void)cancelPriceBtn:(UIButton *)button
{
    NSLog(@"视图 = %@",[[button superview] superview]);

    MyCollectionCell *cell = (MyCollectionCell *)[[button superview] superview];
    NSIndexPath *path = [self.collectionView indexPathForCell:cell];
    
    MyCollection_Model *model = self.dataArray[path.section];
    
    //    { "MemberID": "59","token": "555","sign": "123123"}PageNo PageNo
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/home/CancelFavoriteProduct",bquUrl];
    NSLog(@"取消收藏 %@",urlStr);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"MemberID"] = [UserManager getMyObjectForKey:userIDKey];
    dict[@"token"] = [UserManager getMyObjectForKey:accessTokenKey];
    dict[@"pid"] = model.ProductID;
    
    NSString *realSign = [HttpTool returnForSign:dict];
    dict[@"sign"] = realSign;
    
    [HttpTool post:urlStr params:dict success:^(id json)
     {
        
        [TipView remindAnimationWithTitle:@"取消收藏成功"];
        
        [self.dataArray removeObject:model];
        [self.collectionView reloadData];
        if (self.dataArray.count == 0)
        {
            self.viewBlank.hidden = NO;
        }
        

    } failure:^(NSError *error) {
       
        
    }];
}

#pragma mark
#pragma mark    网络不好必加
-(void)addNetView
{
    [self.view addSubview:self.netView];
    self.netView.delegate = self;
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
