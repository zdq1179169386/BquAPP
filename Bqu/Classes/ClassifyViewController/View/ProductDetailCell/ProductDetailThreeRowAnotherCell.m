//
//  ProductDetailThreeRowAnotherCell.m
//  Bqu
//
//  Created by yb on 15/10/23.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "ProductDetailThreeRowAnotherCell.h"
#define  gap_W 15

@interface ProductDetailThreeRowAnotherCell ()
{
    int _timerTime;
}


@property (nonatomic,strong) UILabel * price;

@end
@implementation ProductDetailThreeRowAnotherCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#fff7f7"];
        
        UILabel * line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        line1.backgroundColor = [UIColor colorWithHexString:@"#e7113d"];
        [self.contentView addSubview:line1];
        
        UILabel * line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, ScreenWidth, 0.5)];
        line2.backgroundColor = [UIColor colorWithHexString:@"#e7113d"];
        [self.contentView addSubview:line2];
        
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 50, 50)];
        image.image = [UIImage imageNamed:@"B区详情页04-特卖"];
        [self.contentView addSubview:image];
        
        
        UILabel * salePrice = [[UILabel alloc] initWithFrame:CGRectMake(gap_W*2+50, 10, 200, 25)];
//        salePrice.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:salePrice];
        self.price = salePrice;
        
        CGFloat dateY = CGRectGetMaxY(salePrice.frame);
        
        UILabel * date = [[UILabel alloc] initWithFrame:CGRectMake(gap_W*2+50, dateY+5, 200, 25)];
        date.textColor = [UIColor colorWithHexString:@"#888888"];
//        date.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:date];
        self.date = date;
        
        UILabel * lineOne = [[UILabel alloc] initWithFrame:CGRectMake(0, 71, ScreenWidth, 9)];
        lineOne.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
        [self.contentView addSubview:lineOne];

    }
    return self;
}
-(void)setModel:(ProductModel *)model
{
    _model = model;
    
    NSString * str1 = @"¥";
    NSString * str2 = [NSString stringWithFormat:@"%.2f ",_model.SalePrice.floatValue];
    NSString * str3 = @"市场价¥";
    NSString * str4 = [NSString stringWithFormat:@"%.2f",_model.MarketPrice.floatValue];
    NSString * str5 = [NSString stringWithFormat:@"%@%@",str3,str4];
    
    NSString * str =  [NSString stringWithFormat:@"%@%@%@%@",str1,str2,str3,str4];

    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:[str rangeOfString:str1]];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#e8103c"] range:[str rangeOfString:str1]];
    
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#e8103c"] range:NSMakeRange(1, str2.length)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:23] range:NSMakeRange(1, str2.length-3)];

    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#888888"] range:[str rangeOfString:str5]];
    self.price.attributedText = attrStr;
    [self.price sizeToFit];
    CGFloat maxX = CGRectGetMaxX(self.price.frame);
    CGFloat maxY = CGRectGetMaxY(self.price.frame);

    
    CGSize lineSize = [str4 sizeWithFont:[UIFont systemFontOfSize:17]];
    UILabel * line = [[UILabel alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#888888"];
    line.frame = CGRectMake(maxX-lineSize.width, maxY-lineSize.height/2.0, lineSize.width, 1);
    [self.contentView addSubview:line];
    
    
//    self.date.text = model.OverTime;
    
//      _timerTime = model.OverTime.intValue;
//    self.overTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:self.overTimer forMode:NSRunLoopCommonModes];
//
//    __block int timeout= model.OverTime.intValue; //倒计时时间
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
//    self.overTimer = _timer;
////    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
//    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
//   
//    dispatch_source_set_event_handler(_timer, ^{
//        if(timeout<=0){ //倒计时结束，关闭
//            dispatch_source_cancel(_timer);
////            dispatch_release(_timer);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //设置界面的按钮显示 根据自己需求设置
//                
//            });
//        }else{
//            
//            int day = (int)(timeout/3600/24);
//            int hour = (int)(timeout-day*3600*24)/3600;
//            int minute = (int)(timeout-day*3600*24 - hour*3600)/60;
//            int second = timeout -day*3600*24- hour*3600 - minute*60;
//            NSLog(@"_%d,_%d,_%d,_%d",day,hour,minute,second);
//
//            
////            int minutes = timeout / 60;
////            int seconds = timeout % 60;
//            NSString *strTime = [NSString stringWithFormat:@"距结束:%d天%d时%d分",day,hour,minute];
//            dispatch_async(dispatch_get_main_queue(), ^{
//         
//                //设置界面的按钮显示 根据自己需求设置
//                self.date.text = strTime;
//
//            });
//          
//            timeout--;
//            
//        }
//    });
//    dispatch_resume(_timer);
    
}
-(void)timerRun
{
    _timerTime--;
    if (_timerTime<=0) {
        [self.overTimer invalidate];
        self.overTimer = nil;
    }else
    {
        int day = (int)(_timerTime/3600/24);
                    int hour = (int)(_timerTime-day*3600*24)/3600;
                    int minute = (int)(_timerTime-day*3600*24 - hour*3600)/60;
                    int second = _timerTime -day*3600*24- hour*3600 - minute*60;
                    NSLog(@"_%d,_%d,_%d,_%d",day,hour,minute,second);
                    NSString *strTime = [NSString stringWithFormat:@"距结束:%d天%d时%d分",day,hour,minute];
                    dispatch_async(dispatch_get_main_queue(), ^{
        
                        //设置界面的按钮显示 根据自己需求设置
                        self.date.text = strTime;
                    });
    }
}
-(void)dealloc
{
    if (self.overTimer) {
        [self.overTimer invalidate];
        self.overTimer = nil;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
