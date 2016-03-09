//
//  RefundTableFooterView.m
//  Bqu
//
//  Created by yb on 15/11/4.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "RefundTableFooterView.h"


@interface RefundTableFooterView ()
{
    NSInteger _section;
}


/**金额*/
@property (nonatomic,strong) UILabel * priceLabel;


@property(nonatomic,strong) UIView * grayView;

@property (nonatomic,strong) UILabel * line1;

@property (nonatomic,strong) UILabel * line2;


@end

@implementation RefundTableFooterView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier withSection:(NSInteger)selectedSection withDelegate:(id)Adelegate
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        _section = selectedSection;
        
        self.delegate = Adelegate;
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.otherBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 100, 30)];
        self.otherBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.otherBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.otherBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.otherBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.otherBtn.tag = 111;
        self.otherBtn.hidden = YES;
        [self.otherBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.priceLabel.font = [UIFont systemFontOfSize:13];
        self.findMoney = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-100, 0, 90, 26)];
        self.findMoney.tag = 222;
        [self.findMoney setTitle:@"钱款去向" forState:UIControlStateNormal];
        [self.findMoney setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        self.findMoney.layer.cornerRadius = 4;
        self.findMoney.clipsToBounds = YES;
        self.findMoney.titleLabel.font = [UIFont systemFontOfSize:14];
        self.findMoney.layer.borderWidth = 1;
        self.findMoney.layer.borderColor = [UIColor redColor].CGColor;
        [self.findMoney addTarget:self action:@selector(findMoney:) forControlEvents:UIControlEventTouchUpInside];
        
//        UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, 1)];
//        line.backgroundColor = [UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:self.otherBtn];
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.findMoney];
        
        self.grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, 10)];
        self.grayView.backgroundColor = RGB_A(240, 238, 239);
        [self.contentView addSubview:self.grayView];
        
        self.icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sx"]];
        [self.contentView addSubview:self.icon];
        
        self.line1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 39, ScreenWidth-20, 1)];
        self.line1.backgroundColor = [UIColor colorWithHexString:@"#cccccc" alpha:0.5];
        [self.contentView addSubview:self.line1];
        
        self.line2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 39, ScreenWidth-20, 1)];
        self.line2.backgroundColor = [UIColor colorWithHexString:@"#cccccc" alpha:0.5];
        [self.contentView addSubview:self.line2];


    }
    return self;
}

-(void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(RefundTableFooterViewBtnClick:withOtherBtn:withSection:)]) {
        [self.delegate RefundTableFooterViewBtnClick:self withOtherBtn:btn withSection:_section];
    }

}
-(void)findMoney:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(RefundTableFooterViewBtnClick:withFindMoney:withSection:)]) {
        [self.delegate RefundTableFooterViewBtnClick:self withFindMoney:btn withSection:_section];
    }
}
-(void)setAfterSaleOrder:(AfterSaleOrderModel *)afterSaleOrder
{
    _afterSaleOrder = afterSaleOrder;
    //还有剩余件数显示
    CGFloat price_Y = 0;
    if (![_afterSaleOrder.RefundItem isKindOfClass:[NSNull class]]) {
        if (_afterSaleOrder.RefundItem.count>0) {
            if (self.isOpen) {
                self.otherBtn.hidden = NO;
                [self.otherBtn setTitle:@"收起" forState:UIControlStateNormal];
                self.otherBtn.frame = CGRectMake(10, 5, 80, 30);
                self.icon.hidden = YES;
            }else
            {
                self.otherBtn.hidden = NO;
                NSInteger count = _afterSaleOrder.RefundItem.count;
                NSString * countStr = [NSString stringWithFormat:@"%ld",count];
                NSString * str = [NSString stringWithFormat:@"还有%@件",countStr];
                NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
                [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:countStr]];
                [self.otherBtn setAttributedTitle:attr forState:UIControlStateNormal];
                CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:15]];
                self.otherBtn.frame = CGRectMake(10, 5, size.width, 30);
                self.icon.hidden = NO;
                self.icon.frame = CGRectMake(15+size.width, 15, self.icon.image.size.width, self.icon.image.size.height);
            }
            price_Y = 40;
            self.line1.hidden = NO;
            self.line1.frame = CGRectMake(10, 39, ScreenWidth-20, 1);

        }else
        {
            self.line1.hidden = YES;
            self.otherBtn.hidden = YES;
            self.icon.hidden = YES;
            price_Y = 0;
        }
    }
    //退款
    NSString * str = [NSString stringWithFormat:@"交易金额:￥%@ 退款金额:￥%@",_afterSaleOrder.DealPrice,_afterSaleOrder.RefundPrice];
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:_afterSaleOrder.RefundPrice]];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:_afterSaleOrder.DealPrice]];
    self.priceLabel.attributedText = attr;
    CGSize  size = [str sizeWithFont:[UIFont systemFontOfSize:13]];
    self.priceLabel.frame = CGRectMake(ScreenWidth-size.width-10, price_Y+5, size.width, 30);

    CGFloat findMoney_Y = CGRectGetMaxY(self.priceLabel.frame)+5;
    if ([_afterSaleOrder.ManagerConfirmStatus isEqualToString:@"退款成功"]) {
        
        
        
        
        
        
        
        self.findMoney.hidden = NO;
        self.findMoney.frame = CGRectMake(ScreenWidth-100, findMoney_Y + 8, 90, 24);
        self.grayView.frame = CGRectMake(0, findMoney_Y+40, ScreenWidth, 10);
        self.line2.hidden = NO;
        self.line2.frame = CGRectMake(10, findMoney_Y-1, ScreenWidth-20, 1);
    }else
    {
        self.findMoney.hidden = YES;
        self.grayView.frame = CGRectMake(0, findMoney_Y, ScreenWidth, 10);
        self.line2.hidden = YES;
    }
    
    
}
@end
