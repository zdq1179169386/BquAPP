//
//  User.h
//  Bqu
//
//  Created by yingbo on 15/10/10.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//








/*我的订单各种key*/
#define K_id @"id"
#define K_orderStatus @"orderStatus"
#define K_status @"status"
#define K_shopname @"shopname"
#define K_orderTotalAmount @"orderTotalAmount"
#define K_productCount @"productCount"
#define K_commentCount @"commentCount"
#define K_orderDate @"orderDate"
#define K_payDate @"payDate"
#define K_tax @"tax"
#define K_discountAmount @"discountAmount"
#define K_integralDiscount @"integralDiscount"
#define K_tradeType @"tradeType"
#define K_itemInfo @"itemInfo"
#define K_CustomsStatus @"CustomsStatus"
#define K_CustomsDisStatus @"CustomsDisStatus"
#define K_noReceivingTimeout @"noReceivingTimeout"
#define K_unpaidTimeout @"unpaidTimeout"
#define K_OrderRefund @"OrderRefund"
#define K_OverSecondTime @"OverSecondTime"


#define K_detailaddress @"address"
#define K_detailfreight @"freight"
#define K_detailidCard @"idCard"
#define K_detailphone @"phone"
#define K_detailproductTotalAmount @"productTotalAmount"
#define K_detailshipTo @"shipTo"



#define K_productId @"productId"
#define K_productName @"productName"
#define K_image @"image"
#define K_count @"count"
#define K_price @"price"
#define K_ID @"id"



#define K_addressId @"Id"
#define K_UserId @"UserId"
#define K_RegionId @"RegionId"
#define K_ShipTo @"ShipTo"
#define K_Address @"Address"
#define K_Phone @"Phone"
#define K_IsDefault @"IsDefault"
#define K_IDCard @"IDCard"
#define K_RegionIdPath @"RegionIdPath"
#define K_RegionFullName @"RegionFullName"

#define K_CityId @"Id"
#define K_CityName @"Name"
#define K_CityCity @"City"

#define K_ContryId @"Id"
#define K_ContryName @"Name"
#define K_ContryContry @"County"


#define K_RegionID @"Id"
#define K_RegionName @"Name"


#define K_IntegralUserId @"UserId"
#define K_IntegralUserName @"UserName"
#define K_IntegralTypeId @"TypeId"
#define K_IntegralTypeName @"TypeName"
#define K_IntegralIntegral @"Integral"
#define K_IntegralDate @"Date"
#define K_IntegralReMark @"ReMark"


#define K_CouponId @"Id"
#define K_CouponUserId @"UserId"
#define K_CouponStartTime @"StartTime"
#define K_CouponEndTime @"EndTime"
#define K_CouponPrice @"Price"
#define K_CouponOrderAmount @"OrderAmount"
#define K_CouponShopId @"ShopId"
#define K_CouponShopName @"ShopName"


#import <Foundation/Foundation.h>



#pragma mark
//个人信息
@interface User : NSObject
@property (nonatomic,strong) NSString *userID;/*用户menberid*/
@property (nonatomic,strong) NSString *userName;/*用户姓名*/
@property (nonatomic,strong) NSString *userNickName;/*用户昵称*/
@property (nonatomic,strong) NSString *userEmail;/*用户邮箱*/
@property (nonatomic,strong) NSString *userSex;/*用户性别*/
@property (nonatomic,strong) NSString *userBirth;/*用户生日*/
@property (nonatomic,strong) NSString *userAddress;/*用户地址*/
@property (nonatomic,strong) NSString *userRegionId;/*用户地址id*/
@property (nonatomic,strong) NSString *userRealName;/*用户真实姓名*/
@property (nonatomic,strong) NSString *userPhone;/*用户电话*/
@property (nonatomic,strong) NSString *userPhoto;/*用户头像*/
@property (nonatomic,strong) NSString *userIDCard;/*用户身份证*/
@property (nonatomic,strong) NSString *userDistributorId;/*分销商id*/
@property (nonatomic,strong) NSString *userReferrerID;/*推广员id*/
@property (nonatomic,strong) NSString *userIntegral;/*积分*/
@property (nonatomic,strong) NSString *userCouponCount;/*优惠券数量*/
@property (nonatomic,strong) NSString *TradePassword;/*安全密码 0未设置 1 已设置*/
@property (nonatomic,strong) NSString *WaitPayOrder;/*未付款订单 0不存在 1 已存在*/
+ (User *)parseUserInfoWithDictionary:(NSDictionary *)dict;
@end

