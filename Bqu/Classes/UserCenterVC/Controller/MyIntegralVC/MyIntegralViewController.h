//
//  MyIntegralViewController.h
//  Bqu
//
//  Created by yingbo on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "HSViewController.h"

typedef enum
{
    IntegralType_All = 0,
    IntegralType_Int = 1,
    IntegralType_Out = 2
 
}IntegralType;


@interface MyIntegralViewController : HSViewController<UITableViewDataSource,UITableViewDelegate>
/*主界面表*/
@property (strong, nonatomic) UITableView * tableView_Base;
/*红色积分视图*/
@property (strong, nonatomic) UIView *integralView;
/*button下方点击时移动的红色线条*/
@property (strong, nonatomic) UIView * lineView;
/*滑动的视图*/
@property (strong, nonatomic) UIScrollView * scrollView;
/*顶部的三个按钮的数组*/
@property (strong, nonatomic) NSMutableArray * array_button;
/*每个按钮的tag*/
@property (assign, nonatomic) NSInteger buttonTag;
/*积分数据大字典*/
@property (strong, nonatomic) NSDictionary * dictionary_dataSource;
/*积分数据数组*/
@property (strong, nonatomic) NSMutableArray * dataArray;
/*空视图*/
@property (strong, nonatomic) UIView * viewBlank;
/*初始化积分*/
@property (nonatomic,copy) NSString *initalIntegral;
/*是否登录*/
@property (nonatomic,strong) NSString *isLogin;
/*积分类型*/
@property (nonatomic,assign) IntegralType Type;

@end
