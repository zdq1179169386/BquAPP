//
//  CommentHeaderCell.m
//  Bqu
//
//  Created by yb on 15/10/21.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "CommentHeaderCell.h"

@interface CommentHeaderCell ()

{
    NSInteger _lastBtn;
}

@end

@implementation CommentHeaderCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
 {
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F2f1f1"];
        CGFloat btnW = 67;
        CGFloat btnH = 30;
        CGFloat gapW = 10;
        self.btnOne = [[UIButton alloc] initWithFrame:CGRectMake(10, 40, btnW, btnH)];
        [self.btnOne setTitle:@"全部(0)" forState:UIControlStateNormal];
        self.btnTwo = [[UIButton alloc] initWithFrame:CGRectMake(10+btnW+gapW, 40, btnW, btnH)];
        [self.btnTwo setTitle:@"好评(0)" forState:UIControlStateNormal];

        CGFloat threeY = CGRectGetMaxX(self.btnTwo.frame);
        self.btnThree = [[UIButton alloc] initWithFrame:CGRectMake(threeY+gapW, 40, btnW, btnH)];
        [self.btnThree setTitle:@"中评(0)" forState:UIControlStateNormal];

        CGFloat fourY = CGRectGetMaxX(self.btnThree.frame);
        self.btnFour = [[UIButton alloc] initWithFrame:CGRectMake(fourY+gapW, 40, btnW, btnH)];
        [self.btnFour setTitle:@"差评(0)" forState:UIControlStateNormal];
        
        self.btnOne.titleLabel.font = [UIFont systemFontOfSize:14];
        self.btnTwo.titleLabel.font = [UIFont systemFontOfSize:14];
        self.btnThree.titleLabel.font = [UIFont systemFontOfSize:14];
        self.btnFour.titleLabel.font = [UIFont systemFontOfSize:14];


        self.btnOne.backgroundColor = [UIColor whiteColor];
        self.btnTwo.backgroundColor = [UIColor whiteColor];
        self.btnThree.backgroundColor = [UIColor whiteColor];
        self.btnFour.backgroundColor = [UIColor whiteColor];
        
        [self.btnOne setTitleColor:[UIColor colorWithHexString:@"#e8103c"] forState:UIControlStateNormal];
        [self.btnTwo setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [self.btnThree setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [self.btnFour setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        
        self.btnOne.tag = 111;
        self.btnTwo.tag = 222;
        self.btnThree.tag = 333;
        self.btnFour.tag = 444;
        _lastBtn = 111;

        [self.btnOne addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnTwo addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnThree addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnFour addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

        
        self.btnOne.layer.cornerRadius = 5;
        self.btnOne.clipsToBounds = YES;
        self.btnTwo.layer.cornerRadius = 5;
        self.btnTwo.clipsToBounds = YES;
        self.btnThree.layer.cornerRadius = 5;
        self.btnThree.clipsToBounds = YES;
        self.btnFour.layer.cornerRadius = 5;
        self.btnFour.clipsToBounds = YES;
        
        self.btnOne.layer.borderWidth = 1;
        self.btnOne.layer.borderColor = [UIColor colorWithHexString:@"#e8103c"].CGColor;
        self.btnTwo.layer.borderWidth = 1;
        self.btnTwo.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
        self.btnThree.layer.borderWidth = 1;
        self.btnThree.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
        self.btnFour.layer.borderWidth = 1;
        self.btnFour.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
        
        [self.contentView addSubview:self.btnOne];
        [self.contentView  addSubview:self.btnTwo];
        [self.contentView  addSubview:self.btnThree];
        [self.contentView  addSubview:self.btnFour];
        
        self.ReviewMarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 100, 20)];
        self.ReviewMarkLabel.textColor = [UIColor colorWithHexString:@"#e8103c"];
        self.ReviewMarkLabel.font = [UIFont systemFontOfSize:20];
        [self.contentView  addSubview:self.ReviewMarkLabel];
        
    }
    return self;
}
-(void)setIsSelecctedBtn:(NSInteger)isSelecctedBtn
{
    [self.btnOne setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    self.btnOne.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
    
    [self.btnTwo setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    self.btnTwo.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
    

    [self.btnThree setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    self.btnThree.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
    

    
    [self.btnFour setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    self.btnFour.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;

    
    UIButton * btn =(UIButton *)[self.contentView viewWithTag:isSelecctedBtn];
    [btn setTitleColor:[UIColor colorWithHexString:@"#e8103c"] forState:UIControlStateNormal];
    btn.layer.borderColor = [UIColor colorWithHexString:@"#e8103c"].CGColor;
}
-(void)btnClick:(UIButton *)btn
{
//    [btn setTitleColor:[UIColor colorWithHexString:@"#e8103c"] forState:UIControlStateNormal];
//    btn.layer.borderColor =  [UIColor colorWithHexString:@"#e8103c"].CGColor;
//    UIButton * lastBtn = (UIButton *)[self.contentView viewWithTag:_lastBtn];
//    [lastBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
//    lastBtn.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
//    _lastBtn = btn.tag;
    
    
    if ([self.delegate respondsToSelector:@selector(CommentHeaderCellBtnClick:withBtn:)]) {
        [self.delegate CommentHeaderCellBtnClick:self withBtn:btn];
    }
}
-(void)setReviewMark:(NSString *)ReviewMark
{
    _ReviewMark = ReviewMark;
    NSMutableArray * array = [NSMutableArray array];
    NSString * mark1 = [NSString stringWithFormat:@"%.1f", _ReviewMark.floatValue];
    int mark3 = (int)(mark1.floatValue + 0.5);
    if (mark3>=1) {
        for (int i=0; i<mark3; i++) {
            CGFloat  starW = 20;
            CGFloat boardW = 5;
            UIImageView * star = [[UIImageView alloc] initWithFrame:CGRectMake(10+i*(starW+boardW), 10, starW, starW)];
            star.image = [UIImage imageNamed:@"B区详情页五角星"];
            [self addSubview:star];
            [array addObject:star];
        }
    }
    UIImageView * star = [array lastObject];
    CGFloat starX = CGRectGetMaxX(star.frame);
    self.ReviewMarkLabel.x = starX +10;
    self.ReviewMarkLabel.text = [NSString stringWithFormat:@"%.1f分", _ReviewMark.floatValue];
    
}
-(void)setGoodComment:(NSString *)goodComment
{
    _goodComment = goodComment;
    if (!_goodComment) {
        [self.btnTwo setTitle:@"好评(0)" forState:UIControlStateNormal];

    }else
    {
        [self.btnTwo setTitle:[NSString stringWithFormat:@"好评(%@)",_goodComment] forState:UIControlStateNormal];

    }
}
-(void)setAllComment:(NSString *)allComment
{
    _allComment = allComment;
    if (!_allComment) {
        [self.btnOne setTitle:@"全部(0)"forState:UIControlStateNormal];

    }
    else
    {
        [self.btnOne setTitle:[NSString stringWithFormat:@"全部(%@)",_allComment] forState:UIControlStateNormal];

    }
}
-(void)setComment:(NSString *)comment
{
    _comment = comment;
    if (!_comment) {
        [self.btnThree setTitle:@"中评(0)" forState:UIControlStateNormal];

    }
    else
    {
        [self.btnThree setTitle:[NSString stringWithFormat:@"中评(%@)",_comment] forState:UIControlStateNormal];

    }
}
-(void)setBadComment:(NSString *)badComment
{
    _badComment = badComment;
    if (_badComment == NULL) {
        [self.btnFour setTitle:@"差评(0)" forState:UIControlStateNormal];

    }else
    {
        [self.btnFour setTitle:[NSString stringWithFormat:@"差评(%@)",_badComment] forState:UIControlStateNormal];

    }

}
@end
