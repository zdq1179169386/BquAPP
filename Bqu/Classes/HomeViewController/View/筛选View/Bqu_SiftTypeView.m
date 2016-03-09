//
//  Bqu_SiftTypeView.m
//  Bqu
//
//  Created by yb on 15/12/9.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "Bqu_SiftTypeView.h"

@interface Bqu_SiftTypeView ()

@property (nonatomic,strong)UIButton *bondedAreaBtn;

@property (nonatomic,strong)UIButton *brandBtn;

@property(nonatomic,strong)UIButton *countryBtn;

@property (nonatomic,copy)Bqu_SiftTypeViewBlock block;

@property (nonatomic,weak)UIButton * selectBtn;

@end

@implementation Bqu_SiftTypeView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
        self.bondedAreaBtn =[self buildButton:@"保税区" frame:CGRectMake(0, 0, frame.size.width, 40) tag:0];
        //[self buildButton:@"保税区" frame:cgrect];
        self.countryBtn = [self buildButton:@"国家" frame:CGRectMake(0, 40, frame.size.width, 40) tag:1];
        self.brandBtn =[self buildButton:@"品牌 " frame:CGRectMake(0, 80, frame.size.width, 40) tag:2];
        
        
        _selectBtn = self.bondedAreaBtn;
        [self touchDown:self.bondedAreaBtn];
        
    }
    return self;
}

-(UIButton*)buildButton:(NSString*)name frame:(CGRect)frame tag:(NSUInteger)tag
{
    UIButton * button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
    button.tag = tag;
    [button setTitle:name forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    [button setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, frame.origin.y, frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    line.alpha = 0.5;
    [button addSubview:line];
    [button addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:button];
    return button;
}

-(void)touchDown:(UIButton*)sender
{
    if (_block) {
        _block(sender.tag);
    }
    _selectBtn.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
    _selectBtn = sender;
    _selectBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
}

-(void)setBqu_SiftTypeViewBlock:(Bqu_SiftTypeViewBlock)block
{
    _block = block;
}
@end
