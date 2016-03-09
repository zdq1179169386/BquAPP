//
//  ImportIdentityCodeViewController.h
//  Bqu
//
//  Created by yingbo on 15/10/10.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "HSViewController.h"

@interface ImportIdentityCodeViewController : HSViewController
{
    int _seconds;
    NSTimer *_timer2;
}
@property (strong, nonatomic) IBOutlet UILabel *tip_label;
@property (strong, nonatomic) IBOutlet UILabel *number_Label;

@property (strong, nonatomic) IBOutlet UIView *identityCode_View;
@property (strong, nonatomic) IBOutlet UITextField *identityCode_TextField;
@property (strong, nonatomic) IBOutlet UIImageView *identityCode_ImageView;
@property (strong, nonatomic) IBOutlet UIButton *commitCode_Button;
@property (strong, nonatomic) IBOutlet UILabel *time_Label;
@property (strong, nonatomic) IBOutlet UILabel *tip_Label;

@property (strong, nonatomic) IBOutlet UIButton *againSend_Button;

@property (copy, nonatomic) NSString *phoneNumber;
@end
