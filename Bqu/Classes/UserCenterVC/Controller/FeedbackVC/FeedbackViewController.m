//
//  FeedbackViewController.m
//  Bqu
//
//  Created by yingbo on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FeedRuleViewController.h"
#import "FeedCell.h"
@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:animated];
    [self createBackBar];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"意见反馈";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F1F1"];
    
    /*创建显示主界面表*/
    [self createMainTable];
    /*导航栏右边反馈规则按钮*/
    [self setFeedlRule];
}

#pragma mark    ----> 表
- (void)createMainTable
{
    if (self.tableView != nil)
    {
        return;
    }
    else
    {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.bounces = YES;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //自定义cell
        [self.tableView registerNib:[UINib nibWithNibName:@"FeedCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        [self.view addSubview:self.tableView];

    }
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 617;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    //反馈按钮绑定事件
    [cell.one_Btn addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.one_Btn.tag = 601;
    [cell.two_btn addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.two_btn.tag = 602;
    [cell.three_Btn addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.three_Btn.tag = 603;
    [cell.fourBtn addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.fourBtn.tag = 604;
    [cell.five_Btn addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.five_Btn.tag = 605;
    
    self.buttonArray = [NSArray array];
    self.buttonArray = @[cell.one_Btn,cell.two_btn,cell.three_Btn,cell.fourBtn,cell.five_Btn];
    
    cell.textView1.delegate = self;
    cell.textView1.tag =333;
    cell.textView2.delegate = self;
    cell.textView2.tag =334;

    [cell.commit_Btn addTarget:self action:@selector(commitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.commit_Btn onlyCornerRadius];
    
    
    cell.tip1_Lab.textColor = [UIColor colorWithHexString:@"#333333"];
    cell.tip2_Lab.textColor = [UIColor colorWithHexString:@"#333333"];
    cell.tip3_Lab.textColor = [UIColor colorWithHexString:@"#333333"];
    cell.tip4_Lab.textColor = [UIColor colorWithHexString:@"#333333"];
    cell.tip5_Lab.textColor = [UIColor colorWithHexString:@"#333333"];
    
    [cell.one_Btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];;
    [cell.two_btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];;
    [cell.three_Btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];;
    [cell.fourBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];;
    [cell.five_Btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)setFeedlRule
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(RuleClicked) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 60, 21);
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"常见问题" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
}

- (void)RuleClicked
{
    FeedRuleViewController *rule = [[FeedRuleViewController alloc] init];
    rule.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rule animated:NO];
}

-(void)textViewDidChange:(UITextView *)textView
{
    FeedCell * cell = nil;
    //判断当前设备是否iOS7系列 ios7多一层
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        cell = (FeedCell *)[[[textView superview] superview] superview];
    }
    else
    {
        cell = (FeedCell *)[[textView superview] superview];
    }

    
    //判断当前是哪个textView
    if (textView.tag == 333)
    {
        if (textView.text.length > 0)
        {
            [cell.lab1 setHidden:YES];
        }
        else
        {
            [cell.lab1 setHidden:NO];

        }
    }
    else if(textView.tag == 334)
    {
        if (textView.text.length > 0)
        {
            [cell.lab2 setHidden:YES];
        }
        else
        {
            [cell.lab2 setHidden:NO];
        }
    }
}


/*意见类型按钮点击事件*/
- (void)ButtonClick:(UIButton *)sender
{
    for (UIButton * button in self.buttonArray)
    {
        button.backgroundColor = RGB_A(211, 211, 211);
    }
    
    UIButton *sender1 = (UIButton *)sender;
    sender1.backgroundColor = [UIColor clearColor];
    NSString *tag = [NSString stringWithFormat:@"%ld",(long)sender1.tag-600];
    self.SourceType = tag;
    
}
/*提交按钮点击事件*/
- (void)commitButtonClick:(UIButton *)sender
{
    if ([self.isLogin isEqualToString:@"0"])
    {
        FeedCell * cell = nil;
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
        {
            cell = (FeedCell *)[[[sender superview] superview] superview];
        }
        else
        {
            cell = (FeedCell *)[[sender superview] superview];
        }
        
        /*是否选择意见类型*/
        if (self.SourceType == nil )
        {
            [TipView remindAnimationWithTitle:@"要选择意见类型哦"];
        }
        else
        {
            /*三个输入框是否为空*/
            if (![cell.textView1.text isEqualToString:@""] || ![cell.textView2.text isEqualToString:@""] || ![cell.emailTextF.text isEqualToString:@""]  )
            {
                /*邮箱正则*/
                if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"] evaluateWithObject:cell.emailTextF.text])
                {
                    [TipView remindAnimationWithTitle:@"邮箱格式不正确哦~"];
                }
                else
                {
                    /*添加意见反馈接口*/
                    NSString *urlStr = [NSString stringWithFormat:@"%@%@",bquUrl,addFeedbacklUrl];
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    dict[@"MemberID"] = [NSString stringWithFormat:@"%@",[UserManager getMyObjectForKey:userIDKey]];
                    dict[@"token"] = [UserManager getMyObjectForKey:accessTokenKey];
                    dict[@"action"] = @"AddFeedback";
                    dict[@"Describe"] = cell.textView1.text;
                    dict[@"Improve"] = cell.textView1.text;
                    dict[@"Email"] = cell.emailTextF.text;
                    dict[@"SourceType"] = self.SourceType;
                    
                    NSString *realSign = [HttpTool returnForSign:dict];
                    dict[@"sign"] = realSign;
                    [HttpTool post:urlStr params:dict success:^(id json)
                     {
                         //NSLog(@"反馈%@",json);
                         
                         NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
                         if ([resultStr isEqualToString:@"0"])
                         {
                             [TipView remindAnimationWithTitle:@"反馈成功"];

                             [TipView doSomething:^{
                                 [self.navigationController popToRootViewControllerAnimated:NO];
                             } afterDelayTime:1];
                             
                         }
                     } failure:^(NSError *error)
                     {
                         
                     }];
                }
            }
            else
            {
                [TipView remindAnimationWithTitle:@"填写内容不可以为空哦"];
            }
        }
    }
    else
    {
       [TipView remindAnimationWithTitle:@"您还没有登陆哦~"];
    }
}

/*第三方,向上拉,键盘下落*/
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<0)
    {
        [self.view endEditing:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
