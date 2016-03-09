//
//  ZLL.h
//  Bqu
//
//  Created by yb on 15/11/27.
//  Copyright © 2015年 yb. All rights reserved.
//  张伶俐

#ifndef ZLL_h
#define ZLL_h

//张伶俐
#import "UIButton+Bootstrap.h"         //自定义按钮样式
#import "UserManager.h"                //管理个人信息
#import "TipView.h"                    //自定义提示
#import "User.h"
#import "ZLLAutoCode.h"                 //随机验证码
#import "MyTool.h"                     //小工具
#import "HttpEngine.h"                  //数据请求


#define existMobileUrl @"/api/users/ExistsMobile"   //验证手机号是否存在
#define registrSendCodeUrl @"/api/users/SendCode"   //发送验证码
#define registrCheckCodeUrl @"/api/users/CheckCode" //检查验证码
#define userRegisterUrl @"/api/users/UserRegister"  //用户注册
#define userLoginUrl @"/API/Users/UserLogin"        //用户登录
#define isLoginUrl @"/API/Users/CheckLogin"         //用户是否登录
#define userInfoUrl @"/API/Users/GetUserInfo"       //用户信息
#define searchPasswordUrl @"/API/Users/GoBackPassWord"    //找回密码
#define setSafePasswordUrl @"/API/Users/SetTradePassWord"   //设置安全密码
#define UpdateUserPasswordUrl @"/API/Users/UpdateUserPassWord"  //修改密码
#define getMyCollectionUrl @"/API/Users/GetUserConcern"  //获取我的收藏
#define getMyOrderUrl @"/API/Order/GetUserOrders"  //获取我的订单
#define getOrderDetailUrl @"/API/Order/GetOrderDetail"  //获取我的订单详情
#define cancelPayUrl @"/API/Order/CancelOrder"  //取消支付
#define surePayUrl @"/API/Order/ConfirmOrder"   //确认支付
#define deleteOrder @"/API/Order/DeleteOrder"   //删除订单
#define deleteOrderReason @"/API/Order/GetOrderCancelReason"   //获取取消订单原因
#define getAddresslUrl @"/API/Users/GetUserAddress"  //获取我的地址
#define AddAddresslUrl @"/API/Users/AddAddress"  //获取我的地址
#define getMyOrderDetailUrl @"/API/Order/GetOrderDetail"  //获取我的订单详情
#define getAddresslUrl @"/API/Users/GetUserAddress"  //获取我的地址
#define AddAddresslUrl @"/API/Users/AddAddress"  //获取我的地址
#define setDefaultAddresslUrl @"/API/Users/SetDefaultAddress"  //设置为默认地址
#define deleteAddresslUrl @"/API/Users/DeleteAddress"  //删除地址
#define changeAddresslUrl @"/API/Users/UpdateAddress"  //修改地址
#define getRegionAddresslUrl @"/API/Users/GetAllRegion"  //获取省市级联数据
#define getOrderLogisticsInfolUrl @"/API/Order/GetOrderLogisticsInfo"  //获取订单物流信息
#define addEvaluatelUrl @"/API/Order/AddEvaluation"  //商品评价
#define getSetlUrl @"/api/home/AboutSys"  //设置

#define aboutlUrl @"/api/home/AboutSys/Detail"  //关于B区
#define getIntergrailUrl @"/API/Users/GetUserIntegral"  //获取积分
#define getCouponlUrl @"/API/Users/GetUserCoupon"  //获取优惠券
#define ExchangeCouponlUrl @"/API/Users/ExChangeUserCoupon"  //兑换优惠券
#define addFeedbacklUrl @"/api/order/refund/AddFeedback"  //添加意见反馈

#define questUrl @"/api/order/refund/AddFeedback"  //添加意见反馈常见问题
#define integralRuleUrl @"m/App/IntegralRule"  //积分规则
#define couiponRulelUrl @"m/App/CouponEmpty"  //优惠规则
#define getPromoterInfoUrl @"/API/ReferrerMember/GetReferrerInfo" //推广员个人信息
#define addPromoterInfoUrl @"/API/ReferrerMember/AddReferrerInfo" //申请成为推广员
#define getInvitedFriendsUrl @"/API/ReferrerMember/GetInviteFriends" //推广员邀请的好友
#define addAccount @"/API/ReferrerMember/AddAccountBank" //添加账户
#define deleteAccount @"/API/ReferrerMember/DelAccountBank" //删除账户
#define getPromoterDetailRecordUrl @"/API/ReferrerMember/GetReferrerRecord" //推广员明细



#endif /* ZLL_h */
