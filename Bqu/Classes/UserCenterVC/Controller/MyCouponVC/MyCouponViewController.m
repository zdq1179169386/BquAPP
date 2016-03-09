//
//  MyCouponViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "MyCouponViewController.h"
#import "CouponCell.h"
#import "CouponRuleViewController.h"
#import "LoginViewController.h"

@interface MyCouponViewController ()

@end

@implementation MyCouponViewController

- (void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:animated];
    [self createBackBar];
    //每次进入详情页，都需判断，用户是否登录
    [HttpTool testUserIsOnlineSuccess:^(BOOL msg)
    {
        if (msg==YES)
        {
            self.isLogin = @"0";
        }else
        {
            self.isLogin = @"1";
        }
    }];

 
}
#pragma mark    ------------------>   请求数据
- (void)requestData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,getCouponlUrl];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"MemberID"] = [NSString stringWithFormat:@"%@",[UserManager getMyObjectForKey:userIDKey]];
    dict[@"token"] = [UserManager getMyObjectForKey:accessTokenKey];
    dict[@"PageNo"] = @"1";
    dict[@"PageSize"] = @"100";
    NSString *status = [NSString stringWithFormat:@"%u",self.Status];
    NSLog(@"类型%@",status);
    dict[@"Status"] = status;
    
    NSString *realSign = [HttpTool returnForSign:dict];
    dict[@"sign"] = realSign;
    [HttpTool post:urlStr params:dict success:^(id json)
     {
         [self.tableView_Base.header endRefreshing];
         
         NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
         if ([resultStr isEqualToString:@"0"])
         {
             [self removeNewView];
             NSArray *dataArray = [NSArray array];
             dataArray = json[@"data"];
             
             if (![dataArray isKindOfClass:[NSNull class]])
             {
                 if (dataArray.count == 0)
                 {
                     self.viewBlank.hidden = NO;
                     self.dataArray = [NSMutableArray array];
                     self.tableView_Base.hidden = YES;
                     if (self.Status == 1 || self.Status ==2)
                     {
                         self.viewBlank.hidden = YES;
                     }
                     UIView *view = [ self.view viewWithTag:1111];
                     view.hidden = YES;
                 }
                 else
                 {
                     UIView *view = [ self.view viewWithTag:1111];
                     [view removeFromSuperview];
                     //优惠券兑换按钮
                     UIView *coupon_View = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-61-64, ScreenWidth, 61)];
                     coupon_View.tag = 1111;
                     coupon_View.backgroundColor = [UIColor whiteColor];
                     [self.view addSubview:coupon_View];
                     
                     UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
                     line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
                     [coupon_View addSubview:line];
                     
                     UIButton *loginOut_Button = [UIButton buttonWithType:UIButtonTypeCustom];
                     loginOut_Button.frame = CGRectMake(10, 10, ScreenWidth-20, 41);
                     loginOut_Button.layer.cornerRadius = 6;
                     loginOut_Button.layer.borderColor = [UIColor colorWithHexString:@"#E8103C"].CGColor;
                     loginOut_Button.layer.borderWidth = 1;
                     [loginOut_Button setTitle:@"马上去兑换" forState:UIControlStateNormal];
                     loginOut_Button.titleLabel.font = [UIFont systemFontOfSize:15];
                     [loginOut_Button setTitleColor:[UIColor colorWithHexString:@"#E8103C"] forState:UIControlStateNormal];
                     [loginOut_Button addTarget:self action:@selector(exchangeButtonClick) forControlEvents:UIControlEventTouchUpInside];
                     [coupon_View addSubview:loginOut_Button];
                     
                     
                     self.tableView_Base.hidden = NO;
                     self.viewBlank.hidden = YES;
                     self.dataArray = [NSMutableArray array];
                     for (NSDictionary *dict in dataArray)
                     {
                         Coupon_Model *coupon = [Coupon_Model parseDataWithDictionary:dict];
                         [self.dataArray addObject:coupon];
                     }
                     
                     [self.tableView_Base reloadData];
                 }
                 
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
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F0F1"];
    self.navigationItem.title = @"我的优惠券";
    
    //导航栏右按使用说明
    [self setCouponRule];
    // 初始化选项卡
    [self initScrollView];
    // 初始化空位置
    [self blankView];
    if ([self.isLogin isEqualToString:@"1"])
    {
        self.viewBlank.hidden = NO;
    }
    else
    {
        self.viewBlank.hidden = YES;
        [self requestData];
        //初始化主界面表
        [self initTableView];
    }


}


- (void)setCouponRule
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(RuleClicked) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 60, 21);
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"使用说明" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
}

