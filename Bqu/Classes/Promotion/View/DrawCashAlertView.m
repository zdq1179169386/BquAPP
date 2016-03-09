//
//  DrawCashAlertView.m
//  Bqu
//
//  Created by yb on 15/12/10.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "DrawCashAlertView.h"
#import "DrawCashAlertViewCell.h"
#import "PromotionAccountModel.h"
@interface DrawCashAlertView ()<UITableViewDataSource,UITableViewDelegate>

{
    int count;
    NSArray * _array;
    NSIndexPath * _index;
}
@end

@implementation DrawCashAlertView

- (id)initWithFrame:(CGRect)frame withDelegate:(id)delegate withTitle:(NSString *)title withArray:(NSArray *)array withIndexPath:(NSIndexPath* )index
{
    if (self = [super initWithFrame:frame]) {
        self.delegate = delegate;
        count = array.count;
        _array = [[NSArray alloc] initWithArray:array];
        _index = index;
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(30, 60, ScreenWidth-60, (array.count+1)*50)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 5;
        view.clipsToBounds = YES;
        [self addSubview:view];
        view.center = CGPointMake(ScreenWidth/2.0, ScreenHeight/2.0);
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-60, 43)];
        label.text = title;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = RGB_A(82, 144, 222);
        [view addSubview:label];
        
        UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, ScreenWidth-60, 1)];
        line.backgroundColor = RGB_A(82, 144, 222);
        [view addSubview:line];
        
        UITableView * table = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth-60, view.size.height-50)];
        table.delegate= self;
        table.dataSource = self;
        [table registerClass:[DrawCashAlertViewCell class] forCellReuseIdentifier:@"cell"];
        table.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        [view addSubview:table];
        
        
    }
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString * Id = @"cell";
    DrawCashAlertViewCell * cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (!cell) {
        cell = [[DrawCashAlertViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        
    }
    
    PromotionAccountModel * model = [_array objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DrawCashAlertViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString * str = [NSString stringWithFormat:@"%@\n%@",cell.accountLabel.text,cell.numberLabel.text];
    int row =(int) indexPath.row;
    if ([self.delegate respondsToSelector:@selector(DrawCashAlertViewDelegateBtnClick:withStr:withIndexPath:withRow:)]) {
        [self.delegate DrawCashAlertViewDelegateBtnClick:self withStr:str withIndexPath:_index withRow:row];
    }
    [self removeFromSuperview];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
@end

