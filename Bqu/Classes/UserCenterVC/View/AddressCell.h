//
//  AddressCell.h
//  Bqu
//
//  Created by yingbo on 15/11/30.
//  Copyright © 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressCell : UITableViewCell

@property (nonatomic,strong) UIImageView *addressImgView;
@property (nonatomic,strong) UILabel *receiverLab;
@property (nonatomic,strong) UILabel *addressLab;
@property (nonatomic,strong) UILabel *IdCardLab;
@property (nonatomic,strong) UILabel *phonrNumberLab;
@property (nonatomic,strong) NSDictionary *dataDic;
- (void)setValue:(id)value;


@end
