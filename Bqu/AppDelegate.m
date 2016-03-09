//
//  AppDelegate.m
//  Bqu
//
//  Created by yb on 15/10/14.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "AppDelegate.h"
#import "Header.h"
#import "ClassifyViewController.h"
#import "HomeViewController.h"
#import "ShoppingCarViewController.h"
#import "UserCenterViewController.h"
#import "NewfeatureController.h"
#import "SearchViewController.h"
#import "SearchController.h"

#import <AlipaySDK/AlipaySDK.h>
#import "MobClick.h"
#import "PromotionViewController.h"

//________________________________________ShareSDK________________________________________
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"



@interface AppDelegate ()<NewfeatureControllerDelagate,UINavigationControllerDelegate>
/**<#property#>*/
@property (nonatomic,strong)UITabBarController * tabrbarController;


@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
//    [self logFont];
  
    //版本新特性
    NSString * key = @"CFBundleShortVersionString";
    NSString * lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSString * currentVersion = [[NSBundle mainBundle].infoDictionary objectForKey:key];
   
    NSLog(@"%@,%@",lastVersion,currentVersion);

    if ([currentVersion isEqualToString:lastVersion]) {
        // 生成界面
        [self setTabBar];
    }else
    {
        //新特性界面
        NewfeatureController * newVC = [[NewfeatureController alloc] init];
        newVC.delegate = self;
        self.window.rootViewController = newVC;
        //将当前的版本号存进沙盒
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
//    NSUserDefaults *myUserDefaults = [NSUserDefaults standardUserDefaults];
//    if([[myUserDefaults objectForKey:@"isfirst1"] intValue] == 0)
//    {
//        [self showIntroPages];
//    }
//    [self setTabBar];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //友盟统计
    [MobClick startWithAppkey:@"566142a2e0f55a96a40027bd" reportPolicy:BATCH channelId:nil];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    //ShareSDK
    [self setupShareSDK];
    //获取版本号
    [self getAppVersion];
    return YES;
}
//获取版本号
-(void)getAppVersion
{
    
    NSString * key = @"CFBundleShortVersionString";
    NSString * currentVersion = [[NSBundle mainBundle].infoDictionary objectForKey:key];
    
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",TEST_URL,GetAppVersion];
    NSDictionary * dict = @{@"AppType":@"1"};
    NSMutableDictionary * mDict = [HttpTool getDicToRequest:dict];
    [HttpTool post:urlStr params:mDict success:^(id json) {
       
        NSLog(@"%@",json[@"data"]);
        NSString * resultCode = json[@"resultCode"];
        if (resultCode.intValue == 0) {
            NSDictionary * dict = json[@"data"];
            NSString * version = dict[@"V"];
            if (![version isKindOfClass:[NSNull class]]) {
                if (version.floatValue > currentVersion.floatValue) {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"跟新提示" message:@"B区目前有新版本发布，请跟新" delegate:self cancelButtonTitle:nil otherButtonTitles:@" 确定", nil];
                    [alert show];
                }
            }
            
        }else
        {
            NSLog(@"目前已是最新版本");
        }
        
        
    } failure:^(NSError *error) {
        
        
    }];
}
#pragma mark --
-(void)setupShareSDK
{
    [ShareSDK registerApp:@"d1f39ad0ed5c"
     
          activePlatforms:@[
//                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 //                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                 
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
//             case SSDKPlatformTypeSinaWeibo:
//                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
//             case SSDKPlatformTypeSinaWeibo:
//                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                 [appInfo SSDKSetupSinaWeiboByAppKey:@"1294648796"
//                                           appSecret:@"e34cceb7dcbff59d864c32fdb1cf5ae9"
//                                         redirectUri:@"http://www.bqu.com"
//                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxb4ba26da97516ccf"
                                       appSecret:@"ad7630a18fc4f67927e68f7979a2e7e4"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105009792"
                                      appKey:@"vYETHnPaDk2J03dR"
                                    authType:SSDKAuthTypeBoth];
             default:
                 break;
         }
     }];
    //(注意：每一个case对应一个break不要忘记填写，不然很可能有不必要的错误，新浪微博的外部库如果不要客户端分享或者不需要加关注微博的功能可以不添加，否则要添加，QQ，微信，google＋这些外部库文件必须要加)
}
-(void)logFont
{
    //family:'Source Han Sans CN'
    //    2015-11-05 21:04:00.112 Bqu[585:60b] 	font:'SourceHanSansCN-ExtraLight'
    for(NSString *fontfamilyname in [UIFont familyNames])
    {
        NSLog(@"family:'%@'",fontfamilyname);
        for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
        {
            NSLog(@"\tfont:'%@'",fontName);
        }
        NSLog(@"-------------");
    }

}
-(void)startClickDelegate:(NewfeatureController *)newFeature withBtn:(UIButton *)startBtn
{
    [self setTabBar];
}
- (void)setTabBar
{
    //hom页面
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.bounds = CGRectMake(0, 0, 75, 30);
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.center = CGPointMake(imageView.frame.size.width/2.0, 15);
    bgImageView.bounds = CGRectMake(0, 0, 60, 24);
    bgImageView.image = [UIImage imageNamed:@"1012app首页-切图@2x_08"];
    [imageView addSubview:bgImageView];
    
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    UINavigationController *homeNC = [[UINavigationController alloc] initWithRootViewController:homeVC];
    [homeNC.navigationBar setTintColor:[UIColor redColor]];
    homeVC.navigationItem.titleView = imageView;
    homeNC.tabBarItem.title = @"首页";
    [homeNC.navigationBar setTintColor:[UIColor redColor]];
    homeNC.tabBarItem.image = [[UIImage imageNamed:@"Tabbar_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeNC.tabBarItem.selectedImage = [[UIImage imageNamed:@"Tabbar_home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    PromotionViewController *promotionVC = [[PromotionViewController alloc] init];
    UINavigationController *promotionNC = [[UINavigationController alloc] initWithRootViewController:promotionVC];
    promotionVC.tabBarItem.title = @"推广";
    promotionVC.tabBarItem.image = [[UIImage imageNamed:@"promotion_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    promotionVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"promotion_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    
    ClassifyViewController *classifyVC = [[ClassifyViewController alloc] init];
    UINavigationController *classifyNC = [[UINavigationController alloc] initWithRootViewController:classifyVC];
    classifyNC.tabBarItem.title = @"分类";
    classifyNC.tabBarItem.image = [[UIImage imageNamed:@"Tabbar_classify"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    classifyNC.tabBarItem.selectedImage = [[UIImage imageNamed:@"Tabbar_classify_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
   ShoppingCarViewController *shoppingCarVC = [[ShoppingCarViewController alloc] init];
    UINavigationController *shoppingCarNC = [[UINavigationController alloc] initWithRootViewController:shoppingCarVC];
    shoppingCarNC.tabBarItem.title = @"购物车";
    shoppingCarNC.tabBarItem.image = [[UIImage imageNamed:@"Tabbar_shoppingcar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    shoppingCarNC.tabBarItem.selectedImage = [[UIImage imageNamed:@"Tabbar_shoppingcar_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UserCenterViewController *mineVC = [[UserCenterViewController alloc] init];
    UINavigationController *mineNC = [[UINavigationController alloc] initWithRootViewController:mineVC];
    mineNC.tabBarItem.title = @"我";
    mineNC.tabBarItem.image = [[UIImage imageNamed:@"Tabbar_userCenter"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineNC.tabBarItem.selectedImage = [[UIImage imageNamed:@"Tabbar_userCenter_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIColor * color = [UIColor colorWithHexString:@"e8103c"];
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      color, NSForegroundColorAttributeName,
      [UIFont fontWithName:@"ProximaNova-Semibold" size:0.0], NSFontAttributeName,
      nil]forState:UIControlStateSelected];
    
    UITabBarController *tabBar = [[UITabBarController alloc] init];
    tabBar.viewControllers = @[homeNC,promotionNC,classifyNC,shoppingCarNC,mineNC];
    tabBar.selectedIndex = 0;
    tabBar.delegate = self;
    self.window.rootViewController = tabBar;
    self.tabrbarController = tabBar;
    
    //判断是否登录，改变购物车，按钮的数量
    [self changeShoppingCar];
    
    //设置键盘
    [self setUpKeyBoard];
}
-(void)setUpKeyBoard
{
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    [manager disableInViewControllerClass:[SearchViewController class]];
    [manager disableInViewControllerClass:[SearchController class]];
    
}
#pragma mark -- 判断是否登录，改变购物车，按钮的数量
-(void)changeShoppingCar
{
    [HttpTool testUserIsOnlineSuccess:^(BOOL msg) {
        if (msg == YES) {
            //用户登录
            [self requestForShoppingCart];
        }else
        {
            //没有登录
            
        }
    }];
}
#pragma mark -- 获取购物车物品数量
-(void)requestForShoppingCart
{
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/API/Cart/GetCartInfo",TEST_URL];
    NSString * memberID = [UserManager getMyObjectForKey:userIDKey];
    NSString * token = [UserManager getMyObjectForKey:accessTokenKey];
    
    //    NSLog(@"%@,%@",memberID,token);
    
    NSMutableDictionary * signDict = [NSMutableDictionary dictionary];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    NSString * sign = nil;
    if (!memberID || !token) {
        
        return;
        
    }else if (memberID && token)
    {
        [signDict setObject:memberID forKey:@"MemberID"];
        [signDict setObject:token forKey:@"token"];
        
        sign  = [HttpTool returnForSign:signDict];
        dict[@"MemberID"] = memberID;
        dict[@"token"] = token;
        dict[@"sign"] = sign;
        [HttpTool post:urlStr params:dict success:^(id json) {
            //                NSLog(@"%@",json);
            
            NSString * resultCode = json[@"resultCode"];
            if (resultCode.intValue == 0) {
                NSInteger arrarCount = 0;
                NSMutableArray * dataArray = [[NSMutableArray alloc] initWithCapacity:0];
                dataArray = json[@"data"];
                if (!dataArray) {
                    return ;
                }
                if(![dataArray isKindOfClass:[NSNull class]])
                {
                    if (dataArray.count==0) {
//                        blockSelf.buttomBar.shoppingCart.number.text = @"0";
                        return ;
                    }
                    for (int i=0; i<dataArray.count; i++) {
                        NSArray * subArray = dataArray[i];
                        arrarCount = arrarCount +subArray.count;
                    }
                    //改变购物车按钮的数量
                    NSString * number = [NSString stringWithFormat:@"%ld",arrarCount];
                    //TODO:－－－－－改变tabbar的数量
                    UITabBarItem * item = [self.tabrbarController.tabBar.items objectAtIndex:3];
                    [item setBadgeValue:number];
                    
                }
                //
                
            }
        } failure:^(NSError *error) {
          
        }];
    }
    
}
#pragma mark -------tabbarController Delegate--------
//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
//    [((UINavigationController *)viewController) popToRootViewControllerAnimated:NO];
//}

#pragma mark - Funcs

-(void)showIntroPages
{
    NSMutableArray *pagesArr = [[NSMutableArray alloc] init];
    NSArray *imgArr = ISiPhone4 ? @[@"4-1", @"4-2", @"4-3", @"4-4"]:
    @[@"5-1", @"5-2", @"5-3", @"5-4"];
    for (NSString *imgStr in imgArr)
    {
        EAIntroPage *aPage = [EAIntroPage page];
        aPage.imgPositionY = 0;
        aPage.titleImage = [UIImage imageNamed:imgStr];//加了这一句就可以滑动，但是有问题
        
        [pagesArr addObject:aPage];
    }
    
    _introView = [[EAIntroView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) andPages:pagesArr];
    _introView.swipeToExit = NO;
    _introView.hideOffscreenPages = YES;
    _introView.showSkipButtonOnlyOnLastPage = YES;
    
    // 跳过引导页
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setFrame:CGRectMake((ScreenWidth - 160)/2, ScreenHeight - (ISiPhone5 ? 137 : 94), 150, 35)];
    [btn setTitle:@"2222" forState:UIControlStateNormal];
    //    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(skipBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    
    _introView.skipButton = btn;
    [_introView setDelegate:self];
    [_introView showInView:self.window animateDuration:0.0];
}

-(void)skipBtnClick
{
    [_introView hideWithFadeOutDuration:0.3f];
    
    NSUserDefaults *myUserDefaults = [NSUserDefaults standardUserDefaults];
    [myUserDefaults setObject:[NSNumber numberWithInt:100] forKey:@"isfirst"];
    [myUserDefaults synchronize];
}

//设置当前视图控制器
-(void)setCurrentViewController:(UIViewController *)newController
{
    if (self.currentController==newController)
    {
        return;
    }
    
    if (newController!=nil)
    {
        self.currentController = newController;
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.window endEditing:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //在支付时候 设置了window 为显示，所以在进入后台之后 需要把设置回去
    NSArray *array = [[UIApplication sharedApplication] windows];
    UIWindow* win=[array objectAtIndex:0];
    [win setHidden:YES];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //在支付时候 设置了window 为显示，所以在进入后台之后 需要把设置回去
    NSArray *array = [[UIApplication sharedApplication] windows];
    UIWindow* win=[array objectAtIndex:0];
    [win setHidden:YES];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}
-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    // 1.取消下载
    [mgr cancelAll];
    
    // 2.清除内存中的所有图片
    [mgr.imageCache clearMemory];
}
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.yingbo.Bqu" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Bqu" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Bqu.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    //跳转支付宝钱包进行支付，处理支付结果
       if ([url.host isEqualToString:@"safepay"])
    {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        }];
    }
    if ([url.host isEqualToString:@"platformapi"])
    {
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
        }];
    }
    
    
    return YES;
}
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    //跳转支付宝钱包进行支付，处理支付结果
    if ([url.host isEqualToString:@"safepay"])
    {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        }];
    }
    if ([url.host isEqualToString:@"platformapi"])
    {
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
        }];
    }
    
    
    return YES;
}

@end
