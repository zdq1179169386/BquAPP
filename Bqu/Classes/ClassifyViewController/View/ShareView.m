//
//  ShareView.m
//  Bqu
//
//  Created by yb on 15/10/21.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "ShareView.h"
#define buttomView_H 320.0

@implementation ShareView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        NSArray * array = [NSArray arrayWithObjects:@"B区详情页04-分享弹窗",@"B区详情页04-分享弹窗朋友圈",@"B区详情页04-分享弹窗微博",@"B区详情页04-分享qq@2x",@"B区详情页04-分享qq空间", nil];
        
        self.backgroundColor = [UIColor colorWithHexString:@"#B2B2B2" alpha:0.7];
        self.buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-buttomView_H, ScreenWidth, buttomView_H)];
        self.buttomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.buttomView];
        
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
        title.text = @"分享给朋友";
        title.textAlignment = NSTextAlignmentCenter;
        [self.buttomView addSubview:title];
        for (int i =0; i<5; i++) {
            CGFloat btnW = 50;
            CGFloat gapW = (ScreenWidth-150)/4.0;
            NSInteger row = i/3;
            NSInteger loc = i%3;
            
            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(gapW+loc*(gapW+btnW), 60+(gapW+btnW)*row, btnW, btnW)];
//            btn.backgroundColor = [UIColor redColor];
            [btn setImage:[UIImage imageNamed:[array objectAtIndex:i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i + 100;
            [self.buttomView addSubview:btn];
        }
        
        self.dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, buttomView_H-20-40, ScreenWidth, 40)];
        self.dismissBtn.layer.borderWidth = 1;
        self.dismissBtn.layer.borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
        [self.dismissBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.dismissBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.dismissBtn.tag = 222;
        [self.dismissBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.buttomView addSubview:self.dismissBtn];
        
    }
    return self;
}
-(void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(ShareViewDelegate:withBtn:)]) {
        [self.delegate ShareViewDelegate:self withBtn:btn];
    }
}
+(instancetype)creatShareView
{
    return [[self alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
}
@end
