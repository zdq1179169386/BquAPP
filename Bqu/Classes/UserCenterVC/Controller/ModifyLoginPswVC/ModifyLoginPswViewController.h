//
//  ModifyLoginPswViewController.h
//  Bqu
//
//  Created by yingbo on 15/10/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "HSViewController.h"

@interface ModifyLoginPswViewController : HSViewController
@property (strong, nonatomic) IBOutlet UIView *modifyLoginPsw_View;
@property (strong, nonatomic) IBOutlet UIImageView *oldPsw_ImgView;
@property (strong, nonatomic) IBOutlet UITextField *oldPsw_TextF;
@property (strong, nonatomic) IBOutlet UIView *modifyPsw_View;
@property (strong, nonatomic) IBOutlet UIImageView *pswNew_ImgView;
@property (strong, nonatomic) IBOutlet UITextField *pswNew_TextF;
@property (strong, nonatomic) IBOutlet UILabel *tip_Lab;
@property (strong, nonatomic) IBOutlet UIButton *commit_Button;

@property (nonatomic,strong) NSString *isLogin;


@end
