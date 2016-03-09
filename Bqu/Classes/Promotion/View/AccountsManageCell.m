//
//  AccountsManageCell.m
//  Bqu
//
//  Created by WONG on 15/12/8.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "AccountsManageCell.h"


@interface AccountsManageCell()

@end

@implementation AccountsManageCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        self.accountName = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, ScreenWidth/2, 15)];
        self.accountName.text = @"支付宝";
        self.accountName.textAlignment = NSTextAlignmentLeft;
        self.accountName.textColor = [UIColor colorWithHexString:@"#333333"];
        self.accountName.font = [UIFont systemFontOfSize:12];

        self.accoutUser = [[UILabel alloc] initWithFrame:CGRectMake(10,35,ScreenWidth - 80 ,11)];
        self.accoutUser.text = @"马云 mymymymymymymy";
        self.accoutUser.font = [UIFont systemFontOfSize:11];
        self.accoutUser.textAlignment = NSTextAlignmentLeft;
        self.accoutUser.textColor = [UIColor colorWithHexString:@"999999"];
        
        self.deleteImg = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-10-14, 23, 14, 14)];
        self.deleteImg.image = [UIImage imageNamed:@"delete"];
        
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteBtn.bounds = CGRectMake( 0, 0, 40, 40);
        self.deleteBtn.center = CGPointMake(ScreenWidth-10-20, 30);
        [self.deleteBtn addTarget:self action:@selector(deleteuserAccount) forControlEvents:UIControlEventTouchDown];

        self.line = [[UIView alloc] initWithFrame:CGRectMake(0,59,ScreenWidth ,1)];
        self.line.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        
        [self.contentView addSubview:self.accountName];
        [self.contentView addSubview:self.accoutUser];
        [self.contentView addSubview:self.deleteImg];
        [self.contentView addSubview:self.deleteBtn];
        [self.contentView addSubview:self.line];

    }
    return self;
}
- (void)deleteuserAccount
{
    if ([self.delegate respondsToSelector:@selector(deleteuserAccount:)]) {
        [self.delegate deleteuserAccount:self.account];
    }
}
- (void)setAccount:(AccountModel *)account {
    _account = account;
    
    _accountName.text = _account.accountStyle;
    _accoutUser.text = _account.subTitle;
    _deleteBtn.hidden = _account.deleteState;
    _deleteImg.hidden = _account.deleteState;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
