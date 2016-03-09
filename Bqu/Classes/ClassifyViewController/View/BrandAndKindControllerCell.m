
//
//  BrandAndKindControllerCell.m
//  Bqu
//
//  Created by yb on 15/10/19.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BrandAndKindControllerCell.h"

@implementation BrandAndKindControllerCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
        self.productImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 160)];
        CGFloat name_Y = CGRectGetMaxY(self.productImage.frame);
        self.productName = [[UILabel alloc] initWithFrame:CGRectMake(10, name_Y, frame.size.width-20, 50)];
        self.productName.numberOfLines = 0;
        self.productName.font = [UIFont systemFontOfSize:17];
//        self.productName.backgroundColor = [UIColor redColor];
        self.productName.font = [UIFont systemFontOfSize:15];
        CGFloat price_Y = CGRectGetMaxY(self.productName.frame);
        self.price = [[UILabel alloc] initWithFrame:CGRectMake(10, price_Y, (frame.size.width-20)/2.0, 20)];
//        self.price.backgroundColor = [UIColor redColor];
        self.price.textColor = [UIColor colorWithHexString:@"#f72548"];
        self.price.font = [UIFont boldSystemFontOfSize:13];
        
        self.referencePrice = [[UILabel alloc] initWithFrame:CGRectMake(10, frame.size.height-10-20, frame.size.width - 20, 20)];
//        self.referencePrice.backgroundColor = [UIColor redColor];
        self.referencePrice.textColor = [UIColor colorWithHexString:@"#888888"];
        self.referencePrice.font = [UIFont systemFontOfSize:13];
        
        [self.contentView addSubview:self.productImage];
        [self.contentView addSubview:self.productName];
        [self.contentView addSubview:self.price];
        [self.contentView addSubview:self.referencePrice];
        
        
    }
    return self;
}

@end
