//
//  HomeTableFourBtnCell.m
//  Bqu
//
//  Created by yb on 15/11/30.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "HomeTableFourBtnCell.h"

@implementation HomeTableFourBtnCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        for (int i = 0; i<4; i++) {
            
            //图片
            CGFloat imageW = 45;
            CGFloat boardW = 20;
            CGFloat spaceW = (ScreenWidth -boardW*2- imageW*4)/3.0;
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(boardW + i*(spaceW + imageW), 10, imageW, imageW)];
            if (i==0) {
                
                imageView.image = [UIImage imageNamed:@"正"];
                
            }else if (i==1)
            {
                
                imageView.image = [UIImage imageNamed:@"线下"];
                
            }else if (i ==2)
            {
                imageView.image = [UIImage imageNamed:@"闪电"];
                
            }else
            {
                imageView.image = [UIImage imageNamed:@"包邮"];
                
            }
            [self.contentView addSubview:imageView];
            
            CGFloat labelW = 60;
            CGFloat labelH = 20;
            CGFloat spaceW2 = (ScreenWidth -15*2- labelW*4)/3.0;
            CGFloat label_Y = CGRectGetMaxY(imageView.frame)+10;
            UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(15 + i*(spaceW2 + labelW), label_Y , labelW, labelH)];
//            lable.backgroundColor = HWRandomColor;
            lable.font = [UIFont systemFontOfSize:13];
            lable.textColor = [UIColor colorWithHexString:@"#555555"];
            lable.textAlignment = NSTextAlignmentCenter;
            if (i == 0) {
                lable.text = @"海外直供";
            }else if (i == 1)
            {
                lable.text = @"线下店铺";
                
                
            }else if (i == 2)
            {
                lable.text = @"闪电发货";
                
            }else
            {
                lable.text = @"满88包邮";
                
            }
            [self.contentView addSubview:lable];
            
            
            CGFloat btnW = ScreenWidth/4.0;
            CGFloat btnH = label_Y;
            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(i *btnW, 0, btnW, btnH)];
            btn.tag = i + 100;
//            btn.backgroundColor =HWRandomColor;
            [btn addTarget:self action:@selector(fourBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:btn];
            
        }
        

    }
    return self;
}
-(void)fourBtnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(HomeTableFourBtnCellClick:withBtn:)]) {
        [self.delegate HomeTableFourBtnCellClick:self withBtn:btn];
    }
}
@end
