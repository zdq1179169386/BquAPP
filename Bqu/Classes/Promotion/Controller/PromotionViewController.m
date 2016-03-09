//
//  PromotionViewController.m
//  Bqu
//
//  Created by yb on 15/12/7.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "PromotionViewController.h"
#import "PromotionTableViewCell.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "PromotionHeaderView.h"
#import "AccountManageViewController.h"
#import "InvitedFriendsViewController.h"
#import "WithdrawCashViewController.h"
#import "PromoterInfoModel.h"
#import "PromotionShareCell.h"
#import "AvatarBrowser.h"
//ShareSDK
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import "PromoterDetailRecordViewController.h"

@interface PromotionViewController () <UITableViewDataSource, UITableViewDelegate, PromotionHeaderViewDelegate, PromotionShareCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) PromotionHeaderView *headerView;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *rowHeightArray;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, assign) BOOL isBecomePromoter;
@property (nonatomic, strong) PromoterInfoModel *promoterInfoModel;

@end

@implementation PromotionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"推广员";
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (IOS7_OR_LATER)
    {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    self.isBecomePromoter = NO;
    self.isLogin = NO;
    self.promoterInfoModel = [[PromoterInfoModel alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self resetView];
}

- (void)resetView
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", bquUrl, isLoginUrl];
    NSString *memberID = [UserManager getMyObjectForKey:userIDKey];
    NSString *token = [UserManager getMyObjectForKey:accessTokenKey];
    if (memberID == nil || token == nil) {
        self.isLogin = NO;
        [self resetSubViews];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:memberID forKey:@"MemberID"];
    [dict setValue:token forKey:@"token"];
    
    NSString *realSign = [HttpTool returnForSign:dict];
    [dict setValue:realSign forKey:@"sign"];
    if (!self.isLogin || self.promoterInfoModel == nil) {
        [ProgressHud addProgressHudWithView:self.view andWithTitle:@"加载中"];
    }
    
    [HttpTool post:urlStr params:dict success:^(id json) {
        
        NSString *resultCode = json[@"resultCode"];
        if (resultCode.intValue == 0) {
            //已登录
            self.isLogin = YES;
            
            NSString *flag = [UserManager getMyObjectForKey:isPromoter];
            if (flag.intValue == 1) {
                self.isBecomePromoter = YES;
                [self resetSubViews];
                [self getPromoterInfo];
            } else {
                [ProgressHud hideProgressHudWithView:self.view];
                self.isBecomePromoter = NO;
                [self resetSubViews];
            }
            
        } else {
            [ProgressHud hideProgressHudWithView:self.view];
            //未登录
            self.isLogin = NO;
            [self resetSubViews];
        }
        
    } failure:^(NSError *error) {
        [ProgressHud hideProgressHudWithView:self.view];
        self.isLogin = NO;
        [self resetSubViews];
    }];
}

- (void)getPromoterInfo
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", bquUrl, getPromoterInfoUrl];
    NSString *memberID = [UserManager getMyObjectForKey:userIDKey];
    NSString *token = [UserManager getMyObjectForKey:accessTokenKey];
    if (memberID == nil || token == nil) {
        [ProgressHud hideProgressHudWithView:self.view];
        self.isLogin = NO;
        [self resetSubViews];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:memberID forKey:@"MemberID"];
    [dict setValue:token forKey:@"token"];
    
    NSString *realSign = [HttpTool returnForSign:dict];
    [dict setValue:realSign forKey:@"sign"];
    
    [HttpTool post:urlStr params:dict success:^(id json) {
        [ProgressHud hideProgressHudWithView:self.view];
        NSString *resultCode = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
        if ([resultCode isEqualToString:@"0"])
        {
            NSDictionary *dict = json[@"data"];
            if (dict != nil && ![dict isEqual:[NSNull null]]) {
                NSLog(@"%@", dict);
                PromoterInfoModel *model = [[PromoterInfoModel alloc] init];
                [model promoterInfoModelFromDictionary:dict];
                self.promoterInfoModel = model;
                [self.headerView resetHeaderViewData:self.promoterInfoModel];
                [self.tableView reloadData];
            }
            
        } else {
            NSString *errorMsg = json[@"message"];
            NSLog(@"%@", errorMsg);
        }
        
    } failure:^(NSError *error) {
        [ProgressHud hideProgressHudWithView:self.view];
    }];
}

