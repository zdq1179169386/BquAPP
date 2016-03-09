//
//  LeaveMessageViewController.m
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "LeaveMessageViewController.h"
#import "BquTextView.h"

@interface LeaveMessageViewController ()

@property (nonatomic,strong)BquTextView * leaveMessageField;
@property (nonatomic,strong)UIButton * certainBtn;
@property (nonatomic,strong)NSString *leaveMessage;
@property (nonatomic,copy)LeaveMessageBlock block;


@end

@implementation LeaveMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"买家留言";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EFEFF0"];
    [self addLeaveMessageField];
    [self addCertainBtn];
    [self createBackBar];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.leaveMessage.length > 0 ) {
        [self.leaveMessageField hasWord ];
    }
    
}
- (void)createBackBar
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(backBarClicked) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 30, 21);
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}


- (void)backBarClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)addLeaveMessageField
{
    _leaveMessageField = [[BquTextView alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth, 100)];
    [_leaveMessageField setPromptLab:@"  请您在此填写对卖家的特殊要求"] ;
    _leaveMessageField.backgroundColor =[UIColor whiteColor];
    _leaveMessageField.font = [UIFont systemFontOfSize:14];

    if (![_leaveMessage isEqual:@""])
    {
        _leaveMessageField.text = _leaveMessage;
    }
    [self.view addSubview:_leaveMessageField];
}


-(void)addCertainBtn
{
    _certainBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 125, ScreenWidth-20, 44)];
    _certainBtn.backgroundColor = [UIColor colorWithHexString:@"#e8103c"];
    _certainBtn.layer.cornerRadius = 4;
    [_certainBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_certainBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [_certainBtn addTarget:self action:@selector(certainTouchDown) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_certainBtn];
}


-(void)certainTouchDown
{
    if(_block){
    _block(_leaveMessageField.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setMessage:(NSString*)leaveMessage
{
    //关闭 暂时
    self.leaveMessage= leaveMessage;
}

-(void)setBlock:(LeaveMessageBlock)block
{
    _block = block;
}
@end
