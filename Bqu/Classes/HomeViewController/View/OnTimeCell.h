//
//  OnTimeCell.h
//  Bqu
//
//  Created by WONG on 15/10/12.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OntimeModel.h"


@interface OnTimeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *OnTimeImg;
@property (weak, nonatomic) IBOutlet UILabel *StorageLable;
@property (weak, nonatomic) IBOutlet UILabel *xxxLable;
@property (nonatomic,strong) OntimeModel *onTimeModel;

+(instancetype)OnTimeCellWithTableView:(UITableView *)tableView;

@end
