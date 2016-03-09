//
//  HomeTableViewFoot.m
//  Bqu
//
//  Created by yb on 15/11/9.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "HomeTableViewFoot.h"

@implementation HomeTableViewFoot

+(instancetype)homeTableViewFoot
{
    HomeTableViewFoot *view = [[HomeTableViewFoot alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    double btnWidth = 100;
    moreBtn.frame = CGRectMake((ScreenWidth-btnWidth)*0.5,10, btnWidth, 30);
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"更多商品"] forState:UIControlStateNormal];
    [moreBtn addTarget:view action:@selector(touchDown) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:moreBtn];
    return view;
}

-(void)touchDown
{
    if ([self.delegate respondsToSelector:@selector(homeTableViewFootTouchDown)]) {
        [self.delegate homeTableViewFootTouchDown];
    }
}
@end
