//
//  FeedCell.h
//  Bqu
//
//  Created by yingbo on 15/11/3.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedCell : UITableViewCell




@property (strong, nonatomic) IBOutlet UILabel *tip1_Lab;
@property (strong, nonatomic) IBOutlet UIImageView *oneImg;
@property (strong, nonatomic) IBOutlet UIButton *one_Btn;
@property (strong, nonatomic) IBOutlet UIImageView *twoImg;
@property (strong, nonatomic) IBOutlet UIButton *two_btn;
@property (strong, nonatomic) IBOutlet UIImageView *threeImg;
@property (strong, nonatomic) IBOutlet UIButton *three_Btn;
@property (strong, nonatomic) IBOutlet UIImageView *fouLmg;
@property (strong, nonatomic) IBOutlet UIButton *fourBtn;
@property (strong, nonatomic) IBOutlet UIImageView *fiveImg;
@property (strong, nonatomic) IBOutlet UIButton *five_Btn;

@property (strong, nonatomic) IBOutlet UILabel *tip2_Lab;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (strong, nonatomic) IBOutlet UITextView *textView1;

@property (strong, nonatomic) IBOutlet UILabel *tip3_Lab;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (strong, nonatomic) IBOutlet UITextView *textView2;

@property (strong, nonatomic) IBOutlet UILabel *tip4_Lab;
@property (strong, nonatomic) IBOutlet UITextField *emailTextF;

@property (strong, nonatomic) IBOutlet UILabel *tip5_Lab;


@property (strong, nonatomic) IBOutlet UIButton *commit_Btn;


@property (weak, nonatomic) IBOutlet UIView *view3;

@end
