//
//  InvitedFriendsViewController.m
//  Bqu
//
//  Created by wyy on 15/12/9.
//  Copyright © 2015年 yb. All rights reserved.
//

#import "InvitedFriendsViewController.h"
#import "InvitedFriendsTableViewCell.h"
#import "PromoterInfoModel.h"

#define kPageSize  100

@interface InvitedFriendsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *topLabel;
@property (nonatomic, strong) NSMutableArray *invitedFriendsArray;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger totalPage;

@end

@implementation InvitedFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.isSecondLevel) {
        self.navigationItem.title = @"他邀请的好友";
    } else {
        self.navigationItem.title = @"我邀请的好友";
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (IOS7_OR_LATER)
    {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    [self initLeftBarButton];
    [self refreshInvitedFriendsCount:@"0"];
    [self requestData];
    //上拉加载更多
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requestForMoreData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)invitedFriendsArray
{
    if (_invitedFriendsArray == nil) {
        _invitedFriendsArray = [NSMutableArray array];
    }
    return _invitedFriendsArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initLeftBarButton
{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshInvitedFriendsCount:(NSString *)num
{
    NSString *str1 = @"目前已邀请";
    NSString *str2 = num;
    NSString *str3 = @"位好友";
    NSString *textStr = [NSString stringWithFormat:@"%@ %@ %@", str1, str2, str3];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:textStr];
    [text addAttribute:NSForegroundColorAttributeName value:RGB_A(51, 51, 51) range:NSMakeRange(0, str1.length)];
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, str1.length)];
    [text addAttribute:NSForegroundColorAttributeName value:RGB_A(246, 38, 72) range:NSMakeRange(str1.length + 1, str2.length)];
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0] range:NSMakeRange(str1.length + 1, str2.length)];
    [text addAttribute:NSForegroundColorAttributeName value:RGB_A(51, 51, 51) range:NSMakeRange(str1.length+str2.length + 2, str3.length)];
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(str1.length+str2.length + 2, str3.length)];
    
    self.topLabel.attributedText = text;
}

- (void)requestData
{
    self.pageIndex = 1;
    [self.invitedFriendsArray removeAllObjects];
    [self sendRequest];
}

- (void)sendRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", bquUrl, getInvitedFriendsUrl];
    NSString *memberID = [UserManager getMyObjectForKey:userIDKey];
    NSString *token = [UserManager getMyObjectForKey:accessTokenKey];
    if (memberID == nil || token == nil) {
        [self.tableView.footer endRefreshing];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.isSecondLevel) {
        if (self.memberId == nil) {
            return;
        }
        [dict setValue:self.memberId forKey:@"MemberID"];
    } else {
        [dict setValue:memberID forKey:@"MemberID"];
    }
    
    [dict setValue:token forKey:@"token"];
    [dict setValue:[NSString stringWithFormat:@"%ld", self.pageIndex] forKey:@"PageNo"];
    [dict setValue:[NSString stringWithFormat:@"%d", kPageSize] forKey:@"PageSize"];
    
    NSString *realSign = [HttpTool returnForSign:dict];
    [dict setValue:realSign forKey:@"sign"];
    [ProgressHud addProgressHudWithView:self.view andWithTitle:@"加载中"];
    
    [HttpTool post:urlStr params:dict success:^(id json) {
        [ProgressHud hideProgressHudWithView:self.view];
        [self.tableView.footer endRefreshing];
        
        NSString *resultCode = [NSString stringWithFormat:@"%@",json[@"resultCode"]];
        if ([resultCode isEqualToString:@"0"])
        {
            NSString *totalCount = [NSString stringWithFormat:@"%@",json[@"totalCount"]];
            self.totalPage = lroundf(totalCount.floatValue/kPageSize);
            NSArray *dataArr = json[@"data"];
            
            if (dataArr != nil && ![dataArr isEqual:[NSNull null]] && dataArr.count > 0) {
                NSLog(@"%@", dataArr);
                
                for (NSDictionary *dict in dataArr) {
                    InvitedFriendModel *model = [[InvitedFriendModel alloc] init];
                    [model invitedFrinedModelFromDictionary:dict];
                    [self.invitedFriendsArray addObject:model];
                }
            }
            [self.tableView reloadData];
            [self refreshInvitedFriendsCount:[NSString stringWithFormat:@"%lu", self.invitedFriendsArray.count]];
            
        } else {
            NSString *errorMsg = json[@"message"];
            NSLog(@"%@", errorMsg);
        }
        
    } failure:^(NSError *error) {
        [ProgressHud hideProgressHudWithView:self.view];
        [self.tableView.footer endRefreshing];
    }];
}

- (void)requestForMoreData
{
    self.pageIndex += 1;
    if (self.pageIndex > self.totalPage) {
        [self.tableView.footer endRefreshing];
        [self.tableView.footer noticeNoMoreData];
        return;
    }
    [self sendRequest];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.invitedFriendsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 37;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"InvitedFriendsTableHeaderView" owner:nil options:nil] objectAtIndex:0];
        return headerView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"InvitedFriendsCell";
    InvitedFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InvitedFriendsTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    if (indexPath.row >= self.invitedFriendsArray.count) {
        return cell;
    }
    if (self.isSecondLevel) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    InvitedFriendModel *model = self.invitedFriendsArray[indexPath.row];
    [cell setInvitedFrinedInfo:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (self.isSecondLevel) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row >= self.invitedFriendsArray.count) {
        return;
    }
    
    InvitedFriendModel *model = self.invitedFriendsArray[indexPath.row];
    if (model.userId == nil) {
        return;
    }
    InvitedFriendsViewController *controller = [[InvitedFriendsViewController alloc] initWithNibName:@"InvitedFriendsViewController" bundle:nil];
    controller.isSecondLevel = YES;
    controller.memberId = model.userId;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
