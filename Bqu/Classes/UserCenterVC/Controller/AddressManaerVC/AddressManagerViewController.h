//
//  AddressManagerViewController.h
//  Bqu
//
//  Created by yingbo on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "HSViewController.h"
#import "MyAddressCell.h"
@interface AddressManagerViewController : HSViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,AddressDelegate>
{
}

@property (strong, nonatomic) UIView * lineView; // button下方点击时移动的红色线条
@property (strong, nonatomic) UIView * viewBlank; //  暂无数据
@property (strong, nonatomic) NSMutableArray * array_button;// buttonArray

@property (nonatomic,strong) NSString *isLogin;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIButton *selectBtn;

@end
