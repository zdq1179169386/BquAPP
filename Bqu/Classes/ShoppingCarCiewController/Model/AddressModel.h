//
//  AddressModel.h
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
// 收货地址 模型

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject <NSCopying>
@property (nonatomic,copy)NSString* Id; //地址id
@property (nonatomic,copy)NSString* userId;//用户id
@property (nonatomic,copy)NSString* regionId;//区域id
@property (nonatomic,copy)NSString* shipTo;//收货人
@property (nonatomic,copy)NSString* address;//收货地址
@property (nonatomic,copy)NSString* phone;//收货人手机
@property (nonatomic,copy)NSString* isDefault;//是否默认
@property (nonatomic,copy)NSString* iDCard;//身份证 号
@property (nonatomic,copy)NSString* regionFullName;//区域完整名称
@property (nonatomic,copy)NSString* regionPath;//区域完整Id


+(AddressModel *)addressModelWithDict:(NSDictionary*)dic ;
+(AddressModel *)addressModelWithAlladdressDict:(NSDictionary*)dic;
@end
