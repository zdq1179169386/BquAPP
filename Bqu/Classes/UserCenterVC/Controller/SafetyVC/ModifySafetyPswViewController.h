//
//  ModifySafetyPswViewController.h
//  Bqu
//
//  Created by yingbo on 15/10/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "HSViewController.h"

@interface ModifySafetyPswViewController : HSViewController
@property (strong, nonatomic) IBOutlet UIView *oldSafePsw_View;
@property (strong, nonatomic) IBOutlet UIImageView *oldSafePsw_ImgView;
@property (strong, nonatomic) IBOutlet UITextField *oldSafePsw_TextF;
@property (strong, nonatomic) IBOutlet UIView *newlySafePsw_View;
@property (strong, nonatomic) IBOutlet UIImageView *newlySafePsw_ImgView;
@property (strong, nonatomic) IBOutlet UITextField *newlySafePsw_TextF;

@property (strong, nonatomic) IBOutlet UIView *againNewPsw_View;
@property (strong, nonatomic) IBOutlet UIImageView *againNewPsw_ImgView;
@property (strong, nonatomic) IBOutlet UITextField *againMewPsw_TextF;

@property (strong, nonatomic) IBOutlet UILabel *tip_lab;
@property (strong, nonatomic) IBOutlet UIButton *commit_Button;
@property (strong, nonatomic) IBOutlet UIButton *forgetSafePsw_Button;

@property (nonatomic,strong) NSString *isLogin;
@property (nonatomic,strong) NSString *phoneNumber;


@end
