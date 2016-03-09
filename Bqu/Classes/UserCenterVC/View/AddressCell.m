//
//  AddressCell.m
//  Bqu
//
//  Created by yingbo on 15/11/30.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "AddressCell.h"

@implementation AddressCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#42516B"];
        
        self.addressImgView =  [[UIImageView alloc] initWithFrame:CGRectMake(9, 18, 15, 20)];
        self.addressImgView.image = [UIImage imageNamed:@"add1"];
        
        self.receiverLab = [[UILabel alloc] initWithFrame:CGRectMake(9+ 15+ 7, 19, 100, 15)];
        self.receiverLab.font = [UIFont systemFontOfSize:12];
        self.receiverLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        
        self.phonrNumberLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth- 100 - 28, 19, 100, 15)];
        self.phonrNumberLab.textAlignment = NSTextAlignmentRight;
        self.phonrNumberLab.font = [UIFont systemFontOfSize:12];
        self.phonrNumberLab.textColor = [UIColor colorWithHexString:@"#ffffff"];

        self.addressLab = [[UILabel alloc] initWithFrame:CGRectMake(9+ 15+ 7, 42, ScreenWidth- 31 - 28, 15)];
        self.addressLab.font = [UIFont systemFontOfSize:12];
        self.addressLab.numberOfLines = 0;
        self.addressLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        
        self.IdCardLab = [[UILabel alloc] initWithFrame:CGRectMake(9+ 15+ 7, 64, ScreenWidth- 31 - 28, 15)];
        self.IdCardLab.font = [UIFont systemFontOfSize:12];
        self.IdCardLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        
        
        [self.contentView addSubview:self.addressImgView];
        [self.contentView addSubview:self.receiverLab];
        [self.contentView addSubview:self.phonrNumberLab];
        [self.contentView addSubview:self.addressLab];
        [self.contentView addSubview:self.IdCardLab];

    }
    return self;
}

- (void)setValue:(id)value
{
    _dataDic = value;
    self.receiverLab.text = [NSString stringWithFormat:@"收件人: %@",_dataDic[@"shipTo"]];
    self.phonrNumberLab.text = _dataDic[@"phone"];
     NSString *fullName = [ _dataDic[@"address"] stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.addressLab.text = [NSString stringWithFormat:@"收货地址: %@",fullName];
    self.IdCardLab.text = [NSString stringWithFormat:@"身份证号: %@",[MyTool shadowIdCardString:_dataDic[@"idCard"]]];
    
    NSString *str = [NSString stringWithFormat:@"收货地址: %@",_dataDic[@"address"]];
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12] maxW:ScreenWidth- 31 - 28];
    self.addressLab.frame = CGRectMake(9+ 15+ 7, 37, ScreenWidth- 31 - 28, size.height);
    self.IdCardLab.frame = CGRectMake(9+ 15+ 7, self.addressLab.frame.origin.y + size.height+7, ScreenWidth- 31 - 28, 15);

}


@end
