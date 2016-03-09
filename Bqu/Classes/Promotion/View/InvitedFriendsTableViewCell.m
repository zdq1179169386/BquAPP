//
//  InvitedFriendsTableViewCell.m
//  Bqu
//
//  Created by wyy on 15/12/9.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "InvitedFriendsTableViewCell.h"

@interface InvitedFriendsTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *friendPhonelabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@end

@implementation InvitedFriendsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInvitedFrinedInfo:(InvitedFriendModel *)model
{
    if (model == nil) {
        return;
    }
    NSString *phone = model.mobile;
    if (phone.length == 11) {
        phone = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    self.friendPhonelabel.text = [NSString stringWithFormat:@"好友（%@）", phone];
    self.timeLabel.text = model.createDate;
}

@end
