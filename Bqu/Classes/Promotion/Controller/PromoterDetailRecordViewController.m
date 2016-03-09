//
//  PromoterDetailRecordViewController.m
//  Bqu
//
//  Created by wyy on 15/12/11.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "PromoterDetailRecordViewController.h"
#import "PromoterDetailRecordTableViewCell.h"
#import "PromoterDetailRecordModel.h"

#define kPageSize  100

@interface PromoterDetailRecordViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *allButton;
@property (nonatomic, weak) IBOutlet UIButton *underwayButton;
@property (nonatomic, weak) IBOutlet UIButton *classifyButton;
@property (nonatomic, weak) IBOutlet UIView *classifySelectView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) int selectType; //0:全部  1:返利  2:提现  3:处理中
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger totalPage;

@end

@implementation PromoterDetailRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"资产明细";
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (IOS7_OR_LATER)
    {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    self.classifySelectView.hidden = YES;
    self.classifySelectView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self initLeftBarButton];
    self.selectType = 0;
    [self resetTopView];
    [self requestData];
    //添加手势
    UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(classifySelectViewHide:)];
    [self.classifySelectView addGestureRecognizer:tap];
    //上拉加载更多
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requestForMoreData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)classifySelectViewHide:(UITapGestureRecognizer *)tap
{
    self.classifySelectView.hidden = YES;
    [self resetTopView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initLeftBarButton
{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)resetTopView
{
    //selectType  0:全部  1:返利  2:提现  3:处理中
    self.classifySelectView.hidden = YES;
    self.classifyButton.imageView.transform = CGAffineTransformMakeRotation(0);
    UIColor *selectColor = RGB_A(246, 38, 72);
    UIColor *normalColor = RGB_A(51, 51, 51);
    if (self.selectType == 1) {
        [self.allButton setTitleColor:normalColor forState:UIControlStateNormal];
        [self.underwayButton setTitleColor:normalColor forState:UIControlStateNormal];
        [self.classifyButton setTitle:@"返利" forState:UIControlStateNormal];
        [self.classifyButton setTitleColor:selectColor forState:UIControlStateNormal];
        
    } else if (self.selectType == 2) {
        [self.allButton setTitleColor:normalColor forState:UIControlStateNormal];
        [self.underwayButton setTitleColor:normalColor forState:UIControlStateNormal];
        [self.classifyButton setTitle:@"提现" forState:UIControlStateNormal];
        [self.classifyButton setTitleColor:selectColor forState:UIControlStateNormal];
        
    } else if (self.selectType == 3) {
        [self.allButton setTitleColor:normalColor forState:UIControlStateNormal];
        [self.underwayButton setTitleColor:selectColor forState:UIControlStateNormal];
        [self.classifyButton setTitle:@"分类" forState:UIControlStateNormal];
        [self.classifyButton setTitleColor:normalColor forState:UIControlStateNormal];
        
    } else {
        [self.allButton setTitleColor:selectColor forState:UIControlStateNormal];
        [self.underwayButton setTitleColor:normalColor forState:UIControlStateNormal];
        [self.classifyButton setTitle:@"分类" forState:UIControlStateNormal];
        [self.classifyButton setTitleColor:normalColor forState:UIControlStateNormal];
    }
}

- (void)requestData
{
    self.pageIndex = 1;
    [self.dataArray removeAllObjects];
    [self sendRequest];
}

- (void)sendRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", bquUrl, getPromoterDetailRecordUrl];
    NSString *memberID = [UserManager getMyObjectForKey:userIDKey];
    NSString *token = [UserManager getMyObjectForKey:accessTokenKey];
    if (memberID == nil || token == nil) {
        [self.tableView.footer endRefreshing];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:memberID forKey:@"MemberID"];
    [dict setValue:token forKey:@"token"];
    [dict setValue:[NSString stringWithFormat:@"%ld", self.pageIndex] forKey:@"PageNo"];
    [dict setValue:[NSString stringWithFormat:@"%d", kPageSize] forKey:@"PageSize"];
    [dict setValue:self.accountId forKey:@"AccountID"];
    [dict setValue:[NSNumber numberWithInt:self.selectType] forKey:@"Type"];
    
    NSString *realSign = [HttpTool returnForSign:dict];
    [dict setValue:realSign forKey:@"sign"];
    [ProgressHud addProgressHudWithView:self.view andWithTitle:@"加载中"];
    
    [HttpTool post:urlStr params:dict success:^(id json) {
        
        [ProgressHud hideProgressHudWithView:self.view];
        [self.tableView.footer endRefreshing];
        
        NSString *resultCode = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
        if ([resultCode isEqualToString:@"0"])
        {
            NSString *totalCount = [NSString stringWithFormat:@"%@",json[@"totalCount"]];
            self.totalPage = lroundf(totalCount.floatValue/kPageSize);
            NSArray *dataArr = json[@"data"];
            
            if (dataArr != nil && ![dataArr isEqual:[NSNull null]] && dataArr.count > 0) {
                NSLog(@"%@", dataArr);
                
                for (NSDictionary *dict in dataArr) {
                    PromoterDetailRecordModel *model = [[PromoterDetailRecordModel alloc] init];
                    [model promoterDetailRecordModelFromDictionary:dict];
                    [self.dataArray addObject:model];
                }
            }
            [self.tableView reloadData];
            
        } else {
            NSString *errorMsg = json[@"message"];
            NSLog(@"%@", errorMsg);
        }
        
    } failure:^(NSError *error) {
        [ProgressHud hideProgressHudWithView:self.view];
        [self.tableView.footer endRefreshing];
    }];
}

- (void)requestForMoreData
{
    self.pageIndex += 1;
    if (self.pageIndex > self.totalPage) {
        [self.tableView.footer endRefreshing];
        [self.tableView.footer noticeNoMoreData];
        return;
    }
    [self sendRequest];
}

- (IBAction)allBtnClicked:(id)sender
{
    self.selectType = 0;
    [self resetTopView];
    [self requestData];
}

- (IBAction)underwayBtnClicked:(id)sender
{
    self.selectType = 3;
    [self resetTopView];
    [self requestData];
}

- (IBAction)classityBtnClicked:(id)sender
{
    self.classifySelectView.hidden = NO;
    [self.allButton setTitleColor:RGB_A(51, 51, 51) forState:UIControlStateNormal];
    [self.underwayButton setTitleColor:RGB_A(51, 51, 51) forState:UIControlStateNormal];
    [self.classifyButton setTitle:@"分类" forState:UIControlStateNormal];
    [self.classifyButton setTitleColor:RGB_A(246, 38, 72) forState:UIControlStateNormal];
    self.classifyButton.imageView.transform = CGAffineTransformMakeRotation(M_PI);
}

- (IBAction)rebateBtnClicked:(id)sender
{
    self.selectType = 1;
    [self resetTopView];
    [self requestData];
}

- (IBAction)withdrawCashBtnClicked:(id)sender
{
    self.selectType = 2;
    [self resetTopView];
    [self requestData];
}


#pragma mark - UITableViewDataSource && UITableViewDelegate
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *Identifier = @"PromoterDetailRecordCell";
    PromoterDetailRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PromoterDetailRecordTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    if (indexPath.row >= self.dataArray.count) {
        return cell;
    }
    
    PromoterDetailRecordModel *model = self.dataArray[indexPath.row];
    [cell setPromoterDetailRecordInfo:model];
    
    return cell;
}

@end
