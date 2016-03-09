//
//  DeliveryCell.h
//  Bqu
//
//  Created by yingbo on 15/10/26.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliveryCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *yuan_ImgView;
@property (strong, nonatomic) IBOutlet UILabel *message_Lab;
@property (strong, nonatomic) IBOutlet UILabel *date_Lab;
@property (strong, nonatomic) IBOutlet UIView *line1_View;
@property (strong, nonatomic) IBOutlet UIView *line2_View;

@end
