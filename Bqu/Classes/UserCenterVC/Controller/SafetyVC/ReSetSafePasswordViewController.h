//
//  ReSetSafePasswordViewController.h
//  Bqu
//
//  Created by yingbo on 15/10/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "HSViewController.h"

@interface ReSetSafePasswordViewController : HSViewController
@property (strong, nonatomic) IBOutlet UIView *setNewPsw_View;
@property (strong, nonatomic) IBOutlet UIImageView *setNewPsw_ImgView;
@property (strong, nonatomic) IBOutlet UITextField *setNewPSw_TextF;
@property (strong, nonatomic) IBOutlet UIButton *show_Button;
@property (strong, nonatomic) IBOutlet UILabel *tip_Lab;
@property (strong, nonatomic) IBOutlet UIButton *commit_Button;


@property (nonatomic,strong) NSString *phoneNumber;
@property (nonatomic,strong) NSString *checkCode;

@end
