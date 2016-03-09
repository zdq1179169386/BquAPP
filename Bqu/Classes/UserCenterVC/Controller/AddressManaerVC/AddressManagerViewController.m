//
//  AddressManagerViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "AddressManagerViewController.h"
#import "MyAddressCell.h"
#import "AddAddressViewController.h"
#import "LoginViewController.h"
#import "MyTool.h"
#import "HttpEngine.h"
@interface AddressManagerViewController ()

@end

@implementation AddressManagerViewController

- (void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:animated];
    [self createBackBar];
    
    //每次进入详情页，都需判断，用户是否登录
    [HttpTool testUserIsOnlineSuccess:^(BOOL msg) {
        if (msg==YES) {
            self.isLogin = @"0";
            [self requestData];

        }else
        {
            self.isLogin = @"1";

        }
    }];
}
#pragma mark
#pragma mark    ----> 请求数据
- (void)requestData
{
//    { "MemberID": "15","token": "555","sign": "123123"}
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,getAddresslUrl];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"MemberID"] = [UserManager getMyObjectForKey:userIDKey];
    dict[@"token"] = [UserManager getMyObjectForKey:accessTokenKey];
    NSString *realSign = [HttpTool returnForSign:dict];
    dict[@"sign"] = realSign;
    [HttpTool post:urlStr params:dict success:^(id json)
     {
         [self.tableView.header endRefreshing];
         NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
         if ([resultStr isEqualToString:@"0"])
         {
             [self removeNewView];
             NSLog(@"地址  = %@",json);
             if ((NSNull *)json[@"data"] != [NSNull null])
             {
                 NSArray *dataArray = [NSArray array];
                 dataArray = json[@"data"];
                 if (dataArray.count == 0)
                 {
                     self.viewBlank.hidden = NO;
                     self.tableView.hidden = YES;
                     UIView *view = [ self.view viewWithTag:1111];
                     view.hidden = YES;
                 }
                 else
                 {
                     self.viewBlank.hidden = YES;
                     self.tableView.hidden = NO;
                     
                     UIView *view = [ self.view viewWithTag:1111];
                     [view removeFromSuperview];
                     //添加地址按钮
                     UIView *addAddress_View = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-44-64, ScreenWidth, 44)];
                     addAddress_View.tag = 1111;
                     addAddress_View.backgroundColor = [UIColor whiteColor];
                     [self.view addSubview:addAddress_View];
                     
                     UIButton *addAddress_Button = [UIButton buttonWithType:UIButtonTypeCustom];
                     addAddress_Button.frame = CGRectMake(ScreenWidth/2-99/2, 7, 99, 30);
                     addAddress_Button.backgroundColor = [UIColor colorWithHexString:@"#e8103c"];
                     [addAddress_Button onlyCornerRadius];
                     addAddress_Button.titleLabel.font = [UIFont systemFontOfSize:12];
                     [addAddress_Button setTitle:@"+ 添加新地址" forState:UIControlStateNormal];
                     [addAddress_Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                     [addAddress_Button addTarget:self action:@selector(addAddressButtonClick) forControlEvents:UIControlEventTouchUpInside];
                     [addAddress_View addSubview:addAddress_Button];
                     
                     self.dataArray = [NSMutableArray array];
                     Address_Model *defaultAddress;
                     for (NSDictionary *dict in dataArray)
                     {
                         Address_Model *address_Model = [Address_Model parseDataWithDictionary:dict];
                         if ([address_Model.IsDefault isEqualToString:@"0"])
                         {
                             [self.dataArray addObject:address_Model];
                         }
                         else
                         {
                             defaultAddress = address_Model;
                         }
                     }
                     if (defaultAddress)
                     {
                         [self.dataArray insertObject:defaultAddress atIndex:0];
                         
                     }

                     [self.tableView reloadData];
                 }
             }
             else
             {
                 [TipView remindAnimationWithTitle:json[@"message"]];
             }
         }
         else
         {
             [self addAlertView];
         }
    } failure:^(NSError *error)
     {
         [self hideLoadingView];
         [self.tableView.header endRefreshing];
         [self addNetView];
     }];

}

#pragma mark
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"收货地址管理";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F0F1"];
    
    // 初始化空位置
    [self blankView];
    
    /**未登录状态下,显示空视图**/
    if ([self.isLogin isEqualToString:@"1"])
    {
        self.viewBlank.hidden = NO;
    }
    else
    {
        self.viewBlank.hidden = YES;
        [self initTableView];
    }
    
}

#pragma mark
#pragma mark    ------------>   初始化表

- (void)initTableView
{
    if (self.tableView != nil)
    {
        return;
    }
    else
    {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-60- 49) style:UITableViewStyleGrouped];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerNib:[UINib nibWithNibName:@"MyAddressCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        [self.view addSubview:self.tableView];

    }
    
    //下拉刷新
    self.tableView.header.backgroundColor = [UIColor colorWithHexString:@"#f2f1f1"];
    self.tableView.header = [DIYHeader headerWithRefreshingBlock:^{
        [self requestData];
    }];

}

