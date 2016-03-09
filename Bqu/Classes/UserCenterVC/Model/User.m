//
//  User.m
//  Bqu
//
//  Created by yingbo on 15/10/10.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import "User.h"

@implementation User

#pragma mark
/*个人信息解析*/
+ (User *)parseUserInfoWithDictionary:(NSDictionary *)dict
{
    User *user = [[User alloc] init];
            user.userID = [NSString stringWithFormat:@"%@",dict[@"Id"]];
            user.userName = dict[@"UserName"];
            user.userNickName = dict[@"Nick"];
            user.userEmail = dict[@"Email"];
            user.userSex = [NSString stringWithFormat:@"%@",dict[@"Sex"]];
            user.userBirth = [NSString stringWithFormat:@"%@",dict[@"Birth"]];
            user.userAddress = dict[@"Address"];
            user.userRegionId = [NSString stringWithFormat:@"%@",dict[@"RegionId"]];
            user.userRealName = dict[@"RealName"];
            user.userIDCard = [NSString stringWithFormat:@"%@",dict[@"IDCard"]];
            user.userPhone = dict[@"Phone"];
            user.userPhoto = dict[@"Photo"];
            user.userDistributorId = [NSString stringWithFormat:@"%@",dict[@"DistributorId"]];
            user.userReferrerID = [NSString stringWithFormat:@"%@",dict[@"ReferrerID"]];
            user.userIntegral = [NSString stringWithFormat:@"%@",dict[@"Integral"]];
            user.userCouponCount = [NSString stringWithFormat:@"%@",dict[@"CouponCount"]];
            user.TradePassword = [NSString stringWithFormat:@"%@",dict[@"TradePassword"]];
            user.WaitPayOrder = [NSString stringWithFormat:@"%@",dict[@"WaitPayOrder"]];
    return user;
}
@end


#pragma mark
/*我的订单列表*/
@implementation OrderList
+ (OrderList *)parseOrderListWithDictionary:(NSDictionary *)dict
{
    OrderList *order = [[OrderList alloc] init] ;
    order.CustomsStatus = [NSString stringWithFormat:@"%@", dict[@"CustomsStatus"]];
    order.CustomsDisStatus = [NSString stringWithFormat:@"%@", dict[@"CustomsDisStatus"]];
    order.OverSecondTime = [NSString stringWithFormat:@"%@", dict[@"OverSecondTime"]];
    order.commentCount = [NSString stringWithFormat:@"%@", dict[@"commentCount"]];
    order.orderId = [NSString stringWithFormat:@"%@", dict[@"id"]];
    order.noReceivingTimeout = [NSString stringWithFormat:@"%@", dict[@"noReceivingTimeout"]];
    order.orderDate = dict[@"orderDate"];
    order.orderStatus = [NSString stringWithFormat:@"%@", dict[@"orderStatus"]];
    order.orderTotalAmount = dict[@"orderTotalAmount"];
    order.payDate = dict[@"payDate"];
    order.productCount = [NSString stringWithFormat:@"%@", dict[@"productCount"]];
    order.shopname = dict[@"shopname"];
    order.status = dict[@"status"];
    order.unpaidTimeout = dict[@"unpaidTimeout"];
    /*是否申请退款*/
    order.refundDic = [NSDictionary dictionary];
    order.refundDic = dict[@"OrderRefund"];
    /*单种商品*/
    order.itemInfoArray = [NSMutableArray array];
    NSArray *dataArray = dict[@"itemInfo"];
    for (NSDictionary *dataDic in dataArray)
    {
        OrderItem *orderItem = [OrderItem parseOrderItemWithDictionary:dataDic];
        [order.itemInfoArray addObject:orderItem];
    }
    return order;
}
@end

/*我的订单列表每个订单单种shangp*/
@implementation OrderItem
+ (OrderItem *)parseOrderItemWithDictionary:(NSDictionary *)dict
{
    OrderItem *orderItem = [[OrderItem alloc] init] ;
    orderItem.Id = [NSString stringWithFormat:@"%@", dict[@"id"]];
    orderItem.count = [NSString stringWithFormat:@"%@", dict[@"count"]];
    orderItem.image = dict[@"image"];
    orderItem.price = [NSString stringWithFormat:@"%@", dict[@"price"]];
    orderItem.productId = [NSString stringWithFormat:@"%@", dict[@"productId"]];
    orderItem.productName = dict[@"productName"];
    return orderItem;
}
@end

