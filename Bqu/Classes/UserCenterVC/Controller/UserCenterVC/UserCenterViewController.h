//
//  UserCenterViewController.h
//  Bqu
//
//  Created by yingbo on 15/10/9.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "HSViewController.h"
#import "UserInfoCell.h"
#import "SimpleCell.h"
#import "CallCell.h"
#import "OrderCouponCell.h"
@interface UserCenterViewController : HSViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,OrderCouponDelegate>
{
    /*已登录界面用户信息字典*/
    NSDictionary    *_userInfoDict;
    /*是否登录*/
    NSString *_isLogin;
}
/*用户主界面表*/
@property (nonatomic,strong) UITableView *userTableView;
/*按钮图片数组*/
@property (nonatomic,strong)   NSMutableArray *array_buttonImage;
/*用户model*/
@property (nonatomic,strong) User *user;                         


@end
