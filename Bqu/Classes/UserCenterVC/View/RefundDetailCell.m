//
//  RefundDetailCell.m
//  Bqu
//
//  Created by yb on 15/10/29.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "RefundDetailCell.h"

@implementation RefundDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.contentView.backgroundColor = HWRandomColor;
        self.date = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 0, 0)];
        self.date.font = [UIFont systemFontOfSize:11];
        self.date.textAlignment = NSTextAlignmentCenter;
        self.date.textColor = RGB_A(125, 125, 125);
        self.iconLeft = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60, 8, 8)];
//        self.iconLeft.backgroundColor = HWRandomColor;
        self.iconRight = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-18, 60, 8, 8)];
//        self.iconRight.backgroundColor = HWRandomColor;
        [self.contentView addSubview:   self.iconRight];
        self.name = [[UILabel alloc] initWithFrame:CGRectZero];
//        self.name.backgroundColor = HWRandomColor;
        self.name.font = [UIFont systemFontOfSize:14];
        
        self.content = [[UILabel alloc] initWithFrame:CGRectZero];
        self.content.numberOfLines = 0;
        self.content.font = [UIFont systemFontOfSize:12];
//        self.content.backgroundColor = HWRandomColor;
        self.bgImage = [[UIView alloc] initWithFrame:CGRectZero];
        self.bgImage.layer.cornerRadius = 5;
        self.bgImage.clipsToBounds = YES;
