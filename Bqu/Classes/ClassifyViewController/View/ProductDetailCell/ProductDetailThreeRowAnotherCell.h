//
//  ProductDetailThreeRowAnotherCell.h
//  Bqu
//
//  Created by yb on 15/10/23.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
@interface ProductDetailThreeRowAnotherCell : UITableViewCell
@property(nonatomic,strong)NSTimer * overTimer;


/**model*/
@property(nonatomic,strong)ProductModel  * model;


/**定时器的时间*/
@property(nonatomic,assign)int time;

@property (nonatomic,strong) UILabel * date;

@end