- (void)resetSubViews
{
    if (self.isLogin) {
        self.navigationItem.title = @"我的推广";
        self.imageArray = [NSArray arrayWithObjects:@"activityRule1.jpg", @"activityRule2.jpg", @"activityRule3.jpg", @"activityRule4.jpg", @"activityRule5.jpg", @"activityRule6.jpg", nil];
        self.rowHeightArray = [NSArray arrayWithObjects:[NSNumber numberWithFloat:195.0],
                               [NSNumber numberWithFloat:171.5],
                               [NSNumber numberWithFloat:139.5],
                               [NSNumber numberWithFloat:227.5],
                               [NSNumber numberWithFloat:183.0],
                               [NSNumber numberWithFloat:183.5],
                               nil];
    } else {
        self.navigationItem.title = @"推广员";
        self.imageArray = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", nil];
        self.rowHeightArray = [NSArray arrayWithObjects:[NSNumber numberWithFloat:212.0],
                               [NSNumber numberWithFloat:85.0],
                               [NSNumber numberWithFloat:127.5],
                               [NSNumber numberWithFloat:121.0],
                               [NSNumber numberWithFloat:121.0],
                               [NSNumber numberWithFloat:121.0],
                               [NSNumber numberWithFloat:299.0],
                               [NSNumber numberWithFloat:171.5],
                               [NSNumber numberWithFloat:171.0],
                               [NSNumber numberWithFloat:171.5],
                               [NSNumber numberWithFloat:132.0],
                               [NSNumber numberWithFloat:132.0],
                               nil];
    }
    [self initTableView];
    [self.tableView reloadData];
    [self resetBottomView];
    [self resetRightBarButton];
}

- (void)initTableView
{
    if (_tableView) {
        [_tableView removeFromSuperview];
    }
    if (self.isLogin) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49) style:UITableViewStyleGrouped];
        self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        if (self.isBecomePromoter) {
            self.tableView.tableHeaderView = self.headerView;
        } else {
            PromotionHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"PromotionBecomePromoterHeaderView" owner:self options:nil] objectAtIndex:0];
            view.delegate = self;
            self.tableView.tableHeaderView = view;
        }
    } else {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49-64)];
        _tableView.tableHeaderView = nil;
        _tableView.backgroundColor = RGB_A(254, 253, 226);
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *footer = [[UIView alloc] init];
    _tableView.tableFooterView = footer;
    [self.view addSubview:_tableView];
}

//底部登录、注册的view
- (void)resetBottomView
{
    if (_bottomView) {
        [_bottomView removeFromSuperview];
    }
    if (!self.isLogin) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-64-49-64, ScreenWidth, 64)];
        _bottomView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
        UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/2-135, 12, 131, 40)];
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        loginBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login"]];
        [loginBtn addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:loginBtn];
        UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/2+4, 12, 131, 40)];
        [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        registerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        [registerBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        registerBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"register"]];
        [registerBtn addTarget:self action:@selector(registerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:registerBtn];
        [self.view addSubview:_bottomView];
    }
}

- (void)resetRightBarButton
{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    if (self.isLogin && self.isBecomePromoter) {
        [rightButton setTitle:@"账户管理" forState:UIControlStateNormal];
//    } else {
//        [rightButton setTitle:@"积分规则" forState:UIControlStateNormal];
    }
    [rightButton setTitleColor:RGB_A(51, 51, 51) forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (PromotionHeaderView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[PromotionHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 204)];
        _headerView.delegate = self;
    }
    return _headerView;
}

#pragma mark - button action
- (void)rightBarButtonClicked:(id)sender
{
    if (self.isLogin && self.isBecomePromoter) {
        //账户管理
        AccountManageViewController *accountManagerVC = [[AccountManageViewController alloc]init];
        accountManagerVC.hidesBottomBarWhenPushed = YES;
        accountManagerVC.AccountID = self.promoterInfoModel.accountID;
        [self.navigationController pushViewController:accountManagerVC animated:YES];
//    } else {
//        //积分规则
    }
}

- (void)loginBtnClicked:(id)sender
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    loginVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginVC animated:NO];
}

- (void)registerBtnClicked:(id)sender
{
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    registerVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:registerVC animated:NO];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isLogin && self.isBecomePromoter) {
        return self.rowHeightArray.count + 1;
    }
    return self.rowHeightArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.isLogin && self.isBecomePromoter) {
        if (section == 0) {
            return 10;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isLogin && self.isBecomePromoter) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.frame.size.height;
        }
        NSInteger index = indexPath.row - 1;
        if (index >= self.rowHeightArray.count) {
            return 0;
        }
        NSNumber *number = self.rowHeightArray[index];
        return number.floatValue;
    }
    
    //未登录，或者未申请
    if (indexPath.row >= self.rowHeightArray.count) {
        return 0;
    }
    
    NSNumber *number = self.rowHeightArray[indexPath.row];
    return number.floatValue;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isLogin && self.isBecomePromoter) {
        if (indexPath.row == 0) {
            PromotionShareCell *shareCell = [[[NSBundle mainBundle] loadNibNamed:@"PromotionShareCell" owner:self options:nil] objectAtIndex:0];
            shareCell.delegate = self;
            [shareCell setShareCellContent:self.promoterInfoModel];
            return shareCell;
        }
    }
    
    static NSString *Identifier = @"PromotionCell";
    PromotionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PromotionTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    if (self.isLogin && self.isBecomePromoter) {
        NSInteger index = indexPath.row - 1;
        if (index >= self.imageArray.count) {
            return cell;
        }
        NSString *imageName = self.imageArray[index];
        cell.contentImageView.image = [UIImage imageNamed:imageName];
        
        return cell;
        
    } else {
        if (indexPath.row >= self.imageArray.count) {
            return cell;
        }
        NSString *imageName = self.imageArray[indexPath.row];
        cell.contentImageView.image = [UIImage imageNamed:imageName];
        
        return cell;
    }
}

