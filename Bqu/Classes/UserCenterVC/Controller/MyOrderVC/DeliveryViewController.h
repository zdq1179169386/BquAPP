//
//  DeliveryViewController.h
//  Bqu
//
//  Created by yingbo on 15/10/26.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "HSViewController.h"

@interface DeliveryViewController : HSViewController<UITableViewDataSource,UITableViewDelegate>
/*订单ID*/
@property (nonatomic,strong) NSString *orderID;
/*主界面表*/
@property (nonatomic,strong) UITableView *tableView;
/*数据大字典*/
@property (nonatomic,strong) NSDictionary *dataDict;
/*物流字典*/
@property (nonatomic,strong) NSDictionary *expressDict;
/*物流数组*/
@property (nonatomic,strong) NSArray *expressArr;
/**物流前的物流数组**/
@property (nonatomic,strong) NSArray *OrderAuditArr;

@end
