//
//  ZXD.h
//  Bqu
//
//  Created by yb on 15/11/27.
//  Copyright © 2015年 yb. All rights reserved.
//  张晓东

#ifndef ZXD_h
#define ZXD_h

//张晓东
#define GetCartInfoURL @"/API/Cart/GetCartInfo"  //获取购物车信息
#define ClearCartInfoURL @"/API/Cart/ClearCartInfo"  //清除购物车失效商品信息
#define UpdateCartInfoURL @"/API/Cart/UpdateCartInfo"  //更新购物车信息
#define GetUserIntegralURL @"/API/Cart/GetUserIntegral"  //获取可用积分
#define GetUserCouponListURL @"//API/Cart/GetUserCouponList"  //获取可用优惠券
#define GetDefaultAddressInfoURL @"/API/Cart/GetDefaultAddressInfo"  //获取默认送货地址
#define CreateOrderURL @"/API/Cart/CreateOrder"  //提交订单
#define CartConfirmURL @"/API/Cart/CartConfirm"  //获取购物车商品结算信息
#define RemoveCartInfoURL @"/API/Cart/RemoveCartInfo" //清除购物车失效商品信息
#define GetCreateOrderMsgUrl @"/API/Cart/GetCreateOrderMsg" //获取用户选择了优惠劵和积分之后，税金，等变化
#define GetUserCartCount @"/API/Cart/GetUserCartCount"//获取购物车商品种类
#define CreateOrderFromSkuURL @"/API/Cart/CreateOrderFromSku" //立即购买提交订单




#endif /* ZXD_h */
