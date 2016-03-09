
//
//  MessageCell.m
//  Bqu
//
//  Created by yingbo on 15/11/30.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.messageImgView =  [[UIImageView alloc] initWithFrame:CGRectMake(9, 10, 15, 15)];
        self.messageImgView.image = [UIImage imageNamed:@"message"];
        
        self.messageLab = [[UILabel alloc] initWithFrame:CGRectMake(9+ 15+ 5, 10, ScreenWidth- 29 - 15, 30)];
        self.messageLab.font = [UIFont systemFontOfSize:12];
        self.messageLab.numberOfLines = 0;
        self.messageLab.textColor = [UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:self.messageImgView];
        [self.contentView addSubview:self.messageLab];
    }
    return self;
}

- (void)setValue:(id)value
{
    _dataDic = value;
    NSString *str = [NSString stringWithFormat:@"买家留言:%@",_dataDic];
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12] maxW:ScreenWidth-29- 15];
    self.messageLab.frame = CGRectMake(9+ 15+ 5, 10, ScreenWidth-29- 15, size.height);
    self.messageLab.text = str;
}


@end
