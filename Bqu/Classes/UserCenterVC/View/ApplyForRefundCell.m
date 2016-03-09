//
//  ApplyForRefundCell.m
//  Bqu
//
//  Created by yb on 15/10/26.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "ApplyForRefundCell.h"

@implementation ApplyForRefundCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        self.btn = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, ScreenWidth-150, 44)];
        self.btn.font = [UIFont systemFontOfSize:16];
        self.rightImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.rightImage.image = [UIImage imageNamed:@"箭头"];
        self.rightImage.size = self.rightImage.image.size;
        self.rightImage.center = CGPointMake(ScreenWidth-20, self.contentView.frame.size.height/2.0);
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, ScreenWidth-120, 44)];
//        self.textField.backgroundColor = [UIColor redColor];
        self.textField.hidden = YES;
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(100, 0, ScreenWidth-120, self.frame.size.height)];
        [self.contentView addSubview:self.textView];
        self.textView.hidden = YES;
        self.textView.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:self.label];
        [self.contentView addSubview:self.btn];
        [self.contentView addSubview:self.rightImage];
        [self.contentView addSubview:self.textField];
    }
    return self;
}
-(void)btnClick
{
    if ([self.delegate respondsToSelector:@selector(ApplyForRefundCellBtnClick:)]) {
        [self.delegate ApplyForRefundCellBtnClick:self];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
