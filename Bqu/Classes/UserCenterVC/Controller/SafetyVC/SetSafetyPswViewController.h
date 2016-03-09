//
//  SetSafetyPswViewController.h
//  Bqu
//
//  Created by yingbo on 15/10/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "HSViewController.h"

@interface SetSafetyPswViewController : HSViewController
@property (strong, nonatomic) IBOutlet UILabel *tip_Lab;
@property (strong, nonatomic) IBOutlet UIView *safetyPsw_View;
@property (strong, nonatomic) IBOutlet UIImageView *safetyPsw_ImgView;
@property (strong, nonatomic) IBOutlet UITextField *safetyPsw_TextF;

@property (strong, nonatomic) IBOutlet UIView *sureSafetyPsw_View;
@property (strong, nonatomic) IBOutlet UIImageView *sureSafetyPsw_ImgVIew;
@property (strong, nonatomic) IBOutlet UITextField *sureSafetyPsw_TextF;

@property (strong, nonatomic) IBOutlet UIButton *commit_Button;

@property (nonatomic,strong) NSString *isLogin;

@property (weak, nonatomic) IBOutlet UILabel *tip2View;

@end
