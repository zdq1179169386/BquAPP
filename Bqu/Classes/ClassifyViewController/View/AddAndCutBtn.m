//
//  AddAndCutBtn.m
//  Bqu
//
//  Created by yb on 15/10/19.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "AddAndCutBtn.h"

@implementation AddAndCutBtn

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        
        CGFloat itemW = frame.size.width/3.0;
        self.cutBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width/3.0, frame.size.height)];
        self.cutBtn.tag = 111;
        [self.cutBtn setTitle:@"－" forState:UIControlStateNormal];
        [self.cutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.cutBtn addTarget:self action:@selector(cutAndAdd:) forControlEvents:UIControlEventTouchUpInside];
        [self.cutBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];

        UILabel * lineOne = [[UILabel alloc] initWithFrame:CGRectMake(itemW, 0, 1, frame.size.height)];
        lineOne.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
        [self addSubview:lineOne];
//        [self.cutBtn setImage:[UIImage imageNamed:@"decrease"] forState:UIControlStateNormal];
        self.number = [[UILabel alloc] initWithFrame:CGRectMake(itemW, 0, itemW, frame.size.height)];
        self.number.textAlignment = NSTextAlignmentCenter;
        self.number.text = @"1";
        
        UILabel * lineTwo = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - itemW, 0, 1, frame.size.height)];
        lineTwo.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
        [self addSubview:lineTwo];
        
        self.addBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-itemW, 0, itemW, frame.size.height)];
        [self.addBtn setTitle:@"+" forState:UIControlStateNormal];
        [self.addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         [self.addBtn addTarget:self action:@selector(cutAndAdd:) forControlEvents:UIControlEventTouchUpInside];
        [self.addBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        self.addBtn.tag = 222;

//       [self.addBtn setImage:[UIImage imageNamed:@"increase"] forState:UIControlStateNormal];
        
        [self addSubview:self.cutBtn];
        [self addSubview:self.number];
        [self addSubview:self.addBtn];
    }
    return self;
}
-(void)cutAndAdd:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(AddAndCutBtn:withBtn:withLabel:)]) {
        [self.delegate AddAndCutBtn:self withBtn:btn withLabel:self.number];
    }
}
@end
