//
//  SequenceToolView.m
//  Bqu
//
//  Created by yb on 15/11/20.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "SequenceToolView.h"

@interface SequenceToolView ()
@property (nonatomic,strong)UIButton * defaultBtn;
@property (nonatomic,strong)UIButton * priceBtn;
@property (nonatomic,strong)UIButton * countBtn;
@property (nonatomic,strong)UIButton * siftBtn;
@property (nonatomic,strong)UIImageView *image;
@property(nonatomic,strong)SequenceToolBlock block;
@end

@implementation SequenceToolView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
        self.backgroundColor = [UIColor whiteColor];
        CGFloat w = ScreenWidth/3;
        _defaultBtn = [self buildButton:@"默认" tag:1 withFrame:CGRectMake(0, 0, w, 40)];
        [self addSubview:_defaultBtn];
//        UILabel * line1 = [[UILabel alloc] initWithFrame:CGRectMake(w, 0, 1,40)];
//        line1.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
//        [_defaultBtn addSubview:line1];
        
        _priceBtn = [self buildButton:@" 价格" tag:2 withFrame:CGRectMake(w, 0, w, 40)];
        _image = [[UIImageView alloc] initWithFrame:CGRectMake(_priceBtn.width-30, 14, 12, 12)];
        _image.image = [UIImage imageNamed:@"搜索列表页筛选清空箭头"];
        [_priceBtn addSubview:_image];
        [self addSubview:_priceBtn];
//        UILabel * line2 = [[UILabel alloc] initWithFrame:CGRectMake(w, 0, 1,40)];
//        line2.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
//        [_priceBtn addSubview:line2];
        
         _countBtn = [self buildButton:@"销量" tag:3 withFrame:CGRectMake(2*w, 0, w, 40)];
        [self addSubview:_countBtn];

        //筛选先屏蔽
//         _siftBtn = [self buildButton:@"筛选" tag:4 withFrame:CGRectMake(3*w, 0, w, 40)];
//        
//        UILabel * line2 = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, 1,40)];
//        line2.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
//        [_siftBtn addSubview:line2];
//        
//        [self addSubview:_siftBtn];
        UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, ScreenWidth, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        [self addSubview:line];
    }
    return self;
}

-(UIButton*)buildButton:(NSString*)name tag:(NSInteger)tag withFrame:(CGRect)frame
{
    UIButton * button = [[UIButton alloc] init];
    button.frame =frame;
    button.tag = tag;
    [button setTitle:name forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.adjustsImageWhenHighlighted = NO;
    if (tag == 1) {
        [button setTitleColor:[UIColor colorWithHexString:@"#e8103c"] forState:UIControlStateNormal];
    }
    else
    {
         [button setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    }
    [button addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchDown];
    
    return button;
}

-(void)touch:(UIButton*)sender
{
    NSInteger index = (NSInteger)sender.tag;
    _block(index);
    //将所有按钮字体颜色 设置为灰色
    [_defaultBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [_priceBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [_countBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    //[_siftBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    if(sender != _priceBtn)
    _image.image = [UIImage imageNamed:@"搜索列表页筛选清空箭头"];
    
    
    //将点击按钮字体颜色 设置为红色
    [sender setTitleColor:[UIColor colorWithHexString:@"#e8103c"] forState:UIControlStateNormal];
}

//-(void)layoutSubviews
//{
//     NSArray * buttons = self.subviews;
//    CGFloat w = ScreenWidth/(buttons.count-1);
//    
//    for (int i = 0 ;  i< buttons.count-1; i++) {
//        CGRect frame = CGRectMake(w*i, 0, w, 40);
//        UIButton * button = buttons[i];
//        button.frame = frame;
//    }
//}
-(void)setImage:(BOOL)sift
{
    if (sift)
    {
        _image.image = [UIImage imageNamed:@"搜索列表页箭头-价格由低到高"];
    }
    else
    {
        _image.image = [UIImage imageNamed:@"搜索列表页箭头-价格由高到低"];
    }
}

-(void)setBlock:(SequenceToolBlock)block
{
    _block = block;
}
@end
