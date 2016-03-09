//
//  AnotherCell.m
//  Bqu
//
//  Created by yb on 15/10/29.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "AnotherCell.h"

@implementation AnotherCell

-(void)setItemModel:(RefundItemModel *)itemModel
{
    _itemModel = itemModel;
    [self.orderImage sd_setImageWithURL:[NSURL URLWithString:_itemModel.ItemImgUrl] placeholderImage:nil];
    self.orderName.text = _itemModel.ItemName;
    CGSize size = [_itemModel.ItemName sizeWithFont:[UIFont systemFontOfSize:13] maxW:170];
    self.orderName.size = CGSizeMake(170, size.height);
    self.dealPrice.text = _itemModel.SalePrice;
    [self.dealPrice sizeToFit];
    self.dealPrice.frame = CGRectMake(ScreenWidth-self.dealPrice.size.width-10, self.orderName.frame.origin.y, self.dealPrice.width, self.dealPrice.height);
    if (_itemModel.ItemQuantity>0) {
        self.number.hidden = NO;
        NSString * str = [NSString stringWithFormat:@"x %@",_itemModel.ItemQuantity];
        self.number.text = str;
        [self.number sizeToFit];
        CGFloat number_Y = CGRectGetMaxY(self.dealPrice.frame);
        self.number.frame = CGRectMake(ScreenWidth - self.number.width-10 , number_Y, self.number.width, self.number.height);    }else
        {
            self.number.hidden = YES;
        }
    
}
@end