#pragma mark
#pragma mark    ---->  表的代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyAddressCell *cell = (MyAddressCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height ;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
       return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    footer.backgroundColor = [UIColor colorWithHexString:@"#F2F0F1"];
    return footer;
}
#pragma mark    ---->  表的数据源


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";

    MyAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];;
    Address_Model *addressModel = [self.dataArray objectAtIndex:indexPath.section];
    cell.delegate = self;
    cell.model = addressModel;
    
    if (indexPath.section == 0)
    {
        cell.topLine.hidden = YES;
    }
    else
    {
        cell.topLine.hidden = NO;
    }
    CGSize size = [cell.userAddress_Lab.text sizeWithFont:[UIFont systemFontOfSize:12] maxW:ScreenWidth-25-25];
    [cell setFrame:CGRectMake(0, 0, ScreenWidth, size.height+96)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Address_Model *addressModel = [self.dataArray objectAtIndex:indexPath.section];

    
    AddAddressViewController *addVC = [[AddAddressViewController alloc] init];
    addVC.hidesBottomBarWhenPushed = YES;
    addVC.status = 1;
    addVC.firstT = addressModel.ShipTo;
    addVC.twoT = addressModel.Phone;
    addVC.threeT = addressModel.IDCard;
    addVC.fourT = addressModel.RegionFullName;
    addVC.fiveT = addressModel.Address;
    addVC.addressId = addressModel.addressId;
    addVC.fourText = addressModel.RegionId;
    [self.navigationController pushViewController:addVC animated:NO];

}

#pragma mark
#pragma mark    ----> 空视图
- (void)blankView
{
    self.viewBlank = [[UIView alloc] initWithFrame:CGRectMake(0,0 , ScreenWidth, ScreenHeight)];
    self.viewBlank.backgroundColor = RGB_A(240, 238, 238);
    self.viewBlank.userInteractionEnabled = YES;
    [self.view addSubview:self.viewBlank];
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.bounds = CGRectMake(0, 0, 80,80);
    imageView.center = CGPointMake(ScreenWidth / 2.0, ScreenHeight / 5);
    imageView.image = [UIImage imageNamed:@"address"];
    [self.viewBlank addSubview:imageView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth / 2.0 - 100, imageView.frame.size.height + imageView.frame.origin.y + 20, 200, 44)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.font =[UIFont systemFontOfSize:12];
    label.numberOfLines =2;
    label.textColor = [UIColor colorWithHexString:@"#888888"];
    label.text = @"您没有收货地址哦~ 快来添加一个吧";
    [self.viewBlank addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.bounds = CGRectMake(0, 0, 98, 43);
    btn.center = CGPointMake(ScreenWidth/2, imageView.center.y+180);
    btn.backgroundColor = RGB_A(226, 16, 54);
    [btn setTitle:@"添加新地址" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addAddressButtonClick) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:17];
    [btn onlyCornerRadius];
    [self.viewBlank addSubview:btn];

}


#pragma mark
#pragma mark    ----> 默认地址按钮点击事件
- (void)setDefaultAddress:(UIButton *)button
{
    MyAddressCell * cell = nil;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        cell = (MyAddressCell *)[[[button superview] superview] superview];
    }
    else
    {
        cell = (MyAddressCell *)[[button superview] superview];
    }
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    Address_Model *address = self.dataArray[path.section];
    
    [HttpEngine setDefaultAddressWithAddressId:address.addressId success:^(id json)
     {
         [self requestData];
        [TipView remindAnimationWithTitle:json[@"message"]];
     } failure:^(NSError *error)
     {
     
     }];
}

#pragma mark    ----> 删除地址按钮点击事件
- (void)deleteAddress:(UIButton *)button
{
    MyAddressCell * cell = nil;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        cell = (MyAddressCell *)[[[button superview] superview] superview];
    }
    else
    {
        cell = (MyAddressCell *)[[button superview] superview];
    }
    NSIndexPath * path = [self.tableView indexPathForCell:cell];

    UIAlertView *aa = [[UIAlertView alloc] initWithTitle:@"确认删除" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    aa.tag = path.section;
    [aa show];

}

#pragma mark    ----> 删除地址按钮弹出的框
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,deleteAddresslUrl];
         
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"MemberID"] = [UserManager getMyObjectForKey:userIDKey];
            dict[@"token"] = [UserManager getMyObjectForKey:accessTokenKey];
            Address_Model *address = self.dataArray[alertView.tag];
            dict[@"AddressID"] = address.addressId;
         
            NSString *realSign = [HttpTool returnForSign:dict];
            dict[@"sign"] = realSign;
            [HttpTool post:urlStr params:dict success:^(id json)
             {
                 NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
                 if ([resultStr isEqualToString:@"0"])
                 {
                     [self requestData];
         
                     if (self.dataArray.count == 0)
                     {
                         UIView *view = [ self.view viewWithTag:1111];
                         view.hidden = YES;
                     }
         
                       [TipView remindAnimationWithTitle:json[@"message"]];
                 }
                 else
                 {
                     
                 }
             }
                   failure:^(NSError *error)
             {
                 
             }];
     }
}


#pragma mark    ----> 添加地址按钮点击事件
- (void)addAddressButtonClick
{
    if ([self.isLogin isEqualToString:@"0"])
    {
        NSLog(@"这是一个测试语句%s",__FUNCTION__);
        AddAddressViewController *addVC = [[AddAddressViewController alloc] init];
        addVC.hidesBottomBarWhenPushed = YES;
        addVC.status = 0;
        [self.navigationController pushViewController:addVC animated:NO];

    }
    else
    {
          [TipView remindAnimationWithTitle:@"您还没有登陆哦~"];
         
        
        [TipView doSomething:^
         {
             LoginViewController *loginVC= [[LoginViewController alloc] init];
             loginVC.hidesBottomBarWhenPushed = YES;
             [self.navigationController pushViewController:loginVC animated:NO];
             
         } afterDelayTime:1];

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

#pragma mark

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
