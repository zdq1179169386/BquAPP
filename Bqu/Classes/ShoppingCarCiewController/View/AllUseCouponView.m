//
//  AllUseCouponView.m
//  Bqu
//
//  Created by yb on 15/10/20.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "AllUseCouponView.h"
#import "PreferentialSelectTableViewCell.h"
#import "PreferentialModel.h"

@implementation AllUseCouponView
{
    UITableView *_table;
    UIButton *_cancelBtn;
    UIButton *_yesBtn;
    UILabel *title;
    NSInteger  selectRow;
}

-(instancetype)initWithFrame:(CGRect)frame deleagte:(id)delegate coupons:(NSArray*)coupons
{
    if (self = [super initWithFrame:frame])
    {
        self.delegate = delegate;
        self.coupons = coupons;
        
        self.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.3];
        CGFloat  ViewHigh = 60*(_coupons.count)+80;
        if (ViewHigh > 320)
        {
            ViewHigh = 320;
        };
        CGFloat width = (ScreenWidth -230)/2;
        CGFloat high = (ScreenHeight-ViewHigh)/2;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(width, high, 230 , ViewHigh)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 6;
        
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, view.size.width, view.size.height-80) style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource =self;
        _table.sectionHeaderHeight = 0.01;
        [view addSubview:_table];
        
        title = [[UILabel alloc]  initWithFrame:CGRectMake(0, 0, view.frame.size.width, 40)];
        title.text = @"选择优惠劵";
        title.textColor = [UIColor colorWithHexString:@"#e8103c"];
        title.font = [UIFont systemFontOfSize:14];
        title.textAlignment = NSTextAlignmentCenter;
        [view addSubview:title];
        
        
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, view.frame.size.height-40, view.frame.size.width/2, 40)];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"e8103c"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchDown];
        _cancelBtn.tag = 100;
        [view addSubview:_cancelBtn];
        
        _yesBtn = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.size.width/2, view.frame.size.height-40, view.frame.size.width/2, 40)];
        [_yesBtn setTitle:@"确定" forState:UIControlStateNormal];
        _yesBtn.tag = 101;
        [_yesBtn setTitleColor:[UIColor colorWithHexString:@"e8103c"] forState:UIControlStateNormal];
        [_yesBtn addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchDown];
        [view addSubview:_yesBtn];
        
        [self addSubview:view];
    }
    return self;
}


#pragma  mark----tableView代理--------开始
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_coupons)
    {
        return _coupons.count;
    }
    else
        return 0;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PreferentialSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"preferent"];
    if (cell == nil)
    {
        cell = [[PreferentialSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"preferent"];
    }
    [cell setValue:_coupons[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectRow = indexPath.row;
    if (_coupons)
    {
        for (PreferentialModel*pModel in _coupons)
        {
            pModel.isSelect = 0;
        }
        PreferentialModel*mode = _coupons[indexPath.row];
        mode.isSelect = 1;
        [_table reloadData];
    }
}

#pragma  mark----tableView代理--------结束
-(void)touch:(UIButton*)sender;
{
    if (sender.tag == 101)
    {
        if ([self.delegate respondsToSelector:@selector(selectCoupon:)]) {
            [self.delegate selectCoupon:selectRow ];
        }
    }
    [self removeFromSuperview];
}
@end
