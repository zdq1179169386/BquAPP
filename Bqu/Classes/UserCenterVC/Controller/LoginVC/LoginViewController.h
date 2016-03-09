//
//  LoginViewController.h
//  Bqu
//
//  Created by yingbo on 15/10/10.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "HSViewController.h"

@interface LoginViewController : HSViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *account_View;
@property (strong, nonatomic) IBOutlet UIImageView *account_ImageView;
@property (strong, nonatomic) IBOutlet UIImageView *cha_ImageView;
@property (strong, nonatomic) IBOutlet UIButton *cha_Button;
@property (strong, nonatomic) IBOutlet UITextField *account_TextField;
@property (strong, nonatomic) IBOutlet UIView *password_View;
@property (strong, nonatomic) IBOutlet UIImageView *password_ImageView;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *cha2_button;

@property (strong, nonatomic) IBOutlet UIButton *login_Button;
@property (strong, nonatomic) IBOutlet UIButton *forgetPsw_Button;

@property (strong, nonatomic) IBOutlet UIView *safeCheck_View;
@property (strong, nonatomic) IBOutlet UIImageView *safe_ImgView;
@property (strong, nonatomic) IBOutlet UITextField *safeCheck_TextF;
@property (strong, nonatomic) IBOutlet UILabel *checkCode_Lab;/**框框显示的验证码**/
@property (strong, nonatomic) IBOutlet UIButton *checkCode_Btn;

@property (strong, nonatomic)  NSString *checkCode;/**验证码**/
@property (assign, nonatomic)  int errorCount;/**输入的错误次数**/
@property (strong, nonatomic)  NSString *message;


@end
