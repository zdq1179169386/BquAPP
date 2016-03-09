//
//  PromptPriceView.m
//  Bqu
//
//  Created by yb on 15/10/20.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "PromptPriceView.h"

@implementation PromptPriceView


-(instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.layer setShadowColor:[UIColor blackColor].CGColor];//设置View的阴影颜色
        [self.layer setShadowOpacity:0.8f];//设置阴影的透明度
        [self.layer setOpacity:0.5f];//设置View的透明度
        [self.layer setShadowOffset:CGSizeMake(4.0, 3.0)];//设置View Shadow的偏移量
        double hsize = 7;
        double wsize = 12;
        if (ScreenWidth < 375) {
            wsize = 10;
            hsize = 9;
        }

        _image = [[UIImageView alloc] initWithFrame:CGRectMake(7, hsize, 11, 18)];
        _image.image = [UIImage imageNamed:@"erro.png"];
        [self addSubview:_image];
        
        _promptLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, self.frame.size.width-23, 29)];
        NSString * ste =@"亲，海关规定购物多件的总价不能超过￥1000哦，请您分多次购买。";
        NSMutableAttributedString*priceToStr = [[NSMutableAttributedString alloc] initWithString:ste];
        [priceToStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#4ea9e9"] range:NSMakeRange(17,6)];
        [priceToStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:wsize] range:NSMakeRange(0, ste.length)];
        _promptLab.attributedText=priceToStr ;
        _promptLab.numberOfLines= 2;
        [self addSubview:_promptLab];
    }
    return self;
}
@end
