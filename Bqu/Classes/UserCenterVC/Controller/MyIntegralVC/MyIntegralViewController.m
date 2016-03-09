//
//  MyIntegralViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "MyIntegralViewController.h"
#import "IntegralCell.h"
#import "integralRuleViewController.h"

@interface MyIntegralViewController ()

@end

@implementation MyIntegralViewController
- (void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:animated];
    [self createBackBar];

}
#pragma mark ------------------>   请求数据
- (void)requestData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,getIntergrailUrl];
    NSLog(@"我的积分 %@",urlStr);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"MemberID"] = [NSString stringWithFormat:@"%@",[UserManager getMyObjectForKey:userIDKey]];
    dict[@"token"] = [UserManager getMyObjectForKey:accessTokenKey];
    dict[@"PageNo"] = @"1";
    dict[@"PageSize"] = @"100";
    NSString *type = [NSString stringWithFormat:@"%u",self.Type];
    dict[@"Type"] = type;
    NSString *realSign = [HttpTool returnForSign:dict];
    dict[@"sign"] = realSign;
    [HttpTool post:urlStr params:dict success:^(id json)
     {
         //NSLog(@"我的积分数据:%@",json);
         NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
         if ([resultStr isEqualToString:@"0"])
         {
             [self removeNewView];
             [self.tableView_Base.header endRefreshing];
             self.dictionary_dataSource = [NSDictionary dictionary];
             self.dictionary_dataSource = json[@"data"];
             self.dataArray = [NSMutableArray array];
             NSArray *dataArray = [NSArray array];
             dataArray = self.dictionary_dataSource[@"UserIntegralRecords"];
             if ([self.dictionary_dataSource isKindOfClass:[NSNull class]])
             {
                 self.viewBlank.hidden = NO;
                 self.tableView_Base.hidden = YES;
             }
             else
             {
                 self.viewBlank.hidden = YES;
                 self.tableView_Base.hidden = NO;
                 for (NSDictionary *dict in dataArray)
                 {
                     Integral_Model *integral = [Integral_Model parseDataWithDictionary:dict];
                     [self.dataArray addObject:integral];
                 }
                 [self.tableView_Base reloadData];
             }

         }
         else
         {
             [self addAlertView];
         }
      } failure:^(NSError *error)
     {
         [self hideLoadingView];
         [self.tableView_Base.header endRefreshing];
         [self addNetView];
     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB_A(240, 238, 238);
    self.navigationItem.title = @"我的积分";
    
    /*导航栏右按钮积分规则*/
    [self setintegralRule];
    // 初始化选项卡
    [self initScrollView];
    // 初始化空位置
    [self blankView];
    
    if ([self.isLogin isEqualToString:@"0"])
    {
        //网络请求
        [self requestData];
        // 初始化表格
        [self initTableView];
    }
    else
    {
        self.viewBlank.hidden = NO;
    }

 

}

- (void)setintegralRule
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(RuleClicked) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 60, 21);
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"积分规则" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

}
- (void)RuleClicked
{
    integralRuleViewController *rule = [[integralRuleViewController alloc] init];
    rule.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rule animated:NO];
}



