//
//  OverSeaCell.m
//  Bqu
//
//  Created by WONG on 15/10/12.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "ThemeCell.h"

@implementation ThemeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setThemeModel:(ThemeModel *)themeModel
{
    _themeModel = themeModel;
    //NSLog(@"%@",themeModel.ImageUrl);
    [self.ThemeImg sd_setImageWithURL:[NSURL URLWithString:_themeModel.ImageUrl] placeholderImage:[UIImage imageNamed:@"1106首页占位图-03品牌专场"]];
}


+(instancetype)themeCellWithTableView:(UITableView*)tableView
{
    static NSString *identifier= @"Theme";
    ThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"ThemeCell" owner:nil options:nil]firstObject];
    }
    return cell;
}
@end
