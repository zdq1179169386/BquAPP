//
//  SimpleCell.h
//  Bqu
//
//  Created by yingbo on 15/10/12.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *cellImage_ImageView;
@property (strong, nonatomic) IBOutlet UILabel *cellTitle_Lab;
@property (strong, nonatomic) IBOutlet UIImageView *rightArrow_ImageView;

@property (strong, nonatomic) IBOutlet UIView *line;

@property (weak, nonatomic) IBOutlet UILabel *InfoLab;


@end
