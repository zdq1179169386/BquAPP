//
//  UserInfoCell.m
//  Bqu
//
//  Created by yingbo on 15/10/12.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "UserInfoCell.h"

@implementation UserInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setValue
{
    self.login_Button.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.login_Button.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.login_Button setTitleColor:[UIColor colorWithHexString:@"#e8103c"] forState:UIControlStateNormal];
    self.login_Button.layer.cornerRadius = 17;

    
    self.register_Button.backgroundColor = [UIColor clearColor];
    self.register_Button.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.register_Button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.register_Button.layer.borderWidth = 3;
    self.register_Button.layer.borderColor = [UIColor colorWithHexString:@"#ffffff"].CGColor;
    self.register_Button.layer.cornerRadius = 17;

    self.photo_ImageView.layer.cornerRadius = 30;
    self.photo_ImageView.clipsToBounds = YES;
}

@end
