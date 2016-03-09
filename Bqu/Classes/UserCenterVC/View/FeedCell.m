//
//  FeedCell.m
//  Bqu
//
//  Created by yingbo on 15/11/3.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "FeedCell.h"

@implementation FeedCell

- (void)awakeFromNib {
    // Initialization code
    
    self.one_Btn.layer.cornerRadius = 4;
    [self.one_Btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    self.one_Btn.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    
    self.two_btn.layer.cornerRadius = 4;
    [self.two_btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    self.two_btn.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    
    self.three_Btn.layer.cornerRadius = 4;
    [self.three_Btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    self.three_Btn.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    
    self.fourBtn.layer.cornerRadius = 4;
    [self.fourBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    self.fourBtn.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    
    self.five_Btn.layer.cornerRadius = 4;
    [self.five_Btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    self.five_Btn.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
  
    self.oneImg.layer.cornerRadius = 4;
    self.twoImg.layer.cornerRadius = 4;
    self.threeImg.layer.cornerRadius = 4;
    self.fouLmg.layer.cornerRadius = 4;
    self.fiveImg.layer.cornerRadius = 4;

    
    self.tip1_Lab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.tip2_Lab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.tip3_Lab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.tip4_Lab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.tip5_Lab.textColor = [UIColor colorWithHexString:@"#888888"];
    
    
    self.lab1.textColor = [UIColor colorWithHexString:@"#cccccc"];
    self.lab2.textColor = [UIColor colorWithHexString:@"#cccccc"];


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
