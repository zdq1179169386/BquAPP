//
//  HomeTableViewHead.m
//  Bqu
//
//  Created by yb on 15/11/9.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "HomeTableViewHead.h"

@implementation HomeTableViewHead

+(HomeTableViewHead*)homeTableViewHeadWith:(NSString*)name
{
  
    HomeTableViewHead *homeTableViewHead = [[HomeTableViewHead alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    //homeTableViewHead.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    bView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [homeTableViewHead addSubview:bView];
    homeTableViewHead.backgroundColor = [UIColor whiteColor];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 23, 2, 14)];
    imgView.image = [UIImage imageNamed:@"1012app首页-切图@2x_27"];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 200, 30)];
    lable.font = [UIFont systemFontOfSize:16];
    lable.text = name;
    lable.textColor = [UIColor colorWithHexString:@"333333"];
    [homeTableViewHead addSubview:imgView];
    [homeTableViewHead addSubview:lable];
    return homeTableViewHead;
}
@end
