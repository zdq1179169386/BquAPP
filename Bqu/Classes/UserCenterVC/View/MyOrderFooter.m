//
//  MyOrderFooter.m
//  Bqu
//
//  Created by yingbo on 15/11/24.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "MyOrderFooter.h"

@interface MyOrderFooter ()
{
    NSInteger _section;
    BOOL isBeOpen;
}

@end
@implementation MyOrderFooter

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier withSection:(NSInteger)section
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        _section = section;
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        /**方向箭头**/
        self.arrowBtn = [[UIImageView alloc] init];
        self.arrowBtn.frame = CGRectMake(60, 8, 12, 12);
        self.arrowBtn.image =  [UIImage imageNamed:@"sx"];

        /**剩余件数**/
        self.restCount = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 50, 26)];
        self.restCount.font = [UIFont systemFontOfSize:12];
        self.restCount.textColor = [UIColor blackColor];
        self.restCount.textAlignment = NSTextAlignmentLeft;
        
        /**为了有时点不上,特地写个大按钮遮住箭头和件数**/
        self.showRestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.showRestBtn.frame = CGRectMake(10, 8, 80, 26);
        self.showRestBtn.backgroundColor = [UIColor clearColor];
        [self.showRestBtn addTarget:self action:@selector(moreProductClick:) forControlEvents:UIControlEventTouchUpInside];


        /**总共件数**/
        self.totalCount = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 155, 2, 50, 26)];
        self.totalCount.font = [UIFont systemFontOfSize:12];
        self.totalCount.textColor = [UIColor colorWithHexString:@"#333333"];
        self.totalCount.textAlignment = NSTextAlignmentRight;
        
        
        /**实际付款**/
        self.orderPay = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 100, 2, 90, 26)];
        self.orderPay.font = [UIFont systemFontOfSize:12];
        self.orderPay.textColor = [UIColor colorWithHexString:@"#333333"];
        self.orderPay.textAlignment = NSTextAlignmentRight;

        /**左边按钮**/
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftBtn.frame = CGRectMake(ScreenWidth-140, 40, 60, 26);
        self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.leftBtn grayStyle];
        self.leftBtn.tag = 1000 ;
        [self.leftBtn addTarget:self action:@selector(footButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        /**右边按钮**/
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightBtn.frame = CGRectMake(ScreenWidth-70, 40, 60, 26);
        self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        self.rightBtn.backgroundColor = [UIColor colorWithHexString:@"e8103c"];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightBtn onlyCornerRadius];
        self.rightBtn.tag = 1001 ;
        [self.rightBtn addTarget:self action:@selector(footButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        /**第一条线**/
         self.line1 = [[UIView alloc] initWithFrame:CGRectMake(8, 0, ScreenWidth, 1)];
        self.line1.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD" alpha:0.5];
       
        /**第二条线**/
         self.line2 = [[UIView alloc] initWithFrame:CGRectMake(8, 30, ScreenWidth, 1)];
         self.line2.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD" alpha:0.5];;
       
        /**底部灰色**/
         self.grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, ScreenWidth, 10)];
         self.grayView.backgroundColor = [UIColor colorWithHexString:@"#EFEEEE"];;

        /**第三条线**/
        self.line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 79, ScreenWidth, 1)];
        self.line3.backgroundColor = [UIColor colorWithHexString:@"#cccccc" alpha:0.5];

        [self.contentView addSubview:self.line1];
        [self.contentView addSubview:self.line2];
        [self.contentView addSubview:self.line3];
        [self.contentView addSubview:self.grayView];
        [self.contentView addSubview:self.restCount];
        [self.contentView addSubview:self.arrowBtn];
        [self.contentView addSubview:self.showRestBtn];
        [self.contentView addSubview:self.totalCount];
        [self.contentView addSubview:self.orderPay];
        [self.contentView addSubview:self.leftBtn];
        [self.contentView addSubview:self.rightBtn];

        
    }
    return self;
}

