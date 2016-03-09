//
//  UsePreferentialTableViewController.m
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "UsePreferentialTableViewController.h"
#import "PreferentialModel.h"
#import "PreferentialSelectTableViewCell.h"

@interface UsePreferentialTableViewController ()

@end

@implementation UsePreferentialTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createBackBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _preferentialArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PreferentialSelectTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"utbCell"];
    if (cell == nil)
    {
        cell = [[PreferentialSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"utbCell"];
    }
    PreferentialModel *pm = _preferentialArr[indexPath.row];
    [cell setValue:pm];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


//设置头 view
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10 , 10, 100,40)];
    lab.text = @"选择优惠劵";
    lab.textColor = [UIColor redColor];
    lab.font = [UIFont systemFontOfSize:16];
    [view addSubview:lab];
    return view;
}

//设置尾 view
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    //设置取消按钮
    UIButton *cancelBtn  = [self buildButton:CGRectMake(0, 0, 100, 40) title:@"取消" tag:200];
    [view addSubview:cancelBtn];
    
    UIButton *yesBtn = [self buildButton:CGRectMake(100, 0, 100, 40) title:@"确定" tag:201];
    [view addSubview:yesBtn];
    return view;
//    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
//    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    cancelBtn.backgroundColor = [UIColor whiteColor];
//    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    cancelBtn.tag = 200;
//    [cancelBtn addTarget:self  action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
//    [view addSubview:cancelBtn];
//    
//    //设置确定按钮
//    UIButton *yesBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 0, 100, 40)];
//    [yesBtn setTitle:@"确定" forState:UIControlStateNormal];
//    yesBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    yesBtn.backgroundColor = [UIColor whiteColor];
//    yesBtn.tag = 201;
//    [yesBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [yesBtn addTarget:self  action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
//    [view addSubview:yesBtn];
//    
}

-(UIButton*)buildButton:(CGRect)frame title:(NSString *)title tag:(NSInteger)tag
{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.tag = tag;
    [btn addTarget:self  action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    return btn;
}

-(void)touchDown:(UIButton*)sender
{
    [self popoverPresentationController];
    if (sender.tag == 201)
    {
        NSIndexPath * path = [self.tableView indexPathForSelectedRow];
        if (path == nil)
        {
            [self  dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
        else
        {
            if ([self.delegate respondsToSelector:@selector(usePreferential:)]) {
                [_delegate usePreferential:path.row];
            }
            [self  dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
}

@end