#pragma mark - PromotionHeaderViewDelegate
#pragma mark -
//一键成为推广员
- (void)becomePromoterClicked:(PromotionHeaderView *)headerView
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", bquUrl, addPromoterInfoUrl];
    id memberID = [UserManager getMyObjectForKey:userIDKey];
    id token = [UserManager getMyObjectForKey:accessTokenKey];
    if (memberID == nil || token == nil) {
        self.isLogin = NO;
        [self resetSubViews];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:memberID forKey:@"MemberID"];
    [dict setValue:token forKey:@"token"];
    
    NSString *realSign = [HttpTool returnForSign:dict];
    [dict setValue:realSign forKey:@"sign"];
    
    [HttpTool post:urlStr params:dict success:^(id json) {
                
        NSString *resultCode = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
        if ([resultCode isEqualToString:@"0"])
        {
            [ProgressHud showHUDWithView:self.view withTitle:@"申请成功" withTime:1.5];
            [UserManager saveIsPromoter:@"1"];
            NSDictionary *dict = json[@"data"];
            if (dict != nil && ![dict isEqual:[NSNull null]]) {
                NSLog(@"%@", dict);
                PromoterInfoModel *model = [[PromoterInfoModel alloc] init];
                [model promoterInfoModelFromDictionary:dict];
                self.promoterInfoModel = model;
                self.isBecomePromoter = YES;
                [self resetSubViews];
            }
            
        } else {
            NSString *errorMsg = json[@"message"];
            NSLog(@"%@", errorMsg);
            [ProgressHud showHUDWithView:self.view withTitle:errorMsg withTime:1.5];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];

}

//明细
- (void)showDetailsClicked:(PromotionHeaderView *)headerView
{
    PromoterDetailRecordViewController *controller = [[PromoterDetailRecordViewController alloc] initWithNibName:@"PromoterDetailRecordViewController" bundle:nil];
    controller.accountId = self.promoterInfoModel.accountID;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

//我邀请的好友
- (void)invitedFriendsClicked:(PromotionHeaderView *)headerView
{
    InvitedFriendsViewController *controller = [[InvitedFriendsViewController alloc] initWithNibName:@"InvitedFriendsViewController" bundle:nil];
    controller.isSecondLevel = NO;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

//提现
- (void)withdrawCashClicked:(PromotionHeaderView *)headerView
{
    WithdrawCashViewController *controller = [[WithdrawCashViewController alloc] initWithNibName:@"WithdrawCashViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    controller.accountID = self.promoterInfoModel.accountID;
    controller.usableMoney = self.promoterInfoModel.usableMoney;
    NSLog(@"accountID=%@",self.promoterInfoModel.accountID);
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - PromotionShareCellDelegate
#pragma mark -
//点击二维码
- (void)qrCodeClicked:(PromotionShareCell *)cell
{
    if (self.promoterInfoModel.referImage == nil) {
        return;
    }
//    [AvatarBrowser showImageWithUrl:self.promoterInfoModel.referImage];
    AvatarBrowser *avatarBrowser = [[AvatarBrowser alloc] init];
    [avatarBrowser showImageWithUrl:self.promoterInfoModel.referImage];
}

- (void)shareButtonClicked:(PromotionShareCell *)cell
{
    NSLog(@"self.promoterInfoModel.referURL= %@",self.promoterInfoModel.referURL);
    NSURL *url = [NSURL URLWithString:self.promoterInfoModel.referImage];
    NSData *data = [NSData dataWithContentsOfURL:url];
    //1、创建分享参数
    UIImage *image = [UIImage imageWithData:data];
    if (image) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"购物还能领红包？接受我的邀请注册B区领取现金并购物，我们一起愉快购物开心拿红包！海淘？有B区就够了！"
                                         images:image
                                            url:[NSURL URLWithString:self.promoterInfoModel.referURL]
                                          title:@"注册送现金 B区新手福利-来自世界的商店"
                                           type:SSDKContentTypeAuto];
        
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        NSArray *itemsArr = @[@(SSDKPlatformSubTypeWechatSession),
                              @(SSDKPlatformSubTypeWechatTimeline),
                              @(SSDKPlatformSubTypeQQFriend),
                              @(SSDKPlatformSubTypeQZone)];
        
        SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:nil items:itemsArr shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            switch (state) {
                case SSDKResponseStateSuccess:
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }
                    break;
                    
                case SSDKResponseStateFail:
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@", error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertView show];
                }
                    break;
                    
                default:
                    break;
            }
        }];
        
        //跳过编辑页面
        [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
        
    }
}

@end
