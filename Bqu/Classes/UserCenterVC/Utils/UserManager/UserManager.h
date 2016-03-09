//
//  UserManager.h
//  Bqu
//
//  Created by yingbo on 15/10/14.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//



#define accessTokenKey @"accesstoken"
#define userInforDictKey  @"userinfoDict"
#define safatyPasswordKey @"safetyPassword"
#define userIDKey @"MemberID"
#define userNameKey @"MemberName"
#define isPromoter @"IsReferrer"

#import <Foundation/Foundation.h>
#import "User.h"


@interface UserManager : NSObject

@property  (nonatomic,assign) BOOL isLogin;

// 添加
+ (void)setMyObject:(id)object forKey:(NSString *)key;

// 读取
+ (id)getMyObjectForKey:(NSString *)key;

// 删除
+ (void)removeMyObjectForKey:(NSString *)key;



//判断是否登录
+ (BOOL)isLogin;


//保存token
+ (void)saveToken:(NSString *)str;

//删除token
+ (void)deleteToken;

//保存用户信息
+ (void)saveUserInfoDict:(User *)user;

//删除用户信息
+ (void)deleteuserInfo;

// 退出登录 删除token 删除用户信息
+ (void)userLoginOut;


//判断是否已经设置安全密码
+ (BOOL) hasSafetyPassword;

//保存用户ID
+ (void)saveUserID:(NSString *)str;

+ (void)delegateUserID;

//保存用户名字
+ (void)saveUserName:(NSString *)str;
//删除用户名字
+ (void)deleteUserName;

//保存用户是否是推广员（1:是 0：否
+ (void)saveIsPromoter:(NSString *)str;

//删除是否是推广员
+ (void)deleteIsPromoter;

@end
