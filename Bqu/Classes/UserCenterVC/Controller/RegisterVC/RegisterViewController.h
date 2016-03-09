//
//  RegisterViewController.h
//  Bqu
//
//  Created by yingbo on 15/10/10.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "HSViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface RegisterViewController : HSViewController<UITextFieldDelegate>
{
    BOOL isSelected;//是否勾选协议
}

@property (strong, nonatomic) IBOutlet UIImageView *number_ImageView;
@property (strong, nonatomic) IBOutlet UIView *number_view;
@property (strong, nonatomic) IBOutlet UITextField *number_TextField;
@property (strong, nonatomic) IBOutlet UIButton *getIdentityCode_Button;
@property (strong, nonatomic) IBOutlet UIButton *agree_button;
@property (strong, nonatomic) IBOutlet UILabel *agree_Label;
@property (strong, nonatomic) IBOutlet UILabel *redAgree_Label;



@end
