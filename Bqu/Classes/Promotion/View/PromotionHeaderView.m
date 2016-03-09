//
//  PromotionHeaderView.m
//  Bqu
//
//  Created by wyy on 15/12/8.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "PromotionHeaderView.h"
#import "PromoterInfoModel.h"

@interface PromotionHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *myPropertyView;
@property (weak, nonatomic) IBOutlet UILabel *myPropertyLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalRebateLabel;
@property (weak, nonatomic) IBOutlet UILabel *freezePropertyLabel;

@end

@implementation PromotionHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"PromotionHeaderView" owner:self options:nil] objectAtIndex:0];
        view.frame = self.bounds;
        self.myPropertyView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"我的资产底.jpg"]];
        [self addSubview:view];
    }
    return self;
}

- (IBAction)detailsBtnClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(showDetailsClicked:)]) {
        [self.delegate showDetailsClicked:self];
    }
}

- (IBAction)invitedFriendsBtnClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(invitedFriendsClicked:)]) {
        [self.delegate invitedFriendsClicked:self];
    }
}

- (IBAction)withdrawCashBtnClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(withdrawCashClicked:)]) {
        [self.delegate withdrawCashClicked:self];
    }
}

- (IBAction)becomePromoterBtnClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(becomePromoterClicked:)]) {
        [self.delegate becomePromoterClicked:self];
    }
}

- (void)resetHeaderViewData:(PromoterInfoModel *)model
{
    self.myPropertyLabel.text = [NSString stringWithFormat:@"%.2f", model.usableMoney.floatValue];
    self.totalRebateLabel.text = [NSString stringWithFormat:@"￥%.2f", model.totalRebate.floatValue];
    self.freezePropertyLabel.text = [NSString stringWithFormat:@"￥%.2f", model.freezMoney.floatValue];
}

@end
