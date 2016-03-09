//
//  OrderDetailCell.h
//  Bqu
//
//  Created by yingbo on 15/10/27.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *address_ImgView_Cell1;
@property (strong, nonatomic) IBOutlet UILabel *receiver_Lab_Cell1;
@property (strong, nonatomic) IBOutlet UILabel *poneNumber_Cell1;
@property (strong, nonatomic) IBOutlet UILabel *address_Lab_Cell1;
@property (strong, nonatomic) IBOutlet UILabel *IDcard_Lab_Cell1;
@property (strong, nonatomic) IBOutlet UILabel *shadow_Lab_Cell1;


@property (weak, nonatomic) IBOutlet UILabel *left_Lab_Cell2;
@property (weak, nonatomic) IBOutlet UILabel *right_Lab_Cell2;


@property (weak, nonatomic) IBOutlet UILabel *left_Lab_Cell3;
@property (weak, nonatomic) IBOutlet UIImageView *yuan_ImageVIew_Cell3;
@property (weak, nonatomic) IBOutlet UIView *line_View_Cell3;
@property (weak, nonatomic) IBOutlet UILabel *logistics_Lab_Cell3;
@property (weak, nonatomic) IBOutlet UILabel *date_Lab_Cell3;
@property (weak, nonatomic) IBOutlet UIImageView *image_Cell3;

@property (weak, nonatomic) IBOutlet UIImageView *product_ImgView_Cell4;
@property (weak, nonatomic) IBOutlet UILabel *PruductName_Lab_Lab_Cell4;
@property (weak, nonatomic) IBOutlet UILabel *ProductPrice_Lab_Cell4;
@property (weak, nonatomic) IBOutlet UILabel *productCount_Lab_Cell4;
@property (weak, nonatomic) IBOutlet UIButton *status_Btn_Cell4;
@property (weak, nonatomic) IBOutlet UIView *line4_View;


@property (weak, nonatomic) IBOutlet UIImageView *messageImg_Lab;
@property (weak, nonatomic) IBOutlet UILabel *message_lab;



@end