//        self.bgImage.backgroundColor = HWRandomColor;
        self.bgImage.userInteractionEnabled = YES;
        
        self.line1 = [[UILabel alloc] initWithFrame:CGRectZero];
        self.line2 = [[UILabel alloc] initWithFrame:CGRectZero];
        self.btn = [[UIButton alloc] initWithFrame:CGRectZero];
        self.btn.backgroundColor = [UIColor whiteColor];
        self.btn.titleLabel.textColor = [UIColor blackColor];
        self.btn.titleLabel.font = [UIFont systemFontOfSize:12];
        self.btn.layer.cornerRadius = 5;
        self.btn.clipsToBounds = YES;
        [self.btn addTarget:self action:@selector(returnGoodsOrTwiceToRefund:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.date];
        [self.contentView addSubview:self.bgImage];
        [self.contentView addSubview:self.iconLeft];

        [self.bgImage addSubview:self.line1];
        [self.bgImage addSubview:self.line2];
        [self.bgImage addSubview:self.name];
        [self.bgImage addSubview:self.content];
        [self.bgImage addSubview:self.btn];
    }
    return self;
}
-(void)setMessageF:(RefundMessageFrame *)messageF
{
    
    _messageF = messageF;
    RefundMessage * message = _messageF.message;

    
    if (message.OperaData) {
        self.date.text = message.OperaData;
    }else
    {
        self.date.text = @"B区自营";
    }

    self.date.frame = _messageF.DateF;
    self.date.frame  = CGRectMake(0, 20, ScreenWidth, 20);

    self.name.text = message.AuditText;
    self.name.frame = _messageF.NameF;
    
    self.line1.frame = _messageF.line1F;
    CGFloat contentY = CGRectGetMaxY(self.line1.frame);

    NSString * str = nil;
    CGFloat maxY = 0;
    if ([message.AuditText isEqualToString:@"买家发起了申请"] || [message.AuditText isEqualToString:@"买家已退货"]) {
        
       //
        self.line1.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        self.iconLeft.hidden = YES;
        self.iconRight.hidden = NO;
        self.iconRight.image = [UIImage imageNamed:@"jiao1"];
        //买家的
        if ([message.AuditText isEqualToString:@"买家发起了申请"]) {
            self.name.textColor = [UIColor blackColor];
            self.bgImage.backgroundColor = [UIColor whiteColor];
            str  = [NSString stringWithFormat:@"%@,原因:%@,金额:%@元",message.AuditText,message.Reason,message.Amount];
            
            
        }else if ([message.AuditText isEqualToString:@"买家已退货"])
        {
            self.name.textColor = [UIColor whiteColor];
            self.bgImage.backgroundColor = RGB_A(0, 163, 207);
            self.content.textColor = [UIColor whiteColor];
            
            str = [NSString stringWithFormat:@"物流公司:%@,单号:%@,退货说明:%@",message.ExpressCompanyName,message.ShipOrderNumber,message.GoodsReturnRemark];
        }
        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12] maxW:ScreenWidth-60];
        
        self.content.frame = CGRectMake(12, contentY+Margin, size.width, size.height);
        
        maxY = CGRectGetMaxY(self.content.frame)+Margin;
        self.content.text = str;
      
    }else
    {
        self.name.textColor = [UIColor whiteColor];
        self.bgImage.backgroundColor = RGB_A(0, 163, 207);
        self.content.textColor = [UIColor whiteColor];
        self.line1.backgroundColor = [UIColor colorWithHexString:@"#68c5e2"];
        self.line1.hidden = NO;
        self.iconLeft.hidden = NO;
        self.iconRight.hidden = YES;
        self.iconLeft.image = [UIImage imageNamed:@"jiao2"];
        //卖家的
        if ([message.AuditText isEqualToString:@"请退货"])
        {
            str = [NSString stringWithFormat:@"收货地址:%@,联系人:%@,电话:%@",message.SenderAddress,message.SenderName,message.SenderPhone];
            self.btn.titleLabel.text = @"退货";
            CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12] maxW:ScreenWidth-60];
            self.content.frame = CGRectMake(12, contentY+Margin, size.width, size.height);
            self.content.text = str;
            
            if (message.SellerAudit.intValue>2) {
                
                self.btn.frame = CGRectZero;
                maxY = CGRectGetMaxY(self.content.frame) + Margin;
            }else
            {
                //有退货按钮
                CGFloat btnY = CGRectGetMaxY(self.content.frame);
                self.btn.frame = _messageF.btnF;
                [self.btn setTitle:@"发货" forState:UIControlStateNormal];
                [self.btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                maxY = CGRectGetMaxY(self.btn.frame)+Margin;
                [self.btn addTarget:self action:@selector(returnGoodsOrTwiceToRefund:) forControlEvents:UIControlEventTouchUpInside];
            }
        }else if([message.AuditText isEqualToString:@"卖家拒绝退款申请"])
        {
            self.iconLeft.image = [UIImage imageNamed:@"jiao3"];
            self.bgImage.backgroundColor = RGB_A(255, 47, 96);
            self.line1.backgroundColor = [UIColor colorWithRed:238 green:101 blue:130 alpha:0.5];
            str = [NSString stringWithFormat:@"%@,%@",message.AuditText,message.SellerRemark];
            CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12] maxW:ScreenWidth-60];
            self.content.frame = CGRectMake(Margin, contentY+Margin, size.width,size.height);
            self.content.text = str;
            maxY = CGRectGetMaxY(self.content.frame) + Margin;
            if (message.RefundMode.intValue == 1) {
                //有二次申请售后按钮；
                CGFloat btnY = CGRectGetMaxY(self.content.frame);
                self.btn.frame = CGRectMake(ScreenWidth-136, btnY+Margin, 90, 30);
                [self.btn setTitle:@"重新申请" forState:UIControlStateNormal];
                [self.btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.btn addTarget:self action:@selector(returnGoodsOrTwiceToRefund:) forControlEvents:UIControlEventTouchUpInside];
            }
            maxY = CGRectGetMaxY(self.btn.frame)+Margin;

        }else if([message.AuditText isEqualToString:@"退款成功"])
        {
            self.iconLeft.image = [UIImage imageNamed:@"jiao3"];
            self.bgImage.backgroundColor = RGB_A(255, 47, 96);
            str = [NSString stringWithFormat:@"退款金额:%@,\n钱款去向:%@ %@ %@",message.Amount,message.RefundAccount,message.PayeeAccount,message.Payee];
            CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12] maxW:ScreenWidth-60];
            self.content.frame = CGRectMake(Margin, contentY+Margin, size.width, size.height);
            self.content.text = str;
            self.btn.frame = CGRectZero;
            maxY = CGRectGetMaxY(self.content.frame)+Margin;
            self.line1.backgroundColor = [UIColor colorWithRed:238 green:101 blue:130 alpha:0.5];
        }else if([message.AuditText isEqualToString:@"等待卖家处理"])
        {
            str = @"如果卖家同意，需要您填写退货邮寄的物流信息。\n如果卖家拒绝，可联系售后4008-575766查询具体原因。";
            CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12] maxW:ScreenWidth-60];
            self.content.frame = CGRectMake(Margin, contentY+Margin, size.width, size.height);
            self.content.text = str;
            maxY = CGRectGetMaxY(self.content.frame)+Margin;
            
        }else
        {
            //没有按钮
            if (message.SellerRemark) {
                str = [NSString stringWithFormat:@"%@",message.SellerRemark];
                CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12] maxW:ScreenWidth-60];
                self.content.frame = CGRectMake(Margin, contentY+Margin, size.width, size.height);
                self.content.text = str;
                self.btn.frame = CGRectZero;
                maxY = CGRectGetMaxY(self.content.frame)+Margin;
                self.line1.hidden = NO;
                
            }else
            {
                maxY = contentY;
                self.line1.hidden = YES;
            }

        }
    }
    self.bgImage.frame = _messageF.bgImageF;
    
}
-(void)returnGoodsOrTwiceToRefund:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(returenGoodsOrTwiceToApplyRefund:with:)]) {
        [self.delegate returenGoodsOrTwiceToApplyRefund:self with:btn];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
