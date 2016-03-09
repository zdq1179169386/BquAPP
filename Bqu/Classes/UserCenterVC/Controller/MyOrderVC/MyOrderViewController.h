//
//  MyOrderViewController.h
//  11
//
//  Created by yingbo on 15/10/14.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "HSViewController.h"
#import "MyOrderFooter.h"
#import "ApplyForRefundAlertView.h"

typedef enum//没啥用
{
    OrderStatus_default = 0,
    OrderStatus_waitpay = 1,
    OrderStatus_waitsend = 2,
    OrderStatus_waitreceive = 3,
    OrderStatus_complete = 4,
    OrderStatus_close = 5,
    OrderStatus_evaluate = 6
}OrderStatus;

@interface MyOrderViewController : HSViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,OrderFooterDelegate,ApplyForRefundAlertViewDelaget>
{
    int _pageNum;     //页数
    int _pageSize;    //每页有几个
    int _maxPage;     //当前刷新小数组的页数
    
    UIButton *lastBtn;//记录上一个标签栏按钮
}
@property (nonatomic,assign) NSInteger buttonTag;
@property (nonatomic,assign) NSString *isEvaluate;
@property (nonatomic,strong) NSString *isLogin;//是否登录

@property (strong, nonatomic) UITableView * tableView_Base;
@property (strong, nonatomic) UIView * lineView; // button下方点击时移动的红色线条
@property (strong, nonatomic) UIScrollView * scrollView;
@property (strong, nonatomic) NSMutableArray * array_button;// buttonArray
@property (strong, nonatomic) NSMutableArray * dataArray;// 数据源
@property (strong, nonatomic) NSArray * arrayState;
@property (strong, nonatomic) UIView * viewBlank; //  暂无数据
@property (strong, nonatomic) NSString *orderStatus;//订单状态


//@property (nonatomic,assign) OrderStatus orderStatus;//订单状态

@property (nonatomic,strong) MyOrder_Model *order;//订单模型

//@property (nonatomic,strong) NSDate *date;

//@property (strong, nonatomic) NSMutableArray * timeArray; //剩余时间数组
//@property (strong, nonatomic) UILabel *timelab;//剩余时间
//@property (strong, nonatomic) NSMutableArray * restTimeArray; //剩余时间数组
//@property (strong, nonatomic) NSMutableArray * timerArray; //剩余时间数组
@property (strong, nonatomic) NSMutableArray * boolArray; //判断开合数组
//@property (strong, nonatomic) UIImageView *clockImg;//钟表



@end
