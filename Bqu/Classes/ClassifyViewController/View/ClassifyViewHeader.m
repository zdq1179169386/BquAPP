//
//  ClassifyViewHeader.m
//  Bqu
//
//  Created by yb on 15/11/23.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "ClassifyViewHeader.h"

#define BtnCount 2.0f
#define btnX 95/375.0f
@interface ClassifyViewHeader ()

@property(nonatomic,strong)UILabel * line;

@property (nonatomic,strong)UIButton * selectedBtn;


@end

@implementation ClassifyViewHeader
+(instancetype)creatHeader
{
    return  [[self alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ClassifyViewHeaderH)];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.buttons = [[NSMutableArray alloc] init];
        CGFloat btnW = 50;
        CGFloat btn_X =  btnX*ScreenWidth;
        for (int i = 0; i < BtnCount; i++) {
            
            UIButton * classifyBtn = [[UIButton alloc] init];
            classifyBtn.tag = 100 + i;
//            classifyBtn.backgroundColor = [UIColor redColor];
            [classifyBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            [classifyBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateSelected];
            classifyBtn.titleLabel.font = [UIFont systemFontOfSize:17];
            classifyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [classifyBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:classifyBtn];
            
            if (i == 0) {
                classifyBtn.frame = CGRectMake(ScreenWidth/2.0-35-btnW, 0, btnW, ClassifyViewHeaderH);
                [classifyBtn setTitle:@"分类" forState:UIControlStateNormal];
                classifyBtn.selected = YES;
                self.selectedBtn = classifyBtn;
                
                UILabel * line = [[UILabel alloc] init];
                [self addSubview:line];
                line.backgroundColor = [UIColor colorWithHexString:@"#E7113D"];
                self.line = line;
                line.center = CGPointMake(classifyBtn.center.x, 33);
                line.bounds = CGRectMake(0, 0, 43, 2);
            }else
            {
                classifyBtn.frame = CGRectMake(ScreenWidth/2.0+35, 0, btnW, ClassifyViewHeaderH);
                [classifyBtn setTitle:@"品牌" forState:UIControlStateNormal];

            }
            [self.buttons addObject:classifyBtn];
        }
        UILabel * grayLine = [[UILabel alloc] initWithFrame:CGRectMake(0, ClassifyViewHeaderH-1, ScreenWidth, 1)];
        grayLine.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
        [self addSubview:grayLine];

        
    }
    return self;
}
-(void)BtnClick:(UIButton *)btn
{

    if ([self.delegate respondsToSelector:@selector(ClassifyViewHeaderDelegate:with:)]) {
        [self.delegate ClassifyViewHeaderDelegate:self with:btn];
    }
    
}
-(void)setupBtn:(int )index
{
    UIButton * btn = [self.buttons objectAtIndex:index];
    [UIView animateWithDuration:0.2 animations:^{
        self.line.center = CGPointMake(btn.center.x, 33);
        self.selectedBtn.selected = NO;
        
    } completion:^(BOOL finished) {
        btn.selected = YES;
        self.selectedBtn = btn;
    }];
}
@end
