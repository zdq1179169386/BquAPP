//
//  AfterSaleOrderModel.m
//  Bqu
//
//  Created by yb on 15/10/27.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "AfterSaleOrderModel.h"

@implementation AfterSaleOrderModel

+(NSDictionary*)objectClassInArray
{
    return @{@"RefundItem":@"RefundItemModel"};
}
-(NSString*)DealPrice
{
    if (_DealPrice.length>0) {
        _DealPrice = [NSString stringWithFormat:@"%.2f",_DealPrice.floatValue];
    }
    return _DealPrice;
}
-(NSString *)RefundPrice
{
    if (_RefundPrice.length>0) {
        _RefundPrice = [NSString stringWithFormat:@"%.2f",_RefundPrice.floatValue];
    }
    return _RefundPrice;
}
-(NSString*)SalePrice
{
    if (_SalePrice.length>0) {
        _SalePrice = [NSString stringWithFormat:@"%.2f",_SalePrice.floatValue];
    }
    return _SalePrice;
}
//-(NSString *)SellerAuditStatus
//{
//    NSLog(@"SellerAuditStatus%@",_SellerAuditStatus);
//    return _SellerAuditStatus;
//}
//-(NSString *)ManagerConfirmStatus
//{
//    NSLog(@"_ManagerConfirmStatus=%@",_ManagerConfirmStatus);
//    return _ManagerConfirmStatus;
//}
//-(NSString *)RefundMode
//{
//    NSLog(@"RefundMode===%@",_RefundMode);
//    return @"1";
////    return _RefundMode;
//}
//-(int)RefundMode
//{
//    
//    NSLog(@"RefundMode==%d",_RefundMode);
//    return _RefundMode;
//}
@end


@implementation RefundItemModel

-(NSString*)SalePrice
{
    if (_SalePrice.length>0) {
        _SalePrice = [NSString stringWithFormat:@"%.2f",_SalePrice.floatValue];
    }
    return _SalePrice;
}

@end

@implementation RegionModel

MJExtensionCodingImplementation

@end

@implementation CountryModel


+(NSDictionary *)objectClassInArray
{
    return @{@"County":@"RegionModel"};

}
MJExtensionCodingImplementation

@end

@implementation CityModel



+(NSDictionary *)objectClassInArray
{
    return @{@"City":@"CountryModel"};
}
MJExtensionCodingImplementation
@end