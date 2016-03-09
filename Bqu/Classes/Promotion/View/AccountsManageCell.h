//
//  AccountsManageCell.h
//  Bqu
//
//  Created by WONG on 15/12/8.
//  Copyright © 2015年 yb. All rights reserved.
//   vitamin zll

#import <UIKit/UIKit.h>
#import "AccountModel.h"

@protocol accountsManagerCellDelegate <NSObject>

- (void)deleteuserAccount:(AccountModel *)account;

@end



@interface AccountsManageCell : UITableViewCell

@property (nonatomic)UILabel *accountName;/*账户名称*/
@property (nonatomic)UILabel *accoutUser;/*用户名 卡号*/
@property (nonatomic)UIImageView *deleteImg;/*删除图片*/
@property (nonatomic)UIButton *deleteBtn;/*删除按钮*/
@property (nonatomic)UIView *line;/*删除按钮*/

@property (nonatomic)AccountModel *account;

@property (nonatomic, weak) id<accountsManagerCellDelegate>delegate;

@end
