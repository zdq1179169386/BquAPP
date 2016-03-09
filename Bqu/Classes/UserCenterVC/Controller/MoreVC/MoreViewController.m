//
//  MoreViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/12.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "MoreViewController.h"
#import "MyCell.h"
#import "SetSafetyPswViewController.h"
#import "ModifyLoginPswViewController.h"
#import "ModifySafetyPswViewController.h"
#import "QuestionViewController.h"
#import "AboutViewController.h"
#import "ConectUsViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self createBackBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB_A(240, 238, 238);
    self.navigationItem.title = @"更多";
    //显示主界面表
    [self createMainTable];
    //显示退出登录视图
    [self loginOutButtton];
    
    NSLog(@"设置界面是否登录1否，0是 ---》%@",self.isLogin);

}

- (void)createMainTable
{
    
    _titleArr1 = @[@"登录密码",@"安全密码"];
    _tipArr1 = @[@"修改",@"设置"];
    _titleArr2 = @[@"常见问题",@"关于B区",@"联系我们"];

    _mian_table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-44-49-20-5) style:UITableViewStyleGrouped];
    _mian_table.backgroundColor = RGB_A(245, 245, 245);
    _mian_table.delegate = self;
    _mian_table.dataSource = self;
    _mian_table.bounces = YES;
    _mian_table.backgroundColor = [UIColor clearColor];
    _mian_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _mian_table.separatorColor = RGB_A(239, 236, 236);
    _mian_table.showsHorizontalScrollIndicator = NO;
    _mian_table.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_mian_table];
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
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 2;
            break;
        case 1:
            return 3;
            break;
               default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *cellID1 = @"cell1";
    static NSString *cellID2 = @"cell2";


    MyCell *cell = nil;
    if (indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID1] ;
        if (!cell)
        {
            NSArray *xibArray = [[NSBundle mainBundle] loadNibNamed:@"MyCell" owner:nil options:nil];
            cell = [xibArray objectAtIndex:0];
        }
        
        cell.title1_Lab.text = _titleArr1[indexPath.row];
        cell.tip1_Lab.text = _tipArr1[indexPath.row];

        if (indexPath.row == 1)
        {
            if ([self.safePsw isEqualToString:@"1"])
            {
                cell.tip1_Lab.text = @"修改";
            }
            else if([self.safePsw isEqualToString:@"0"])
            {
                cell.tip1_Lab.text = @"设置";

            }
        }
       
    }
    else if(indexPath.section == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID2] ;
        if (!cell)
        {
            NSArray *xibArray = [[NSBundle mainBundle] loadNibNamed:@"MyCell" owner:nil options:nil];
            cell = [xibArray objectAtIndex:1];
        }
        cell.title2_Lab.text = _titleArr2[indexPath.row];
        cell.tip2_Lab.hidden = YES;
    }
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
            switch (indexPath.row)
            {
                case 0:
                {
                    if ([self.isLogin isEqualToString:@"0"])
                    {
                        ModifyLoginPswViewController *modifyVC = [[ModifyLoginPswViewController alloc] init];
                        modifyVC.hidesBottomBarWhenPushed = YES;
                        modifyVC.isLogin = self.isLogin;
                        [self.navigationController pushViewController:modifyVC animated:NO];

                    }
                    else
                    {
                        [TipView remindAnimationWithTitle:@"请先登录哦~"];
                    }
                    
                }
                break;
                case 1:
                {
                    
                    if ([self.isLogin isEqualToString:@"0"])
                    {
                        if ([self.safePsw isEqualToString:@"1"])
                        {
                            ModifySafetyPswViewController *modifySafeVC = [[ModifySafetyPswViewController alloc] init];
                            modifySafeVC.hidesBottomBarWhenPushed = YES;
                            modifySafeVC.isLogin = self.isLogin;
                            modifySafeVC.phoneNumber = self.phoneNumber;
                            [self.navigationController pushViewController:modifySafeVC animated:NO];
                        }
                        else if ([self.safePsw isEqualToString:@"0"])
                        {
                            
                            SetSafetyPswViewController *safeVC = [[SetSafetyPswViewController alloc] init];
                            safeVC.hidesBottomBarWhenPushed = YES;
                            safeVC.isLogin = self.isLogin;
                            [self.navigationController pushViewController:safeVC animated:NO];
                            
                        }

                    }
                    else
                    {
                         [TipView remindAnimationWithTitle:@"请先登录哦~"];
                    }

                    
                }
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row)
            {
                case 0:
                {
                    QuestionViewController *questionVC = [[QuestionViewController alloc] init];
                    questionVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:questionVC animated:NO];
                }
                break;
                case 1:
                {
                    AboutViewController *aboutVC = [[AboutViewController alloc] init];
                    aboutVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:aboutVC animated:NO];
                }
                break;
                case 2:
                {
                    ConectUsViewController *aboutVC = [[ConectUsViewController alloc] init];
                    aboutVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:aboutVC animated:NO];
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


#pragma mark     ---------->ButtonClick按钮点击事件

- (void)loginOutButtton
{
    //白色背景视图
    UIView *loginOut_View = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-49-60, ScreenWidth, 60)];
    loginOut_View.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:loginOut_View];
    //退出登录按钮
    UIButton *loginOut_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    loginOut_Button.frame = CGRectMake(10, 5, ScreenWidth-20, 30);
    loginOut_Button.backgroundColor = RGB_A(242, 0, 56);
    loginOut_Button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [loginOut_Button onlyCornerRadius];
    [loginOut_Button setTitle:@"退出登录" forState:UIControlStateNormal];
    [loginOut_Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginOut_Button addTarget:self action:@selector(loginOutClick) forControlEvents:UIControlEventTouchUpInside];
    [loginOut_View addSubview:loginOut_Button];
}

/*退出按钮绑定方法*/
- (void)loginOutClick
{
    /*判断当前页面是否登录*/
    if ([self.isLogin isEqualToString:@"0"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定退出吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    else
    {
        [TipView remindAnimationWithTitle:@"您还没有登陆哦~"];
    }
   
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 1)
    {
        [UserManager deleteToken];
        [UserManager delegateUserID];
        [UserManager deleteUserName];
        [UserManager deleteIsPromoter];

        [self.navigationController popToRootViewControllerAnimated:NO];
        NSLog(@"此时的token=%@",[UserManager getMyObjectForKey:accessTokenKey]);
    }
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
