//
//  EvaluateViewController.h
//  Bqu
//
//  Created by yingbo on 15/10/26.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "HSViewController.h"
#import "CWStarRateView.h"
@interface EvaluateViewController : HSViewController<UITableViewDataSource,UITableViewDelegate,CWStarRateViewDelegate,UITextViewDelegate>

/*订单ID*/
@property (nonatomic,strong) NSString *orderID;
/*商品数组 存放订单里面的所有商品*/
@property (nonatomic,strong) NSArray *productArr;
/*主界面表*/
@property (nonatomic,strong) UITableView *tableView;
/*订单model类*/
@property (nonatomic,strong) MyOrder_Model *order;
/*每个商品的评论小数组*/
@property (nonatomic,strong) NSMutableArray *comentsArr;
/*物流评价星星*/
@property (nonatomic,strong) NSString *serve_Str;
/*快递评价星星*/
@property (nonatomic,strong) NSString *delivery_Str;
/*包装评价星星*/
@property (nonatomic,strong) NSString *pack_Str;
/*每个商品的评论小字典*/
@property (nonatomic,strong) NSMutableDictionary *itemDic;


@end
