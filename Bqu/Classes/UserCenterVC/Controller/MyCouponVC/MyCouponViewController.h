//
//  MyCouponViewController.h
//  Bqu
//
//  Created by yingbo on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "HSViewController.h"
typedef enum
{
    CouponStatus_0 = 0,
    CouponStatus_1 = 1,
    CouponStatus_2 = 2
    
}CouponStatus;
@interface MyCouponViewController : HSViewController<UITableViewDataSource,UITableViewDelegate>

/*主界面表*/
@property (strong, nonatomic) UITableView * tableView_Base;
/*button下方点击时移动的红色线条*/
@property (strong, nonatomic) UIView * lineView;
/*滑动的视图*/
@property (strong, nonatomic) UIScrollView * scrollView;
/*数组 三个按钮*/
@property (strong, nonatomic) NSMutableArray * array_button;
/*按钮tag值*/
@property (assign, nonatomic) NSInteger buttonTag;
/*请求得到的已解析的数组*/
@property (strong, nonatomic) NSMutableArray * dataArray;
/*在暂无数据的空视图*/
@property (strong, nonatomic) UIView * viewBlank; //  暂无数据
/*是否登录*/
@property (nonatomic,strong) NSString *isLogin;
/*优惠券的三种状态*/
@property (nonatomic,assign) CouponStatus Status;

@property (nonatomic,assign) UIWindow *window;


@end
