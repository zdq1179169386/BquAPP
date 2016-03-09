//
//  EvaluateCell.h
//  Bqu
//
//  Created by yingbo on 15/10/27.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStarRateView.h"

@interface EvaluateCell : UITableViewCell<CWStarRateViewDelegate,UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *product_ImgView;
@property (strong, nonatomic) IBOutlet UILabel *productName_Lab;
@property (strong, nonatomic) IBOutlet UILabel *productPrice_Lab;
@property (strong, nonatomic) IBOutlet UILabel *productCount_Lab;
@property (strong, nonatomic) IBOutlet UIView *line_View;
@property (strong, nonatomic) IBOutlet UILabel *goal_Lab;

@property  (strong, nonatomic) IBOutlet UITextView *evaluate_TextV;
@property (strong, nonatomic) IBOutlet CWStarRateView *cell_star;


@property (weak, nonatomic) IBOutlet UILabel *score_Lab;
@property (weak, nonatomic) IBOutlet UILabel *serve_Lab;
@property (weak, nonatomic) IBOutlet UILabel *logistic_Lab;
@property (weak, nonatomic) IBOutlet UILabel *pack_Lab;
@property (weak, nonatomic) IBOutlet UIButton *commit_Btn;



@end
