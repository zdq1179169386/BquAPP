//
//  RefundMessage.m
//  Bqu
//
//  Created by yb on 15/10/28.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "RefundMessage.h"

@implementation RefundMessage



+(NSDictionary*)replacedKeyFromPropertyName
{
    return @{
         @"ExpressCompanyName":@"DeliveThings.ExpressCompanyName",
         @"ShipOrderNumber":@"DeliveThings.ShipOrderNumber",
         @"GoodsReturnRemark":@"DeliveThings.GoodsReturnRemark",
         @"SenderAddress":@"TakeAddress.SenderAddress",
         @"SenderPhone":@"TakeAddress.SenderPhone",
         @"SenderName":@"TakeAddress.SenderName",
    };
}
-(NSString *)RefundAccount
{
    NSLog(@"退款方式%@",_RefundAccount);
    if ([_RefundAccount isKindOfClass:[NSNull class]] || _RefundAccount.length==0) {
        _RefundAccount = @"";
    }
    return _RefundAccount;
}
-(NSString *)PayeeAccount
{
    NSLog(@"退款账户%@",_PayeeAccount);
    if ([_PayeeAccount isKindOfClass:[NSNull class]] || _PayeeAccount.length == 0) {
        _PayeeAccount = @"";
    }
    return _PayeeAccount;
}
-(NSString *)Amount
{
  
    NSString * str = [NSString stringWithFormat:@"%.2f",_Amount.doubleValue];
    return str;
}
-(NSString*)AuditText
{
//    NSLog(@"_AuditText==%@",_AuditText);
    return _AuditText;
}
-(NSString *)SellerRemark
{
//    NSLog(@"_SellerRemark==%@",_SellerRemark);
    return _SellerRemark;
}
-(NSString *)RefundMode
{
    NSLog(@"RefundMode=%@",_RefundMode);
    return _RefundMode;
}
-(int)orderStatus
{
    NSLog(@"orderStatus=%d",_orderStatus);
    return _orderStatus;
}
-(NSString *)Payee
{
    if ([_Payee isKindOfClass:[NSNull class]] || _Payee.length==0) {
        _Payee = @"";
    }
    return _Payee;
}
@end

@implementation RefundMessageFrame

-(void)setMessage:(RefundMessage *)message
{
    _message = message;
    
    self.DateF = CGRectMake(0, 20, ScreenWidth, 20);
    
    self.NameF = CGRectMake(12, 5, ScreenWidth-60, 30);
    
    CGFloat line1Y = CGRectGetMaxY(self.NameF);
    self.line1F = CGRectMake(12, line1Y+4, ScreenWidth-60, 1);
    CGFloat contentY = CGRectGetMaxY(self.line1F);

    
    NSString * str = nil;
    CGFloat maxY = 0;
    
    if ([_message.AuditText isEqualToString:@"买家发起了申请"] || [_message.AuditText isEqualToString:@"买家已退货"]) {
        //买家的
        if ([_message.AuditText isEqualToString:@"买家发起了申请"]) {
            str  = [NSString stringWithFormat:@"%@,原因:%@,金额:%@元",_message.AuditText,_message.Reason,_message.Amount];

        }else if ([_message.AuditText isEqualToString:@"买家已退货"])
        {
            str = [NSString stringWithFormat:@"物流公司:%@,单号:%@,退货说明:%@",_message.ExpressCompanyName,_message.ShipOrderNumber,_message.GoodsReturnRemark];
        }
        
        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12] maxW:ScreenWidth-60];
        
        self.ContentF = CGRectMake(12, contentY+Margin, size.width, size.height);
        
        maxY = CGRectGetMaxY(self.ContentF)+Margin;
    }else
    {
        //卖家的
        if ([_message.AuditText isEqualToString:@"请退货"])
        {
            str = [NSString stringWithFormat:@"收货地址:%@,联系人:%@,电话:%@",_message.SenderAddress,_message.SenderName,_message.SenderPhone];
            CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12] maxW:ScreenWidth-60];
            self.ContentF = CGRectMake(12, contentY+Margin, size.width, size.height);

            if (_message.SellerAudit.intValue>2) {
                //隐藏退货按钮
                self.btnF = CGRectZero;
                maxY = CGRectGetMaxY(self.ContentF) + Margin;
                
            }else{
                //有退货按钮
                CGFloat btnY = CGRectGetMaxY(self.ContentF);
                self.btnF = CGRectMake(ScreenWidth-136, btnY+Margin, 90, 30);
                maxY = CGRectGetMaxY(self.btnF)+Margin;
            }
            
        }else if([_message.AuditText isEqualToString:@"卖家拒绝退款申请"])
        {
            str = [NSString stringWithFormat:@"%@,%@",_message.AuditText,_message.SellerRemark];
            CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12] maxW:ScreenWidth-60];
            self.ContentF = CGRectMake(12, contentY+Margin, size.width, size.height);
            maxY = CGRectGetMaxY(self.ContentF) + Margin;
            if (_message.RefundMode.intValue == 1) {
                //有二次申请售后按钮；
                CGFloat btnY = CGRectGetMaxY(self.ContentF);
                self.btnF = CGRectMake(ScreenWidth-136, btnY+Margin, 90, 30);
                maxY = CGRectGetMaxY(self.btnF)+Margin;
            }

        }else if([_message.AuditText isEqualToString:@"退款成功"])
        {
            str = [NSString stringWithFormat:@"退款金额:%@,\n钱款去向:%@ %@ %@",_message.Amount,_message.RefundAccount,_message.PayeeAccount,_message.Payee];
            CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12] maxW:ScreenWidth-60];
            self.ContentF = CGRectMake(12, contentY+Margin, size.width, size.height);
            self.btnF = CGRectZero;
            maxY = CGRectGetMaxY(self.ContentF)+Margin;

        }else if([_message.AuditText isEqualToString:@"等待卖家处理"])
        {
            str = @"如果卖家同意，需要您填写退货邮寄的物流信息。\n如果卖家拒绝，可联系售后4008-575766查询具体原因。";
            CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12] maxW:ScreenWidth-60];
            self.ContentF = CGRectMake(12, contentY+Margin, size.width, size.height);
            self.btnF = CGRectZero;
            maxY = CGRectGetMaxY(self.ContentF)+Margin;
           
        }else
        {
            //没有按钮
            if (_message.SellerRemark) {
                
                str = [NSString stringWithFormat:@"%@",message.SellerRemark];
                CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12] maxW:ScreenWidth-60];
                self.ContentF = CGRectMake(Margin, contentY+Margin, size.width, size.height);
                self.btnF = CGRectZero;
                maxY = CGRectGetMaxY(self.ContentF)+Margin;
                
            }else
            {
                maxY = contentY;
            }
        }
        
    }
    self.bgImageF = CGRectMake(18, 50, ScreenWidth-36, maxY);
    
    self.cellHeight = maxY +30 + 20;
}

@end