#pragma mark    ------------------>   表
- (void)initTableView
{
    self.tableView_Base = [[UITableView alloc] initWithFrame:CGRectMake(0,self.scrollView.frame.size.height + 48 , ScreenWidth, ScreenHeight  - self.scrollView.frame.size.height-64-48) style:UITableViewStylePlain];
    self.tableView_Base.delegate = self;
    self.tableView_Base.dataSource = self;
    self.tableView_Base.backgroundColor = RGB_A(236, 236, 236);
    self.tableView_Base.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView_Base registerNib:[UINib nibWithNibName:@"IntegralCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:self.tableView_Base];
    
    //下拉刷新
    self.tableView_Base.header.backgroundColor = [UIColor colorWithHexString:@"#f2f1f1"];
    self.tableView_Base.header = [DIYHeader headerWithRefreshingBlock:^{
        [self requestData];
    }];

}


#pragma mark -- > TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


#pragma mark    ------------> 设置区头区尾视图
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


#pragma mark    ------------>单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cellID";
    
    IntegralCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    Integral_Model *integral = self.dataArray[indexPath.row];
    if (indexPath.row == 0)
    {
        cell.line_View.hidden = YES;
    }
    else
    {
        cell.line_View.hidden = NO;
    }

    cell.TypeName.text = integral.TypeName;
    cell.Data.text = integral.Date;
    cell.Remark.text = integral.ReMark;
 
    if (self.Type == 0)
    {
        if([integral.Integral rangeOfString:@"-"].location == NSNotFound)
        {
            cell.Integral.textColor = [UIColor colorWithHexString:@"DB0022"];
            cell.Integral.text = [NSString stringWithFormat:@"+%@",integral.Integral];
        }
        else
        {
            cell.Integral.textColor = [UIColor colorWithHexString:@"378D2F"];
            cell.Integral.text = [NSString stringWithFormat:@"%@",integral.Integral];

        }
    }
    else if (self.Type == 1)
    {
        cell.Integral.textColor = [UIColor colorWithHexString:@"DB0022"];
        cell.Integral.text = [NSString stringWithFormat:@"+%@",integral.Integral];

    }
    else if(self.Type == 2)
    {
        cell.Integral.textColor = [UIColor colorWithHexString:@"378D2F"];
        cell.Integral.text = [NSString stringWithFormat:@"%@",integral.Integral];

    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    return cell;
}



- (void)initScrollView
{
    /*红色视图*/
    self.integralView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 48)];
    self.integralView.backgroundColor = RGB_A(226, 16, 54);
    [self.view addSubview:self.integralView];
    /*红色视图上的我的积分*/
    UILabel * tip_Lab= [[UILabel alloc] initWithFrame:CGRectMake(20, 9,50, 30)];
    tip_Lab.textColor = [UIColor whiteColor];
    tip_Lab.font = [UIFont systemFontOfSize:12];
    tip_Lab.font =[UIFont fontWithName:@"Helvetica-Bold" size:12];
    tip_Lab.text = @"我的积分";
    [self.integralView addSubview:tip_Lab];
    /*红色视图上的我的积分数据*/
    UILabel * integral_Lab= [[UILabel alloc] initWithFrame:CGRectMake(tip_Lab.frame.size.width+20 , 9, 150, 30)];
    integral_Lab.textColor = [UIColor whiteColor];
    integral_Lab.font = [UIFont systemFontOfSize:17];
    integral_Lab.font =[UIFont fontWithName:@"Helvetica-Bold" size:17];
    integral_Lab.text = self.initalIntegral;
    [self.integralView addSubview:integral_Lab];
    /*顶部滑动视图*/
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 48, ScreenWidth, 42 )];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    /*滑动视图上的三个按钮*/
    self.array_button = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray * buttonTitleArray = [NSArray arrayWithObjects:@"全部",@"收入",@"支出", nil];
    for (int i = 0; i < buttonTitleArray.count; i ++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(ScreenWidth/3.0 * i, 0, ScreenWidth/3.0, 42);
        [button setTitle:buttonTitleArray [i] forState:UIControlStateNormal];
        button.tag = i+10000;
        button.titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:17];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick_float:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.scrollView addSubview:button];
        [self.array_button addObject:button];
        /*初始化第一个按钮*/
        if (i == 0)
        {
            self.lineView = [[UIView alloc] init];
            self.lineView.bounds = CGRectMake(0, 0, ScreenWidth/3, 1);
            self.lineView.center = CGPointMake(button.center.x, 41);
            self.lineView.backgroundColor = RGB_A(240, 72, 90);
            [self.scrollView addSubview:self.lineView];
            [button setTitleColor:[UIColor colorWithRed:240 / 255.0 green:72 / 255.0 blue:90 / 255.0 alpha:1] forState:UIControlStateNormal];
        }
    }
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 41, ScreenWidth, 1)];
    line.backgroundColor = RGB_A(210, 210, 210);
    [self.scrollView addSubview:line];
    [self.scrollView bringSubviewToFront:self.lineView];
    [self.view addSubview:self.scrollView];

}

#pragma mark    ---->移动后的按钮
- (void)buttonClick_float:(UIButton *)button
{
    self.Type = (int)button.tag-10000;
    
    for (UIButton * button in self.array_button)
    {
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [button setTitleColor:[UIColor colorWithRed:240 / 255.0 green:72 / 255.0 blue:90 / 255.0 alpha:1] forState:UIControlStateNormal];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.lineView.center = CGPointMake(button.center.x, 41);
    [UIView commitAnimations];
    self.buttonTag = button.tag;
    NSLog(@"self.buttonTag = %ld",self.buttonTag);
    if ([self.isLogin isEqualToString:@"0"])
    {
        [self requestData];
    }
}


- (void)blankView
{
    self.viewBlank = [[UIView alloc] initWithFrame:CGRectMake(0,self.scrollView.frame.size.height , ScreenWidth, ScreenHeight  - self.scrollView.frame.size.height)];
    self.viewBlank.backgroundColor = RGB_A(240, 238, 238);
    [self.view addSubview:self.viewBlank];
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.bounds = CGRectMake(0, 0, 80,80);
    imageView.center = CGPointMake(ScreenWidth / 2.0, ScreenHeight / 5.0 );
    imageView.image = [UIImage imageNamed:@"empty"];
    [self.viewBlank addSubview:imageView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth / 2.0 - 100, imageView.frame.size.height + imageView.frame.origin.y + 20, 200, 44)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:15];
    label.font =[UIFont fontWithName:@"Helvetica-Bold" size:15];
    label.text = @"您目前没有的积分哦~";
    [self.viewBlank addSubview:label];

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
