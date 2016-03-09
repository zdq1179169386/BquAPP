//
//  ZDQBtn.m
//  Bqu
//
//  Created by yb on 15/10/13.
//  Copyright © 2015年 yingbo. All rights reserved.
//

#import "ZDQBtn.h"

@implementation ZDQBtn

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.number = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-10,-7, 18, 18)];
        self.number.backgroundColor = [UIColor colorWithHexString:@"#F6274A"];
        self.number.font = [UIFont systemFontOfSize:13];
        self.number.textAlignment = NSTextAlignmentCenter;
        self.number.layer.cornerRadius = 9;
        self.number.clipsToBounds = YES;
        self.number.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.number.text = @"0";
        [self addSubview:self.number];
    }
    return self;
}


@end
