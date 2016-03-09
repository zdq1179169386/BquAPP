//
//  setPswViewController.h
//  Bqu
//
//  Created by yingbo on 15/10/10.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "HSViewController.h"

@interface setPswViewController : HSViewController
@property (strong, nonatomic) IBOutlet UILabel *tip_Label;
@property (strong, nonatomic) IBOutlet UIView *setPsw_VIew;
@property (strong, nonatomic) IBOutlet UIImageView *setPsw_ImageView;
@property (strong, nonatomic) IBOutlet UITextField *setPsw_TextField;
@property (strong, nonatomic) IBOutlet UIButton *complete_Button;


@property (copy,nonatomic) NSString *phoneNumber;
@property (copy,nonatomic) NSString *checkCode;
@end
