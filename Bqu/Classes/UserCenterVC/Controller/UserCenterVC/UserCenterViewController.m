//
//  UserCenterViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/9.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "UserCenterViewController.h"
#import "LoginViewController.h"
#import "MoreViewController.h"
#import "RegisterViewController.h"
#import "MyOrderViewController.h"
#import "MyCollectViewController.h"
#import "MyCouponViewController.h"
#import "MyIntegralViewController.h"
#import "AddressManagerViewController.h"
#import "RefundViewController.h"
#import "FeedbackViewController.h"

@interface UserCenterViewController ()

@end

@implementation UserCenterViewController
- (void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:animated];
    
    /**在登录情况下,就不需要判断是否登录了**/
    if ([_isLogin isEqualToString:@"0"] && [UserManager getMyObjectForKey:accessTokenKey])
    {
        //调用获取个人信息接口
        [self getUserInfo];
        return ;
    }
    //判断是否登录
    [self refreshLoginView];
    
}

#pragma mark    ------------>请求是否登录
- (void)refreshLoginView
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,isLoginUrl];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[UserManager getMyObjectForKey:accessTokenKey] forKey:@"token"];
    [dic setValue:[UserManager getMyObjectForKey:userIDKey] forKey:@"MemberID"];
    
    NSString *realSign =  [HttpTool returnForSign:dic];
    [dic setValue:realSign forKey:@"sign"];
    [self showLoadingView];

    [HttpTool post:urlStr params:dic success:^(id json)
     {
         //_isLogin接受服务器返回的结果,用来判断是否登录, 0登陆 1未登录
        _isLogin = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
         if ([_isLogin isEqualToString:@"0"])
         {
             //调用获取个人信息接口
             [self getUserInfo];
         }
         else if([_isLogin isEqualToString:@"1"])
         {
             [self hideLoadingView];
            // 未登录状态下，删除用户信息,token，menberID,name
             self.user = nil;
             [UserManager deleteToken];
             [UserManager delegateUserID];
             [UserManager deleteUserName];
             [UserManager deleteIsPromoter];
             [_userTableView reloadData];
         }
         NSLog(@"个人中心是否登陆 0登陆 1未登录---->%@",_isLogin);
     } failure:^(NSError *error)
     {
         [self hideLoadingView];
     }];
    
}
#pragma mark    ------------>请求个人信息
- (void)getUserInfo
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,userInfoUrl];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserManager getMyObjectForKey:userIDKey] forKey:@"MemberID"];
    [dict setValue:[UserManager getMyObjectForKey:accessTokenKey] forKey:@"token"];
    NSString *realSign = [HttpTool returnForSign:dict];
    [dict setValue:realSign forKey:@"sign"];
    [HttpTool post:urlStr params:dict success:^(id json)
    {
        [self hideLoadingView];

        NSLog(@"个人信息数据%@",json);
        if ((NSNull *)json[@"data"] != [NSNull null])
        {
            //解析个人信息数组
            self.user =[User parseUserInfoWithDictionary:json[@"data"]];
            //刷新用户表
            [_userTableView reloadData];
        }
    } failure:^(NSError *error)
     {
         ;
    }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的B区";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F1F1"];
    //设置设置按钮
    [self createSetButton];
    //显示用户表
    [self showUserTable];
}
#pragma mark    ------------> 设置按钮
- (void)createSetButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(setButtonClick) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0 , 0, 22, 22);
    [btn setImage:[UIImage imageNamed:@"设置"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}
#pragma mark    ------------>设置按钮点击事件
- (void)setButtonClick
{
    MoreViewController *moreVC = [[MoreViewController alloc] init];
    moreVC.hidesBottomBarWhenPushed = YES;
    moreVC.isLogin = _isLogin;
    NSString *safe = self.user.TradePassword;
    moreVC.safePsw = safe;                         //判断设置页面安全密码是设置还是修改
    moreVC.phoneNumber = self.user.userPhone;
    [self.navigationController pushViewController:moreVC animated:YES];
}
#pragma mark    ------------>初始化表
- (void)showUserTable
{
    _userTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49) style:UITableViewStyleGrouped];
    _userTableView.backgroundColor = RGB_A(245, 245, 245);
    _userTableView.delegate = self;
    _userTableView.dataSource = self;
    _userTableView.bounces = YES;
    _userTableView.backgroundColor = [UIColor clearColor];
    _userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _userTableView.showsHorizontalScrollIndicator = NO;
    _userTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_userTableView];

    //自定义的cell
    [_userTableView registerNib:[UINib nibWithNibName:@"UserInfoCell" bundle:nil] forCellReuseIdentifier:@"userInfo"];
    [_userTableView registerNib:[UINib nibWithNibName:@"FourButtonCell" bundle:nil] forCellReuseIdentifier:@"fourButton"];
    [_userTableView registerClass:[OrderCouponCell class] forCellReuseIdentifier:@"ordercouponCell"];

    [_userTableView registerNib:[UINib nibWithNibName:@"SimpleCell" bundle:nil] forCellReuseIdentifier:@"simple"];
    [_userTableView registerNib:[UINib nibWithNibName:@"CallCell" bundle:nil] forCellReuseIdentifier:@"call"];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.01;
    }
    
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
   //不知道什么原因,设置为0,就会有很大的误差
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    view.backgroundColor = RGB_A(245, 245, 245);
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 4;
            break;
        case 2:
              return 2;
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierUser = @"userInfo";
    static NSString *identifierSimple = @"simple";
    static NSString *identifierCall = @"call";
 
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
             UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierUser forIndexPath:indexPath];
            [cell setValue];
            if ([_isLogin  isEqual: @"0"])
            {
                // 登录状态下,显示用户昵称，头像，隐藏登陆注册按钮
                //用户头像

                [cell.photo_ImageView sd_setImageWithURL:[NSURL URLWithString:self.user.userPhoto] placeholderImage:[UIImage imageNamed:@"头像"]];
                //用户昵称 默认电话
                cell.userName_Lab.text = self.user.userName;
                if (self.user.userNickName)
                {
                    cell.userName_Lab.text = self.user.userNickName;
                }
                cell.login_Button.hidden = YES;
                cell.register_Button.hidden = YES;
                cell.photo_ImageView.hidden = NO;
                cell.userName_Lab.hidden = NO;
            }
            else
            {
                // 未登录状态下,隐藏用户昵称，头像，显示登陆注册按钮

               [cell.login_Button addTarget:self action:@selector(loginButtionClick) forControlEvents:UIControlEventTouchUpInside];
               [cell.register_Button addTarget:self action:@selector(registerButtionClick) forControlEvents:UIControlEventTouchUpInside];
                cell.login_Button.hidden = NO;
                cell.register_Button.hidden = NO;
                cell.userInteractionEnabled = YES;
                cell.photo_ImageView.hidden = YES;
                cell.userName_Lab.hidden = YES;
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.row == 1)
        {
            OrderCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ordercouponCell"];
            cell.delegate = self;
            //个人中心我的订单,如果有代付款的订单,则会显示红点
            NSString *myOderStr = [NSString stringWithFormat:@"%@",self.user.WaitPayOrder];
            if ([myOderStr isEqualToString:@"0"])
            {
                cell.orderImg.image = [UIImage imageNamed:@"我的订单_不带点"];
            }
            else if ([myOderStr isEqualToString:@"1"])
            {
                cell.orderImg.image = [UIImage imageNamed:@"我的订单_带红点"];
            }

            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        }
    }
    if (indexPath.section == 1)
    {
        SimpleCell *cell= [tableView dequeueReusableCellWithIdentifier:identifierSimple forIndexPath:indexPath];
        
        NSArray *imageArr = @[@"我的优惠券",@"我的积分",@"收货地址管理",@"退款售后"];
        cell.cellImage_ImageView.image = [UIImage imageNamed:imageArr[indexPath.row]];
        NSArray *titleArr = @[@"我的优惠券",@"我的积分",@"收货地址管理",@"退款/售后"];
        cell.cellTitle_Lab.text = titleArr[indexPath.row];
        cell.cellTitle_Lab.font =[UIFont systemFontOfSize:14];
        cell.rightArrow_ImageView.image = [UIImage imageNamed:@"箭头"];
        if (indexPath.row == 0)
        {
            UIView *view = [cell.contentView viewWithTag:1118];
            [view removeFromSuperview];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
            line.tag = 1118;
            line.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC" alpha:0.5];
            [cell.contentView addSubview:line];
        }
        if (indexPath.row == 3)
        {
            UIView *view = [cell.contentView viewWithTag:1119];
            [view removeFromSuperview];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43, ScreenWidth, 1)];
            line.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC" alpha:0.5];
            line.tag = 1119;
            [cell.contentView addSubview:line];
            
            cell.line.hidden = YES;
        }
        
        if (indexPath.row == 0)
        {
            if (self.user == nil)
            {
                cell.InfoLab.text = [NSString stringWithFormat:@"您有0张优惠券"];
            }
            else
            {
                cell.InfoLab.text = [NSString stringWithFormat:@"您有%@张优惠券",self.user.userCouponCount];
            }

        }
        else if (indexPath.row == 1)
        {
            if (self.user == nil)
            {
                cell.InfoLab.text = [NSString stringWithFormat:@"您有0积分"];
            }
            else
            {
                cell.InfoLab.text = [NSString stringWithFormat:@"您有%@积分",self.user.userIntegral];
            }

        }
        else
        {
            cell.InfoLab.hidden = YES;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            SimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierSimple forIndexPath:indexPath];
            cell.cellImage_ImageView.image = [UIImage imageNamed:@"意见反馈"];
            cell.cellTitle_Lab.text = @"意见反馈";
            cell.cellTitle_Lab.font =[UIFont fontWithName:@"Helvetica" size:15];
            cell.rightArrow_ImageView.image = [UIImage imageNamed:@"箭头"];
            cell.InfoLab.hidden = YES;
            
            UIView *view = [cell.contentView viewWithTag:1210];
            [view removeFromSuperview];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
            line.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC" alpha:0.5];
            line.tag = 1210;
            [cell.contentView addSubview:line];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            CallCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCall forIndexPath:indexPath];

            cell.ceImage_ImageView.image = [UIImage imageNamed:@"400"];
            cell.rightArrow_ImageView.image = [UIImage imageNamed:@"箭头"];
            
            UIView *view = [cell.contentView viewWithTag:1211];
            [view removeFromSuperview];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43, ScreenWidth, 1)];
            line.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC" alpha:0.5];
            line.tag = 1211;
            [cell.contentView addSubview:line];


            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }

    }
    return nil;

}
#pragma mark - 返回单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            return 139;
        }
        else
        {
            return 64;
        }
    }
    if (indexPath.section == 1)
    {
        return 44;
    }
    if (indexPath.section == 2)
    {
        return 44;
    }
    return 0;
}
#pragma mark - 选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 1:
            switch (indexPath.row)
        {
                case 0:  //我的优惠券
            {
                MyCouponViewController *couponVC = [[MyCouponViewController alloc] init];
                couponVC.hidesBottomBarWhenPushed = YES;
                couponVC.isLogin = _isLogin;
                [self.navigationController pushViewController:couponVC animated:NO];
            }
            break;
            case 1:    //我的积分
            {
                MyIntegralViewController *integralVC = [[MyIntegralViewController alloc] init];
                integralVC.hidesBottomBarWhenPushed  = YES;
                integralVC.isLogin = _isLogin;
                integralVC.initalIntegral = [NSString stringWithFormat:@"%@",self.user.userIntegral];
                if (!self.user.userIntegral)
                {
                    integralVC.initalIntegral = @"0";
                }
                [self.navigationController pushViewController:integralVC animated:NO];
            }
                break;
            case 2:   //收货地址管理
            {
                AddressManagerViewController *addressVC = [[AddressManagerViewController alloc] init];
                addressVC.hidesBottomBarWhenPushed = YES;
                addressVC.isLogin = _isLogin;
                [self.navigationController pushViewController:addressVC animated:NO];
            }
                break;
            case 3:  //退款售后
            {
                RefundViewController *refundVC = [[RefundViewController alloc] init];
                refundVC.hidesBottomBarWhenPushed = YES;
                refundVC.isLogin = _isLogin;
                [self.navigationController pushViewController:refundVC animated:NO];
                
            }
                break;

                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row)
        {
            case 0:   //意见反馈
            {
                FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] init];
                feedbackVC.hidesBottomBarWhenPushed = YES;
                feedbackVC.isLogin = _isLogin;
                [self.navigationController pushViewController:feedbackVC animated:NO];
                
            }
                break;
            case 1:   //电话
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"4008-575766" message:@"确认拨打吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertView show];
            }
                break;
  
            default:
                break;
        }
            break;
        default:
            break;
    }

}


#pragma mark ----->  登陆按钮点击事件

- (void)loginButtionClick
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    loginVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginVC animated:NO];
}

- (void)registerButtionClick
{
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    registerVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:registerVC animated:NO];
}
#pragma mark    ---->    收藏，订单 按钮点击事件
- (void)OrderCouponButtonClick:(UIButton *)button
{
    switch (button.tag)
    {
        case 1000:    //我的订单
        {
            MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
            myOrderVC.hidesBottomBarWhenPushed = YES;
            myOrderVC.isLogin = _isLogin;
            [self.navigationController pushViewController:myOrderVC animated:NO];
        }
            break;
        case 1001:   //我的收藏
        {
            MyCollectViewController *myCollectVC = [[MyCollectViewController alloc] init];
            myCollectVC.hidesBottomBarWhenPushed = YES;
            myCollectVC.isLogin = _isLogin;
            [self.navigationController pushViewController:myCollectVC animated:NO];
        }
            break;

        default:
            break;
    }
}
                                                           
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self CallPhone];
    }
}
#pragma mark    ------> 拨打电话
-(void)CallPhone
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4008575766"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
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
