//
//  MyOrderHeader.m
//  Bqu
//
//  Created by yingbo on 15/11/23.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "MyOrderHeader.h"

@interface MyOrderHeader ()
{
    NSInteger _section;
    int _restTime;
}

@end

@implementation MyOrderHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier withSection:(NSInteger)section
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _section = section;
        /**顶部线条**/
        self.line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        self.line1.backgroundColor = [UIColor colorWithHexString:@"#cccccc" alpha:0.5];
        
        /**订单状态**/
        self.stateLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 138, 31)];
        self.stateLab.font = [UIFont systemFontOfSize:11];
        self.stateLab.textColor = [UIColor colorWithHexString:@"#e8103c"];
        self.stateLab.textAlignment = NSTextAlignmentLeft;
        
        /**下单日期**/
        self.dateLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 145, 2, 138, 31)];
        self.dateLab.font = [UIFont systemFontOfSize:11];
        self.dateLab.textColor = [UIColor colorWithHexString:@"#888888"];
        self.dateLab.textAlignment = NSTextAlignmentRight;
        
        /**代付款时候的钟表**/
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.dateLab.frame.origin.x-16, 10, 14, 14)];
        self.imageV.image = [UIImage imageNamed:@"clock"];
        self.imageV.hidden = YES;

        [self.contentView addSubview:self.line1];
        [self.contentView addSubview:self.dateLab];
        [self.contentView addSubview:self.stateLab];
        [self.contentView addSubview:self.imageV];

        
        }
    return self;
}


- (void)setValue:(id)value
{
    _order = value;
    
    /**代付款状态,有订单退款时候就显示退款情况**/
    if ([_order.orderStatus isEqualToString:@"2"])
    {
        NSDictionary *dd = [NSDictionary dictionary];
        dd = _order.OrderRefund;
        NSString *idStr = [NSString stringWithFormat:@"%@", dd[@"Id"]];
        if ([idStr isEqualToString:@"0"])
        {
            self.stateLab.text = @"待发货";
        }
        else
        {
            self.stateLab.text = dd[@"Status"];
        }
    }
    else
    {
        self.stateLab.text = _order.status;
    }
    
    /**代付款状态倒计时**/
    if (![_order.orderStatus isEqualToString:@"1"])
    {
        self.dateLab.text = _order.orderDate;
        _imageV.hidden = YES;

    }
    else
    {
        /**倒计时开始**/
        int dd = [_order.OverSecondTime intValue];
        _restTime = dd;


        /**计算剩余时间秒数**/
        int day = (int)(dd/3600/24);
        int hour = (int)(dd-day*3600*24)/3600;
        int minute = (int)(dd-day*3600*24 - hour*3600)/60;
        int second = dd -day*3600*24- hour*3600 - minute*60;

        /**字体颜色改变**/
        NSString *str1 = [NSString stringWithFormat:@"%d",hour];
        NSString *str2 = [NSString stringWithFormat:@"%d",minute];
        NSString *str3 = [NSString stringWithFormat:@"%d",second];
        
        NSString * str =  [NSString stringWithFormat:@"剩余:%@时%@分%@秒",str1,str2,str3];
        NSMutableAttributedString *strTime = [[NSMutableAttributedString alloc] initWithString:str];
        [strTime addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"fe446b"] range:[str rangeOfString:str1]];
        [strTime addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"fe446b"] range:[str rangeOfString:str2]];
        [strTime addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"fe446b"] range:[str rangeOfString:str3]];
        _dateLab.attributedText = strTime;
        
        
        // 计算文字的宽度 钟表随着时间动
        CGRect rect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil];
        float width =  ceilf(rect.size.width);
        self.dateLab.frame = CGRectMake(ScreenWidth - width-10, 2, width, 31);
        self.imageV.frame = CGRectMake(self.dateLab.frame.origin.x-19, 10, 14, 14);
        
        /**显示时钟图标**/
        _imageV.hidden = NO;
        NSLog(@"_order.status=%@,_order.orderStatus=%@,_order.OverSecondTime=%@",_order.status,_order.orderStatus,_order.OverSecondTime);
        NSLog(@"显示时钟图标= %d, %@,%@",_restTime,_order.orderStatus,_order.OverSecondTime);
        if (_order.orderStatus.intValue == 1 && _order.OverSecondTime.floatValue > 0) {

            if (!_headerTimer) {
                _headerTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(restTime:) userInfo:nil repeats:YES];
                [[NSRunLoop mainRunLoop] addTimer:_headerTimer forMode:NSRunLoopCommonModes];

            }
        }
       
    }
        
    /**订单状态颜色设置**/
    if ([_order.orderStatus isEqualToString:@"4"] || [_order.orderStatus isEqualToString:@"5"] || [_order.orderStatus isEqualToString:@"6"])
    {
        self.stateLab.textColor = [UIColor colorWithHexString:@"#888888"];
    }
}

- (void)restTime:(NSTimer *)timer
{
    _restTime--;
    NSLog(@"%@, %@,%@",_order.status,_order.orderStatus,_order.OverSecondTime);
    if (_restTime == 0)
    {
        if ([_headerTimer isValid]) {
            [_headerTimer invalidate];
            _headerTimer = nil;
#warning 发通知，刷新表格
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TimerOutForRequestDate" object:nil userInfo:nil];

        }
    }else
    {
        /**计算剩余时间秒数**/
        int day = (int)(_restTime/3600/24);
        int hour = (int)(_restTime-day*3600*24)/3600;
        int minute = (int)(_restTime-day*3600*24 - hour*3600)/60;
        int second = _restTime -day*3600*24- hour*3600 - minute*60;
        
        /**字体颜色改变**/
        NSString *str1 = [NSString stringWithFormat:@"%d",hour];
        NSString *str2 = [NSString stringWithFormat:@"%d",minute];
        NSString *str3 = [NSString stringWithFormat:@"%d",second];
        
        NSString * str =  [NSString stringWithFormat:@"剩余:%@时%@分%@秒",str1,str2,str3];
        NSMutableAttributedString *strTime = [[NSMutableAttributedString alloc] initWithString:str];
        [strTime addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"fe446b"] range:[str rangeOfString:str1]];
        [strTime addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"fe446b"] range:[str rangeOfString:str2]];
        [strTime addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"fe446b"] range:[str rangeOfString:str3]];

        
        // 计算文字的宽度 钟表随着时间动
        CGRect rect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil];
        float width =  ceilf(rect.size.width);
        self.dateLab.frame = CGRectMake(ScreenWidth - width-10, 2, width, 31);
        self.imageV.frame = CGRectMake(self.dateLab.frame.origin.x-19, 10, 14, 14);

       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //设置界面的按钮显示 根据自己需求设置
            self.dateLab.attributedText = strTime;

        });
    }

}

@end
