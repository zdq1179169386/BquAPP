//
//  OverSeaCell.h
//  Bqu
//
//  Created by WONG on 15/10/12.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeModel.h"


@interface ThemeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ThemeImg;
@property (nonatomic)ThemeModel *themeModel;

+(instancetype)themeCellWithTableView:(UITableView*)tableView;
@end
