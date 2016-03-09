//
//  SubClassifyVCCollectionViewCell.m
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "SubClassifyVCCollectionViewCell.h"

@implementation SubClassifyVCCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.contentView.backgroundColor = [UIColor grayColor];
       
        self.Image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width,frame.size.height - 20)];
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(0,0, frame.size.width, frame.size.height)];
        self.name.font = [UIFont systemFontOfSize:13];
        self.name.textAlignment = NSTextAlignmentCenter;
//        self.Image.backgroundColor = [UIColor redColor];
//        self.name.backgroundColor = [UIColor yellowColor];
//        [self.contentView addSubview:self.Image];
        [self.contentView addSubview:self.name];
    }
    return self;
}
-(void)setData:(ProductCategoryData *)data
{
    _data = data;
//    NSLog(@"Name=%@",_data.Name);
    self.name.text = _data.Name;
//    CGSize size = [_data.Name ];
    [self.name sizeToFit];
}
@end
