//
//  AddNewAccountViewController.m
//  Bqu
//
//  Created by WONG on 15/12/9.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "AddNewAccountViewController.h"
#import "AddAcountTableViewCell.h"
@interface AddNewAccountViewController ()
{
    NSString *_accountType; /*1是支付宝，2是银行卡*/
    NSArray *alipayArray;
    NSArray *bankArray;
    NSArray *accountArray;
    
    NSString *_Type;
    NSString *_TypeName;
    NSString *_AccountNumber;
    NSString *_BankBranch;
    NSString *_BankCardNumber;
    NSString *_CellPhone;
    NSString *_RealName;
 
    
}
@property (nonatomic)UITableView *tableView;
@property (nonatomic,strong)NSArray *titleArray;



@end

@implementation AddNewAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F1F1"];
    
    self.titleArray = [[NSArray alloc] initWithObjects:@"支付宝",@"银行卡",nil];
    _accountType = @"2";
    bankArray = [[NSArray alloc] initWithObjects:@"账户类型",@"开户行名称",@"开户行支行",@"银行卡号",@"姓名",@"手机", nil];
    alipayArray = [[NSArray alloc] initWithObjects:@"账户类型",@"支付宝账号",@"姓名",@"手机", nil];
    accountArray = [NSArray arrayWithArray:bankArray];
    
    
    [self initTable];
    [self setCommitBtn];
    
}
- (void)initTable {
    self.title = @"账户管理";
    
    UIButton * backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 294+64+1)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [[UIView alloc] init];
        [self.tableView registerNib:[UINib nibWithNibName:@"AddAcountTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.scrollEnabled = NO;
        
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.tableView];
    }
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_accountType isEqualToString:@"1"])
    {
        return 4;
    }
    else
    {
        return 6;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    header.backgroundColor = [UIColor colorWithHexString:@"fcf7dd"];
    
    UIImageView *warningImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 12, 12)];
    warningImg.image = [UIImage imageNamed:@"提示"];
    [header addSubview:warningImg];
    
    UILabel *tips = [[UILabel alloc] initWithFrame:CGRectMake(30, 9, ScreenWidth/2, 12)];
    tips.font = [UIFont systemFontOfSize:10];
    tips.textColor = [UIColor colorWithHexString:@"f21f42"];
    tips.text = @"请填写以下信息，用于提现等功能。";
    [header addSubview:tips];

    return header;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddAcountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row == 0)
    {
        cell.accountInfo.hidden = YES;
        [cell.arrowBtn addTarget:self action:@selector(selectAccountType) forControlEvents:UIControlEventTouchUpInside];
        [cell.arrowBtn setTitle:[_accountType isEqualToString:@"1"]?@"支付宝":@"银行卡" forState:UIControlStateNormal];
    }
    else
    {
        cell.arrowBtn.hidden = YES;
        cell.arrowImg.hidden = YES;
    }
    cell.accountName.text = accountArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)selectAccountType
{    
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    ApplyForRefundAlertView *alertView = [[ApplyForRefundAlertView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth, ScreenHeight)withDelegate:self withTitle:@"请选择账户类型" withArray:self.titleArray withIndexPath:0];
    [window addSubview:alertView];
}

- (void)ApplyForRefundAlertViewBtnClick:(ApplyForRefundAlertView *)view withStr:(NSString *)title withIndexPath:(NSIndexPath *)index withRow:(int)row
{
    if (row == 0)
    {
       _accountType = @"1";
    }
    else if(row == 1)
    {
        _accountType = @"2";

    }
    accountArray = [NSArray arrayWithArray:[_accountType isEqualToString:@"1"]?alipayArray:bankArray];


    [self.tableView reloadData];
}


