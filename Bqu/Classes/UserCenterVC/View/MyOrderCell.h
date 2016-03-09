//
//  MyOrderCell.h
//  Bqu
//
//  Created by yingbo on 15/10/20.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *line_View;
@property (strong, nonatomic) IBOutlet UIImageView *goodsPhoto_ImgView;
@property (strong, nonatomic) IBOutlet UILabel *goodsName_Lab;
@property (strong, nonatomic) IBOutlet UILabel *goodsPrice_Lab;
@property (strong, nonatomic) IBOutlet UILabel *goodsCount_Lab;
@property (strong, nonatomic) IBOutlet UILabel *refund_Lab;


@property (strong, nonatomic) MyOrderItems_Model *ordrItem;
-(void)setValue:(id)value;
@end
