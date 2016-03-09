//
//  PromotionShareCell.m
//  Bqu
//
//  Created by wyy on 15/12/10.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "PromotionShareCell.h"
#import "PromoterInfoModel.h"

@interface PromotionShareCell ()

@property (weak, nonatomic) IBOutlet UILabel *tipsIndoLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareUrlLabel;
@property (weak, nonatomic) IBOutlet UIView *qrCodeView;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@end

@implementation PromotionShareCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.qrCodeView bringSubviewToFront:self.qrCodeImageView];
    self.shareButton.layer.masksToBounds = YES;
    self.shareButton.layer.cornerRadius = 2.0;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qrCodeImageTouched:)];
    [self.qrCodeView addGestureRecognizer:tapGesture];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setShareCellContent:(PromoterInfoModel *)model
{
    if (model == nil) {
        return;
    }
    NSString *shareUrl = [NSString stringWithFormat:@"这是我的邀请链接：%@ 让我们一起嗨go世界！", model.referURL];
    self.shareUrlLabel.text = shareUrl;
    //得到字符串所占size
    UIFont *font = [UIFont systemFontOfSize:12.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGRect rc1 = [self.tipsIndoLabel.text boundingRectWithSize:CGSizeMake(ScreenWidth-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    CGRect rc2 = [shareUrl boundingRectWithSize:CGSizeMake(ScreenWidth-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    CGFloat height = 220.0;
    height += rc1.size.height;
    height += rc2.size.height;
    self.height = height;
    
    [self.qrCodeImageView sd_setImageWithURL:[NSURL URLWithString:model.referImage] placeholderImage:nil];
}

- (void)qrCodeImageTouched:(UITapGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(qrCodeClicked:)]) {
        [self.delegate qrCodeClicked:self];
    }
}

- (IBAction)shareButtonWasClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(shareButtonClicked:)]) {
        [self.delegate shareButtonClicked:self];
    }
}

@end
