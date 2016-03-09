//
//  BrandCollectionReusableView.m
//  Bqu
//
//  Created by yb on 15/10/13.
//  Copyright © 2015年 yingbo. All rights reserved.
//

#import "BrandCollectionReusableView.h"

@implementation BrandCollectionReusableView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        self.lineOne = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, 2, 22)];
        self.lineOne.backgroundColor = [UIColor colorWithHexString:@"#F52748"];
    
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(10,20, 80, 40)];
        self.title.font = [UIFont fontWithName:NormalFONT size:18];
        self.title.textColor = [UIColor colorWithHexString:@"#333333"];
//       self.title.backgroundColor = [UIColor grayColor];
        
        self.graytitle = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 80, 40)];
        self.graytitle.textColor = [UIColor colorWithHexString:@"#888888"];
        self.graytitle.font = [UIFont fontWithName:LightFONT size:14];
        self.graytitle.text = @"推荐品牌";
        [self addSubview:self.lineOne];
        [self addSubview:self.title];
        [self addSubview:self.graytitle];
        NSLog(@"%f,%f",self.lineOne.center.y,self.title.center.y);
    }
            return self;
}

@end
