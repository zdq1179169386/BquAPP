//
//  ReceivingInformationTableViewCell.h
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//  确认订单上 收件人地址cell

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@interface ReceivingInformationTableViewCell : UITableViewCell
@property (nonatomic)UILabel * name;
@property (nonatomic)UILabel * nameLab; //收件人姓名
@property (nonatomic)UILabel * phoneNumLab;//收件人电话
@property (nonatomic)UILabel * addressLab;//收件地址
@property (nonatomic)UILabel * idLab;
@property (nonatomic)UILabel * idNumLab;//收件人身份证号码
@property (nonatomic)UILabel * defaultAddressLab;//默认地址

-(void)setValue:(AddressModel*)address;

+(instancetype)receivingInformationTableViewCell:(UITableView*)tableView;
@end
