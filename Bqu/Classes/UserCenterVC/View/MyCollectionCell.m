//
//  MyCollectionCell.m
//  Bqu
//
//  Created by yingbo on 15/10/19.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "MyCollectionCell.h"

@interface MyCollectionCell ()

@end

@implementation MyCollectionCell

- (void)setValue:(id)value
{
    _model = value;
    
     [self.goodsPhoto_ImgVIew sd_setImageWithURL:[NSURL URLWithString:_model.ProductImg] placeholderImage:nil];
     self.goodsName_Lab.text = _model.ProductName;
     self.goddsPrice_Lab.text = [NSString stringWithFormat:@"¥ %@",_model.MinSalePrice];
     self.goddMarketPrice_Lab.text = [NSString stringWithFormat:@"市场价 ¥ %@",_model.MarketPrice];
     self.collectionCount_Lab.text = _model.ConcernCount;
   
         // 计算文字的高度
     CGRect rect = [self.collectionCount_Lab.text boundingRectWithSize:CGSizeMake((ScreenWidth-30)/2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
     float width =  ceilf(rect.size.width);
   
     self.collectionCount_Lab.frame = CGRectMake(self.frame.size.width-width-15, 215, width, 21);
    self.collectionCount_Lab.textAlignment = NSTextAlignmentRight;
    
     self.redHeart_imgView.frame = CGRectMake(self.frame.size.width - self.collectionCount_Lab.frame.size.width - 29, 220, 12, 12);
     self.layer.borderWidth = 1;
     self.layer.cornerRadius = 4.0;
     self.layer.borderColor = [RGB_A(229, 229, 229) CGColor];

    
    [self.cancelPraice addTarget:self action:@selector(cancelPraiceClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)cancelPraiceClick:(UIButton *)button
{
    NSLog(@"这是一个测试语句%s",__FUNCTION__);
    if ([self.delegate respondsToSelector:@selector(cancelPriceBtn:)])
    {
        [self.delegate cancelPriceBtn:button];
    }
}

- (void)awakeFromNib
{
    // Initialization code
}

@end
