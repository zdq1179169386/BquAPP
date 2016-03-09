//
//  OrderDetailFooter.m
//  Bqu
//
//  Created by 张胜瀚 on 15/12/3.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "OrderDetailFooter.h"

@interface OrderDetailFooter ()
{
    NSInteger _section;
}

@end
@implementation OrderDetailFooter

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier withSection:(NSInteger)section
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        _section = section;
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.totalPriceTipLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 25)];
        self.totalPriceTipLab.text = @"商品合计";
        self.totalPriceTipLab.font = [UIFont systemFontOfSize:12];
        self.totalPriceTipLab.textColor = [UIColor colorWithHexString:@"#333333"];
        
        self.freighTiptLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10+35*1, 100, 25)];
        self.freighTiptLab.text = @"运费";
        self.freighTiptLab.font = [UIFont systemFontOfSize:12];
        self.freighTiptLab.textColor = [UIColor colorWithHexString:@"#333333"];
        
        self.taxTipLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10+35*2, 100, 25)];
        self.taxTipLab.text = @"关税";
        self.taxTipLab.font = [UIFont systemFontOfSize:12];
        self.taxTipLab.textColor = [UIColor colorWithHexString:@"#333333"];
        
         self.totalPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth -70-10, 10, 70, 15)];
         self.totalPriceLab.font = [UIFont systemFontOfSize:12];
         self.totalPriceLab.textColor = [UIColor colorWithHexString:@"#333333"];
         self.totalPriceLab.textAlignment = NSTextAlignmentRight;
        
         self.freightLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 70-10, 10+35*1, 70, 15)];
         self.freightLab.font = [UIFont systemFontOfSize:12];
         self.freightLab.textColor = [UIColor colorWithHexString:@"#333333"];
         self.freightLab.textAlignment = NSTextAlignmentRight;
     
         self.taxLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 70-10, 10+35*2, 70, 15)];
         self.taxLab.font = [UIFont systemFontOfSize:12];
         self.taxLab.textColor = [UIColor colorWithHexString:@"#333333"];
         self.taxLab.textAlignment = NSTextAlignmentRight;
        

        self.shouPayLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 180-10, 10+35*3, 180, 15)];
        self.shouPayLab.font = [UIFont systemFontOfSize:12];
        self.shouPayLab.textColor = [UIColor colorWithHexString:@"#333333"];
        self.shouPayLab.textAlignment = NSTextAlignmentRight;
        
        self.grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 35*4, ScreenWidth, 59)];
        self.grayView.backgroundColor = [UIColor colorWithHexString:@"#F2F1F1"];
        
        self.couponLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, ScreenWidth-20, 15)];
        self.couponLab.font = [UIFont systemFontOfSize:12];
        self.couponLab.textColor = [UIColor colorWithHexString:@"#888888"];
        self.couponLab.textAlignment = NSTextAlignmentLeft;
        [self.grayView addSubview:self.couponLab];
        
        self.dateLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 13+15+7, 180, 15)];
        self.dateLab.font = [UIFont systemFontOfSize:12];
        self.dateLab.textColor = [UIColor colorWithHexString:@"#888888"];
        self.dateLab.textAlignment = NSTextAlignmentLeft;
        [self.grayView addSubview:self.dateLab];

        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftBtn.frame = CGRectMake(ScreenWidth-10-60-10-70, 35*4+58+10, 60, 24);
        [self.leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.leftBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        self.leftBtn.layer.borderColor = [UIColor colorWithHexString:@"#cccccc" alpha:0.5].CGColor;
        self.leftBtn.layer.borderWidth = 1;
        self.leftBtn.layer.cornerRadius = 4;
        self.leftBtn.tag = 1000;
        [self.leftBtn addTarget:self action:@selector(detailFootButtonClick:) forControlEvents:UIControlEventTouchUpInside];

        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightBtn.frame = CGRectMake(ScreenWidth-10-60, 35*4+58+10, 60, 24);
        [self.rightBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.rightBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.rightBtn.backgroundColor = [UIColor colorWithHexString:@"#e8103c"];
        self.rightBtn.layer.borderColor = [UIColor colorWithHexString:@"#db0b36" alpha:0.5].CGColor;
        self.rightBtn.layer.borderWidth = 1;
        self.rightBtn.layer.cornerRadius = 4;
        self.rightBtn.tag = 1001;
        [self.rightBtn addTarget:self action:@selector(detailFootButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        self.line1.backgroundColor = [UIColor colorWithHexString:@"#dddddd" alpha:0.5];
        self.line2 = [[UIView alloc] initWithFrame:CGRectMake(10, 35, ScreenWidth, 1)];
        self.line2.backgroundColor = [UIColor colorWithHexString:@"#dddddd" alpha:0.5];
        self.line3 = [[UIView alloc] initWithFrame:CGRectMake(10, 35*2, ScreenWidth, 1)];
        self.line3.backgroundColor = [UIColor colorWithHexString:@"#dddddd" alpha:0.5];
        self.line4 = [[UIView alloc] initWithFrame:CGRectMake(10, 35*3, ScreenWidth, 1)];
        self.line4.backgroundColor = [UIColor colorWithHexString:@"#dddddd" alpha:0.5];
        self.line5 = [[UIView alloc] initWithFrame:CGRectMake(0, 35*4, ScreenWidth, 1)];
        self.line5.backgroundColor = [UIColor colorWithHexString:@"#dddddd" alpha:0.5];
        self.line6 = [[UIView alloc] initWithFrame:CGRectMake(0, 35*4+58, ScreenWidth, 1)];
        self.line6.backgroundColor = [UIColor colorWithHexString:@"#dddddd" alpha:0.5];
        self.line7 = [[UIView alloc] initWithFrame:CGRectMake(0, 244, ScreenWidth, 1)];
        self.line7.backgroundColor = [UIColor colorWithHexString:@"#dddddd" alpha:0.5];
        
        [self.contentView addSubview:self.totalPriceTipLab];
        [self.contentView addSubview:self.freighTiptLab];
        [self.contentView addSubview:self.taxTipLab];
        [self.contentView addSubview:self.totalPriceLab];
        [self.contentView addSubview:self.freightLab];
        [self.contentView addSubview:self.taxLab];
        [self.contentView addSubview:self.shouPayLab];
        [self.contentView addSubview:self.grayView];
        [self.contentView addSubview:self.leftBtn];
        [self.contentView addSubview:self.rightBtn];
        [self.contentView addSubview:self.line1];
        [self.contentView addSubview:self.line2];
        [self.contentView addSubview:self.line3];
        [self.contentView addSubview:self.line4];
        [self.contentView addSubview:self.line5];
        [self.contentView addSubview:self.line6];
        [self.contentView addSubview:self.line7];

        
    }
    return self;
}

- (void)setValue:(id)value withOrder:(id)order
{
    _dataDic = (NSDictionary *)value;
    _order = order;
    
    /** zxd添加*/
    self.rightBtn.backgroundColor = [UIColor colorWithHexString:@"e8103c"];
    self.rightBtn.enabled = YES;
    self.rightBtn.layer.borderColor = [UIColor colorWithHexString:@"#db0b36" alpha:0.5].CGColor;
    
    
    self.totalPriceLab.text = [NSString stringWithFormat:@"￥%0.2f",[_dataDic[@"productTotalAmount"] floatValue]];
    self.freightLab.text = [NSString stringWithFormat:@"￥%0.2f",[_dataDic[@"freight"] floatValue]];
    self.taxLab.text = [NSString stringWithFormat:@"￥%0.2f",[_dataDic[@"tax"] floatValue]];
    NSString *shouPayStr = [NSString stringWithFormat:@"应付总额:￥%0.2f",[_dataDic[@"orderTotalAmount"] floatValue]];
    NSString *str1 = [NSString stringWithFormat:@"￥%0.2f",[_dataDic[@"orderTotalAmount"] floatValue]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:shouPayStr];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#e8103c"] range:[shouPayStr rangeOfString:str1]];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:[shouPayStr rangeOfString:str1]];

    self.shouPayLab.attributedText = str;

    NSString *integral = [NSString stringWithFormat:@"%0.2f",[_dataDic[@"integralDiscount"] floatValue]];
    NSString *coupon = [NSString stringWithFormat:@"%0.2f",[_dataDic[@"discountAmount"] floatValue]];
    self.couponLab.text = [NSString stringWithFormat:@"优惠券抵扣 %@  积分抵扣 %@",coupon,integral];
    self.dateLab.text = [NSString stringWithFormat:@"下单时间: %@",_dataDic[@"orderDate"]];

    
     if ([_dataDic[@"orderStatus"] integerValue] == 5)
     {
         NSString *RecycleBin = [NSString stringWithFormat:@"%@",self.order.RecycleBin];
         if ([RecycleBin isEqualToString:@"0"])
         {
             self.leftBtn.hidden = YES;
             [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
             [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
             self.rightBtn.backgroundColor = [UIColor whiteColor];
             self.rightBtn.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
         }
         else
         {
             self.rightBtn.hidden = YES;
             self.leftBtn.hidden = YES;
             self.line7.hidden = YES;
             self.line6.hidden = YES;
         }
     }else if ([_dataDic[@"orderStatus"] integerValue] == 4)
     {
         NSString *commentCount = [NSString stringWithFormat:@"%@",self.order.RecycleBin];
         if ([commentCount isEqualToString:@"1"])
         {
             self.rightBtn.hidden = YES;
             self.leftBtn.hidden = YES;
             self.line7.hidden = YES;
             self.line6.hidden = YES;
         }
         else
         {
             NSString *commentCount = [NSString stringWithFormat:@"%@",_dataDic[@"commentCount"]];
             if ([commentCount isEqualToString:@"0"])
             {
                 self.leftBtn.hidden = NO;
                 [self.leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                 [self.rightBtn setTitle:@"立即评价" forState:UIControlStateNormal];
                 [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                 self.rightBtn.backgroundColor = [UIColor whiteColor];
                 self.rightBtn.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
                 [self.rightBtn redStyle];
             }
             else
             {
                 self.leftBtn.hidden = YES;
                 [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                 [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                 self.rightBtn.backgroundColor = [UIColor whiteColor];
                 self.rightBtn.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
             }

         }
     }
     else if ([_dataDic[@"orderStatus"] integerValue] == 3)
     {
         [self.leftBtn setTitle:@"物流跟踪" forState:UIControlStateNormal];
         [self.rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
    
     }
     else if ([_dataDic[@"orderStatus"] integerValue] == 2)
     {
         self.leftBtn.hidden = YES;
         //退款信息的字典 ID=0 表示尚未退款 status表示退款状态
         NSDictionary *dd = [NSDictionary dictionary];
         dd = _dataDic[@"OrderRefund"];
         NSString *idStr = [NSString stringWithFormat:@"%@",dd[@"Id"]];
         if ([idStr isEqualToString:@"0"])
         {
             [self.rightBtn setTitle:@"订单退款" forState:UIControlStateNormal];
         }
         else
         {
             [self.rightBtn setTitle:@"查看售后" forState:UIControlStateNormal];
         }
    
     }
     else if ([_dataDic[@"orderStatus"] integerValue] == 1)
     {
         [self.leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
         [self.rightBtn setTitle:@"立即付款" forState:UIControlStateNormal];
         


     }

    
}

- (void)detailFootButtonClick:(UIButton *)button
{
    NSLog(@"%s",__FUNCTION__);
    if ([self.delegate respondsToSelector:@selector(detailfooter:withBtn:)])
    {
        [self.delegate detailfooter:_section withBtn:button];
    }
}

@end
