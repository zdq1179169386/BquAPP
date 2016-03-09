//
//  MyAddressCell.h
//  Bqu
//
//  Created by yingbo on 15/10/22.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyAddressCell;
@protocol AddressDelegate <NSObject>

- (void)setDefaultAddress:(UIButton *)button;
- (void)deleteAddress:(UIButton *)button;


@end


@interface MyAddressCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *userName_Lab;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumber_Lab;
@property (strong, nonatomic) IBOutlet UILabel *userAddress_Lab;
@property (strong, nonatomic) IBOutlet UILabel *IdCard_Lab;

@property (strong, nonatomic) IBOutlet UIView *line_View;
@property (strong, nonatomic) IBOutlet UIView *line2;
@property (strong, nonatomic) IBOutlet UIView *topLine;

@property (strong, nonatomic) IBOutlet UIButton *default_Button;
@property (strong, nonatomic) IBOutlet UILabel *default_Lab;
@property (strong, nonatomic) IBOutlet UIButton *deleteAddress_Button;
@property (strong, nonatomic) IBOutlet UIButton *defaultImgBtn;
@property (strong, nonatomic) IBOutlet UIButton *deleteImgBtn;


@property (assign, nonatomic) id<AddressDelegate> delegate;

@property (strong, nonatomic)  Address_Model *model;

@end
