//
//  FirmOrderTableViewController.h
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.

//  确认订单的页面

#import <UIKit/UIKit.h>
#import "GoodsInfomodel.h"
#import "ShopBaseViewController.h"


@interface FirmOrderTableViewController : ShopBaseViewController<UITableViewDataSource,UITableViewDelegate>
//@property (nonatomic)NSArray * order;

-(instancetype)initWithArray:(NSArray*)goodsArray;
-(instancetype)initWithGoods:(GoodsInfomodel*)goods;
@end
