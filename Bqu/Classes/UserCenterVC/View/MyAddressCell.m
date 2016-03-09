//
//  MyAddressCell.m
//  Bqu
//
//  Created by yingbo on 15/10/22.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "MyAddressCell.h"

@implementation MyAddressCell

- (void)awakeFromNib {
    // Initialization code
    self.topLine.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC" alpha:0.5];
    self.line2.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC" alpha:0.5];
    self.line_View.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD" alpha:0.5];
    self.default_Lab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.userName_Lab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.phoneNumber_Lab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.IdCard_Lab.textColor = [UIColor colorWithHexString:@"#333333"];
}

- (void)setModel:(Address_Model *)model
{
    _model = model;
    self.userName_Lab.text = _model.ShipTo;
    self.phoneNumber_Lab.text = _model.Phone;
    NSString *fullName = [ _model.RegionFullName stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.userAddress_Lab.text = [NSString stringWithFormat:@"%@%@", fullName,_model.Address];
    CGSize size = [self.userAddress_Lab.text sizeWithFont:[UIFont systemFontOfSize:12] maxW:ScreenWidth-25-39];
    self.userAddress_Lab.frame = CGRectMake(25, 65, ScreenWidth-25-39, size.height);
    self.IdCard_Lab.frame = CGRectMake(25, self.userAddress_Lab.frame.origin.y+self.userAddress_Lab.frame.size.height+4, ScreenWidth-25-30, 15);
  
    self.line2.center = CGPointMake(ScreenWidth/2, self.IdCard_Lab.frame.origin.y+self.IdCard_Lab.frame.size.height+12);

    self.IdCard_Lab.text = [NSString stringWithFormat:@"身份证号:%@", [MyTool shadowIdCardString:_model.IDCard]];
    if ([_model.IsDefault isEqualToString:@"1" ] )
    {
        [self.defaultImgBtn setImage:[UIImage imageNamed:@"ture"] forState:UIControlStateNormal];
    }
    else if([_model.IsDefault isEqualToString:@"0" ] )
    {
        [self.defaultImgBtn setImage:[UIImage imageNamed:@"addres"] forState:UIControlStateNormal];
        
    }

    [self.default_Button addTarget:self action:@selector(setDefaultButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteAddress_Button addTarget:self action:@selector(deleteAddressButtonClick:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)setDefaultButtonClick:(UIButton *)button
{       
    if ([self.delegate respondsToSelector:@selector(setDefaultAddress:)])
    {
        [self.delegate setDefaultAddress:button];
    }
}

- (void)deleteAddressButtonClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(deleteAddress:)])
    {
        [self.delegate deleteAddress:button];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
