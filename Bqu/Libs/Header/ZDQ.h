//
//  ZDQ.h
//  Bqu
//
//  Created by yb on 15/11/27.
//  Copyright © 2015年 yb. All rights reserved.
// 朱德强

#ifndef ZDQ_h
#define ZDQ_h


// -------------
//  family:'Source Han Sans CN'
// 	font:'SourceHanSansCN-Heavy'
// 	font:'SourceHanSansCN-Light'
// 	font:'SourceHanSansCN-Normal'
//	font:'SourceHanSansCN-Medium'
//	font:'SourceHanSansCN-Bold'
// 	font:'SourceHanSansCN-ExtraLight'
//          SourceHanSansCN-Regular.otf
//family:'Hiragino Mincho ProN'
//	font:'HiraMinProN-W6'
//	font:'HiraMinProN-W3'

//我也不知道字体叫什么名字，自己看着用，这里只有6种，font文件下还有其他的，自己要用，自己加,数字和字母先不弄。
#define HeavyFONT @"SourceHanSansCN-Heavy"
//建议用LightFONT  NormalFONT  ExtraLightFONT
#define LightFONT @"SourceHanSansCN-Light"

#define NormalFONT @"SourceHanSansCN-Normal"

#define MediumFONT @"SourceHanSansCN-Medium"

#define BoldFONT  @"SourceHanSansCN-Bold"

#define ExtraLightFONT @"SourceHanSansCN-ExtraLight"

#define RegularFONT @"SourceHanSansCN-Regular"

#define W3_FONT @"HiraMinProN-W3"

#define W6_FONT @"HiraMinProN-W6"
//___________________________________________________________________________________________________________
// RGB颜色
#define HWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 随机色
#define HWRandomColor HWColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define FontWithSize(s) [UIFont fontWithName:@"HelveticaNeue-Light" size:s]

#define KEY @"ZD4417JEFFDDSCC50H3FAE3C787D0E23"
//#import "Masonry.h"
#import "MJExtension.h"
#import "UIColor+Hex.h"
#import "UIView+Extension.h"
#import "AFNetworking.h"
#import "NSString+MD5.h"
#import "HttpTool.h"
#import "NSString+Extension.h"
#import "MJExtension.h"
#import "KeyboardManager.h"
#import "MJExtension.h"
#import "ProgressHud.h"
#import "MJRefresh.h"
#import "DIYHeader.h"
#import "NetWorkView.h"
#import "DIYFooter.h"

//#import "SVProgressHUD.h"


// DEBUG控制台输出(若版本味debug版本打印，若版本为release版本不打印)
#ifdef DEBUG

#define SULOG(...) NSLog(__VA_ARGS__);
#define SULOG_METHOD NSLog(@"%s", __func__);// 打印方法名
#define SULOG_DEBUG(fmt, ...) do { \
NSString* file = [[NSString alloc] initWithFormat:@"%s", __FILE__]; \
NSLog((@"{%@(%d)%s-%@}: " fmt), [file lastPathComponent], __LINE__, __func__, [NSThread currentThread], ##__VA_ARGS__); \
} while(0);//ARC下使用，MRC下加入[file release];

#else

#define SULOG(...);
#define SULOG_METHOD;
#define SULOG_DEBUG(...);

#endif




// 扫一扫 规则
//商品详情
#define ProductDeatil @"product/detail"
#define ScanPrefix @"http://www.bqu.com"
#define DistributorIDKey @"did"
#define DistributorIDSaveTime @"DistributorIDSaveTime"
//
#define GetAccountBanks @"/API/ReferrerMember/GetAccountBanks"//账户管理
#define  GetWithdrawal  @"/API/ReferrerMember/GetWithdrawal"//提现
#define WithdrawalSuccess @"/API/ReferrerMember/WithdrawalSuccess"//提现详情
#define GetAppVersion @"/api/home/GetAppVersion"//获取系统版本号
#endif /* ZDQ_h */
