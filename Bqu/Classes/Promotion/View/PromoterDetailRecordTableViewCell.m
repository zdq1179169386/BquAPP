//
//  PromoterDetailRecordTableViewCell.m
//  Bqu
//
//  Created by wyy on 15/12/11.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "PromoterDetailRecordTableViewCell.h"

@interface PromoterDetailRecordTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *showNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation PromoterDetailRecordTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPromoterDetailRecordInfo:(PromoterDetailRecordModel *)model
{
    if (model == nil) {
        return;
    }
    
    if (model.cardNo.length > 0) {
        NSString *cardNo = model.cardNo;
        if (cardNo.length >= 4) {
            cardNo = [cardNo substringFromIndex:(cardNo.length - 4)];
        }
        NSString *str = [NSString stringWithFormat:@"（%@尾号：%@）", model.bankName, cardNo];
        if (model.showName.length > 0) {
            str = [NSString stringWithFormat:@"%@%@", model.showName, str];
        } else {
            str = [NSString stringWithFormat:@"提现%@", str];
        }
        self.showNameLabel.text = str;
    } else {
        NSString *mobile = model.mobile;
        if (mobile.length == 11) {
            mobile = [mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
        self.showNameLabel.text = [NSString stringWithFormat:@"好友（%@）%@", mobile, model.showName];
    }
    self.timeLabel.text = model.createDate;
    if (model.price.floatValue > 0) {
        self.priceLabel.text = [NSString stringWithFormat:@"+%.2f元", model.price.floatValue];
    } else {
        self.priceLabel.text = [NSString stringWithFormat:@"%.2f元", model.price.floatValue];
    }
    self.statusLabel.text = model.statusName;
    if ([model.statusName isEqualToString:@"等待确认收货"]) {
        self.statusLabel.textColor = RGB_A(246, 38, 72);
    } else {
        self.statusLabel.textColor = RGB_A(153, 153, 153);
    }
}

@end
