//
//  RefundViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "RefundViewController.h"
#import "ApplyForRefundController.h"
#import "AfterSaleOrderModel.h"
#import "RefundTableCell.h"
#import "RefundOrderDetailController.h"
#import "MyOrderCell.h"
#import "AnotherCell.h"
#import "UserCenterViewController.h"
#import "RefundTableFooterView.h"
#import "RefundTableHeaderView.h"
#import "GoodsDetailViewController.h"
@interface RefundViewController ()<UITableViewDataSource,UITableViewDelegate,RefundTableFooterViewDelegate,RefundTableHeaderViewDelegate>
{
    BOOL _flag[0];
    NSInteger _count;
    NSInteger _page;
    //最大分页数
    NSInteger _maxPage;
}
/**未登录时的背景图*/
@property (nonatomic,strong)UIView * isBgView;

@property(nonatomic,strong) UITableView * tableView;

@property(nonatomic,strong)NSMutableArray * dataArray;

/**判断是否开合,布尔数组*/
@property (nonatomic,strong)NSMutableArray * boolArray;

/**选中的区*/
@property (nonatomic,assign)int selectedSection;


@end

@implementation RefundViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (IOS7_OR_LATER)
    {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    
    self.navigationItem.title = @"退款售后";
    self.view.backgroundColor = RGB_A(240, 238, 238);
    UIButton * backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back1) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
//    [self createBackBar];
    
    if ([self.isLogin isEqualToString:@"0"])
    {
//        self.dataArray = [NSArray array];
        [self requestForData];
        [self initTable];
        
    }else
    {
        //未登录或者没有退款纪录
        [self initBgView];
        
    }

    
}
-(NSMutableArray*)boolArray
{
    if (!_boolArray) {
        _boolArray = [[NSMutableArray alloc] init];
    }
    return _boolArray;
}
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(void)back1
{

      [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)initTable
{
    _page = 1;
    _maxPage = 1;
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
        //注册cell
        [self.tableView registerClass:[RefundTableCell class] forCellReuseIdentifier:@"cell"];
        [self.tableView registerClass:[MyOrderCell class] forCellReuseIdentifier:@"cell1"];
        [self.tableView registerClass:[AnotherCell class] forCellReuseIdentifier:@"cell2"];

        [self.tableView registerClass:[RefundTableFooterView class] forHeaderFooterViewReuseIdentifier:@"footer"];
        [self.tableView registerClass:[RefundTableHeaderView class] forHeaderFooterViewReuseIdentifier:@"header"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //下拉刷新
        self.tableView.header = [DIYHeader  headerWithRefreshingBlock:^{
            [self requestForData];
        }];
        //上拉加载
        self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            [self requestForMoreData];
        }];
        // 设置了底部inset
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
        // 忽略掉底部inset
        self.tableView.footer.ignoredScrollViewContentInsetBottom = 30;
    }
}
#pragma mark -- 获取所有的售后单
-(void)requestForData
{
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/api/order/refund/list",TEST_URL];
    //创建，安字段创建
    NSString * memberId = [UserManager getMyObjectForKey:userIDKey];
    NSString * token = [UserManager getMyObjectForKey:accessTokenKey];
    if (!memberId || !token) {
        return;
    }
    NSDictionary * dict = @{@"date":@"threemonth",@"MemberID":memberId,@"status":@"0",@"page":@"1",@"pagesize":@"10",@"token":token};
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic = [HttpTool getDicToRequest:dict];
    
    [HttpTool post:urlStr params:dic success:^(id json) {
        [self.dataArray removeAllObjects];
                NSLog(@"获取所有的售后单=%@",json[@"totalCount"]);
        if (!json[@"error"]) {
            NSArray * array = [AfterSaleOrderModel objectArrayWithKeyValuesArray:json[@"data"]];
            [self.dataArray addObjectsFromArray:array];
            //            self.dataArray = array;
            _count = array.count;
            
            
        }
        NSLog(@"totalCount=%@",json[@"totalCount"]);
        NSString * totalCount = json[@"totalCount"];
        float x = totalCount.floatValue/10.0;
        _maxPage = ceilf(x);
        
        NSMutableArray * boolArray = [NSMutableArray array];
        for (int i = 0; i<self.dataArray.count; i++) {
            BOOL isOpen = NO;
            NSString * openStr = [NSString stringWithFormat:@"%d",isOpen];
            [boolArray addObject:openStr];
        }
        self.boolArray = boolArray;
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
        [self.tableView.header endRefreshing];
        
    }];
    
}

