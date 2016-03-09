//
//  SecondCollectionReusableView.m
//  Bqu
//
//  Created by yb on 15/10/13.
//  Copyright © 2015年 yingbo. All rights reserved.
//

#import "AllBrandCollectionReusableView.h"

@implementation AllBrandCollectionReusableView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
      self.btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth-20, 40)];
      self.btn.titleLabel.font = [UIFont fontWithName:NormalFONT size:16];
      self.btn.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
      [self.btn setTitle:@"全部品牌" forState:UIControlStateNormal];
      [self.btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [self.btn setImage:[UIImage imageNamed:@"右箭头"] forState:UIControlStateNormal];
        self.btn.imageEdgeInsets = UIEdgeInsetsMake(0, 170, 0, 0);
      [self addSubview:self.btn];

    }
    return self;
}
@end
