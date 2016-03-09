
//
//  ZDQCollectionReusableView.m
//  Bqu
//
//  Created by yb on 15/10/13.
//  Copyright © 2015年 yingbo. All rights reserved.
//

#import "ZDQCollectionReusableView.h"

@implementation ZDQCollectionReusableView

//-(instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.lineOne = [[UILabel alloc] initWithFrame:CGRectMake(20, frame.size.height/2.0, (frame.size.width-130)/2.0, 1)];
//        self.lineOne.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
//        CGFloat  titleX = CGRectGetMaxX(_lineOne.frame);
//        self.title = [[UILabel alloc] initWithFrame:CGRectMake(titleX +10, 0,70, frame.size.height)];
//        self.title.textAlignment = NSTextAlignmentCenter;
//        self.title.font = [UIFont systemFontOfSize:13];
//        self.title.textColor = [UIColor colorWithHexString:@"#666666"];
//
//
//        CGFloat lineTwoX = CGRectGetMaxX(self.title.frame);
//        self.lineTwo = [[UILabel alloc] initWithFrame:CGRectMake(lineTwoX+10, frame.size.height/2.0, (frame.size.width-130)/2.0, 1)];
//        self.lineTwo.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
//        [self addSubview:self.lineOne];
//        [self addSubview:self.title];
//        [self addSubview:self.lineTwo];
//    }
//    return self;
//}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.Btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.Btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.Btn];
    }
    return self;
}
-(void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(ZDQCollectionReusableViewClick:withBtn:)]) {
        [self.delegate ZDQCollectionReusableViewClick:self withBtn:btn];
    }
}
@end
