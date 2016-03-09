//
//  CompleteRegisterViewController.h
//  Bqu
//
//  Created by yingbo on 15/10/10.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "HSViewController.h"

@interface CompleteRegisterViewController : HSViewController
@property (strong, nonatomic) IBOutlet UIImageView *complete_ImageVIew;
@property (strong, nonatomic) IBOutlet UILabel *tip_Label;
@property (strong, nonatomic) IBOutlet UILabel *tip1_Label;
@property (strong, nonatomic) IBOutlet UILabel *number_Label;
@property (strong, nonatomic) IBOutlet UIButton *complete_Button;


@property (strong, nonatomic) NSString *number;
@property (copy,nonatomic) NSString *psw;

@end