/*我的订单列表每个订单单种shangp*/
@implementation OrderDetailItem
+ (OrderDetailItem *)parseOrderDetailItemWithDictionary:(NSDictionary *)dict
{
    OrderDetailItem *orderDetailItem = [[OrderDetailItem alloc] init] ;
    orderDetailItem.allowRefundDate = dict[@"allowRefundDate"];
    orderDetailItem.allowRefundTimes = [NSString stringWithFormat:@"%@", dict[@"allowRefundTimes"]];
    orderDetailItem.count = [NSString stringWithFormat:@"%@", dict[@"count"]];
    orderDetailItem.Id = [NSString stringWithFormat:@"%@", dict[@"id"]];
    orderDetailItem.image = dict[@"image"];
    orderDetailItem.price = dict[@"price"];
    orderDetailItem.productId = [NSString stringWithFormat:@"%@", dict[@"productId"]];
    orderDetailItem.productName = dict[@"productName"];
    orderDetailItem.refundId = dict[@"refundId"];
    orderDetailItem.taxrate = [NSString stringWithFormat:@"%@", dict[@"taxrate"]];
    return orderDetailItem;
}
@end

#pragma mark
/*我的收藏*/
@implementation MyCollection_Model
+ (MyCollection_Model *)parseUserInfoWithDictionary:(NSDictionary *)dict
{
    MyCollection_Model *collection_Model = [[MyCollection_Model alloc] init];
    collection_Model.ProductID = [NSString stringWithFormat:@"%@",dict[@"ProductId"]];
    collection_Model.ProductName = dict[@"ProductName"];
    collection_Model.ProductImg = dict[@"ProductImg"];
    collection_Model.MinSalePrice = [NSString stringWithFormat:@"%@",dict[@"MinSalePrice"]];
    collection_Model.MarketPrice = [NSString stringWithFormat:@"%@",dict[@"MarketPrice"]];
    collection_Model.ConcernCount = [NSString stringWithFormat:@"%@",dict[@"ConcernCount"]];
    return collection_Model;
}
@end




@implementation MyOrder_Model
+ (MyOrder_Model *)parseAllDataWithDictionary:(NSDictionary *)dict
{
    MyOrder_Model *myOrder_Model = [[MyOrder_Model alloc] init];
    
    myOrder_Model.Id = [NSString stringWithFormat:@"%@",dict[K_id]];
    myOrder_Model.orderStatus = [NSString stringWithFormat:@"%@",dict[K_orderStatus]];
    myOrder_Model.status = dict[K_status];
    myOrder_Model.shopname = dict[K_shopname];
    myOrder_Model.orderTotalAmount = dict[K_orderTotalAmount];
    myOrder_Model.productCount = [NSString stringWithFormat:@"%@",dict[K_productCount]];
    myOrder_Model.orderDate = dict[K_orderDate];
    myOrder_Model.payDate = dict[K_payDate];
    myOrder_Model.tradeType = [NSString stringWithFormat:@"%@", dict[K_tradeType]];
    myOrder_Model.CustomsStatus = dict[K_CustomsStatus];
    myOrder_Model.CustomsDisStatus = dict[K_CustomsDisStatus];
    myOrder_Model.itemInfoArray = [NSMutableArray array];
    myOrder_Model.noReceivingTimeout = [NSString stringWithFormat:@"%@",dict[K_noReceivingTimeout]];
    myOrder_Model.unpaidTimeout = [NSString stringWithFormat:@"%@",dict[K_unpaidTimeout]];
    myOrder_Model.OrderRefund = dict[K_OrderRefund];
    myOrder_Model.OverSecondTime = dict[K_OverSecondTime];
    myOrder_Model.commentCount = [NSString stringWithFormat:@"%@", dict[@"commentCount"]];
    myOrder_Model.RecycleBin = [NSString stringWithFormat:@"%@", dict[@"RecycleBin"]];

    NSArray * arary = dict[K_itemInfo];
    if (![arary isKindOfClass:[NSNull class]])
    {
        
        for (NSDictionary *dict in arary)
        {
            MyOrderItems_Model *myOrderItems_Model = [MyOrderItems_Model parseDataWithDictionary:dict];
            
            [ myOrder_Model.itemInfoArray addObject:myOrderItems_Model];
        }
    }
    
    return myOrder_Model;
}
-(NSString *)status
{
    NSLog(@"_status=%@",_status);
    return  _status;
}
-(NSString *)OverSecondTime
{
    NSLog(@"_OverSecondTime=%@",_OverSecondTime);
    return _OverSecondTime;
}
-(NSString *)orderStatus
{
    NSLog(@"_orderStatus=%@",_orderStatus);
    return _orderStatus;
}
@end


@implementation MyOrderItems_Model

+ (MyOrderItems_Model *)parseDataWithDictionary:(NSDictionary *)dict;
{
    MyOrderItems_Model *myOrderItems = [[MyOrderItems_Model alloc] init];
    myOrderItems.productId = [NSString stringWithFormat:@"%@",dict[K_productId]];
    myOrderItems.productName = dict[K_productName];
    myOrderItems.image = dict[K_image];
    myOrderItems.count = [NSString stringWithFormat:@"%@",dict[K_count]];
    myOrderItems.price = [NSString stringWithFormat:@"%@", dict[K_price]];
    myOrderItems.ID = [NSString stringWithFormat:@"%@", dict[K_ID]];
    
    
    return myOrderItems;
}

@end

@implementation Address_Model

