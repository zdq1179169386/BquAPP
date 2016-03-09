//
//  PhoneIdentityViewController.h
//  Bqu
//
//  Created by yingbo on 15/10/10.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "HSViewController.h"

@interface PhoneIdentityViewController : HSViewController
{
    int _seconds;
    NSTimer *_timer1;
}
@property (strong, nonatomic) IBOutlet UILabel *send_Label;
@property (strong, nonatomic) IBOutlet UILabel *number_Label;
@property (strong, nonatomic) IBOutlet UILabel *secret_Label;
@property (strong, nonatomic) IBOutlet UIView *identityCode_View;
@property (strong, nonatomic) IBOutlet UIImageView *indentityCode_ImageView;
@property (strong, nonatomic) IBOutlet UITextField *identityCode_TextField;
@property (strong, nonatomic) IBOutlet UIButton *getIdentityCode_Button;
@property (strong, nonatomic) IBOutlet UIButton *Next_Button;

@property (strong, nonatomic) IBOutlet UILabel *time_Lab;
@property (strong, nonatomic) IBOutlet UILabel *tip_Lab;

@property (strong, nonatomic) NSString *number;


@end
