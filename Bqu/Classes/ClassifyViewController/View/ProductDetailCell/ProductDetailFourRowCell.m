//
//  ProductDetailFourRowCell.m
//  Bqu
//
//  Created by yb on 15/10/24.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "ProductDetailFourRowCell.h"
#define gap_W 5.0
@implementation ProductDetailFourRowCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.commentCount = [[UILabel alloc] initWithFrame:CGRectMake(15, gap_W, ScreenWidth-20, 30)];
        self.commentCount.textColor = [UIColor colorWithHexString:@"#030202"];
        self.commentCount.font = [UIFont fontWithName:NormalFONT size:17];
        self.commentScore = [[UILabel alloc] initWithFrame:CGRectMake(15, 30+gap_W+gap_W, ScreenWidth-20, 30)];
        self.commentScore.font = [UIFont fontWithName:LightFONT size:17];
        UILabel * lineTwo = [[UILabel alloc] initWithFrame:CGRectMake(15, 59+gap_W+gap_W, ScreenWidth-20, 1)];
        lineTwo.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
        [self.contentView addSubview:lineTwo];
        
        self.moreComment = [[UIButton alloc] initWithFrame:CGRectMake(0, 60+gap_W+gap_W, ScreenWidth, 40)];
        [self.moreComment setTitle:@"查看更多评价" forState:UIControlStateNormal];
        [self.moreComment setTitleColor:[UIColor colorWithHexString:@"#030202"] forState:UIControlStateNormal];
        self.moreComment.titleLabel.font = [UIFont fontWithName:RegularFONT size:17];
        self.moreComment.tag = 222;
        [self.moreComment addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:self.commentCount];
        [self.contentView addSubview:self.commentScore];
        [self.contentView addSubview:self.moreComment];
        
        
        UILabel * lineThree = [[UILabel alloc] initWithFrame:CGRectMake(0, 100+gap_W+gap_W, ScreenWidth, 10)];
        lineThree.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
        [self.contentView addSubview:lineThree];
        
        CGFloat itemW = (ScreenWidth-40)/3.0;
        
        UILabel * middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 110+gap_W+gap_W, itemW, 30)];
        middleLabel.textAlignment = NSTextAlignmentCenter;
        middleLabel.textColor = [UIColor colorWithHexString:@"#f4355c"];
        middleLabel.text = @"B区海购保证";
        middleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:middleLabel];
        middleLabel.center = CGPointMake(ScreenWidth/2.0, 125+gap_W+gap_W);
        
        UILabel * lineFour = [[UILabel alloc] initWithFrame:CGRectMake(15, 125+gap_W+gap_W, itemW, 1)];
        lineFour.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:lineFour];
        
        UILabel * lineFive = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-15-itemW, 125+gap_W+gap_W, itemW, 1)];
        lineFive.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:lineFive];
        
        CGFloat btnW = (ScreenWidth-200)/5.0;
        self.btn1 = [[UIButton alloc] initWithFrame:CGRectMake(btnW, 140+gap_W+gap_W, 50, 50)];
        self.btn2 = [[UIButton alloc] initWithFrame:CGRectMake(2*btnW+50, 140+gap_W+gap_W, 50, 50)];
        self.btn3 = [[UIButton alloc] initWithFrame:CGRectMake(3*btnW+100, 140+gap_W+gap_W, 50, 50)];
        self.btn4 = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-50-btnW, 140+gap_W+gap_W, 50, 50)];
        [self.btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btn3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btn4 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.btn1.tag = 3331;
        self.btn2.tag = 3332;
        self.btn3.tag = 3333;
        self.btn4.tag = 3334;
        
        [self.btn1 setImage:[UIImage imageNamed:@"B区详情页01正"] forState:UIControlStateNormal];
        [self.btn2 setImage:[UIImage imageNamed:@"B区详情页01飞机"] forState:UIControlStateNormal];
        [self.btn3 setImage:[UIImage imageNamed:@"B区详情页01线下店铺"] forState:UIControlStateNormal];
        [self.btn4 setImage:[UIImage imageNamed:@"B区详情页01闪电发货"] forState:UIControlStateNormal];
        
        [self.contentView addSubview:self.btn1];
        [self.contentView addSubview:self.btn2];
        [self.contentView addSubview:self.btn3];
        [self.contentView addSubview:self.btn4];
        
        UILabel * btnLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(btnW, 200, 50, 50)];
        UILabel * btnLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(2*btnW+50, 200, 50, 50)];
        UILabel * btnLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(3*btnW+100, 200, 50, 50)];
        UILabel * btnLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-50-btnW, 200, 50, 50)];
        btnLabel1.font = [UIFont systemFontOfSize:12];
        btnLabel2.font = [UIFont systemFontOfSize:12];
        btnLabel3.font = [UIFont systemFontOfSize:12];
        btnLabel4.font = [UIFont systemFontOfSize:12];
        btnLabel1.text = @"正品保障";
        btnLabel2.text = @"海外直购";
        btnLabel3.text = @"线下店铺";
        btnLabel4.text = @"闪电发货";
        
        [self.contentView addSubview:btnLabel1];
        [self.contentView addSubview:btnLabel2];
        [self.contentView addSubview:btnLabel3];
        [self.contentView addSubview:btnLabel4];
        
        UILabel *lineSix = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, ScreenWidth, 10)];
        lineSix.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
        [self.contentView addSubview:lineSix];

    }
    return self;
}
-(void)setModel:(ProductModel *)model
{
    _model = model;
    if (_model.CommentCount.intValue>0) {
        
        self.commentCount.text = [NSString stringWithFormat:@"用户评价(%@)",_model.CommentCount];

    }else
    {
        self.commentCount.text = [NSString stringWithFormat:@"用户评价(0)"];

    }
    
    self.commentScore.text = [NSString stringWithFormat:@"%.1f分",_model.ReviewMark.floatValue];
    [self.commentScore sizeToFit];
    NSString * mark1 = [NSString stringWithFormat:@"%.1f", _model.ReviewMark.floatValue];
    int mark3 = (int)(mark1.floatValue + 0.5);
    if (mark3>=1) {
        for (int i=0; i<mark3; i++) {
            CGFloat  starW = 20;
            CGFloat boardW = 5;
            UIImageView * star = [[UIImageView alloc] initWithFrame:CGRectMake(self.commentScore.width+20+i*(starW+boardW), self.commentScore.y, starW, starW)];
            star.image = [UIImage imageNamed:@"B区详情页五角星"];
            [self.contentView addSubview:star];
        }
    }

}
-(void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(ProductDetailFourRowCellBtnClick:withBtn:)]) {
        [self.delegate ProductDetailFourRowCellBtnClick:self withBtn:btn];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
