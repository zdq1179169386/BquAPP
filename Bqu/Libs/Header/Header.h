//
//  Header.h
//  BquAPP
//
//  Created by yb on 15/10/14.
//  Copyright © 2015年 yb. A                                                                                                                                                        ll rights reserved.
//

#import "UIImageView+WebCache.h"
#import "ZDQ.h"
#import "ZXD.h"
#import "ZLL.h"
#import "BquAppBaseViewController.h"
//网络的链接失败的code
#define NetWorkingErrorCode 11111
//_____________________________________________________________________________________

//朱德强
//字体
//_________________________________________________________________________________________
#define _RELEASE 0
// 0 走下面，1走上面
#if _RELEASE // 处于开发阶段
//测试地址
#define TEST_URL @"http://43.247.89.26:10017"
#define bquUrl @"http://43.247.89.26:10017"        //b区总地址
#define WX_URL @"http://43.247.89.26:10017"
#else // 处于发布阶段
//正式地址
//#define TEST_URL @"http://appapi.bqu.com"
//#define bquUrl @"http://appapi.bqu.com"          //b区总地址
//#define WX_URL @"http://appapi.bqu.com"

#define TEST_URL @"http://appapi2.bqu.com"
#define bquUrl @"http://appapi2.bqu.com"          //b区总地址
#define WX_URL @"http://appapi2.bqu.com"
#endif

//__________________________________________________________________________________________

//AFN2.6版本的问题，必须导入这段代码
#ifndef TARGET_OS_IOS

#define TARGET_OS_IOS TARGET_OS_IPHONE

#endif

#ifndef TARGET_OS_WATCH

#define TARGET_OS_WATCH 0

#endif
//__________________________________________________________________________________________


#ifndef Header_h
#define Header_h

// 获取主屏幕的宽高
#define ScreenHeight    [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth     [[UIScreen mainScreen] bounds].size.width

//获取tabbar的高
#define kTabBarHeight  49.0f

//自定义颜色
#define RGB_A(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]



//barTintColor背景色; tintColor是barButtonItem颜色; titleTextAttributes是标题颜色
#define NAVI_BarTintColor      RGB_A(255,255,255)
#define NAVI_TintColor         RGB_A(1,11,11)
#define NAVI_TitleTextColor    RGB_A(31,11,11)





#define KNotificationRefreshPerson @"RefreshPerson"


// 判断iOS7

#define IOS7_OR_LATER   ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
// 判断iPhone5
#define ISiPhone5       CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size, CGSizeMake(640, 1136))
// 判断iPhone4
#define ISiPhone4       CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size, CGSizeMake(640, 9606))

#define kViewDictViewKey             @"kViewDictViewKey"
#define kViewDictHeightKey           @"kViewDictHeightKey"


//下一个页面返回按钮样式
#define CustomNavigationBackBarButttonStyle   UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];backItem.title = @"";self.navigationItem.backBarButtonItem = backItem





#endif /* Header_h */
