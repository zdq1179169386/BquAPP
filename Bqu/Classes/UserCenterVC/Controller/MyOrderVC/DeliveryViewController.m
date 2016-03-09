//
//  DeliveryViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/26.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "DeliveryViewController.h"
#import "LogisticsCell.h"

@interface DeliveryViewController ()

@end

@implementation DeliveryViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self createBackBar];
    [self requestData];
}

#pragma mark    ------------------>   请求数据
- (void)requestData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,getOrderLogisticsInfolUrl];
    NSLog(@"物流 %@",urlStr);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"MemberID"] = [UserManager getMyObjectForKey:userIDKey];
    dict[@"token"] = [UserManager getMyObjectForKey:accessTokenKey];
    dict[@"OrderId"] = self.orderID;
    NSString *realSign = [HttpTool returnForSign:dict];
    dict[@"sign"] = realSign;
    
    [self showLoadingView];
    [HttpTool post:urlStr params:dict success:^(id json)
     {
         [self hideLoadingView];
         NSLog(@"物流数据 %@",json);
         NSLog(@"message %@",json[@"message"]);

         self.expressDict = [NSDictionary dictionary];
         self.expressArr = [NSArray array];
         if ((NSNull*)json[@"data"] != [NSNull null])
         {
             self.dataDict = json[@"data"];
             self.expressDict = json[@"data"][@"Express"];
             self.expressArr = self.expressDict[@"ExpressDataItems"];
             [self.tableView reloadData];
             [self topView];

         }

     }
     failure:^(NSError *error) {
         
         
     }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"物流跟踪";
    self.view.backgroundColor = RGB_A(240, 238, 238);
    [self createMainTable];

}


#pragma mark    ----> 顶部视图
- (void)topView
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    topView.backgroundColor = RGB_A(57, 70, 97);
    
    UIImageView *log_ImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 35, 35)];
    log_ImgView.image = [UIImage imageNamed:@"lt0"];
    [topView addSubview:log_ImgView];
    
    UILabel *tip_Lab = [[UILabel alloc] initWithFrame:CGRectMake(55, 3, 260, 25)];
    tip_Lab.font = [UIFont boldSystemFontOfSize:12];
    tip_Lab.textColor = [UIColor whiteColor];
    tip_Lab.textAlignment = NSTextAlignmentLeft;
    [topView addSubview:tip_Lab];


    UILabel *orderID_Lab = [[UILabel alloc] initWithFrame:CGRectMake(55, 22, 260, 25)];
    orderID_Lab.font = [UIFont boldSystemFontOfSize:12];
    orderID_Lab.textColor = [UIColor whiteColor];
    orderID_Lab.textAlignment = NSTextAlignmentLeft;
    [topView addSubview:orderID_Lab];
    
    tip_Lab.text = [ NSString stringWithFormat:@"%@(物流处理中)",self.dataDict[@"ExpressCompanyName"]];
    orderID_Lab.text =  [ NSString stringWithFormat:@"运单号:%@",self.dataDict[@"ShipOrderNumber"]];
    
    [self.view addSubview:topView];
}


#pragma mark    ----> 表
- (void)createMainTable
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth, ScreenHeight-64-50) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = YES;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"LogisticsCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *tip_Lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, 230, 28)];
    tip_Lab.font = [UIFont systemFontOfSize:12];
    tip_Lab.textColor = [UIColor blackColor];
    tip_Lab.textAlignment = NSTextAlignmentLeft;
    tip_Lab.text = @"订单跟综";
    [view addSubview:tip_Lab];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    topLine.backgroundColor = RGB_A(214, 214, 214);
    [view addSubview:topLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 29, ScreenWidth, 1)];
    bottomLine.backgroundColor = RGB_A(214, 214, 214);
    [view addSubview:bottomLine];
    return view;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.expressArr.count >0)
    {
        return  self.expressArr.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    LogisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    if (indexPath.row == 0)
    {
        cell.mayLine_View.hidden = YES;
        cell.line_View.backgroundColor = [UIColor colorWithHexString:@"#e8103c"];
        cell.log_ImgView.image = [UIImage imageNamed:@"log"];
    }
    else
    {
        cell.mayLine_View.hidden = NO;
        cell.line_View.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
        cell.log_ImgView.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    }

    NSString *isSuccess = [NSString stringWithFormat:@"%@",self.expressDict[@"Success"]];
    NSLog(@"isSuccess%@",isSuccess);
    /*是否获取到物流信息*/
    if ([isSuccess isEqualToString:@"1" ])
    {
        /*物流数组是否有数据*/
        if (self.expressArr.count > 0)
        {
            NSDictionary *dicc = self.expressArr[indexPath.row];
            cell.date_Lab.text = dicc[@"Time"];
            cell.logistics_Lab.text = dicc[@"Content"];

        }
        else
        {
            cell.logistics_Lab.text = @"暂无物流信息";
            cell.date_Lab.text = @"";
            
        }
    }
    else
    {
        cell.logistics_Lab.text = @"暂无物流信息";
        cell.date_Lab.text = @"";
    }
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