- (void)setCommitBtn
{
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake(10, self.tableView.frame.origin.y+self.tableView.frame.size.height+18, ScreenWidth-20, 33);
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    commitBtn.backgroundColor = [UIColor colorWithHexString:@"#f62648"];
    commitBtn.layer.cornerRadius = 6;
    commitBtn.layer.borderColor = [UIColor colorWithHexString:@"#ee1c3f"].CGColor;
    commitBtn.layer.borderWidth = 1;
    [commitBtn addTarget:self action:@selector(commitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
}

- (void)commitClick
{
    [self.view endEditing:YES];
    NSIndexPath * index1 = [NSIndexPath indexPathForRow:1 inSection:0];
    AddAcountTableViewCell * cell1 = (AddAcountTableViewCell *)[self.tableView cellForRowAtIndexPath:index1];
    
    NSIndexPath * index2 = [NSIndexPath indexPathForRow:2 inSection:0];
    AddAcountTableViewCell * cell2 = (AddAcountTableViewCell *)[self.tableView cellForRowAtIndexPath:index2];
    
    NSIndexPath * index3 = [NSIndexPath indexPathForRow:3 inSection:0];
    AddAcountTableViewCell * cell3 = (AddAcountTableViewCell *)[self.tableView cellForRowAtIndexPath:index3];
    
    NSIndexPath * index4 = [NSIndexPath indexPathForRow:4 inSection:0];
    AddAcountTableViewCell * cell4 = (AddAcountTableViewCell *)[self.tableView cellForRowAtIndexPath:index4];
    
    NSIndexPath * index5 = [NSIndexPath indexPathForRow:5 inSection:0];
    AddAcountTableViewCell * cell5 = (AddAcountTableViewCell *)[self.tableView cellForRowAtIndexPath:index5];

    if ([_accountType isEqualToString:@"1"])
    {
        if ([cell1.accountInfo.text isEqualToString:@""] || [cell2.accountInfo.text isEqualToString:@""] ||[cell3.accountInfo.text isEqualToString:@""] )
        {
            [TipView remindAnimationWithTitle:@"要输入完整信息哦"];
        }
        else
        {
            _AccountNumber = cell1.accountInfo.text;
            _RealName = cell2.accountInfo.text;
            _CellPhone = cell3.accountInfo.text;
            _BankBranch = @"";
            _BankCardNumber  = @"";
//            _bankName = @"";
            _TypeName = @"支付宝";
            [self requestData];
        }
    }
    else
    {
        if ([cell1.accountInfo.text isEqualToString:@""] || [cell2.accountInfo.text isEqualToString:@""] ||[cell3.accountInfo.text isEqualToString:@""] ||[cell4.accountInfo.text isEqualToString:@""] ||[cell5.accountInfo.text isEqualToString:@""] )
        {
            [TipView remindAnimationWithTitle:@"要输入完整信息哦"];
        }
        else
        {
            _TypeName = cell1.accountInfo.text;
            _BankBranch = cell2.accountInfo.text;
            _BankCardNumber = cell3.accountInfo.text;
            _RealName = cell4.accountInfo.text;
            _CellPhone = cell5.accountInfo.text;
            _AccountNumber = @"";

            [self requestData];
        }
    }
}

- (void)requestData
{
    NSString *url = [NSString stringWithFormat:@"%@%@",bquUrl,addAccount];
    //    "MemberID":"5","AccountID":"69","RealName":"XXX","Type":"1","TypeName":"支付宝","AccountNumber":"asdad@qq.com","BankBranch":"","BankCardNumber":"","CellPhone":"18657119239","token":"iFKGu8IfoSFNLRHfNgQ/PFE1vVkXMgB8GINnifeg28AGQvDtPRXV6I2ui1P1uV9n","sign":"FFD8C437F5D35A6EB9FD777268FF5AC4"
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"MemberID"] = [UserManager getMyObjectForKey:userIDKey];
    dict[@"token"] = [UserManager getMyObjectForKey:accessTokenKey];
    dict[@"AccountID"] = self.accountId;
    dict[@"Type"] = _accountType;
    dict[@"TypeName"] = _TypeName;
    dict[@"AccountNumber"] = _AccountNumber;
    dict[@"BankBranch"] = _BankBranch;
    dict[@"BankCardNumber"] = _BankCardNumber;
    dict[@"CellPhone"] = _CellPhone;
    dict[@"RealName"] = _RealName;
    NSString *realSign = [HttpTool returnForSign:dict];
    dict[@"sign"] = realSign;
    
    [HttpTool post:url params:dict success:^(id json)
     {
         NSLog(@"添加账户 = %@",json);
         NSLog(@"dic = %@",dict);
         NSString *resultCode = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
         if ([resultCode isEqualToString:@"0"])
         {
             [self.navigationController popViewControllerAnimated:NO];
             [TipView remindAnimationWithTitle:@"添加成功"];
         }
         else{
             [TipView remindAnimationWithTitle:json[@"message"]];

         }
         
     } failure:^(NSError *error)
     {
         
     }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
