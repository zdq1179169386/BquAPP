//
//  NoGoodsInShoppingCar.m
//  Bqu
//
//  Created by yb on 15/10/19.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "NoGoodsInShoppingCar.h"
#import "LoginViewController.h"

@implementation NoGoodsInShoppingCar

-(instancetype) initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithHexString:@"#F2F0F0"];
        
        _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        _headImage.image = [UIImage imageNamed:@"shopbg"];
        _headImage.userInteractionEnabled = YES ;
        [self addSubview:_headImage];
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 300, 50)];
        view.backgroundColor = [UIColor clearColor];
        view.center = _headImage.center;
        view.userInteractionEnabled = YES;
        [_headImage addSubview:view];
        
        _sweetPrompt = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width,view.height)];
        _sweetPrompt.text = @"温馨提示：现在登入登入，同步电脑与手机购物车中的商品";
        _sweetPrompt.textColor = [UIColor colorWithHexString:@"#E8103C"];
        _sweetPrompt.font = [UIFont systemFontOfSize:11];
        _sweetPrompt.textAlignment = NSTextAlignmentCenter;
        _sweetPrompt.backgroundColor = [UIColor clearColor];
        [view addSubview:_sweetPrompt];
        
        _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(85, 17, 42,17)];
        _loginBtn.backgroundColor = [UIColor colorWithRed:255 green:225 blue:230 alpha:1];
        _loginBtn.layer.borderWidth = 1;
        _loginBtn.layer.borderColor = [UIColor colorWithHexString:@"#E8103c"].CGColor;
        _loginBtn.layer.cornerRadius = 3;
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor colorWithHexString:@"#E8103c"] forState:UIControlStateNormal];
        [view addSubview:_loginBtn];
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 130, 40)];
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        btn.tag = 100;
        [view addSubview:btn];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-45, ScreenHeight/5, 90, 90)];
        imageView.image = [UIImage imageNamed:@"shopcar"];
        [self addSubview:imageView];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-230)/2, imageView.y+110, 230, 20)];
        label.text = @"您的购物车空空如也，赶快去挑选商品吧!";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHexString:@"#888888"];
        label.font = [UIFont systemFontOfSize:12];
        [self addSubview:label];
        
        
        _promptBtn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth-100)/2, label.y+40, 100, 30)];
        _promptBtn.backgroundColor = [UIColor colorWithHexString:@"#E8103c"];
        _promptBtn.titleLabel.textColor = [UIColor whiteColor];
        [_promptBtn setTitle:@"去逛逛" forState:UIControlStateNormal];
        _promptBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _promptBtn.layer.cornerRadius = 4;
        [_promptBtn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        _promptBtn.tag = 101;
        [self addSubview:_promptBtn];
        
    }
    return self;
}


-(void)touchDown:(UIButton*)sender
{
    
    if ([self.delegate respondsToSelector:@selector(jumpToLoginOrOther:)]) {
        
        [self.delegate jumpToLoginOrOther:sender];
    }
}

-(void)noLoginStatus
{
    self.headImage.hidden = NO;
    self.sweetPrompt.hidden = NO;
    self.hidden = NO;
}

-(void)LoginStatus
{
    self.hidden = YES;
}

-(void)LoginNOGoodsStatus
{
    self.headImage.hidden = YES;
    self.sweetPrompt.hidden = YES;
    self.hidden = NO;
}
@end