#pragma mark
/*订单列表*/
@interface OrderList : NSObject
@property (nonatomic,strong) NSString *CustomsStatus;   /*订单海关状态*/
@property (nonatomic,strong) NSString *CustomsDisStatus;/*订单海关货物状态*/
@property (nonatomic,strong) NSString *OverSecondTime;  /*剩余时间 秒*/
@property (nonatomic,strong) NSString *commentCount;    /*评论数量 0 未评论 非零评论*/
@property (nonatomic,strong) NSString *orderId;              /*订单id*/
@property (nonatomic,strong) NSString *noReceivingTimeout;/*确认收货剩余时间*/
@property (nonatomic,strong) NSString *orderDate;       /*下单时间*/
@property (nonatomic,strong) NSString *orderStatus;     /*订单状态*/
@property (nonatomic,strong) NSString *orderTotalAmount;/*订单实际付款*/
@property (nonatomic,strong) NSString *payDate;         /*支付日期 为空表示未支付*/
@property (nonatomic,strong) NSString *productCount;    /*商品种数*/
@property (nonatomic,strong) NSString *shopname;        /*店铺名称*/
@property (nonatomic,strong) NSString *status;          /*订单状态 文字*/
@property (nonatomic,strong) NSString *unpaidTimeout;   /*未付款剩余时间*/
@property (nonatomic,strong) NSDictionary *refundDic;   /*未付款剩余时间*/
@property (nonatomic,strong) NSMutableArray *itemInfoArray;   /*未付款剩余时间*/
+ (OrderList *)parseOrderListWithDictionary:(NSDictionary *)dict;
@end

/*订单列表单个订单内单种商品*/
@interface OrderItem : NSObject
@property (nonatomic,strong) NSString *count;   /*商品件数*/
@property (nonatomic,strong) NSString *Id;      /*商品主键id*/
@property (nonatomic,strong) NSString *image;   /*商品图片*/
@property (nonatomic,strong) NSString *price;    /*商品价格*/
@property (nonatomic,strong) NSString *productId;/*商品id*/
@property (nonatomic,strong) NSString *productName; /*商品名称*/
+ (OrderItem *)parseOrderItemWithDictionary:(NSDictionary *)dict;
@end

/*订单详情单种商品*/
@interface OrderDetailItem : NSObject
@property (nonatomic,strong) NSString *allowRefundDate;   /*商品件数*/
@property (nonatomic,strong) NSString *allowRefundTimes;      /*商品主键id*/
@property (nonatomic,strong) NSString *count;   /*商品图片*/
@property (nonatomic,strong) NSString *Id;    /*商品价格*/
@property (nonatomic,strong) NSString *image;/*商品id*/
@property (nonatomic,strong) NSString *price; /*商品名称*/
@property (nonatomic,strong) NSString *productId;    /*商品价格*/
@property (nonatomic,strong) NSString *productName;/*商品id*/
@property (nonatomic,strong) NSString *refundId; /*商品名称*/
@property (nonatomic,strong) NSString *taxrate; /*商品名称*/
+ (OrderDetailItem *)parseOrderDetailItemWithDictionary:(NSDictionary *)dict;
@end


#pragma mark
//我的收藏列表
@interface MyCollection_Model : NSObject
@property (nonatomic,strong) NSString *ProductID;
@property (nonatomic,strong) NSString *ProductName;
@property (nonatomic,strong) NSString *ProductImg;
@property (nonatomic,strong) NSString *MinSalePrice;
@property (nonatomic,strong) NSString *MarketPrice;
@property (nonatomic,strong) NSString *ConcernCount;
+ (MyCollection_Model *)parseUserInfoWithDictionary:(NSDictionary *)dict;
@end

#pragma mark

@interface MyOrder_Model : NSObject
//我的订单
@property (nonatomic,strong) NSString *Id;
@property (nonatomic,strong) NSString *orderStatus;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *shopname;
@property (nonatomic,strong) NSString *orderTotalAmount;
@property (nonatomic,strong) NSString *productCount;
@property (nonatomic,strong) NSString *commentCount;
@property (nonatomic,strong) NSString *orderDate;
@property (nonatomic,strong) NSString *payDate;
@property (nonatomic,strong) NSString *tax;
@property (nonatomic,strong) NSString *discountAmount;
@property (nonatomic,strong) NSString *integralDiscount;
@property (nonatomic,strong) NSString *tradeType;
@property (nonatomic,strong) NSMutableArray *itemInfoArray;
@property (nonatomic,strong) NSString *CustomsStatus;
@property (nonatomic,strong) NSString *CustomsDisStatus;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *freight;
@property (nonatomic,strong) NSString *idCard;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *productTotalAmount;
@property (nonatomic,strong) NSString *shipTo;
@property (nonatomic,strong) NSString *noReceivingTimeout;
@property (nonatomic,strong) NSString *unpaidTimeout;
@property (nonatomic,strong) NSDictionary  *OrderRefund;
@property (nonatomic,strong) NSString  *OverSecondTime;
@property (nonatomic,strong) NSString  *RecycleBin;

