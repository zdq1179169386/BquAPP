//
//  PreferentialTableViewCell.m
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "PreferentialTableViewCell.h"

@implementation PreferentialTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        _selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-40, 10, 35, 35)];
        [_selectBtn addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchDown];
        //_selectBtn.backgroundColor = [UIColor redColor];
        [self addSubview:_selectBtn];
    }
    
    return self;
}

-(void)select:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(selectPreferential:)]) {
        [_delegate selectPreferential:sender];
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setImage:(BOOL)select
{
    if(select)
    {
         [self.selectBtn setImage:[UIImage imageNamed:@"xuntrue"] forState:UIControlStateNormal];
    }
    else
    {
        [self.selectBtn setImage:[UIImage imageNamed:@"xunfalse"] forState:UIControlStateNormal];
    }
}
@end
