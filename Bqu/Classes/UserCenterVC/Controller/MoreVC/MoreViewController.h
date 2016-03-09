//
//  MoreViewController.h
//  Bqu
//
//  Created by yingbo on 15/10/12.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "HSViewController.h"

@interface MoreViewController : HSViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
/*第一个区的左边title数组*/
    NSArray *_titleArr1;
/*第一个区的右边tip数组*/
    NSArray *_tipArr1;
/*第二个区的左边title数组*/
    NSArray *_titleArr2;
/*主界面表*/
    UITableView *_mian_table;
}
/*退出登录的视图*/
@property (strong, nonatomic)  UIView *loginOut_VIew;
/*退出登录的按钮*/
@property (strong, nonatomic)  UIButton *loginOut_Button;
/*是否登录*/
@property (nonatomic,strong) NSString *isLogin;
/*传给修改安全密码*/
@property (nonatomic,strong) NSString *phoneNumber;
/*是否已经设置过安全密码 0未设置 1设置过*/
@property (nonatomic,strong) NSString *safePsw;

@end
