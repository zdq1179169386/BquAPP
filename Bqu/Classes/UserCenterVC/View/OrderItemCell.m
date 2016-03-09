//
//  OrderItemCell.m
//  Bqu
//
//  Created by yingbo on 15/12/1.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "OrderItemCell.h"

@interface OrderItemCell ()
{
    NSInteger _row;
}
@end

@implementation OrderItemCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.productImg =  [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 59, 59)];
        self.productImg.layer.borderColor = [UIColor colorWithHexString:@"#EEEEEE" alpha:0.5].CGColor;
        self.productImg.layer.borderWidth = 1;

        
        self.productName = [[UILabel alloc] initWithFrame:CGRectMake(10 + self.productImg.frame.size.width + 10, 12, ScreenWidth- (10 + self.productImg.frame.size.width + 10)-(10 + 70), 30)];
        self.productName.font = [UIFont systemFontOfSize:12];
        self.productName.numberOfLines = 2;
        self.productName.textColor = [UIColor colorWithHexString:@"#333333"];
        
        self.productPrice = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth -(10 + 70), 12, 70, 15)];
        self.productPrice.font = [UIFont systemFontOfSize:12];
        self.productPrice.textColor = [UIColor colorWithHexString:@"#333333"];
        self.productPrice.textAlignment = NSTextAlignmentRight;

        self.productCount = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth -(10 + 70), 12+self.productPrice.frame.size.height + 8, 70, 15)];
        self.productCount.textAlignment = NSTextAlignmentRight;
        self.productCount.font = [UIFont systemFontOfSize:12];
        self.productCount.textColor = [UIColor colorWithHexString:@"#888888"];
        
        self.refundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.refundBtn.frame = CGRectMake(ScreenWidth -(10 + 60), 12+self.productPrice.frame.size.height + 10+self.productCount.frame.size.height+5, 60, 24);
        self.refundBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        self.refundBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.refundBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        self.refundBtn.layer.borderColor = [UIColor colorWithHexString:@"#cccccc" alpha:0.5].CGColor;
        self.refundBtn.layer.borderWidth = 1;
        self.refundBtn.layer.cornerRadius = 4;

        self.line = [[UIView alloc] initWithFrame:CGRectMake(10, 87, ScreenWidth-10, 1)];
        self.line.backgroundColor = [UIColor colorWithHexString:@"#dddddd" alpha:0.5];
        [self.contentView addSubview:self.productImg];
        [self.contentView addSubview:self.productName];
        [self.contentView addSubview:self.productPrice];
        [self.contentView addSubview:self.productCount];
        [self.contentView addSubview:self.refundBtn];
        [self.contentView addSubview:self.line];

        
        
    }
    return self;
}


- (void)setValue:(id)value withRecycle:(id)order
{
    _item = value;
    _order = order;
    [self.productImg sd_setImageWithURL:[NSURL URLWithString:_item.image] placeholderImage:nil];
    self.productPrice.text = [NSString stringWithFormat:@"￥%0.2f", [_item.price floatValue]];
    self.productCount.text = [NSString stringWithFormat:@"x%@",_item.count];
    self.productName.text = _item.productName;
    [self.refundBtn addTarget:self action:@selector(applyScalesButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([_item.refundId isKindOfClass:[NSNull class]])
    {
        [self.refundBtn setTitle:@"申请售后" forState:UIControlStateNormal];
        self.refundBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        self.refundBtn.layer.borderColor = [UIColor colorWithHexString:@"#cccccc" alpha:0.5].CGColor;
        self.refundBtn.layer.borderWidth = 1;
        self.refundBtn.layer.cornerRadius = 4;
        [self.refundBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    }
    else
    {
        [self.refundBtn setTitle:@"查看售后" forState:UIControlStateNormal];
        self.refundBtn.backgroundColor = [UIColor colorWithHexString:@"#e8103c"];
        self.refundBtn.layer.borderColor = [UIColor colorWithHexString:@"#db0b36" alpha:0.5].CGColor;
        self.refundBtn.layer.borderWidth = 1;
        self.refundBtn.layer.cornerRadius = 4;
        [self.refundBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    }


    /*代收货 待评价 不在回收站*/
    if ([self.order.orderStatus integerValue] == 3 || [self.order.orderStatus integerValue] == 4  )
    {
        if ( [self.order.RecycleBin isEqualToString:@"0"])
        {
            self.refundBtn.hidden = NO;
        }
        else
        {
            if ([_item.refundId isKindOfClass:[NSNull class]])
            {
                self.refundBtn.hidden = YES;
            }
            else
            {
                self.refundBtn.hidden = NO;
            }
        }
    }
    else
    {
        self.refundBtn.hidden = YES;
        self.line.frame = CGRectMake(10, 77, ScreenWidth-10, 1);
    }
    /**/

}

- (void)applyScalesButtonClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(applyRefundButtonClick:)]) {
        [self.delegate applyRefundButtonClick:button];
    }
}
@end