- (void)RuleClicked
{
    CouponRuleViewController *rule = [[CouponRuleViewController alloc] init];
    rule.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rule animated:NO];
}


- (void)initScrollView
{
    self.array_button = [[NSMutableArray alloc] initWithCapacity:0];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 42)];
    NSArray * buttonTitleArray = [NSArray arrayWithObjects:@"未使用",@"已使用",@"已过期", nil];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
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
        if (i == 0)
        {
            self.lineView = [[UIView alloc] init];
            self.lineView.bounds = CGRectMake(0, 0, 50, 2);
            self.lineView.center = CGPointMake(button.center.x, 41);
            self.lineView.backgroundColor = RGB_A(240, 72, 90);
            self.lineView.layer.cornerRadius = 3;
            self.lineView.clipsToBounds = YES;
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

- (void)blankView
{
    self.viewBlank = [[UIView alloc] initWithFrame:CGRectMake(0,self.scrollView.frame.size.height , ScreenWidth, ScreenHeight  - self.scrollView.frame.size.height)];
    self.viewBlank.backgroundColor = RGB_A(240, 238, 238);
    [self.view addSubview:self.viewBlank];
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.bounds = CGRectMake(0, 0, 80,80);
    imageView.center = CGPointMake(ScreenWidth / 2.0, ScreenHeight /5.5);
    imageView.image = [UIImage imageNamed:@"我的收藏为空"];
    [self.viewBlank addSubview:imageView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth / 2.0 - 100, imageView.frame.size.height + imageView.frame.origin.y + 20, 200, 44)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:15];
    label.font =[UIFont fontWithName:@"Helvetica-Bold" size:15];
    label.numberOfLines =2;
    label.text = @"您没有可以使用的优惠券哦~ 请使用兑换码兑换";
    [self.viewBlank addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.bounds = CGRectMake(0, 0, 120, 43);
    btn.center = CGPointMake(ScreenWidth/2, imageView.center.y+180);
    btn.backgroundColor = RGB_A(226, 16, 54);
    [btn setTitle:@"马上去兑换" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(exchangeButtonClickno) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:17];
    [btn onlyCornerRadius];
    [self.viewBlank addSubview:btn];
    
}

- (void)buttonClick_float:(UIButton *)button
{
    for (UIButton * button in self.array_button)
    {
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [button setTitleColor:[UIColor colorWithRed:240 / 255.0 green:72 / 255.0 blue:90 / 255.0 alpha:1] forState:UIControlStateNormal];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.lineView.center = CGPointMake(button.center.x, 41);
    [UIView commitAnimations];
    self.Status = (int)button.tag-10000;
    if ([self.isLogin isEqualToString:@"0"])
    {
        [self requestData];
    }
}


#pragma mark    ------------------>   表
- (void)initTableView
{
    if (self.tableView_Base != nil)
    {
        return ;
    }
    else
    {
        self.tableView_Base = [[UITableView alloc] initWithFrame:CGRectMake(0,self.scrollView.frame.size.height, ScreenWidth, ScreenHeight  - self.scrollView.frame.size.height-60-64) style:UITableViewStylePlain];
        self.tableView_Base.delegate = self;
        self.tableView_Base.dataSource = self;
        self.tableView_Base.backgroundColor = RGB_A(236, 236, 236);
        self.tableView_Base.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView_Base registerNib:[UINib nibWithNibName:@"CouponCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
        [self.view addSubview:self.tableView_Base];
        //下拉刷新
        self.tableView_Base.header.backgroundColor = [UIColor colorWithHexString:@"#f2f1f1"];
        self.tableView_Base.header = [DIYHeader headerWithRefreshingBlock:^{
            [self requestData];
        }];
    }
}


#pragma mark -- > TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

#pragma mark    ------------> 设置区头区尾视图
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}


#pragma mark    ------------>单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cellID";
    CouponCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    Coupon_Model *coupon = self.dataArray[indexPath.row];
    
    cell.couponPrice_Lab.text = coupon.Price;
    cell.couponDate_Lab.text = [NSString stringWithFormat:@"使用期限%@",coupon.EndTime];

    cell.couponTip_Lab.text = [NSString stringWithFormat:@"满%0.2f可用(不含运费、税金)",coupon.OrderAmount.doubleValue];
    if (self.Status == 0)
    {
        cell.couponImg_ImgView.image = [UIImage imageNamed:@"you"];
    }
    else if (self.Status == 1)
    {
        cell.couponImg_ImgView.image = [UIImage imageNamed:@"guoqi"];
    }
    else if(self.Status == 2)
    {
        cell.couponImg_ImgView.image = [UIImage imageNamed:@"wu"];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    return cell;
}



- (void)exchangeButtonClick
{
    
    [self exchangeCoupnView];
    
    
}

- (void)exchangeButtonClickno
{
    if ([_isLogin isEqualToString:@"0"])
    {
         [self exchangeCoupnView];
    }
    else
    {
        [TipView remindAnimationWithTitle:@"请先登录哦"];
        
        [TipView doSomething:^
         {
             LoginViewController *loginVC= [[LoginViewController alloc] init];
             loginVC.hidesBottomBarWhenPushed = YES;
             [self.navigationController pushViewController:loginVC animated:NO];
             
         } afterDelayTime:1];

    }
   
}


#pragma mark    ---->    兑换优惠券的灰视图
- (void)exchangeCoupnView
{
    self.window = [[UIApplication sharedApplication].delegate window];
    /**灰色背景**/
    UIView *GrayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    GrayView.backgroundColor = [UIColor colorWithRed:158/255.0 green:158/255.0 blue:158/255.0 alpha:0.6];
    GrayView.tag = 222;
    [self.window addSubview:GrayView];
    /**白色框框**/
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2-247/2, ScreenHeight/2-127/2, 247, 127)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 6;
    whiteView.clipsToBounds = YES;
    [GrayView addSubview:whiteView];
    /**兑换优惠券**/
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(247/2-100/2, 23, 100, 15) ];
    tipLab.backgroundColor = [UIColor clearColor];
    tipLab.text = @"兑换优惠券";
    tipLab.font = [UIFont boldSystemFontOfSize:12];
    tipLab.textColor = [UIColor colorWithHexString:@"#333333"];
    tipLab.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:tipLab];
    /**输入框**/
    UITextField *exchangeTextF = [[UITextField alloc] initWithFrame:CGRectMake(247/2-219/2, 52, 247-28, 23) ];
    exchangeTextF.backgroundColor = [UIColor whiteColor];
    exchangeTextF.layer.borderWidth = 1;
    exchangeTextF.layer.borderColor = [UIColor colorWithHexString:@"#E8103C"].CGColor;
    exchangeTextF.tag = 223;
    exchangeTextF.font = [UIFont boldSystemFontOfSize:12];
    [whiteView addSubview:exchangeTextF];
    /*横线**/
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 87, 247, 1)];
    line1.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    [whiteView addSubview:line1];
    /**竖线**/
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(247/2, 87, 1, 40)];
    line2.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    [whiteView addSubview:line2];
    
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 87, 247/2, 40);
    cancelBtn.backgroundColor = [UIColor clearColor];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [cancelBtn setTitleColor:RGB_A(10, 71, 166) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(yesOrNOButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.tag = 200;
    [whiteView addSubview:cancelBtn];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(247/2, 87, 247/2, 40);
    sureBtn.backgroundColor = [UIColor clearColor];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [sureBtn setTitleColor:RGB_A(10, 71, 166) forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(yesOrNOButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.tag = 201;
    [whiteView addSubview:sureBtn];


}

#pragma mark    ---->兑换优惠券 取消确定
- (void)yesOrNOButtonClick:(UIButton *)button
{
    [self.view endEditing:YES];
    switch (button.tag)
    {
        case 200:
        {
            UIView *view =  [self.window viewWithTag:222];
            [view removeFromSuperview];
        }
            break;
        case 201:
        {
            UITextField *textF = (UITextField *)[self.window viewWithTag:223];
         
            if (![textF.text isEqualToString:@""])
            {
                NSString *urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,ExchangeCouponlUrl];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[@"MemberID"] = [NSString stringWithFormat:@"%@",[UserManager getMyObjectForKey:userIDKey]];
                dict[@"token"] = [UserManager getMyObjectForKey:accessTokenKey];
                dict[@"MemberName"] = [UserManager getMyObjectForKey:userNameKey];
                dict[@"CDK"] = textF.text;
                
                NSString *realSign = [HttpTool returnForSign:dict];
                dict[@"sign"] = realSign;
                [HttpTool post:urlStr params:dict success:^(id json)
                 {
                     NSLog(@"优惠券 == %@",json);

                     [TipView remindAnimationWithTitle:json[@"message"]];
                     NSString *resultCodeStr = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
                     if ([resultCodeStr isEqualToString:@"0"])
                     {
                         [TipView doSomething:^
                          {
                              UIView *view =  [self.window viewWithTag:222];
                              [view removeFromSuperview];
                              [self requestData];

                          }  afterDelayTime:1];
                     }
                 } failure:^(NSError *error)
                 {
                     
                 }];
            }
            else
            {
                   [TipView remindAnimationWithTitle:@"输入不可以为空哦~"];
            }
            
        }
            break;

        default:
            break;
    }
    
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
