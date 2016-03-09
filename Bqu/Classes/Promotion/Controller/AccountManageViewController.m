//
//  AccountManageViewController.m
//  Bqu
//
//  Created by WONG on 15/12/8.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "AccountManageViewController.h"
#import "AccountsManageCell.h"
#import "AccountModel.h"
#import "PromotionBsaeViewController.h"
#import "AddNewAccountViewController.h"

@interface AccountManageViewController ()<accountsManagerCellDelegate,UIScrollViewDelegate>

@property (nonatomic,weak)UITableView *accountListView;


@property (nonatomic)UIButton *right;
@property (nonatomic,weak)UIView *bottomView;
@property (nonatomic,weak)UIButton *addBtn;

@property (nonatomic,strong)NSMutableArray * dataArray;

@property (nonatomic)BOOL orEditor;

@property (nonatomic)AccountModel *accountModel;
@end

@implementation AccountManageViewController
//#pragma mark  --- 懒加载表视图
//- (UITableView *)accountListView {
//    if (!_accountListView) {
//        UITableView *accountListView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
//        [self.view addSubview:_accountListView = accountListView];
//    }
//    return _accountListView;
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self AccountRequest];

}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self loadData];
    // Do any additional setup after loading the view.
    [self initRightBarButton];
    [self initMainView];
    [self initLeftBarButton];
    _orEditor = 1;// --- 1,非编辑状态 --- 0, 编辑状态 ----
    self.dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    
}

#pragma mark --- 请求 ---

- (void)AccountRequest {
    [ProgressHud addProgressHudWithView:self.view andWithTitle:@"加载中"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/ReferrerMember/GetAccountBanks",TEST_URL];
  
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:[UserManager getMyObjectForKey:userIDKey] forKey:@"MemberID"];
    [dict setObject:self.AccountID forKey:@"AccountID"];
    [dict setObject:[UserManager getMyObjectForKey:accessTokenKey] forKey:@"token"];
    
    NSString * realSign = [HttpTool returnForSign:dict];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"MemberID"] = [UserManager getMyObjectForKey:userIDKey];
    dic[@"AccountID"] = self.AccountID;
    dic[@"token"] = [UserManager getMyObjectForKey:accessTokenKey];
    dic[@"sign"] = realSign;
    
    [HttpTool post:urlStr params:dic success:^(id json) {
        
        [ProgressHud hideProgressHudWithView:self.view];
        NSArray * array = json[@"data"];
        self.dataArray = [NSMutableArray array];
            if (![array isKindOfClass:[NSNull class]] && array
                .count > 0){
                for (int i = 0; i < array.count; i++) {
                    NSDictionary *diction = array[i];
                    self.accountModel = [AccountModel accountModel:diction];
                    [self.dataArray addObject:self.accountModel];
                }
                [self.accountListView reloadData];
            }
    } failure:^(NSError *error) {
        [ProgressHud hideProgressHudWithView:self.view];

    }];
}



- (void)initLeftBarButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0,0,20,40)];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}


- (void)backTo {
    [self.navigationController popToRootViewControllerAnimated:NO];
}


- (void)initRightBarButton
{
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        self.right = rightButton;
        [self.right setTitle:@"编辑" forState:UIControlStateNormal];
        [self.right setTitleColor:RGB_A(51, 51, 51) forState:UIControlStateNormal];
        [self.right addTarget:self action:@selector(editor) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.right];
        self.navigationItem.rightBarButtonItem = rightBarButton;
}



- (void)initMainView
{
    self.navigationItem.title = @"账户管理";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    
    UITableView *accountListView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-50-5) style:UITableViewStylePlain];
    accountListView.delegate = self;
    accountListView.dataSource = self;
    [accountListView registerClass:[AccountsManageCell class] forCellReuseIdentifier:@"accountCell"];
    
    accountListView.backgroundColor = [UIColor clearColor];
    accountListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 50, ScreenWidth, 50)];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 50,ScreenHeight - 40,100,30)];
    addBtn.backgroundColor = [UIColor colorWithHexString:@"e8103c"];
    [addBtn setTitle:@"新增" forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    addBtn.layer.cornerRadius = 3;
    [addBtn addTarget:self action:@selector(addNewAccount) forControlEvents:UIControlEventTouchUpInside];
    
    accountListView.delegate = self;
    accountListView.dataSource = self;
    accountListView.scrollEnabled = NO;
    
    self.accountListView = accountListView;

    [self.view addSubview:accountListView];
    [self.view addSubview:bottomView];
    [self.view addSubview:addBtn];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountsManageCell *accountCell = [tableView dequeueReusableCellWithIdentifier:@"accountCell"];
    
        AccountModel *model = [self.dataArray objectAtIndex:indexPath.row];
        accountCell.account = model;
        accountCell.delegate = self;

    accountCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return accountCell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (void)deleteuserAccount:(AccountModel *)account
{
    [ProgressHud addProgressHudWithView:self.view andWithTitle:@"加载中"];

    NSString *urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,deleteAccount];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"MemberID"] = [UserManager getMyObjectForKey:userIDKey];
    dic[@"BankID"] = account.BankId;
    dic[@"token"] = [UserManager getMyObjectForKey:accessTokenKey];
    NSString * realSign = [HttpTool returnForSign:dic];
    dic[@"sign"] = realSign;
    [HttpTool post:urlStr params:dic success:^(id json)
     {
         [ProgressHud hideProgressHudWithView:self.view];
         NSLog(@"删除账号 = %@",json);
         NSString *resultCode = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
         if ([resultCode isEqualToString:@"0"])
         {
             [_dataArray removeObject:account];
             // 删完刷新
             [self.accountListView reloadData];
         }
         [TipView remindAnimationWithTitle:json[@"message"]];
     } failure:^(NSError *error)
     {
         [ProgressHud hideProgressHudWithView:self.view];

     }];
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_accountListView.contentOffset.y<0)
    {
        [self.view endEditing:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// 点击事件
- (void)addNewAccount {
    AddNewAccountViewController *addNewVC = [[AddNewAccountViewController alloc]init];
    addNewVC.accountId = self.AccountID;
    [self.navigationController pushViewController:addNewVC animated:YES];
    
}
- (void)editor {
    _orEditor = !_orEditor;
    
    if (_orEditor == 1) {
        [self.right setTitle:@"编辑" forState:UIControlStateNormal];
        NSLog(@"完成状态");
    }else {
        [self.right setTitle:@"完成" forState:UIControlStateNormal];
        NSLog(@"编辑状态");
    }
    for (AccountModel *model in self.dataArray) {
        model.deleteState = _orEditor;
    }
    [self.accountListView reloadData];
    
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
