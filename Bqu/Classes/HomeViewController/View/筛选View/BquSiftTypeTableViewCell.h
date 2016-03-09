//
//  BquSiftTypeTableViewCell.h
//  Bqu
//
//  Created by yb on 15/12/9.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiftTypeModel.h"

@interface BquSiftTypeTableViewCell : UITableViewCell
@property(nonatomic)SiftTypeModel *model;

+(instancetype)bquSiftTypeTableViewCell:(UITableView*)tableView;

@end
