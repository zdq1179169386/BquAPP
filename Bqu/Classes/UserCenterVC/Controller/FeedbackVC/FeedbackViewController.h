//
//  FeedbackViewController.h
//  Bqu
//
//  Created by yingbo on 15/10/16.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "HSViewController.h"

@interface FeedbackViewController : HSViewController<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>

/*主界面表*/
@property (nonatomic,strong) UITableView *tableView;
/*判断是否登录*/
@property (nonatomic,strong) NSString *isLogin;
/*反馈类型按钮数组*/
@property (strong, nonatomic)  NSArray *buttonArray;
/*反馈类型*/
@property (nonatomic,strong) NSString *SourceType;

@end
