//
//  ProductDeatilSecondSectionHeader.m
//  Bqu
//
//  Created by yb on 15/10/20.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "ProductDeatilSecondSectionHeader.h"

@interface ProductDeatilSecondSectionHeader()
{
    NSInteger _lastBtn;
}

@end

@implementation ProductDeatilSecondSectionHeader

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
//        self.backgroundColor = [UIColor whiteColor];
        CGFloat btnW = ScreenWidth/3.0;
        self.fistBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnW, 40)];
        [self.fistBtn setTitle:@"图文详情" forState:UIControlStateNormal];
        self.fistBtn.titleLabel.font = [UIFont fontWithName:NormalFONT size:17];
        self.secondBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnW, 0, btnW, 40)];
        [self.secondBtn setTitle:@"基本参数" forState:UIControlStateNormal];
        self.secondBtn.titleLabel.font = [UIFont fontWithName:NormalFONT size:17];
        self.threebtn = [[UIButton alloc] initWithFrame:CGRectMake(btnW*2, 0, btnW, 40)];
        [self.threebtn setTitle:@"B区保障" forState:UIControlStateNormal];
        self.threebtn.titleLabel.font = [UIFont fontWithName:NormalFONT size:17];

        self.fistBtn.backgroundColor = [UIColor whiteColor];
        self.secondBtn.backgroundColor = [UIColor whiteColor];

        self.threebtn.backgroundColor = [UIColor whiteColor];

        [self.fistBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.secondBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.threebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  
        [self.fistBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.secondBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.threebtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

        _lastBtn = 111;
        self.fistBtn.tag = 111;
        self.secondBtn.tag = 222;
        self.threebtn.tag = 333;
        [self.contentView addSubview:self.fistBtn];
        [self.contentView addSubview:self.secondBtn];
        [self.contentView addSubview:self.threebtn];
        
        UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        [self.contentView addSubview:line];
        
        self.buttomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, btnW, 1)];
        self.buttomLine.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.buttomLine];

    }
    return self;
}
-(void)btnClick:(UIButton *)btn
{
   
    if ([self.delegate respondsToSelector:@selector(ProductDeatilSecondSectionHeaderDelegate:withBtn:withLine:withTag:)]) {
        [self.delegate ProductDeatilSecondSectionHeaderDelegate:self withBtn:btn withLine:self.buttomLine withTag:_lastBtn];
    }

}
@end
