//
//  MyCell.h
//  Bqu
//
//  Created by yingbo on 15/10/12.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *title1_Lab;
@property (strong, nonatomic) IBOutlet UILabel *tip1_Lab;

@property (weak, nonatomic) IBOutlet UILabel *title2_Lab;
@property (weak, nonatomic) IBOutlet UILabel *tip2_Lab;

@end
