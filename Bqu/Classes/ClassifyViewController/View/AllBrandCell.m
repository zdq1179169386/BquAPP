//
//  AllBrandCell.m
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "AllBrandCell.h"

@implementation AllBrandCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat itemW = (ScreenWidth - 50)/4.0;
        self.Image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.Image.layer.borderWidth = 1;
        self.Image.layer.borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
        self.Image.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.Image];
    }
    return self;
}

@end
