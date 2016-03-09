//
//  PayWayTableViewCell.m
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "PayWayTableViewCell.h"

@implementation PayWayTableViewCell


-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _image = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-30, 20, 20, 20)];
        _image.image = [UIImage imageNamed:@"xunfalse.png"];
        [self addSubview:_image];
    }
    return  self;
}

-(void)setValue2:(BOOL)on
{
    if (on)
    {
        _image.image = [UIImage imageNamed:@"xuntrue.png"];
    }
    else
    {
        _image.image = [UIImage imageNamed:@"xunfalse.png"];
    }
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
