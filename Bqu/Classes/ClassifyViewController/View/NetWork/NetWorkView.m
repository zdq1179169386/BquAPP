//
//  NetWorkView.m
//  Bqu
//
//  Created by yb on 15/11/19.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "NetWorkView.h"

#define ImageW 100
#define Margin
#define Gap_W 16

@interface NetWorkView ()

@property(nonatomic,strong) UIImageView * Image;

@property (nonatomic,strong) UILabel * notice;

@property (nonatomic,strong) UIButton * reloadBtn;

@end

@implementation NetWorkView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.notice = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 30)];
        _notice.textAlignment = NSTextAlignmentCenter;
        _notice.font = FontWithSize(17);
        _notice.text = @"亲,您的手机网络不太顺畅喔～";
        _notice.textColor = [UIColor colorWithHexString:@"#888888"];
//        _notice.backgroundColor = [UIColor redColor];
        [self addSubview:_notice];
        _notice.center = CGPointMake(frame.size.width/2.0, frame.size.height/2.0);
        
        _Image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ImageW, ImageW)];
        self.Image.image = [UIImage imageNamed:@"404"];
        [self addSubview:_Image];
        _Image.size = _Image.image.size;
        CGFloat image_Y = CGRectGetMinY(_notice.frame);

        _Image.center = CGPointMake(frame.size.width/2.0,image_Y- ImageW/2.0 - Gap_W);
        
        _reloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 110, 40)];
        _reloadBtn.backgroundColor = [UIColor redColor];
        _reloadBtn.layer.cornerRadius = 5;
        _reloadBtn.clipsToBounds = YES;
        [_reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        _reloadBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [_reloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_reloadBtn addTarget:self action:@selector(reloadView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_reloadBtn];
        CGFloat notice_Y = CGRectGetMaxY(_notice.frame);
        _reloadBtn.center = CGPointMake(frame.size.width/2.0, notice_Y+Gap_W+ 20);
        
    }
    return self;
}
-(void)reloadView:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(NetWorkViewDelegate:withBtn:)]) {
        [self.delegate NetWorkViewDelegate:self withBtn:btn];
    }
}
@end
