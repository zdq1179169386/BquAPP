//
//  SiftConditionDetailShowView.m
//  Bqu
//
//  Created by yb on 15/12/10.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "SiftConditionDetailShowView.h"
#import "SiftCOnditionDetailShowViewModel.h"

@interface SiftConditionDetailShowView ()
@property(nonatomic)UIButton *bt1;
@property(nonatomic)UIButton *bt2;
@property(nonatomic)UIButton *bt3;
@property(nonatomic)UIButton *bt4;
@property(nonatomic)UIButton *bt5;
@property(nonatomic)UIButton *deleteBtn;
@property(nonatomic)NSMutableArray * btns;
@property(nonatomic)UIScrollView * scrollView;


@property(nonatomic,copy)conditionDetailShowViewBlock block;
@end

@implementation SiftConditionDetailShowView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-57-9, 40)];
        UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth-57-9, 0, 1, 40)];
        line2.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        line2.alpha = 0.5;
        [self addSubview:self.scrollView];
        [self addSubview:line2];
        
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.bt1 = [self buildButton:0];
        self.bt2 = [self buildButton:1];
        self.bt3 = [self buildButton:2];
        self.bt4 = [self buildButton:3];
        self.bt5 = [self buildButton:4];

        self.deleteBtn = [self button:10];
        self.btns = [[NSMutableArray alloc] initWithObjects:self.bt1,self.bt2,self.bt3,self.bt4,self.bt5, nil];
        
        UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        line.alpha = 0.5;
        [self addSubview:line];
    }
    return  self;
}

-(UIButton*)buildButton:(NSUInteger)index
{
    UIButton * btn = [self button:index];
    [btn setImage:[UIImage imageNamed:@"B区-搜索列表页筛选清空"] forState:UIControlStateNormal];
    btn.hidden = YES;
    return btn;
}

-(UIButton*)button:(NSUInteger)index
{
    UIButton * btn = [[UIButton alloc] init];
    btn.x = ScreenWidth - 47-10;
    btn.width = 47;
    btn.height = 24;
    btn.y = 8;
    btn.tag = index;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    //btn.titleLabel.textColor = [UIColor colorWithHexString:@"dddddd"];
    [btn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    btn.layer.borderWidth =1;
    btn.layer.borderColor =[UIColor colorWithHexString:@"dddddd"].CGColor;
    
    [btn setTitle:@"清空" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchUpInside];
    if (index> 5) {
        [self addSubview:btn];
    }
    else
    {
        [self.scrollView addSubview:btn];
    }
    return btn;
}

-(void)touchDown:(UIButton*)sender
{
    if (_block) {
        _block((NSUInteger)sender.tag);
    }
}

-(void)setConditionArray:(NSArray *)conditionArray
{
    [self allHide];
    _conditionArray = conditionArray;
    for (int  i = 0 ; i < _conditionArray.count; i++) {
        UIButton *btn = _btns[i];
        btn.hidden = NO;
        SiftCOnditionDetailShowViewModel *model =_conditionArray[i];
        NSString * name = model.name;
        [btn setTitle:name forState:UIControlStateNormal];
        CGSize size = [btn.titleLabel sizeThatFits:CGSizeMake(btn.titleLabel.width, MAXFLOAT)];
        btn.width = size.width + 30;
        if (i == 0) {
            btn.x = 10;
        }
        else
        {
            UIButton * BtnLeft = _btns[i-1];
            btn.x = BtnLeft.x+BtnLeft.width+10;
        }
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, size.width+10, 0, 0);
        btn.titleEdgeInsets =UIEdgeInsetsMake(0,-30, 0, 0);
        self.scrollView.contentSize = CGSizeMake(btn.x+size.width+30+10, 40);
    }
}


-(void)allHide
{
    for (UIButton * btn in _btns) {
        btn.hidden = YES;
    }
}

-(void)setConditionDetailShowViewBlock:(conditionDetailShowViewBlock)block
{
    _block = block;
}
@end
