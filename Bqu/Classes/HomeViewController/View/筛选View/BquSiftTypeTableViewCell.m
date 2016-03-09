//
//  BquSiftTypeTableViewCell.m
//  Bqu
//
//  Created by yb on 15/12/9.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "BquSiftTypeTableViewCell.h"



@interface BquSiftTypeTableViewCell ()

@property(nonatomic) UILabel * showLab;

@end


@implementation BquSiftTypeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.showLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-20, 40)];
        self.showLab.font = [UIFont systemFontOfSize:14];
        self.showLab.textColor = [UIColor colorWithHexString:@"#333333"];
        self.showLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.showLab];
        
        UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, ScreenWidth-90, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        [self addSubview:line];
    }
    return self;
}

+(instancetype)bquSiftTypeTableViewCell:(UITableView*)tableView
{
    static NSString * identifier = @"SiftTypeTableViewCell";
    BquSiftTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
    if (!cell) {
        cell = [[BquSiftTypeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier ];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)setModel:(SiftTypeModel *)model
{
    _model = model;
    _showLab.text = [NSString stringWithFormat:@"%@",model.name];
}

@end