+ (Address_Model *)parseDataWithDictionary:(NSDictionary *)dict;
{
    Address_Model *address_Model = [[Address_Model alloc] init];
    address_Model.addressId = [NSString stringWithFormat:@"%@",dict[K_addressId]];
    address_Model.UserId = [NSString stringWithFormat:@"%@",dict[K_UserId]];
    address_Model.RegionId = [NSString stringWithFormat:@"%@",dict[K_RegionId]];
    address_Model.ShipTo = dict[K_ShipTo];
    address_Model.Address = dict[K_Address];
    address_Model.Phone = dict[K_Phone];
    address_Model.IsDefault = [NSString stringWithFormat:@"%@", dict[K_IsDefault]];
    address_Model.IDCard = dict[K_IDCard];
    address_Model.RegionIdPath = dict[K_RegionIdPath];
    address_Model.RegionFullName = dict[K_RegionFullName];
    
    return address_Model;
}


@end




@implementation Region_Model


+ (Region_Model *)parseDataWithDictionary:(NSDictionary *)dict
{
    Region_Model *region_Model = [[Region_Model alloc] init];
    
    region_Model.RegionID = [NSString stringWithFormat:@"%@",dict[K_RegionID]];
    region_Model.RegionName = dict[K_RegionName];
    
    return region_Model;
}
@end


@implementation Contry_Model


+ (Contry_Model *)parseDataWithDictionary:(NSDictionary *)dict
{
    Contry_Model *contry_Model = [[Contry_Model alloc] init];
    contry_Model.CountryId = [NSString stringWithFormat:@"%@",dict[K_ContryId]];
    contry_Model.CountryName = dict[K_ContryName];
    contry_Model.ContryContray = [NSMutableArray array];
    
    NSArray * arary = dict[K_ContryContry];
    
    if (![arary isKindOfClass:[NSNull class]])
    {
        for (NSDictionary *dict in arary)
        {
            Region_Model *region_Model = [Region_Model parseDataWithDictionary:dict];
            [contry_Model.ContryContray addObject:region_Model];
        }

    }
     
    return contry_Model;
}
@end

@implementation City_Model


+ (City_Model *)parseDataWithDictionary:(NSDictionary *)dict
{
    City_Model *city_Model = [[City_Model alloc] init];
    city_Model.CityCity = [NSMutableArray array];
    
    
    NSArray * arary = dict[K_CityCity];

    if (![arary isKindOfClass:[NSNull class]])
    {
       
        for (NSDictionary *dict in arary)
        {
            
            Contry_Model *contry_Model = [Contry_Model parseDataWithDictionary:dict];
            [city_Model.CityCity addObject:contry_Model];
            
        }
    }
    else
    {
        NSLog(@"这是一个测试语句%s",__FUNCTION__);
    }
    
    
    city_Model.CityId = [NSString stringWithFormat:@"%@",dict[K_CityId]];
    city_Model.CityName = dict[K_CityName];

    
    
    return city_Model;
}


@end

@implementation Integral_Model

+ (Integral_Model *)parseDataWithDictionary:(NSDictionary *)dict;
{
    Integral_Model *integral = [[Integral_Model alloc] init];
    integral.UserId = [NSString stringWithFormat:@"%@",dict[K_IntegralUserId]];
    integral.UserName = dict[K_IntegralUserName];
    integral.TypeId = [NSString stringWithFormat:@"%@",dict[K_IntegralTypeId]];
    integral.TypeName = dict[K_IntegralTypeName];
    integral.Integral = [NSString stringWithFormat:@"%@",dict[K_IntegralIntegral]];
    integral.Date = dict[K_IntegralDate];
    NSString *str =  dict[K_IntegralReMark];
    if (![str isKindOfClass:[NSNull class]])
    {
        integral.ReMark = dict[K_IntegralReMark];
    }
    else
    {
        integral.ReMark = @"";
    }
    
    return integral;
}


@end



@implementation Coupon_Model


+ (Coupon_Model *)parseDataWithDictionary:(NSDictionary *)dict;
{
    Coupon_Model *coupon = [[Coupon_Model alloc] init];
    coupon.ID = [NSString stringWithFormat:@"%@",dict[@"Id"]];
    coupon.UserId = [NSString stringWithFormat:@"%@",dict[@"UserId"]];
    coupon.StartTime = dict[@"StartTime"];
    coupon.EndTime = dict[@"EndTime"];
    coupon.Price = [NSString stringWithFormat:@"%@",dict[@"Price"]];
    coupon.OrderAmount = [NSString stringWithFormat:@"%@",dict[@"OrderAmount"]];
    coupon.ShopId = [NSString stringWithFormat:@"%@",dict[@"ShopId"]];
    coupon.ShopName = dict[@"ShopName"];
    
    return coupon;
}

@end

@implementation deleteTheOrderReason
+ (deleteTheOrderReason *)parseDataWithDictionary:(NSDictionary *)dict
{
    deleteTheOrderReason *reason = [[deleteTheOrderReason alloc] init];
    reason.Id = dict[@"id"];
    reason.Name = dict[@"Name"];
    return reason;
}

@end



