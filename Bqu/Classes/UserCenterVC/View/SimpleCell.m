//
//  SimpleCell.m
//  Bqu
//
//  Created by yingbo on 15/10/12.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "SimpleCell.h"

@implementation SimpleCell

- (void)awakeFromNib
{
    self.line.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD" alpha:0.5];
    self.line.frame = CGRectMake(43, 43, ScreenWidth+10, 1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
