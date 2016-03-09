//
//  SearchPasswordViewController.h
//  Bqu
//
//  Created by yingbo on 15/10/10.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "HSViewController.h"
#import "ZLLAutoCode.h"

@interface SearchPasswordViewController : HSViewController
@property (strong, nonatomic) IBOutlet UIView *number_View;
@property (strong, nonatomic) IBOutlet UIImageView *number_ImageView;
@property (strong, nonatomic) IBOutlet UITextField *number_TextField;
@property (strong, nonatomic) IBOutlet UIView *safety_View;
@property (strong, nonatomic) IBOutlet UIImageView *safety_ImageView;
@property (strong, nonatomic) IBOutlet UITextField *safety_TextField;
@property (strong, nonatomic) IBOutlet UIImageView *safetyCode_iamgeView;

@property (strong, nonatomic) ZLLAutoCode *autoCodeView;
@property (strong, nonatomic) IBOutlet UIImageView *cha_img;
@property (strong, nonatomic) IBOutlet UIButton *cha_Button;


@property (strong, nonatomic) IBOutlet UIButton *next_Button;
@end
