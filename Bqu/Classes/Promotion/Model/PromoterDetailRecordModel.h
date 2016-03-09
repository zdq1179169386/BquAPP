//
//  PromoterDetailRecordModel.h
//  Bqu
//
//  Created by wyy on 15/12/11.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PromoterDetailRecordModel : NSObject

@property (nonatomic, copy) NSString *recordId;      //明细ID
@property (nonatomic, copy) NSString *mobile;       //联系电话
@property (nonatomic, copy) NSString *createDate;   //创建时间
@property (nonatomic, copy) NSString *price;        //金额
@property (nonatomic, copy) NSString *cardNo;       //银行卡
@property (nonatomic, copy) NSString *bankName;     //银行名称
@property (nonatomic, copy) NSString *statusName;   //状态名称
@property (nonatomic, copy) NSString *showName;     //显示名称
@property (nonatomic, copy) NSString *type;         //会员ID
@property (nonatomic, copy) NSString *status;       //会员ID

- (void)promoterDetailRecordModelFromDictionary:(NSDictionary *)dic;

@end