+ (MyOrder_Model *)parseAllDataWithDictionary:(NSDictionary *)dict;
@end


//我的订单每个元素
@interface MyOrderItems_Model : NSObject
@property (nonatomic,strong) NSString *productId;/*商品id*/
@property (nonatomic,strong) NSString *productName;/*商品名称*/
@property (nonatomic,strong) NSString *image;/*商品图片*/
@property (nonatomic,strong) NSString *count;/*商品数量*/
@property (nonatomic,strong) NSString *price;/*商品价格*/
@property (nonatomic,strong) NSString *ID;/*商品主键id*/
+ (MyOrderItems_Model *)parseDataWithDictionary:(NSDictionary *)dict;
@end



//我的地址
@interface Address_Model : NSObject
@property (nonatomic,strong) NSString *addressId;
@property (nonatomic,strong) NSString *UserId;
@property (nonatomic,strong) NSString *RegionId;
@property (nonatomic,strong) NSString *ShipTo;
@property (nonatomic,strong) NSString *Address;
@property (nonatomic,strong) NSString *Phone;
@property (nonatomic,strong) NSString *IsDefault;
@property (nonatomic,strong) NSString *IDCard;
@property (nonatomic,strong) NSString *RegionIdPath;
@property (nonatomic,strong) NSString *RegionFullName;
+ (Address_Model *)parseDataWithDictionary:(NSDictionary *)dict;
@end



//我的区
@interface Region_Model : NSObject
@property (nonatomic,strong) NSString *RegionID;
@property (nonatomic,strong) NSString *RegionName;
+ (Region_Model *)parseDataWithDictionary:(NSDictionary *)dict;
@end


//我的市
@interface Contry_Model : NSObject
@property (nonatomic,strong) NSString *CountryId;
@property (nonatomic,strong) NSString *CountryName;
@property (nonatomic,strong) NSMutableArray *ContryContray;
+ (Contry_Model *)parseDataWithDictionary:(NSDictionary *)dict;
@end

//我的省
@interface City_Model : NSObject
@property (nonatomic,strong) NSMutableArray *CityCity;
@property (nonatomic,strong) NSString *CityId;
@property (nonatomic,strong) NSString *CityName;
+ (City_Model *)parseDataWithDictionary:(NSDictionary *)dict;
@end


//我的积分
@interface Integral_Model : NSObject
@property (nonatomic,strong) NSString *UserId;
@property (nonatomic,strong) NSString *UserName;
@property (nonatomic,strong) NSString *TypeId;
@property (nonatomic,strong) NSString *TypeName;
@property (nonatomic,strong) NSString *Integral;
@property (nonatomic,strong) NSString *Date;
@property (nonatomic,strong) NSString *ReMark;
+ (Integral_Model *)parseDataWithDictionary:(NSDictionary *)dict;
@end


//我的优惠券
@interface Coupon_Model : NSObject
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *UserId;
@property (nonatomic,strong) NSString *StartTime;
@property (nonatomic,strong) NSString *EndTime;
@property (nonatomic,strong) NSString *Price;
@property (nonatomic,strong) NSString *OrderAmount;
@property (nonatomic,strong) NSString *ShopId;
@property (nonatomic,strong) NSString *ShopName;
+ (Coupon_Model *)parseDataWithDictionary:(NSDictionary *)dict;
@end


//评价
@interface CommetContent : NSObject
@property (nonatomic,copy) NSString * content;
@property (nonatomic,copy) NSString * starCount;
@property (nonatomic,copy) NSString * productId;
@end


//取消订单原因
@interface deleteTheOrderReason : NSObject
@property (nonatomic,copy) NSString * Id;
@property (nonatomic,copy) NSString * Name;
+ (deleteTheOrderReason *)parseDataWithDictionary:(NSDictionary *)dict;
@end


