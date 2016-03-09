//
//  ForgetSafePasswordViewController.h
//  Bqu
//
//  Created by yingbo on 15/10/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "HSViewController.h"

@interface ForgetSafePasswordViewController : HSViewController
{
    int _seconds;
    NSTimer *_timer3;
}
@property (strong, nonatomic) IBOutlet UILabel *tip_Lab;
@property (strong, nonatomic) IBOutlet UILabel *number_Lab;
@property (strong, nonatomic) IBOutlet UILabel *shade_Lab;
@property (strong, nonatomic) IBOutlet UIView *phoneIdentity_View;
@property (strong, nonatomic) IBOutlet UIImageView *phoneIdentity_ImgView;
@property (strong, nonatomic) IBOutlet UIButton *getCode_Button;
@property (strong, nonatomic) IBOutlet UITextField *identityCode_TextF;
@property (strong, nonatomic) IBOutlet UIButton *next_Button;
@property (strong, nonatomic) IBOutlet UILabel *secondLab;
@property (strong, nonatomic) IBOutlet UILabel *secondtip_Lab;

@property (nonatomic,strong) NSString *phoneNumber;


@end
