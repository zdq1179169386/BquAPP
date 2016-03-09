//
//  ApplyForRefundAlertView.m
//  Bqu
//
//  Created by yb on 15/10/26.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "ApplyForRefundAlertView.h"

@interface ApplyForRefundAlertView ()

{
    int count;
    NSArray * _array;
    NSIndexPath * _index;
}

@end

@implementation ApplyForRefundAlertView

- (id)initWithFrame:(CGRect)frame withDelegate:(id)delegate withTitle:(NSString *)title withArray:(NSArray *)array withIndexPath:(NSIndexPath* )index
{
    if (self = [super initWithFrame:frame]) {
        self.delegate = delegate;
        count = array.count;
        _array = [[NSArray alloc] initWithArray:array];
        _index = index;
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(30, 60, ScreenWidth - 60, (array.count+1)*44)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 5;
        view.clipsToBounds = YES;
        [self addSubview:view];
        view.center = CGPointMake(ScreenWidth/2.0, ScreenHeight/2.0);
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-60, 43)];
        label.text = title;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHexString:@"#4c8dde"];
        label.font = [UIFont systemFontOfSize:15];
        [view addSubview:label];
        
        UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, ScreenWidth-60, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#4c8edd"];
        [view addSubview:line];
        
        UITableView * table = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth-60, view.size.height-44)];
//   删除左端15像素
        if ([table respondsToSelector:@selector(setSeparatorInset:)])
        {
            [table setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([table respondsToSelector:@selector(setLayoutMargins:)])
        {
            [table setLayoutMargins:UIEdgeInsetsZero];
        }
//   搭配下边方法
        table.delegate = self;
        table.dataSource = self;
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
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        
    }
    cell.textLabel.text = [_array objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}
// 左端15像素，搭配上边方法
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
 
    int row =(int) indexPath.row;
    if ([self.delegate respondsToSelector:@selector(ApplyForRefundAlertViewBtnClick:withStr:withIndexPath:withRow:)]) {
        [self.delegate ApplyForRefundAlertViewBtnClick:self withStr:cell.textLabel.text withIndexPath:_index withRow:row];
    }
    [self removeFromSuperview];
}
@end
