//
//  ResetPasswordViewController.h
//  Bqu
//
//  Created by yingbo on 15/10/10.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "HSViewController.h"

@interface ResetPasswordViewController : HSViewController

@property (strong, nonatomic) IBOutlet UIView *setNewPsw_View;
@property (strong, nonatomic) IBOutlet UIImageView *setNewPsw_ImageView;
@property (strong, nonatomic) IBOutlet UITextField *setNewPsw_TextField;
@property (strong, nonatomic) IBOutlet UIButton *showPsw_Button;
@property (strong, nonatomic) IBOutlet UILabel *tip_Label;
@property (strong, nonatomic) IBOutlet UIButton *next_Button;

@property (strong, nonatomic) NSString *checkCode;
@property (strong, nonatomic) NSString *number;


@end
