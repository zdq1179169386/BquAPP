//
//  AfterSaleOrderModel.h
//  Bqu
//
//  Created by yb on 15/10/27.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AfterSaleOrderModel : NSObject


/**售后单id*/
@property(nonatomic,copy)NSString * Id;

/**订单id*/
@property(nonatomic,copy)NSString * OrderId;


/**商品的主键ID*/
@property(nonatomic,copy)NSString * OrderItemId;


/**成交金额*/
@property(nonatomic,copy)NSString * DealPrice;

/**添加日期*/
@property(nonatomic,copy)NSString * InfoDate;


/**商品编号*/
@property(nonatomic,copy)NSString * ProductId;

/**商品名称*/
@property(nonatomic,copy)NSString * ProductName;

/**数组*/
@property(nonatomic,strong)NSArray * RefundItem;

/**售后单类型(1,订单退款;2,货品退款;3,退货退款;)*/
@property(nonatomic,assign)int  RefundMode;

/**退款金额*/
@property(nonatomic,copy)NSString * RefundPrice;

/**数量(订单退款为0,退货退款显示退货数量)*/
@property(nonatomic,copy)NSString * ReturnQuantity;

/**商家审核状态*/
@property(nonatomic,copy)NSString * SellerAuditStatus;


/**平台审核状态*/
@property(nonatomic,copy)NSString * ManagerConfirmStatus;


/**商品缩略图*/
@property(nonatomic,copy)NSString * ThumbnailsUrl;


/**销售价*/
@property(nonatomic,copy)NSString * SalePrice;


@end

@interface RefundItemModel : NSObject

/**订单商品编号*/
@property(nonatomic,copy)NSString * ItemId;

/**商品名称*/
@property(nonatomic,copy)NSString * ItemName;


/**商品数量*/
@property(nonatomic,copy)NSString * ItemQuantity;


/**缩略图*/
@property(nonatomic,copy)NSString * ItemImgUrl;

/**销售价*/
@property(nonatomic,copy)NSString * SalePrice;


//"ItemId": 3054,//订单商品编号
//"ItemName": "捆绑商品",//商品名称
//"ItemQuantity": 1,//数量
//"ItemImgUrl": "http://192.168.18.250:10000/Storage/Shop/1/Products/133/0cac676e-d2f1-4014-bd11-9b2874fe0000_100.jpg",//缩略图
//"SalePrice": "680.00"//销售价

@end

//DealPrice = "0.01";
//InfoDate = "2015-10-27 19:05:16";
//ManagerConfirmStatus = "\U5f85\U5e73\U53f0\U786e\U8ba4";
//OrderId = 2015102746146170;
//ProductId = 129;
//ProductName = "\U652f\U4ed8\U6d4b\U8bd5";
//RefundItem =             (
//                          {
//                              ItemId = 4771;
//                              ItemImgUrl = "http://img1.bqu.com/Storage/Shop/1/Products/129/a547073c-b6cd-4529-bea8-be5bd2a25d72_100.jpg";
//                              ItemName = "\U652f\U4ed8\U6d4b\U8bd5";
//                              ItemQuantity = 1;
//                              SalePrice = "0.01";
//                          }
//                          );
//RefundMode = 1;
//RefundPrice = "0.01";
//ReturnQuantity = 0;
//SellerAuditStatus = "\U5546\U5bb6\U62d2\U7edd";
//ThumbnailsUrl = "http://img1.bqu.com/Storage/Shop/1/Products/129/a547073c-b6cd-4529-bea8-be5bd2a25d72_100.jpg";



@interface RegionModel : NSObject
//我的区
@property (nonatomic,strong) NSString * Id;
@property (nonatomic,strong) NSString * Name;

@end


@interface CountryModel : NSObject
//我的市
@property (nonatomic,strong) NSString * Id;
@property (nonatomic,strong) NSString * Name;
@property (nonatomic,strong) NSMutableArray * County;


@end


@interface CityModel : NSObject
//我的省
@property (nonatomic,strong) NSMutableArray *City;
@property (nonatomic,strong) NSString * Id;
@property (nonatomic,strong) NSString * Name;

@end
