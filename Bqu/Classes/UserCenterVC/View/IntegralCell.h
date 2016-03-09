//
//  IntegralCell.h
//  Bqu
//
//  Created by yingbo on 15/10/29.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntegralCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *TypeName;
@property (strong, nonatomic) IBOutlet UILabel *Data;
@property (strong, nonatomic) IBOutlet UILabel *Remark;
@property (strong, nonatomic) IBOutlet UILabel *Integral;
@property (strong, nonatomic) IBOutlet UIView *line_View;

@end
