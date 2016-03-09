//
//  ReceivingInformationTableViewCell.m
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "ReceivingInformationTableViewCell.h"

@implementation ReceivingInformationTableViewCell

//@property (nonatomic)UILabel * name;
//@property (nonatomic)UILabel * nameLab; //收件人姓名
//@property (nonatomic)UILabel * phone;
//@property (nonatomic)UILabel * phoneNumLab;//收件人电话
//@property (nonatomic)UILabel * addressLab;//收件地址
//@property (nonatomic)UILabel * idLab;
//@property (nonatomic)UILabel * idNumLab;//收件人身份证号码

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
       // UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth , 73)];
        //头像设置
        _name = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 55, 14)];
        _name.textColor = [UIColor colorWithHexString:@"#333333"];
        _name.text = @"收货人:";
        _name.font = [UIFont systemFontOfSize:13];
        [self addSubview:_name];
        
        //名字设置
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(65, 15, 100, 14)];
        _nameLab.font = [UIFont systemFontOfSize:13];
        _nameLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _nameLab.text = @" ";
        [self addSubview:_nameLab];
        
        //电话设置
        _phoneNumLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-200, 15, 100, 14)];
        _phoneNumLab.font = [UIFont systemFontOfSize:13];
        _phoneNumLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _phoneNumLab.textAlignment = NSTextAlignmentRight;
        _phoneNumLab.text = @" ";
        [self addSubview:_phoneNumLab];
        
        
        //地址设置
        _addressLab = [[UILabel alloc] initWithFrame:CGRectMake(15 , 37, ScreenWidth-50 , 14)];
        _addressLab.font = [UIFont systemFontOfSize:13];
        _addressLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _addressLab.text = @"收货地址：";
        [self addSubview:_addressLab];
        
        //身份证设置
        _idLab = [[UILabel alloc] initWithFrame:CGRectMake(15 , 60, 55 , 14)];
        _idLab.font = [UIFont systemFontOfSize:13];
        _idLab.text = @"身份证：";
        _idLab.textColor = [UIColor colorWithHexString:@"#333333"];
        [self addSubview:_idLab];
        
        //身份证号码设置
        _idNumLab = [[UILabel alloc] initWithFrame:CGRectMake(65 , 60, 200 , 14)];
        _idNumLab.font = [UIFont systemFontOfSize:13];
        _idNumLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _idNumLab.text = @" ";
        [self addSubview:_idNumLab];
        
        [self addDefaul];
        

    }
    return self;
}

+(instancetype)receivingInformationTableViewCell:(UITableView*)tableView
{
    ReceivingInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Acell" ];
    if (cell == nil)
    {
        cell = [[ReceivingInformationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Acell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//设置lable的值
-(void)setValue:(AddressModel*)address
{
    if(address != nil && ![address.shipTo isKindOfClass:[NSNull class]] && ![address isKindOfClass:[NSNull class]])
    {
        _nameLab.text = address.shipTo;
        _phoneNumLab.text = address.phone;
        _addressLab.text = [NSString stringWithFormat:@"%@ %@",address.regionFullName,address.address];
        NSString *iDCard =address.iDCard;
        NSString * idNumStr = [NSString stringWithFormat:@"%@***********%@",[iDCard substringToIndex:3],[iDCard substringFromIndex:iDCard.length-4]];
        _idNumLab.text = idNumStr;
        NSLog(@"%@",address.isDefault);
        if (address.isDefault.intValue == 1)
        {
            _defaultAddressLab.hidden = NO;
        }else
        {
            _defaultAddressLab.hidden = YES;
        }
    }
}
-(void) addDefaul
{
    _defaultAddressLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-60, 15, 40, 14)];
    _defaultAddressLab.text = @"默认";
    _defaultAddressLab.textColor = [UIColor colorWithHexString:@"e8103c"];
    _defaultAddressLab.font = [UIFont systemFontOfSize:13];
    _defaultAddressLab.textAlignment = NSTextAlignmentCenter;
    _defaultAddressLab.hidden = YES;
    [self addSubview:_defaultAddressLab];
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
