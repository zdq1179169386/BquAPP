//
//  OrderDetailStatusCell.m
//  Bqu
//
//  Created by 张胜瀚 on 15/12/3.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "OrderDetailStatusCell.h"

@implementation OrderDetailStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.orderStatusLab = [[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.size.height/2-15/2, 60, 15)];
        self.orderStatusLab.font = [UIFont systemFontOfSize:12];
        self.orderStatusLab.numberOfLines = 0;
        self.orderStatusLab.textColor = [UIColor colorWithHexString:@"#333333"];
        
        self.orderInfoLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-(170+10), 12.5, 170, 15)];
        self.orderInfoLab.font = [UIFont systemFontOfSize:12];
        self.orderInfoLab.textColor = [UIColor colorWithHexString:@"#333333"];
        self.orderInfoLab.textAlignment = NSTextAlignmentRight;
        
        self.line = [[UIView alloc] initWithFrame:CGRectMake(10, 39, ScreenWidth-10, 1)];
        self.line.backgroundColor = [UIColor colorWithHexString:@"#dddddd" alpha:0.5];
        
        [self.contentView addSubview:self.orderStatusLab];
        [self.contentView addSubview:self.orderInfoLab];
        [self.contentView addSubview:self.line];

    }
    return self;
}

- (void)setValue:(id)value
{
    _dataDic = value;
    self.orderStatusLab = _dataDic[@""];
}

-(void)setStr:(NSString*)s1 str2:(NSString*)str2
{
    self.orderStatusLab.text = s1;
    self.orderInfoLab.text = str2;
    self.orderInfoLab.font = [UIFont boldSystemFontOfSize:12];
    self.orderInfoLab.textColor = [UIColor colorWithHexString:@"#e8103c"];
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
