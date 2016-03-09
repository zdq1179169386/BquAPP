//
//  AddressModel.m
//  Bqu
//
//  Created by yb on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

+(AddressModel *)addressModelWithDict:(NSDictionary*)dic
{
    
    AddressModel *addMd = [[AddressModel alloc] init ];
    if(![dic isKindOfClass:[NSNull class]])
    {
        addMd.Id = dic[@"AddressId"] ;
        addMd.userId = dic[@"UserId"] ;
        addMd.regionId = dic[@"RegionId"] ;
        addMd.shipTo = dic[@"ShipTo"];
        addMd.address = dic[@"Address"];
        addMd.phone = dic[@"Phone"];
        addMd.isDefault = dic[@"IsDefault"] ;
        addMd.iDCard = dic[@"IDCard"];
        addMd.regionFullName = dic[@"RegionFullName"];
        addMd.regionPath = dic[@"RegionPath"];
    }
    return addMd;
}

+(AddressModel *)addressModelWithAlladdressDict:(NSDictionary*)dic
{
    
    AddressModel *addMd = [[AddressModel alloc] init ];
    if(![dic isKindOfClass:[NSNull class]])
    {
        addMd.Id = dic[@"Id"] ;
        addMd.userId = dic[@"UserId"] ;
        addMd.regionId = dic[@"RegionId"] ;
        addMd.shipTo = dic[@"ShipTo"];
        addMd.address = dic[@"Address"];
        addMd.phone = dic[@"Phone"];
        addMd.isDefault = dic[@"IsDefault"] ;
        addMd.iDCard = dic[@"IDCard"];
        addMd.regionFullName = dic[@"RegionFullName"];
        addMd.regionPath = dic[@"RegionIdPath"];
    }
    return addMd;
}


- (id)copyWithZone:(NSZone *)zone
{
    //实现自定义浅拷贝
    AddressModel *address=[[self class] allocWithZone:zone];
    address.Id = [_Id copy] ;
    address.userId = [_userId copy] ;
    address.regionId = [_regionId copy] ;
    address.shipTo = [_shipTo copy];
    address.address = [_address copy];
    address.phone = [_phone copy];
    address.isDefault = [_isDefault copy] ;
    address.iDCard = [_iDCard copy];
    address.regionFullName = [_regionFullName copy];
    address.regionPath = [_regionPath copy];
    return address;
}
@end