#pragma mark --  上拉加载
-(void)requestForMoreData
{
    _page = _page + 1;
    if (_page>_maxPage) {
        [self.tableView.footer endRefreshing];
        [self.tableView.footer noticeNoMoreData];
        return;
    }
    NSString * urlStr = [NSString stringWithFormat:@"%@/api/order/refund/list",TEST_URL];
    //创建，安字段创建
    NSString * memberId = [UserManager getMyObjectForKey:userIDKey];
    NSString * token = [UserManager getMyObjectForKey:accessTokenKey];
    if (!memberId || !token) {
        return;
    }
    NSString * page = [NSString stringWithFormat:@"%ld",_page];
    NSDictionary * dict = @{@"date":@"threemonth",@"MemberID":memberId,@"status":@"0",@"page":page,@"pagesize":@"10",@"token":token};
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic = [HttpTool getDicToRequest:dict];
    
    [HttpTool post:urlStr params:dic success:^(id json) {
        
        NSLog(@"获取所有的售后单=%@",json[@"data"]);
        if (!json[@"error"]) {

            NSArray * array = [AfterSaleOrderModel objectArrayWithKeyValuesArray:json[@"data"]];
            if (array.count==0) {
                [self.tableView.footer endRefreshing];
                [self.tableView.footer noticeNoMoreData];
                return;
            }
            [self.dataArray addObjectsFromArray:array];
//            self.dataArray = array;
            _count = array.count;
            
            
        }
        NSMutableArray * boolArray = [NSMutableArray array];
        for (int i = 0; i<self.dataArray.count; i++) {
            BOOL isOpen = NO;
            NSString * openStr = [NSString stringWithFormat:@"%d",isOpen];
            [boolArray addObject:openStr];
        }
        [self.boolArray addObjectsFromArray:boolArray];
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
        [self.tableView.footer endRefreshing];
        
    }];

}
#pragma mark -- UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    if (self.dataArray>0) {
        AfterSaleOrderModel * model = self.dataArray[section];
       
        if (model.RefundItem.count>0) {
            
            NSString * str = self.boolArray[section];
            if ([str isEqualToString:@"0"]) {
                
                return 1;
            }else
            {
                //是否展开
                return model.RefundItem.count+1;
            }
            
        }else
        {
            return 1;
        }
        
    }
    return 0;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * Id = @"cell";
    AfterSaleOrderModel * model = self.dataArray[indexPath.section];
    if (indexPath.row==0) {
        RefundTableCell * cell = [tableView dequeueReusableCellWithIdentifier:Id];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        return cell;
    }else
    {
        AnotherCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
         if(![model.RefundItem isKindOfClass:[NSNull class]])
         {
             if (model.RefundItem.count>0) {
                 cell.itemModel = model.RefundItem[indexPath.row-1];
             }
         }
        return cell;
       
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    AfterSaleOrderModel * model = self.dataArray[section];
    if ([model.ManagerConfirmStatus isEqualToString:@"退款成功"]) {
       
        if (![model.RefundItem isKindOfClass:[NSNull class]]) {
            if (model.RefundItem.count>0) {
                return 130;
            }
        }
        return 90;
       
    }else if (![model.RefundItem isKindOfClass:[NSNull class]])
    {
        if (model.RefundItem.count>0) {
            
            return 90;
        }
        
    }
    return 50;
}
#pragma mark -- 区头
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RefundTableHeaderView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    AfterSaleOrderModel * model = self.dataArray[section];
    header.delegate = self;
    header.refundModel = model;
    header.btn.tag = section;
    return header;
    
}
#pragma mark -- 区头的代理
-(void)RefundTableHeaderViewClick:(RefundTableHeaderView *)header withBtn:(UIButton *)btn
{
    AfterSaleOrderModel * model = self.dataArray[btn.tag];
//    NSLog(@"----%ld",btn.tag);
    RefundOrderDetailController * vc = [[RefundOrderDetailController alloc] init];
    vc.refundId = model.Id;
    vc.afterMarketmodel = model;
    if ([model.ManagerConfirmStatus isEqualToString:@"商家拒绝"] && model.RefundMode != 1) {
        //因为商家拒绝，才有二次申请售后的机会，并且，只有售后，才有二次申请机会，退单退款只有一次机会。
        vc.afterMarketmodel = model;
    }
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -- 区尾
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    RefundTableFooterView * footer = [[RefundTableFooterView alloc] initWithReuseIdentifier:@"footer" withSection:section withDelegate:self];
    NSString * boolStr = self.boolArray[section];
    if (boolStr.boolValue==1) {
        //开
        footer.isOpen = YES;
    }else
    {
        //合
        footer.isOpen = NO;
    }
    AfterSaleOrderModel * model = self.dataArray[section];
    footer.afterSaleOrder = model;
    return footer;
}
#pragma mark -- 区尾的代理
-(void)RefundTableFooterViewBtnClick:(RefundTableFooterView*)view withOtherBtn:(UIButton *)otherBtn withSection:(NSInteger)section
{
//    NSLog(@"___%d",section);
        //显示剩余件数
        NSString * str = self.boolArray[section];
//    if ([str isEqualToString:@"1"]) {
//        [view.otherBtn setTitle:@"收起" forState:UIControlStateNormal];
//    }else
//    {
//        
//    }
        BOOL value = !str.boolValue;
        NSLog(@"value=%d",value);
        str = [NSString stringWithFormat:@"%d",value];
        [self.boolArray replaceObjectAtIndex:section withObject:str];
        NSIndexSet * set = [[NSIndexSet alloc] initWithIndex:section];
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
        
}
#pragma mark -- 退款成功，点击区尾跳到售后单详情页
-(void)RefundTableFooterViewBtnClick:(RefundTableFooterView*)view withFindMoney:(UIButton *)findMoney withSection:(NSInteger)section
{
    AfterSaleOrderModel * model = self.dataArray[section];
    RefundOrderDetailController * vc = [[RefundOrderDetailController alloc] init];
    vc.refundId = model.Id;
    vc.afterMarketmodel = model;
    [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark -- 点击头部跳到售后单详情页
-(void)headerClick:(UIButton*)btn
{
    AfterSaleOrderModel * model = self.dataArray[btn.tag-100];
    RefundOrderDetailController * vc = [[RefundOrderDetailController alloc] init];
    vc.refundId = model.Id;
    if ([model.SellerAuditStatus isEqualToString:@"商家拒绝"]) {
        //因为商家拒绝，才有二次申请售后的机会
        vc.afterMarketmodel = model;
    }
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -- 跳到商品详情页
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    AfterSaleOrderModel * model = self.dataArray[indexPath.section];
    GoodsDetailViewController * vc = [[GoodsDetailViewController alloc] init];
    if (indexPath.row==0) {
        
        vc.productId = model.ProductId;

    }else
    {
        if(![model.RefundItem isKindOfClass:[NSNull class]])
        {
            if (model.RefundItem.count>0) {
                RefundItemModel * itemModel = model.RefundItem[indexPath.row-1];
               vc.productId= itemModel.ItemId;
            }
        }

    }
//    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark -- 初始化
-(void)initBgView
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f1f1"];
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    image.image = [UIImage imageNamed:@"empty"];
    [self.view addSubview:image];
    image.center = CGPointMake(ScreenWidth/2.0,(ScreenHeight-64)/2.0);
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    lable.text = @"抱歉,你还没有退款纪录";
    [self.view addSubview:lable];
    CGFloat labelY = CGRectGetMaxY(image.frame);
//    lable.font = [UIFont systemFontOfSize:12];
    lable.textColor = [UIColor lightGrayColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.center = CGPointMake(ScreenWidth/2.0, labelY+25);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