- (void)setValue:(id)value;
{
    _order = value;
    
    /** zxd添加*/
    self.rightBtn.backgroundColor = [UIColor colorWithHexString:@"e8103c"];
    self.rightBtn.enabled = YES;
    
    
    
    /**还有几件,少于两件剩余件数和箭头按钮隐藏,多余显示**/
    NSString *str1 = [NSString stringWithFormat:@"%d",[_order.productCount intValue] -2];
    NSString * str =  [NSString stringWithFormat:@"还有%@件",str1];
    NSMutableAttributedString *strTime = [[NSMutableAttributedString alloc] initWithString:str];
    [strTime addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#fe446b"] range:[str rangeOfString:str1]];
    
    self.restCount.attributedText = strTime;
    
    
    NSArray *array = _order.itemInfoArray;
    if (array.count <= 2 )
    {   //隐藏
        self.restCount.hidden = YES;
        self.arrowBtn.hidden = YES;
    }else
    {   //显示
        self.restCount.hidden = NO;
        self.arrowBtn.hidden = NO;
    }
    
    /**总共几件**/
    
    self.totalCount.text = [NSString stringWithFormat:@"共%@件",_order.productCount];

    self.orderPay.text = [NSString stringWithFormat:@"实付:￥%0.2f",[_order.orderTotalAmount floatValue]];

    //左右两个按钮
    int state = [_order.orderStatus intValue];
    
    
    
    switch (state)
    {
        case 1://代付款
        {
            [self.leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.rightBtn setTitle:@"立即支付" forState:UIControlStateNormal];
            
             /** zxd添加*/
            if (_order.OverSecondTime.intValue == 0) {
                self.rightBtn.backgroundColor = [UIColor lightGrayColor];
                self.rightBtn.enabled = NO;
            }
            
            
        }
            break;
        case 2://待发货
        {
            self.leftBtn.hidden = YES;
            
            /**海关状态不为0,无法退款**/
            if (![_order.CustomsStatus isEqualToString:@"0"] || ![_order.CustomsDisStatus isEqualToString:@"0"])
            {
                self.rightBtn.hidden = YES;
                self.line3.frame = CGRectMake(0, 29, ScreenWidth, 1);
                self.grayView.frame = CGRectMake(0, 30, ScreenWidth, 10);
                
            }
            else
            {
                //退款信息的字典 ID=0 表示尚未退款 status表示退款状态
                NSDictionary *dd = [NSDictionary dictionary];
                dd = _order.OrderRefund;
                NSString *idStr = [NSString stringWithFormat:@"%@", dd[@"Id"]];
                if ([idStr isEqualToString:@"0"])
                {
                    [self.rightBtn setTitle:@"订单退款" forState:UIControlStateNormal];
                }
                else
                {
                    [self.rightBtn setTitle:@"查看售后" forState:UIControlStateNormal];
                }
           }
        }
            break;
        case 3://代收货
        {
            [self.leftBtn setTitle:@"物流跟踪" forState:UIControlStateNormal];
            [self.rightBtn setTitle:@"确定收货" forState:UIControlStateNormal];
        }
            break;
        case 4://已完成
        {
            if ([_order.RecycleBin isEqualToString:@"1"])
            {
                self.leftBtn.hidden = YES;
                self.rightBtn.hidden = YES;
                self.line3.frame = CGRectMake(0, 29, ScreenWidth, 1);
                self.grayView.frame = CGRectMake(0, 30, ScreenWidth, 10);
            }
            else
            {
                if ([_order.commentCount isEqualToString:@"0"])
                {
                    self.leftBtn.hidden = NO;
                    self.rightBtn.hidden = NO;
                    [self.leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                    [self.rightBtn setTitle:@"立即评价" forState:UIControlStateNormal];
                    [self.rightBtn redStyle];
                    
                }
                else
                {
                    self.leftBtn.hidden = YES;
                    self.rightBtn.hidden = NO;
                    [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                    [self.rightBtn grayStyle];

                }
            }

        }
            break;
        case 5://已关闭
        {
           
            if ([_order.RecycleBin isEqualToString:@"1"])
            {
                self.leftBtn.hidden = YES;
                self.rightBtn.hidden = YES;
                self.line3.frame = CGRectMake(0, 29, ScreenWidth, 1);
                self.grayView.frame = CGRectMake(0, 30, ScreenWidth, 10);
            }
            else
            {
                self.leftBtn.hidden = YES;
                self.rightBtn.hidden = NO;
                [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                [self.rightBtn grayStyle];
            }
        }
            break;

        default:
            break;
    }
}

- (void)footButtonClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(footer:withBtn:)])
    {
        [self.delegate footer:_section withBtn:button];
    }
}

- (void)moreProductClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(footer:restBtn:)])
    {
        [self.delegate footer:_section restBtn:button];
    }

}


@end
