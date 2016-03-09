//
//  UserInfoCell.h
//  Bqu
//
//  Created by yingbo on 15/10/12.
//  Copyright (c) 2015年 yingbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *bg_ImageView;
@property (strong, nonatomic) IBOutlet UIImageView *photo_ImageView;
@property (strong, nonatomic) IBOutlet UILabel *userName_Lab;
@property (strong, nonatomic) IBOutlet UIButton *login_Button;
@property (strong, nonatomic) IBOutlet UIButton *register_Button;

- (void)setValue;

@end
