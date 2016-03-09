//
//  ClassifyTableOneCell.m
//  Bqu
//
//  Created by yb on 15/11/4.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "ClassifyTableOneCell.h"
#define Cell_H  56
#define Cell_W  114
@interface ClassifyTableOneCell ()

@property(nonatomic,strong)UILabel * line;

@property (nonatomic,strong) UILabel * name;

@end

@implementation ClassifyTableOneCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor =  [UIColor colorWithHexString:@"#F7F7F7"];
        self.accessoryType = UITableViewCellAccessoryNone;
        if (!self.line) {
            self.line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 4,Cell_H)];
            self.line.backgroundColor = [UIColor redColor];
            self.line.hidden = YES;
            [self.contentView addSubview:self.line];
        }
        if (!self.name) {
            self.name = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Cell_W,Cell_H)];
            self.name.font = [UIFont systemFontOfSize:17];
            self.name.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:self.name];
        }
        
    }
    return self;
}
-(void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (_isSelected==YES) {
        //选中
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.name.textColor = [UIColor colorWithHexString:@"#f72548"];
        self.line.hidden = NO;
    }else
    {
        //未选中
        self.contentView.backgroundColor =  [UIColor colorWithHexString:@"#F7F7F7"];
        self.name.textColor = [UIColor blackColor];
        self.line.hidden = YES;
    }
}
-(void)setTitle:(NSString *)title
{
    _title = title;
    self.name.text = title;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
