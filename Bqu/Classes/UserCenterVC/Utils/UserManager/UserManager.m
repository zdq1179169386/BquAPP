//
//  UserManager.m
//  Bqu
//
//  Created by yingbo on 15/10/14.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//


#import "UserManager.h"

@implementation UserManager

//保存对象
+ (void)setMyObject:(id)object forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//获取对像
+ (id)getMyObjectForKey:(NSString *)key
{
    id object = nil;
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    object = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return object;
}

//删除对象
+ (void)removeMyObjectForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//判断是否登录
+ (BOOL)isLogin
{
    BOOL isLogin = ([[self getMyObjectForKey:accessTokenKey] length]>0);

    return isLogin;
}

//保存用户token
+ (void)saveToken:(NSString *)str;
{
    [self setMyObject:str forKey:accessTokenKey];
}

//删除token
+ (void)deleteToken
{
    [self setMyObject:nil forKey:accessTokenKey];
}



//保存用户信息
+ (void)saveUserInfoDict:(User *)user
{
     [self setMyObject:user forKey:userInforDictKey];
}

//删除用户信息
+ (void)deleteuserInfo
{
    [self setMyObject:nil forKey:userInforDictKey];

}


// 退出登录 删除token 删除用户信息
+ (void)userLoginOut
{
    [self deleteToken];
    [self delegateUserID];
    [self deleteuserInfo];
}

//判断是否已经设置安全密码
+ (BOOL) hasSafetyPassword;
{
    NSString *safatyPasswordStr = [self getMyObjectForKey:safatyPasswordKey];
    
    BOOL hasSafetyPassword = ([safatyPasswordStr length]>0);
    return hasSafetyPassword;
}

//保存用户ID
+ (void)saveUserID:(NSString *)str
{
    [self setMyObject:str forKey:userIDKey];
}

//删除用户ID
+ (void)delegateUserID
{
    [self setMyObject:nil forKey:userIDKey];
}
//保存用户名字
+ (void)saveUserName:(NSString *)str
{
    [self setMyObject:str forKey:userNameKey];
}
//删除用户名字
+ (void)deleteUserName
{
    [self setMyObject:nil forKey:userNameKey];
}

//保存用户是否是推广员（1:是 0：否）
+ (void)saveIsPromoter:(NSString *)str
{
    [self setMyObject:str forKey:isPromoter];
}

//删除是否是推广员
+ (void)deleteIsPromoter
{
    [self setMyObject:nil forKey:isPromoter];
}

@end
